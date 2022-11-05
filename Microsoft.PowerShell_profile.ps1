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
  vim $PROFILE
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
  kubectl --context="${k8s_context}" --namespace="${namespace}" run "${pod_name}" --image="${image_name}" --env="LOCAL_PORT=${local_port}" --env="REMOTE_PORT=${remote_port}" --env="REMOTE_IP=${remote_ip}" --env="PROTOCOL=${protocol}"
  kubectl --context="${k8s_context}" --namespace="${namespace}" wait --for=condition=ready pod "${pod_name}"
  kubectl --context="${k8s_context}" --namespace="${namespace}" port-forward "${pod_name}" "${local_port}:${remote_port}"
  kubectl --context="${k8s_context}" --namespace="${namespace}" delete pod "${pod_name}"
}

# END FUNCTIONS

# BEGIN ALIASES

Set-Alias -name kx -Value kubectx
Set-Alias -name kns -Value kubens
Set-Alias -name k -Value kubectl
Set-Alias -name g -Value git
Set-Alias -name which -Value get-command

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
