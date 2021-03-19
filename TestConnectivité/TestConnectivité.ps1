########################################################################################################################
########################################################################################################################
########################################################################################################################
###### Créé par : Alain Philip Despont
###### Dernière mise à jour : 19.03.2021
###### But du script : Diagnostiquer une connexion internet
###### Logiciels additionnels : 
###### Notes :
########################################################################################################################
########################################################################################################################
########################################################################################################################

#Script pour tester la connectivité
# Tester si cable réseau est branché http://guidestomicrosoft.com/2016/07/23/check-if-the-network-cable-is-unplugged-through-powershell/
#Get-NetAdapter | Where-Object PhysicalMediaType -EQ 802.3

# http://quickbytesstuff.blogspot.com/2015/10/powershell-get-ip-address-and-subnet.html
# $nic_configuration = gwmi -computer .  -class "win32_networkadapterconfiguration" | Where-Object {$_.defaultIPGateway -ne $null}
# $IP = $nic_configuration.ipaddress
# write-output " IP Address : $IP"
# $MAC_Address = $nic_configuration.MACAddress
# write-output " MAC Address :  $MAC_Address"
# $SubnetMask = $nic_configuration.ipsubnet
# write-output " MAC Address :  $SubnetMask"




# Nom dordinateur et groupe/domaine
$computername = (Get-WmiObject Win32_ComputerSystem).Name
$domainename = (Get-WmiObject Win32_ComputerSystem).Domain

#Prendre les informations (IPv4, IPv6, masque, passerelle)
# https://stackoverflow.com/questions/27277701/powershell-get-ipv4-address-into-a-variable
$ipv4 = (Test-Connection -ComputerName $env:ComputerName -Count 1).IPV4Address.IPAddressToString
$ipv6 = (Test-Connection -ComputerName $env:ComputerName -Count 1).IPV6Address.IPAddressToString
$masque = (Get-WmiObject -class "win32_networkadapterconfiguration"| where {$_.IPEnabled}).ipsubnet
$macadress = (Get-WmiObject -class "win32_networkadapterconfiguration"| where {$_.IPEnabled}).MACAddress

#Tester si la passerelle par défaut répond
$passerelle = (Get-wmiObject -class "Win32_networkAdapterConfiguration" | where {$_.IPEnabled}).DefaultIPGateway
if ($passerelle -eq $null) {$passerelle = "192.168.0.1"}


#Résultats
""
write-host -ForegroundColor Gray "##################################################"
write-host -ForegroundColor Yellow "TEST DE CONNECTIVITE"
write-host -ForegroundColor Gray "##################################################"
""


#Afficher l'information sur le noeud
write-host -ForegroundColor Yellow "ORDINATEUR ET DOMAINE"
""
"Nom de l'ordinateur                 $computername"
"Domaine ou Groupe de travail        $domainename"
""


#Afficher l'adressage de la carte réseau
write-host -ForegroundColor Yellow "ADRESSAGE IP"
""
"Adresse IPv4                        $ipv4"
"Masque de sous réseau (4/6)         $masque"
"Adresse IPv6                        $ipv6"
"Adresse MAC                         $macadress"
""


#La passerelle
write-host -ForegroundColor Yellow "PASSERELLE"
""
"Passerelle par défaut               $Passerelle"
""


#Et un diagnostique de l'ensemble
write-host -ForegroundColor Yellow "DIAGNOSTIQUE"
""


$isdomain = if($domainname -ne "WORKGROUP")
{write-host -ForegroundColor Yellow "L'ordinateur n'est pas membre d'un domaine Active Directory"}
else
{write-host -ForegroundColor Green "L'ordinateur est membre du domaine" $domainename}


$netcard = get-wmiobject win32_networkadapter | where netconnectionstatus -eq 2
if($netcard.netconnectionstatus -eq 2)
{write-host -ForegroundColor Green "L'ordinateur possède au moins une carte réseau active"}
else
{write-host -ForegroundColor Red "! Pas de carte réseau active !"}


#On teste si la passerelle est joignable
$accespasserelle = Test-netconnection "$passerelle"
if ($accespasserelle.PingSucceeded -eq $True)
{write-host -ForegroundColor Green "La passerelle par défaut est joignable depuis cet ordinateur"}
else
{write-host -ForegroundColor Red "! Passerelle injoignable !"}


#Pareil, mais pour voir si la résolution de nom se fait correctement
$accesdns = Test-netconnection google.com
if ($accesdns.PingSucceeded -eq $True)
{write-host -ForegroundColor Green "L'ordinateur peut résoudre les noms à l'aide de DNS"}
else
{write-host -ForegroundColor Red "! Pas de DNS !"}


#On teste si on arrive à joindre le serveur de google
$accesinternet = Test-netconnection 8.8.8.8
if ($accesinternet.PingSucceeded -eq $True)
{write-host -ForegroundColor Green "L'ordinateur peut accéder a internet"}
else
{write-host -ForegroundColor Red "! Pas d'internet !"}
""



Read-Host -Prompt "Presser Enter pour quitter"



