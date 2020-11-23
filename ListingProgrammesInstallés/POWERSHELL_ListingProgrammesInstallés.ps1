########################################################################################################################
########################################################################################################################
########################################################################################################################
###### Créé par : Alain Philip Despont
###### Dernière mise à jour : 21.11.2020
###### But du script : Produire des listes des programmes, apps et mise à jour installées sur le système en les séparant si c'est Microsoft ou pas.
###### Logiciels additionnels : 
###### Notes : -NotMatch ne produit pas les résultat voulus, d'ou l'utilisation de -notcontains
########################################################################################################################
########################################################################################################################
########################################################################################################################

$chemin_temporaire = "$PSScriptRoot" + "/ProgrammesInstallés_temp.csv"
$chemin_Windows = "$PSScriptRoot" + "/ProgrammesWindows.csv"
$chemin_PasWindows = "$PSScriptRoot" + "/ProgrammesPasWindows.csv"

# Exporte tous les programmes installés dans un fichier CSV
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*| 
Select-Object -Property DisplayName, DisplayVersion, Publisher, @{Name="InstallDate"; Expression={([datetime]::ParseExact($_.InstallDate, 'yyyyMMdd', $null)).toshortdatestring()}} |
Export-Csv -NoTypeInformation -Path $chemin_temporaire

# Importe le fichier temporaire, supprime les vides du tableur, crée un fichier contenant tous les programmes installés qui ne sont pas de Microsoft
Import-Csv -Path $chemin_temporaire|
Where-Object {$_.PSObject.Properties.Value -ne ''}|
Where-Object {$_.PSObject.Properties.Value -notcontains "Microsoft"}|
Where-Object {$_.PSObject.Properties.Value -notcontains "Microsoft Corporation"}|
Where-Object {$_.PSObject.Properties.Value -notcontains "Microsoft Corporations"}|
Export-Csv -NoTypeInformation -Path $chemin_PasWindows

# Réimporte le fichier, mais cette fois garde que ce qui est Microsoft
Import-Csv -Path $chemin_temporaire|
Where-Object {$_.PSObject.Properties.Value -Match "Microsoft"}|
Export-Csv -NoTypeInformation -Path $chemin_Windows

#Nettoyer fichiers temporaires
Remove-Item -Path $chemin_temporaire