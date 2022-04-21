function confirm {
    Clear-Host
    Write-Host "This will uninstall old versions of Windows Subsystem for Android and all of its apps.`nTake a backup of the apps (if needed).`nDownload new version of `"Windows Subsystem for Android`" with Google Play Store service compatibility." -ForegroundColor Yellow
    $readhostraw = Read-Host 'Type [P] to proceed or [C] to cancel.'
    $readhost1 = $readhostraw.Replace(' ', '')
    if ($readhost1 -eq 'P') {
        Write-Host ''
        Write-Host 'Download the `"Windows Subsystem for Android`" zip file from https://bit.ly/30C2Nsk' -ForegroundColor Cyan
        $filepath = Read-Host 'Enter the correct path of the downloaded file'
        $filepathcorrect = $filepath.Replace('"', '')
        if ((Get-Item $filepathcorrect -ErrorAction SilentlyContinue).length -gt 550000000) {
            Set-Location 'C:\'
            $ErrorActionPreference = 'SilentlyContinue'
            Write-Host ''
            Write-Host 'Removing old version of "Windows Subsystem for Android" (if installed).'
            Get-AppxPackage -Name 'MicrosoftCorporationII.WindowsSubsystemForAndroid' | Remove-AppxPackage
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -Like 'MicrosoftCorporationII.WindowsSubsystemForAndroid' | Remove-AppxProvisionedPackage -Online
            Write-Host 'Enabling Developer Mode.'
            $RegistryKeyPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock'
            if (-not(Test-Path -Path $RegistryKeyPath)) {
                New-Item -Path $RegistryKeyPath -ItemType Directory -Force >$null
            }
            New-ItemProperty -Path $RegistryKeyPath -Name AllowAllTrustedApps -PropertyType DWORD -Value 1 -Force >$null
            New-ItemProperty -Path $RegistryKeyPath -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1 -Force >$null
            Write-Host ''
            Write-Host 'Fetching "7-Zip: standalone console version."'
            (New-Object System.Net.WebClient).DownloadFile('https://github.com/nianqy/WSA-Play-Store/raw/main/7za.exe', "$env:TEMP\7za.exe")
            Write-Host '7-Zip fetched.'
            Write-Host ''
            Write-Host 'Extracting "Windows Subsystem for Android" zip files.'
            Set-Alias 7za "$env:TEMP\7za.exe"
            7za x $filepath -o'C:\' '-aos' '-bsp1' | Out-String -Stream | Select-String -Pattern '\d{1,3}%' -AllMatches | ForEach-Object { $_.Matches.Value } | ForEach-Object {
                [System.Console]::SetCursorPosition(0, [System.Console]::CursorTop)
                Write-Host 'Extraction progress:' $_ -NoNewline
            }
            Write-Host ''
            Remove-Item $env:TEMP\7za.exe
            $ErrorActionPreference = 'Stop'
            Set-Location 'C:\Windows Subsystem for Android'
            Write-Host ''
            Write-Host 'Registering and installing Windows Subsystem for Android.'
            try {
                Add-AppxPackage -Register .\AppxManifest.xml 
            } catch {
                Write-Host 'An error occurred while registering and installing.' -ForegroundColor red 
            }
            Write-Host 'Installation completed.'
            Write-Host ''
            Write-Host 'To start Windows Subsystem for Android go to Startmenu > Apps > open Windows Subsystem for Android and on the very top open file manager.'
            Write-Host 'If you can''t sign into Play Store then use "Fix Play Store sign in" option.'
            Write-Host ''
            $ErrorActionPreference = 'SilentlyContinue'
            Start-Sleep 2
            [IO.File]::WriteAllBytes("$env:USERPROFILE\Desktop\Windows Subsystem for Android.lnk", [Convert]::FromBase64String('TAAAAAEUAgAAAAAAwAAAAAAAAEaBAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwAAAAAAAAAAAAAAAAAAAFAFFAAfgJvUNEJFAvNNt4A4k5Q0VuE6BQAANAVBUFBTIgUIAAMAAAAAAAAAjgIAADFTUFNVKEyfeZ85S6jQ4dQt4dXzkQAAABEAAAAAHwAAAEAAAABNAGkAYwByAG8AcwBvAGYAdABDAG8AcgBwAG8AcgBhAHQAaQBvAG4ASQBJAC4AVwBpAG4AZABvAHcAcwBTAHUAYgBzAHkAcwB0AGUAbQBGAG8AcgBBAG4AZAByAG8AaQBkAF8AOAB3AGUAawB5AGIAMwBkADgAYgBiAHcAZQAAABEAAAAOAAAAABMAAAABAAAAtQAAABUAAAAAHwAAAFEAAABNAGkAYwByAG8AcwBvAGYAdABDAG8AcgBwAG8AcgBhAHQAaQBvAG4ASQBJAC4AVwBpAG4AZABvAHcAcwBTAHUAYgBzAHkAcwB0AGUAbQBGAG8AcgBBAG4AZAByAG8AaQBkAF8AMQAuADcALgAzADIAOAAxADUALgAwAF8AeAA2ADQAXwBfADgAdwBlAGsAeQBiADMAZAA4AGIAYgB3AGUAAAAAAKkAAAAFAAAAAB8AAABMAAAATQBpAGMAcgBvAHMAbwBmAHQAQwBvAHIAcABvAHIAYQB0AGkAbwBuAEkASQAuAFcAaQBuAGQAbwB3AHMAUwB1AGIAcwB5AHMAdABlAG0ARgBvAHIAQQBuAGQAcgBvAGkAZABfADgAdwBlAGsAeQBiADMAZAA4AGIAYgB3AGUAIQBTAGUAdAB0AGkAbgBnAHMAQQBwAHAAAABVAAAADwAAAAAfAAAAIQAAAEMAOgBcAFcAaQBuAGQAbwB3AHMAIABTAHUAYgBzAHkAcwB0AGUAbQAgAGYAbwByACAAQQBuAGQAcgBvAGkAZAAAAAAAHQAAACAAAAAASAAAALZHJjUUSohIp/hjZWDhbxwAAAAAxQEAADFTUFNNC9SGaZA8RIGaKlQJDczsOQAAAAwAAAAAHwAAABMAAABJAG0AYQBnAGUAcwBcAE0AZQBkAFQAaQBsAGUALgBwAG4AZwAAAAAAOQAAAAIAAAAAHwAAABMAAABJAG0AYQBnAGUAcwBcAEEAcABwAEwAaQBzAHQALgBwAG4AZwAAAAAAOQAAAA0AAAAAHwAAABQAAABJAG0AYQBnAGUAcwBcAFcAaQBkAGUAVABpAGwAZQAuAHAAbgBnAAAAEQAAAAQAAAAAEwAAAAB41P89AAAAEwAAAAAfAAAAFQAAAEkAbQBhAGcAZQBzAFwATABhAHIAZwBlAFQAaQBsAGUALgBwAG4AZwAAAAAAEQAAAAUAAAAAEwAAAP////8RAAAADgAAAAATAAAAAAQAAFEAAAALAAAAAB8AAAAfAAAAVwBpAG4AZABvAHcAcwAgAFMAdQBiAHMAeQBzAHQAZQBtACAAZgBvAHIAIABBAG4AZAByAG8AaQBkACIhAAAAAD0AAAAUAAAAAB8AAAAVAAAASQBtAGEAZwBlAHMAXABTAG0AYQBsAGwAVABpAGwAZQAuAHAAbgBnAAAAAAAAAAAAMQAAADFTUFOxFm1ErY1wSKdIQC6kPXiMFQAAAGQAAAAAFQAAAAEJAAAAAAAAAAAAAG0AAAAxU1BTMPElt+9HGhCl8QJgjJ7rrFEAAAAKAAAAAB8AAAAfAAAAVwBpAG4AZABvAHcAcwAgAFMAdQBiAHMAeQBzAHQAZQBtACAAZgBvAHIAIABBAG4AZAByAG8AaQBkACIhAAAAAAAAAAAtAAAAMVNQU7N37Q0UxmxFrlsoWzjXsBsRAAAABwAAAAATAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='))
            Start-Process "$env:USERPROFILE\Desktop\Windows Subsystem for Android.lnk"
            $shell = New-Object -ComObject wscript.shell;
            for ($i = 1; $i -le 20; $i++) {
                $stop = (Get-Process WsaSettings -ErrorAction SilentlyContinue).count -eq 0
                Start-Sleep -Milliseconds 200
                if (-not($stop)) {
                    $i = 20 
                }
            }
            if (-not((Get-Process WsaSettings -ErrorAction SilentlyContinue).count -eq 0)) {
                Start-Sleep 1
                $shell.SendKeys('{TAB}{TAB}{TAB}{TAB}')
                $shell.SendKeys(' ')
                $shell.SendKeys('{TAB}{TAB}')
                $shell.SendKeys('  ')
                while ((Get-Process WsaClient -ErrorAction SilentlyContinue).count -eq 0) {
                    Start-Sleep -Milliseconds 200 
                }
                Start-Sleep 1
                $shell.SendKeys(' ')
                $shell.SendKeys('{TAB}')
                $shell.SendKeys(' ')
                Write-Host ''
                Write-Host 'To open Play Store go to Startmenu > Apps > Play Store'
                Write-Host 'If you can''t sign into Play Store then use "Fix Play Store sign in" option from tool.'
                Write-Host ''
            }
        } else {
            Write-Host 'Path or file is invalid.'
        }
    }
    if ($readhost1 -eq 'C') {
        Write-Host 'Canceled' 
    }
    if ($readhost1 -ne 'P' -xor $readhost1 -ne 'C') {
    } else {
        confirm 
    }
}
$check = Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
function confirmdism {
    Clear-Host
    if ($check.State -eq 'Disabled') {
        Write-Host "Play Store runs on Windows Subsystem for Android using Virtual Machine Platform, which is disabled on this machine.`nDo you want to enable Virtual Machine Platform now." -ForegroundColor Yellow
        Write-Host ''
        Write-Warning 'PC will automatically restart after enabling.'
        Write-Host 'After restarting run the tool again for installation.' -ForegroundColor Yellow
        $readhost2 = Read-Host 'Type [P] to proceed or [C] to cancel.'
        $readhost2 = $readhost2.replace(' ', '')
        if ($readhost2 -eq '[P]') {
            Write-Host ''; Write-Host 'Operation in progress'; dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /Quiet ; exit 
        }
        if ($readhost2 -ne '[P]' -xor $readhost2 -ne '[C]') {
        } else {
            confirmdism 
        }
    } else {
        Write-Host 'Windows "Virtual Machine Platform" is enabled.' -ForegroundColor Yellow; confirm 
    }
}
confirmdism