"""Exercise real playbook tasks with isolated command fixtures."""

from pathlib import Path
import copy
import json
import os
import re
import subprocess
import sys
import tempfile
import yaml

fixture_directory = tempfile.TemporaryDirectory(prefix="ansible-reruns-")
base = Path(fixture_directory.name)
python = sys.executable
fake_cli = """import json, os, sys
from pathlib import Path
root = Path(os.environ['ASDF_DATA_DIR'])
home = Path(os.environ['FIXTURE_HOME'])
args = sys.argv[1:]
if Path(sys.argv[0]).name == 'asdf':
    if args[:2] == ['plugin', 'add']:
        (root / 'plugins' / args[2]).mkdir(parents=True, exist_ok=True)
    elif args[0] == 'latest':
        print('1.2.3')
    elif args[0] == 'install':
        tool, version = args[1:]
        (root / 'installs' / tool / version).mkdir(parents=True, exist_ok=True)
    else:
        sys.exit('unsupported fixture asdf command: ' + repr(args))
else:
    marker = home / 'helm-plugins.json'
    plugins = json.loads(marker.read_text()) if marker.exists() else []
    if args == ['plugin', 'list']:
        print('NAME\\tVERSION')
        for plugin in plugins:
            print(plugin + '\\t1.0.0')
    elif args[:2] == ['plugin', 'install']:
        if os.environ.get('FAIL_HELM') == '1':
            sys.stderr.write('simulated plugin download failure\\n')
            sys.exit(17)
        name = 'diff' if 'helm-diff' in args[2] else 'import'
        if name in plugins:
            sys.stderr.write('plugin already exists\\n')
            sys.exit(1)
        marker.write_text(json.dumps(plugins + [name]))
    else:
        sys.exit('unsupported fixture helm command: ' + repr(args))
"""


def fixture(source, tags, fail_helm=False):
    root = Path(tempfile.mkdtemp(prefix="rerun-fixture-", dir=base))
    home = root / "home"
    home.mkdir()
    (home / ".tool-versions").write_text("ruby 3.3.0\nfzf 0.0.1\n")
    binaries = root / "bin"
    binaries.mkdir()
    for name in ("asdf", "helm"):
        exe = binaries / name
        exe.write_text("#!" + python + "\n" + fake_cli)
        exe.chmod(0o755)
    play = copy.deepcopy(yaml.safe_load(Path(source).read_text())[0])
    play["gather_facts"] = False
    play["tasks"] = [t for t in play["tasks"] if tags in t.get("tags", [])]
    play.setdefault("vars", {}).update(
        {
            "ansible_python_interpreter": python,
            "setup_home": str(home),
            "asdf_data_dir": str(root / "asdf"),
        }
    )
    play["environment"] = {
        "PATH": str(binaries) + ":" + os.environ["PATH"],
        "ASDF_DATA_DIR": str(root / "asdf"),
        "FIXTURE_HOME": str(home),
        "FAIL_HELM": "1" if fail_helm else "0",
    }
    target = root / "playbook.yaml"
    target.write_text(yaml.safe_dump([play], sort_keys=False))
    return root, home, target


def execute(target, label):
    env = dict(
        os.environ,
        ANSIBLE_LOCAL_TEMP=str(target.parent / "local"),
        ANSIBLE_REMOTE_TEMP=str(target.parent / "remote"),
    )
    result = subprocess.run(
        ["ansible-playbook", "-i", "localhost,", str(target)],
        env=env,
        capture_output=True,
        text=True,
        timeout=90,
    )
    output = result.stdout + result.stderr
    (target.parent / (label + ".log")).write_text(output)
    recap = re.search(
        r"localhost\s+:\s+ok=(\d+)\s+changed=(\d+).*?failed=(\d+)", output
    )
    if not recap:
        raise AssertionError(output)
    return result.returncode, int(recap[2]), int(recap[3]), output


source = (
    sys.argv[1]
    if len(sys.argv) > 1
    else str(Path(__file__).resolve().parents[1] / "playbook.yaml")
)
root, home, target = fixture(source, "asdf")
rc, changed, failed, output = execute(target, "first")
assert rc == 0 and changed > 0 and failed == 0, (
    "first asdf run must report real changes: " + output[-1500:]
)
rc, changed, failed, output = execute(target, "second")
assert rc == 0 and changed == 0 and failed == 0, (
    "second asdf run must be unchanged: " + output[-1500:]
)
lines = (home / ".tool-versions").read_text().splitlines()
assert lines.count("fzf 1.2.3") == 1 and "fzf 0.0.1" not in lines, lines
assert "ruby 3.3.0" in lines and "kubectl 1.34.4" in lines, lines
print(
    "PASS: asdf reports first-run changes, remains unchanged on rerun, preserves unmanaged versions"
)

root, home, target = fixture(source, "helm")
rc, changed, failed, output = execute(target, "first")
assert rc == 0 and changed > 0 and failed == 0, output[-1500:]
rc, changed, failed, output = execute(target, "second")
assert rc == 0 and changed == 0 and failed == 0, (
    "installed Helm plugins must be skipped: " + output[-1500:]
)
print("PASS: Helm plugins install once and skip existing plugins")

root, home, target = fixture(source, "helm", fail_helm=True)
rc, changed, failed, output = execute(target, "failed-download")
assert rc != 0 and failed > 0 and "simulated plugin download failure" in output, (
    "genuine Helm errors must fail the play: " + output[-1500:]
)
print("PASS: genuine Helm installation failures propagate")
