# If profile doesn't exist, create it with `New-Item $profile -Type File -Force`

# BEGIN FUNCTIONS

Function Test-Elevated {
  $wid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $prp = New-Object System.Security.Principal.WindowsPrincipal($wid)
  $adm = [System.Security.Principal.WindowsBuiltInRole]::Administrator
  $prp.IsInRole($adm)
}

Function vimrc {
  vim ~/_vimrc
}

Function gitconfig {
  vim ~/.gitconfig
}

Function bashrc {
  vim ~/projetos/dotfiles/Microsoft.PowerShell_profile.ps1
  cp ~/projetos/dotfiles/Microsoft.PowerShell_profile.ps1 $PROFILE
  . $PROFILE
}

Function ka {
  kube-auth --auth-only
}

Function wild-vault-fallback {
  $k8s_cluster='infra-prod.us-east-1.k8s.tfgco.com'
  $namespace='bastion-vault'
  $pod_name="godoy-tcp-proxy-$(Get-Date -UFormat '%Y-%m-%d-%H-%M-%S')"
  $image_name='henkelmax/proxy:latest'
  $protocol='tcp'
  $local_port=8200
  $remote_port=443
  $remote_ip='internal-vault.wildlife.io'
  kubectl --context="${k8s_cluster}" --namespace="${namespace}" run "${pod_name}" --image="${image_name}" --env="LOCAL_PORT=${local_port}" --env="REMOTE_PORT=${remote_port}" --env="REMOTE_IP=${remote_ip}" --env="PROTOCOL=${protocol}"
  kubectl --context="${k8s_cluster}" --namespace="${namespace}" wait --for=condition=ready pod "${pod_name}"
  kubectl --context="${k8s_cluster}" --namespace="${namespace}" port-forward "${pod_name}" "${local_port}:${remote_port}"
  kubectl --context="${k8s_cluster}" --namespace="${namespace}" delete pod "${pod_name}"
}

Function aws-prof {
  if (
    $args[0] -ceq "tfgco" -or
    $args[0] -ceq "general-stag" -or
    $args[0] -ceq "it-prod" -or
    $args[0] -ceq "scalemonk" -or
    $args[0] -ceq "playground" -or
    $args[0] -ceq "tfgco-ufcg" -or
    $args[0] -ceq "security-team-prod" -or
    $args[0] -ceq "it-test" -or
    $args[0] -ceq "wl-disaster-recovery" -or
    $args[0] -ceq "data-dev"
  ) {
    aws sso login --profile $args[0]
  }
}

Function aws-envs {
  aws sts get-caller-identity --profile $args[0] *> $null
  if (-not $?) {
    aws-prof $args[0]
  }
  $AWS_ENVS = $(aws2-wrap.exe --profile $args[0] --export)
  foreach ($AWS_ENV in $AWS_ENVS) {
    Invoke-Expression $AWS_ENV
  }
  Set-Variable $ENV:AWS_PROFILE=$args[0]
}

# END FUNCTIONS

# BEGIN ALIASES

Set-Alias -name kx -Value kubectx
Set-Alias -name kns -Value kubens
Set-Alias -name k -Value kubectl
Set-Alias -name g -Value git
Set-Alias -name which -Value get-command
Set-Alias -name tf -Value terraform

# END ALIASES

# https://learn.microsoft.com/en-us/powershell/module/psreadline/about/about_psreadline
# https://learn.microsoft.com/en-us/powershell/module/psreadline/about/about_psreadline_functions
# https://learn.microsoft.com/en-us/powershell/module/psreadline/set-psreadlinekeyhandler
# BEGIN BINDS

Set-PSReadLineKeyHandler -Key Ctrl+d -Function ViAcceptLineOrExit

#Set-PSReadLineKeyHandler -Chord Ctrl+d -ScriptBlock {
#  [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
#  [Microsoft.PowerShell.PSConsoleReadLine]::Insert("exit")
#  [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
#}

# END BINDS


# BEGIN VARIABLES

C:\Users\metak\.kube\completion.ps1
