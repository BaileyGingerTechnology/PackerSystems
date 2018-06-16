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
elseif ($args[0] -gt 3) {
  Write-Host "Please give a number between 1 and 3"
}