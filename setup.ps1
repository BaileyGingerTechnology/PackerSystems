# Author: Bailey Kasin

Write-Output "Setting up project"

git pull
git submodule update --init --remote --recursive

$DoIt = Read-Host -Prompt 'Latest changes pulled. Build ScoringEngine? (Requries Go, enter "yes" to continue)'

if ( $DoIt -ne "yes" ) {
  exit
}

Set-Location ScoringEngine/CyberPatriotScoringEngine
go build

Move-Item CyberPatriotScoringEngine.exe ../../CyberPatriot/files/CheckScore.exe -Force

Set-Location ../../