########################################################################################################################
########################################################################################################################
########################################################################################################################
###### Créé par : Alain Philip Despont
###### Dernière mise à jour : 07.01.2021
###### But du script : Créer des vidéos raccourcies pour les réseaux sociaux, en découpant des vidéos existantes.
###### Logiciels additionnels : ffmpeg
###### Notes : Get-Location fait que le script ne peut pas être executé via ISE, il faut l'executer dans le dossier contenant les vidéos.
########################################################################################################################
########################################################################################################################
########################################################################################################################

#Emplacement FFMPEG
$ffmpeg = "E:\ffmpeg-win-2.2.2\ffmpeg.exe"

# Récupère l'emplacement du script (mis dans le même dossier que les vidéos à couper)
$dossier = Get-Location

# Récupère toutes les vidéos qui serviront à faire des preview
$toutesvideos = @(Get-ChildItem -name *.mp4)
$temps_debut_video = Read-Host -prompt 'Debut de la découpe au format => HH:MM:SS'
$temps_a_couper = Read-Host -prompt 'Taille de la vidéo finale au format=> HH:MM:SS'

# Pour chaque video (videoacut) présentes, créer une commande et l'executer.
foreach ($videoAcut in $toutesvideos){

#Créé la commande
$commande = "$ffmpeg" + " -ss " + "$temps_debut_video" + " -t " + "$temps_a_couper" + " -i " + "$dossier" + "\" + "$videoAcut" + " -vcodec copy -acodec copy " + "$dossier" + "\PREVIEW_" + "$videoAcut"

#Execute la commande, on pipe la commande sur cmd parce que sinon elle ne s'execute simplement pas
cmd.exe /c "$commande"
}


