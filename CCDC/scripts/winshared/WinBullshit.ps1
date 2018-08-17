# Windows, and therefore Chocolatey, has really stupid exit codes.
# For example, 3010 which means success and reboot needed.
# Because success codes can be non-0, Packer will fail on success.
# Thus, this bullshit:

if ($args[0] -eq 1) {
  choco install -y dotnet4.5.2
  exit 0
}
elseif ($args[0] -eq 2) {
  choco install -y dotnet4.6.1
  exit 0
}
elseif ($args[0] -eq 3) {
  choco install -y dotnet4.6.2
  exit 0
}
elseif ($args[0] -eq 4) {
  choco install -y ucma4
  exit 0
}
else {
  Write-Host "Please give a number between 1 and 4"
}