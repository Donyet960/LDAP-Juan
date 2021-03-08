#!/bin/bash
clear
dir="/home/$USER/backup"

function backup {
echo "Iniciant copia de seguretat"
if [ -d $dir ];
then
echo "[======>·················]25%"
else
mkdir $dir
echo "[======>·················]25%"
fi
sleep 2
#############################################Comprava si existeix el directori i si no el crea#############################################
clear
data=`date +%d-%m-%Y`
echo -e "Nom per defecte?\e[1;32m[$data]\e[0m"
read name
if [ -z "$name" ]
then
echo "[===========>············]50%"
echo "Nom del backup→ $data.ldif"
backup=`echo "$data.ldif"`
else
echo "[===========>············]50%"
echo "Nom del backup→ $name-$data.ldif"
backup=`echo "$name-$data.ldif"`
fi
sleep 2
############################################Nom per al backup, per defecte la fecha actual#################################################
clear
if [ -f $dir/$backup ]
then
echo "Ja existeix el backup"
backup
else
echo "Creant backup"
echo "[===================>····]75%"
sudo systemctl stop slapd.service
sudo slapcat >> $dir/$backup
sleep 2
#############################################Comprova si existeix el backup, i si existeix no el crea#######################################
clear
sudo systemctl restart slapd.service
echo "[=======================>]100%"
sleep 2
echo "Copia de seguretat creada i servei funcional"
echo "Gracies per utilitzar aquest script"
echo -e "\e[1;31mby Ximo Ribera\e[0m"
fi

}
######################################################################################################################################################

function restore {
echo "Restaurant copia de seguretat"
sleep 2
clear
if [ -d $dir ];
then
echo "[======>·················]25%"
else
echo "No existeix directori per a les copies de seguretat"
fi
sleep 2
##########################################Comprova si existeix el directori dels backups#######################################################
clear
backups=`ls $dir`
echo "Quina copia de seguretat vols utilitzar?"
echo "$backups"
read rbackup
if [ -f $dir/$rbackup ]
then
clear
echo "[===========>············]50%"
sleep 2
sudo /etc/init.d/slapd stop
sudo rm /var/lib/ldap/*
sudo /etc/init.d/slapd start
sudo /etc/init.d/slapd stop
sudo slapadd -l $dir/$rbackup
sudo chown openldap:openldap /var/lib/ldap/*
clear
echo "[===================>····]75%"
sleep 2
###########################################S'han borrat els fitxers corresponents i restaurat la base de dades############################################

sudo /etc/init.d/slapd start
clear
echo "[=======================>]100%"
sleep 2
echo "Copia de seguretat restaurada i servei funcional"
echo "Gracies per utilitzar aquest script"
echo -e "\e[1;31mby Ximo Ribera\e[0m"
###########################################El servei s'ha iniciat correctament#############################################################################3
else
echo "Copia de seguritat no s'ha trobat, torna a intentaro"
sleep 2
restore
fi



}
function opcio {
echo -e "\e[1;34mLDAP-Backup\e[0m"
echo -e "\e[1;31mby Ximo Ribera\e[0m"
echo "	1.Copia de Seguretat"
echo "	2.Restaurar base de dades"
echo "	3.Res vuic ixir"
read -p "Que vols fer? " opcio
case $opcio in
	1)backup;;
	2)restore;;
	3)echo "Val, ixin del programa";;
	*)clear
	echo "Pots repetir l'opcio"
	opcio;;
esac
}

opcio
