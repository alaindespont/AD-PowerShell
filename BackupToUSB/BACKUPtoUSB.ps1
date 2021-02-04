########################################################################################################################
########################################################################################################################
########################################################################################################################
###### Créé par : Alain Philip Despont
###### Dernière mise à jour : 04.02.2021
###### But du script : Copier des fichiers d'une clé USB sur un autre support USB
###### Logiciels additionnels : 
###### Notes : 
########################################################################################################################
########################################################################################################################
########################################################################################################################

# Variables de date
$mois = get-date -uformat %m
$jour = get-date -uformat %d
$annee = get-date -uformat %y

# Fonction pour arrêter le script et sortir au cas ou il y'a un problème
function Get-Exit {exit}

# On cherche la clé USB a sauvegarder
$USBASAUVEGARDER = "Alain"
$Source_USB_Letter = get-volume | select -property DriveLetter, FileSystemLabel, DriveType | where-object {$_.FileSystemLabel -eq "$USBASAUVEGARDER" -and $_.DriveType -eq "Removable"}
$SrcUSB = $Source_USB_Letter.DriveLetter

#On cherche la clé USB sur laquelle on sauvegarde
$BACKUPUSB = "BACKUP USB"
$Backup_USB_Letter = get-volume | select -property DriveLetter, FileSystemLabel, DriveType | where-object {$_.FileSystemLabel -eq "$BACKUPUSB" -and $_.DriveType -eq "Removable"}
$BakUSB = $Backup_USB_Letter.DriveLetter

# Source des fichiers à enregistrer
$Source_USB = "$SrcUSB"+ ":\USB"
$Source_Musique = "H:\2_MUSIQUE"
$Source_Photos = "H:\3_PHOTOS"
$Source_VegasPro = "H:\4_VEGASPRO"

# On test les chemins
$testUSB = test-path $Source_USB 
$testMUSIQUE = test-path $Source_Musique
$testPHOTOS = test-path $Source_Photos
$testVEGAS = test-path $Source_VegasPro

# Si les chemins n'existent pas (changement de la lettre du lecteur, ou clé pas branchée, on arrête le script)
Write-Host "TEST DES CHEMINS DES FICHIERS A SAUVEGARDER"
Write-Host ""
if ($testUSB -eq $False) {Read-Host -prompt "La clé USB -> $USBASAUVEGARDER [$SrcUSB] <- pas joignable. Le script va s'arrêter." | Get-Exit}
Else {Write-Host "$Source_USB" "[OK]"}
if ($testMUSIQUE -eq $False){Read-Host -prompt "-> H:\2_MUSIQUE <- pas joignable. Le script va s'arrêter." | Get-Exit}
Else {Write-Host "$Source_Musique" "[OK]"}
if ($testPHOTOS -eq $False){Read-Host -prompt "-> H:\3_PHOTOS <- pas joignable. Le script va s'arrêter." | Get-Exit}
Else {Write-Host "$Source_Photos" "[OK]"}
if ($testVEGAS -eq $False){Read-Host -prompt "-> H:\4_VEGASPRO <- pas joignable. Le script va s'arrêter." | Get-Exit}
Else {Write-Host "$Source_VegasPro" "[OK]"}

# Si tous les volumes sont connectés, on peut continuer le script et en avertir l'utilisateur
Write-Host ""
Write-Host "Le script va faire une copie des fichiers sur la clé usb -> $BACKUPUSB [$BakUSB] <-"
Read-Host -prompt "Appuyez sur [ENTER] pour continuer."

# On donne le chemin des sauvegardes, on le teste (voir si la clé est branché elle aussi).
# Si le chemin existe, on crée un dossier avec la date du jour.
$CheminBackup_USB = "$BakUSB" +":\1_BACKUP_DATA"
$testBACKUP = test-path $CheminBackup_USB
if ($testBACKUP -eq $False) {Read-Host -prompt "-> $CheminBackup_USB <- n'est pas joignable. Le script va s'arrêter." | Get-Exit}
Else {Write-Host "$CheminBackup_USB" "[OK]"}
$nomdossier = "Sauvegarde du "+"$jour"+"."+"$mois"+"."+"$annee"
if ($testUSB -eq $True) {$CheminSauvegarde = New-Item -Path $CheminBackup_USB -Name $nomdossier -ItemType "directory"}

# On crée des dossiers différents pour chaque sauvegarde.
$usb = "$CheminSauvegarde" +"\USB"
$musique = "$CheminSauvegarde" +"\MUSIQUE"
$photos = "$CheminSauvegarde" +"\PHOTOS"
$vegaspro = "$CheminSauvegarde" +"\VEGASPRO" 

# On copie [source] [destination] [*] tous les fichiers
# /e     Copie tous les sous-dossiers
# /r:1   Nombre d'essais
# /w:1   Temps entre chaque essais
# /v     Verbose

Robocopy $Source_USB $usb * /e /r:1 /w:1 /v /ns /nc /ndl /nfl /njh /log+:"C:\Users\alain\Desktop\BACKUPtoUSB_log.txt"
Robocopy $Source_Musique $musique * /e /r:1 /w:1 /v /ns /nc /ndl /nfl /njh /log+:"C:\Users\alain\Desktop\BACKUPtoUSB_log.txt"
Robocopy $Source_Photos $photos * /e /r:1 /w:1 /v /ns /nc /ndl /nfl /njh /log+:"C:\Users\alain\Desktop\BACKUPtoUSB_log.txt"
Robocopy $Source_VegasPro $vegaspro * /e /r:1 /w:1 /v /ns /nc /ndl /nfl /njh /log+:"C:\Users\alain\Desktop\BACKUPtoUSB_log.txt"

Read-Host -prompt "Backup terminé. Merci de vérifier le log sur le bureau."