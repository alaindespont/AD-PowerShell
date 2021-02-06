########################################################################################################################
########################################################################################################################
########################################################################################################################
###### Créé par : Alain Philip Despont
###### Dernière mise à jour : 06.02.2021
###### But du script : Produire des listes des programmes, apps et mise à jour installées sur le système en les séparant si c'est Microsoft ou pas.
###### Logiciels additionnels : 
###### Notes : -NotMatch ne produit pas les résultat voulus, d'ou l'utilisation de -notcontains
########################################################################################################################
########################################################################################################################
########################################################################################################################

$chemin_temporaire32 = "$PSScriptRoot" + "/ProgrammesInstallés_temp32.csv"
$chemin_temporaire64 = "$PSScriptRoot" + "/ProgrammesInstallés_temp64.csv"
$chemin_temporaire_full = "$PSScriptRoot" + "/ProgrammesInstallés_tempfull.csv"
$chemin_Windows = "$PSScriptRoot" + "/ProgrammesWindows.csv"
$chemin_PasWindows = "$PSScriptRoot" + "/ProgrammesPasWindows.csv"

# Programmes 32 bit
# Exporte tous les programmes installés dans un fichier CSV
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*| 
Select-Object -Property DisplayName, DisplayVersion, Publisher, @{Name="InstallDate"; Expression={([datetime]::ParseExact($_.InstallDate, 'yyyyMMdd', $null)).toshortdatestring()}} |
Export-Csv -NoTypeInformation -Path $chemin_temporaire32

# Programmes 64bit
# Exporte tous les programmes installés dans un fichier CSV
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*| 
Select-Object -Property DisplayName, DisplayVersion, Publisher, @{Name="InstallDate"; Expression={([datetime]::ParseExact($_.InstallDate, 'yyyyMMdd', $null)).toshortdatestring()}} |
Export-Csv -NoTypeInformation -Path $chemin_temporaire64

# Assemble les deux csv
@(Import-Csv -path $chemin_temporaire32) + @(Import-Csv -path $chemin_temporaire64) | Export-Csv $chemin_temporaire_full

# Importe le fichier temporaire complet, supprime les vides du tableur, crée un fichier contenant tous les programmes installés qui ne sont pas de Microsoft
Import-Csv -Path $chemin_temporaire_full|
Where-Object {$_.PSObject.Properties.Value -ne ''}|
Where-Object {$_.PSObject.Properties.Value -notcontains "Microsoft"}|
Where-Object {$_.PSObject.Properties.Value -notcontains "Microsoft Corporation"}|
Where-Object {$_.PSObject.Properties.Value -notcontains "Microsoft Corporations"}|
Export-Csv -NoTypeInformation -Path $chemin_PasWindows

# Réimporte le fichier, mais cette fois garde que ce qui est Microsoft
Import-Csv -Path $chemin_temporaire_full|
Where-Object {$_.PSObject.Properties.Value -Match "Microsoft"}|
Export-Csv -NoTypeInformation -Path $chemin_Windows

#Nettoye les fichiers temporaires
Remove-Item -Path $chemin_temporaire32
Remove-Item -Path $chemin_temporaire64
Remove-Item -Path $chemin_temporaire_full
