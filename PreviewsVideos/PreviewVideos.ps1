########################################################################################################################
########################################################################################################################
########################################################################################################################
###### Cr�� par : Alain Philip Despont
###### Derni�re mise � jour : 21.11.2020
###### But du script : Cr�er des vid�os raccourcies pour les r�seaux sociaux, en d�coupant des vid�os existantes.
###### Logiciels additionnels : ffmpeg
###### Notes : Get-Location fait que le script ne peut pas �tre execut� via ISE, il faut l'executer dans le dossier contenant les vid�os.
########################################################################################################################
########################################################################################################################
########################################################################################################################

#Emplacement FFMPEG
$ffmpeg = "E:\ffmpeg-win-2.2.2\ffmpeg.exe"

# R�cup�re l'emplacement du script (mis dans le m�me dossier que les vid�os � couper)
$dossier = Get-Location

# R�cup�re toutes les vid�os qui serviront � faire des preview
$toutesvideos = @(Get-ChildItem -name *.mp4)
$temps_debut_video = Read-Host -prompt 'Debut de la d�coupe au format => HH:MM:SS'
$temps_a_couper = Read-Host -prompt 'Taille de la vid�o finale au format=> HH:MM:SS'

# Pour chaque video (videoacut) pr�sentes, cr�er une commande et l'executer.
foreach ($videoAcut in $toutesvideos){

#Cr�� la commande
$commande = "$ffmpeg" + " -ss " + "$temps_debut_video" + " -t " + "$temps_a_couper" + " -i " + "$dossier" + "\" + "$videoAcut" + " -vcodec copy -acodec copy " + "$dossier" + "\PREVIEW_" + "$videoAcut"

#Execute la commande, on pipe la commande sur cmd parce que sinon elle ne s'execute simplement pas
$commande | cmd
}


