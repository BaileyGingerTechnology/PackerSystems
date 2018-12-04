if not exist "C:\Windows\Temp\7z920-x64.msi" (
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://www.7-zip.org/a/7z920-x64.msi', 'C:\Windows\Temp\7z920-x64.msi')" <NUL
)
msiexec /qn /i C:\Windows\Temp\7z920-x64.msi

if "%PACKER_BUILDER_TYPE%" equ "vmware-iso" goto :vmware
if "%PACKER_BUILDER_TYPE%" equ "virtualbox-iso" goto :virtualbox
goto :done

:vmware

if exist "C:\Users\GingerTech\windows.iso" (
    move /Y C:\Users\GingerTech\windows.iso C:\Windows\Temp
)

if not exist "C:\Windows\Temp\windows.iso" (
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://softwareupdate.vmware.com/cds/vmw-desktop/ws/12.0.0/2985596/windows/packages/tools-windows.tar', 'C:\Windows\Temp\vmware-tools.tar')" <NUL
    cmd /c ""C:\Program Files\7-Zip\7z.exe" x C:\Windows\Temp\vmware-tools.tar -oC:\Windows\Temp"
    FOR /r "C:\Windows\Temp" %%a in (VMware-tools-windows-*.iso) DO REN "%%~a" "windows.iso"
)

cmd /c ""C:\Program Files\7-Zip\7z.exe" x "C:\Windows\Temp\windows.iso" -oC:\Windows\Temp\VMWare"
cmd /c C:\Windows\Temp\VMWare\setup64.exe /S /v "/qn REBOOT=R ADDLOCAL=ALL REMOVE=Hgfs"

goto :done

:virtualbox

move /Y C:\Users\GingerTech\VBoxGuestAdditions.iso C:\Windows\Temp
cmd /c ""C:\Program Files\7-Zip\7z.exe" x C:\Windows\Temp\windows.iso -oC:\Windows\Temp\virtualbox"
cmd /c for %%i in (C:\Windows\Temp\virtualbox\cert\vbox*.cer) do C:\Windows\Temp\virtualbox\cert\VBoxCertUtil add-trusted-publisher %%i --root %%i
cmd /c C:\Windows\Temp\virtualbox\VBoxWindowsAdditions.exe /S

:done