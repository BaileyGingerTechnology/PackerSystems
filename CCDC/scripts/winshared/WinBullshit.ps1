# Windows, and therefore Chocolatey, has really stupid exit codes.
# For example, 3010 which means success and reboot needed.
# Because success codes can be non-0, Packer will fail on success.

# Also, dotnet4.6.1 and ucma4 will require two tries each. The first
# installs a dependency and then exists with code 5100 which, according
# to built in Windows debug commands, means "Asia." It actually means
# that the install cannot complete without rebooting and trying again,
# because the dependency install finished with exit code 3010.

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