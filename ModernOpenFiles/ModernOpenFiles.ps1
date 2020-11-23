########################################################################################################################
########################################################################################################################
########################################################################################################################
###### Cr�� par : Alain Philip Despont
###### Derni�re mise � jour : 02.12.2019
###### But du script : Automatiser l'ouverture des applciations et fichiers dat�s du Cin�ma Moderne
###### Logiciels additionnels : 
###### Notes : Besoin du batch pour lancer le script au d�marrage de l'ordinateur, � placer dans les programmes de d�marrage
########################################################################################################################
########################################################################################################################
########################################################################################################################

$jour = get-date -uformat %d
$annee = get-date -uformat %y
$mois_chiffre = get-date -uformat %m
$mois_lettre = get-date -format "MMMM"

$cheminInventaireDVD = "C:\Users\utilisateur\Documents\D�comptes cin�ma Moderne\DVD\" +"$mois_chiffre" + "-Inventaire DVD" + " $mois_lettre" + " 19.ods"

Invoke-Item "$cheminInventaireDVD"
Invoke-Item "C:\Users\utilisateur\Documents\D�comptes cin�ma Moderne\AnomaliesCabines2019.ods"
Invoke-Item "C:\Users\utilisateur\Documents\D�comptes cin�ma Moderne\DVD\DVD promo1.ods"
Invoke-Item "C:\Program Files (x86)\Microsoft\Skype for Desktop\Skype.exe"
Invoke-Item "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
Invoke-Item "C:\Program Files (x86)\Mozilla Thunderbird\thunderbird.exe"
Invoke-Item "C:\Program Files\iTunes\iTunes.exe"
Invoke-item "C:\Windows\system32\StikyNot.exe"

Copy-Item "C:\Users\utilisateur\Documents\D�comptes cin�ma Moderne\Rapport journalier\ORIGINAL_Tagesrapport  Warenbestand Moderne.ods" -destination "C:\Users\utilisateur\Desktop"
Rename-Item "C:\Users\utilisateur\Desktop\ORIGINAL_Tagesrapport  Warenbestand Moderne.ods" -NewName "TA.B2.Mod.$jour.$mois_chiffre.$annee.ods"