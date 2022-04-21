function uninstallplaystore {
    Clear-Host
    $ProgressPreference = 'SilentlyContinue'
    Write-Host "Uninstalling Play Store will remove `"Windows Subsystem for Android`" completely.`nApps installed by the Play Store and other will no longer be available.`nDo you also want to disable Virtual Machine Platform?" -ForegroundColor Yellow
    $readhostraw = Read-Host 'To proceed type [P] to delete everything, [U] only uninstall WSA or [C] to cancel'
    $readhost = $readhostraw.replace(' ', '')
    if ($readhost -eq 'P') {
        Write-Host''
        $checkapp = (Get-AppxPackage -Name MicrosoftCorporationII.WindowsSubsystemForAndroid).name
        if ($checkapp -eq 'MicrosoftCorporationII.WindowsSubsystemForAndroid') {
            Write-Host 'Removing Windows Subsystem for Android.'
            Get-AppxPackage -Name 'MicrosoftCorporationII.WindowsSubsystemForAndroid' | Remove-AppxPackage
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -Like 'MicrosoftCorporationII.WindowsSubsystemForAndroid' | Remove-AppxProvisionedPackage -Online
            Write-Host 'Successfully removed.'
        } else {
            Write-Host 'Windows Subsystem for Android not found or it has already been removed.' 
        }
        if (Test-Path 'C:\Windows Subsystem for Android\WsaSettings.exe') {
            Stop-Process -Name adb -Force -ErrorAction SilentlyContinue
            Write-Host 'Removing WSA files and Directory.'
            Remove-Item 'C:\Windows Subsystem for Android\*' -Recurse -Force -Confirm:$false
            Write-Host 'Successfully removed.'
        } else {
            Write-Host 'Windows Subsystem for Android not found or it has already been removed.' 
        }
        $checkfeature = Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
        if ($checkfeature.State -eq 'Enabled') {
            Write-Host 'Disabling Virtual Machine Platform.'
            dism.exe /online /disable-feature /featurename:VirtualMachinePlatform /norestart
            Write-Host 'Successfully disabled.'
        } else {
            Write-Host 'Virtual Machine Platform is already disable.' 
        }
        Write-Host 'Done...' -ForegroundColor Green
    }
    if ($readhost -eq 'U') {
        Write-Host''
        $checkapp = (Get-AppxPackage -Name MicrosoftCorporationII.WindowsSubsystemForAndroid).name
        if ($checkapp -eq 'MicrosoftCorporationII.WindowsSubsystemForAndroid') {
            Write-Host 'Removing Windows Subsystem for Android.'
            Get-AppxPackage -Name 'MicrosoftCorporationII.WindowsSubsystemForAndroid' | Remove-AppxPackage
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -Like 'MicrosoftCorporationII.WindowsSubsystemForAndroid' | Remove-AppxProvisionedPackage -Online
            Write-Host 'Successfully removed.'
        } else {
            Write-Host 'Windows Subsystem for Android not found or it has already been removed.'
        }
        if (Test-Path 'C:\Windows Subsystem for Android\WsaSettings.exe') {
            Stop-Process -Name adb -Force -ErrorAction SilentlyContinue
            Write-Host 'Removing WSA files and Directory.'
            Remove-Item 'C:\Windows Subsystem for Android\*' -Recurse -Force -Confirm:$false
            Write-Host 'Successfully Removed.'
        } else {
            Write-Host 'Windows Subsystem for Android not found or it has already been removed.'
        }
        Write-Host 'Done...' -ForegroundColor Green 
    }
    if ($readhost -eq 'C') {
        Write-Host ''
        Write-Host 'Cancel'
        Write-Host ''
    }
    if ($readhost -ne 'P' -xor $readhost -ne 'U' -xor $readhost -ne 'C') {
        uninstallplaystore 
    }
    
}
uninstallplaystore