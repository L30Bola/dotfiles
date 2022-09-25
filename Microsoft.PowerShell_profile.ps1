# If profile doesn't exist, create it with `New-Item $profile -Type File -Force`

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

Set-Alias -name kx -Value kubectx
Set-Alias -name kns -Value kubens
Set-Alias -name k -Value kubectl
Set-Alias -name g -Value git
