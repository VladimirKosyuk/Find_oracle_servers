#Created by https://github.com/VladimirKosyuk

#Find servers with Oracle installed in AD Domain. Output result to CLI as server DNS name;Oracle version
#
# Build date: 21.09.2020									   
 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


$list = Get-ADComputer -Filter * -properties *|Where-Object {$_.enabled -eq $true} | Where-Object {(($_.distinguishedname -like "*Servers*") -and ($_.distinguishedname -notlike "*Test*"))  -and ($_.LastLogonDate -ge ((Get-Date).AddDays(-14)))}| Select-Object -ExpandProperty "name"
$ErrorActionPreference="silentlycontinue"
foreach ($pc in $list) {
$error.Clear()
Invoke-Command -ComputerName $pc -ScriptBlock {
$ErrorActionPreference="silentlycontinue"
if
($Path = (Get-WmiObject win32_service | Where-Object{($_.PathName -like '*oracle*') -and ($_.Pathname -like '*ORACLE.EXE*')} | Select-Object -ExpandProperty "Pathname").Split(' ')[0])
{$Ver = get-childitem $Path | Select-Object -ExpandProperty VersionInfo | Select-Object -ExpandProperty FileVersion

Write-Output (($env:computername)+";"+($Ver))}

}
}

Remove-Variable -Name * -Force -ErrorAction SilentlyContinue
