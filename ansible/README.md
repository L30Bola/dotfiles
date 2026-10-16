# Local Mac setup

Run from this directory so Ansible loads the inventory and configuration:

```bash
cd ~/.vim/ansible
ansible-playbook playbook.yaml
```

The play uses the same Python interpreter as `ansible-playbook`, so changes to
asdf's selected Python version do not interrupt Ansible.

Homebrew no longer accepts `--no-quarantine`. All casks use Homebrew's normal
quarantine behavior. The `no-quarantine` tag remains only as a compatibility
alias for selecting the NearDrop, Mos, and Maccy tasks.

Icon customization elevates only for applications that your user cannot write.
For those applications, run with `--ask-become-pass` and enter your Mac
administrator password at the terminal prompt.

Some casks require administrator authentication. Supply `homebrew_sudo_password`
through an Ansible Vault encrypted variables file and run:

```bash
ansible-playbook playbook.yaml --extra-vars @/path/to/vault.yml --ask-vault-pass
```

`--ask-become-pass` alone does not populate the password used by the Homebrew
cask module. Do not put passwords in shell arguments or commit plaintext
passwords.

`../scripts/mac-setup.sh` installs or updates Ansible, ansible-lint, and
ansible-navigator in separate pipx environments. The linter gets its own copy
of the Ansible collections without replacing the main Ansible executables.

To validate a worktree while retaining the original dotfiles symlink targets:

```bash
ansible-playbook playbook.yaml --extra-vars dotfiles_dir="$HOME/.vim"
```

For syntax and lint checks:

```bash
ansible-playbook playbook.yaml --syntax-check
ansible-lint --offline playbook.yaml
```

`tests/check_reruns.py` runs the actual asdf and Helm tasks against temporary
fixture commands. It checks change reporting, repeat-run behavior, preservation
of unmanaged tool versions, and propagation of genuine installation errors.
Run it with a Python interpreter that has PyYAML installed and
`ansible-playbook` on PATH:

```bash
python3 tests/check_reruns.py
```

`ble_sh_dir` and `ble_sh_version` can select an isolated source checkout and a
specific commit when the existing `~/ble.sh` checkout has local changes.
