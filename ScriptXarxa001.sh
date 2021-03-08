#!/bin/bash
netplan_client=0
netplan_servidor=0
servidor_dhcp=0
targeta_servidor_out=0
targeta_servidor_out_ip=0
targeta_servidor_in=0
targeta_servidor_in_ipestatica=0
targeta_servidor_in_gateway=0
targeta_servidor_in_nameservers=0
ruta=0

function sino_menu_1 {

read -p "Si o no?(S/n): " sino

if [ $sino == "S" ] || [ $sino == "s" ]
	then
	menu_1
elif [ $sino == "n" ] || [ $sino == "N" ]
	then
	echo -e "Eixin del programa, \e[1;32m[Enter]\e[0m per a continuar"
	read
else
	echo "Opcio no disponible, pots repetir?"
	sino_menu_1
fi

}
function sino_client_ipestatica {
read -p "Esta correcte?(S/n)" sino

if [ $sino == "S" ] || [ $sino == "s" ]
        then
	sudo chmod 777 /etc/netplan/01-network-manager-all.yaml		
	sudo echo "$netplan_client" > /etc/netplan/01-network-manager-all.yaml
	sudo chmod 644 /etc/netplan/01-network-manager-all.yaml

	echo -e "\e[1;32m[Enter]\e[0m per a aplicar els canvis"
	read
	sudo netplan apply
	echo "Ja tindriem configurat el client amb IP estatica"
	echo "Vols tornar al menu principal?"
	sino_menu_1
elif [ $sino == "n" ] || [ $sino == "N" ]
        then
        echo -e "Configurar xarxa client altra vegada, \e[1;32m[Enter]\e[0m per a continuar"
        read
	client_ipestatica
else
        echo "Opcio no disponible, pots repetir?"
        sino_client_ipestatica
fi


}
function sino_client_dhcp {
read -p "Esta correcte?(S/n)" sino

if [ $sino == "S" ] || [ $sino == "s" ]
        then
	sudo chmod 777 /etc/netplan/01-network-manager-all.yaml
        sudo echo "$netplan_client" > /etc/netplan/01-network-manager-all.yaml
	sudo chmod 644 /etc/netplan/01-network-manager-all.yaml
	echo -e "\e[1;32m[Enter]\e[0m per a aplicar els canvis"
        read
        sudo netplan apply
        echo "Ja tindriem configurat el client amb DHCP"
        echo "Vols tornar al menu principal?"
        sino_menu_1
elif [ $sino == "n" ] || [ $sino == "N" ]
        then
        echo -e "Configurar xarxa client altra vegada, \e[1;32m[Enter]\e[0m per a continuar"
        read
        client_dhcp
else
        echo "Opcio no disponible, pots repetir?"
        sino_client_dhcp
fi


}
function sino_servidor {
read -p "Esta correcte?(S/n)" sino

if [ $sino == "S" ] || [ $ino == "s" ]
	then
        echo -e "\e[1;32m[Enter]\e[0m per a aplicar els canvis"
        
elif [ $sino == "n" ] || [ $sino == "N" ]
        then
        echo -e "Configurar xarxa servidor altra vegada, \e[1;32m[Enter]\e[0m per a continuar"
        read
        servidor
else
        echo "Opcio no disponible, pots repetir?"
        sino_servidor
fi

}
function sino_dhcpd {
read -p "Esta correcte?(S/n)" sino

if [ $sino == "S" ] || [ $ino == "s" ]
        then
        echo -e "\e[1;32m[Enter]\e[0m per a aplicar "
	
elif [ $sino == "n" ] || [ $sino == "N" ]
        then
        echo -e "Configurar xarxa servidor altra vegada, \e[1;32m[Enter]\e[0m per a continuar"
        read
       	servidor_servidor_dhcp
else
        echo "Opcio no disponible, pots repetir?"
        sino_dhcpd
fi


}
function sino_enrutar {

read -p "Si o no?(S/n): " sino

if [ $sino == "S" ] || [ $sino == "s" ]
        then
		echo -e "Aleshores quina ruta vols utilitzar?\e[1;36mEXEMPLE: sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE\e[0m "
		read -p "Enrutar: " ruta
        
elif [ $sino == "n" ] || [ $sino == "N" ]
        then
        ruta="sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE"
		echo "Doncs $ruta, sera el comandament que gastarem per a enrutar els paquets"
		
        read
else
        echo "Opcio no disponible, pots repetir?"
        sino_enrutar
fi
sudo apt install iptables-persistent
}
######################################################################################################################
clear
echo -e "La funcio de aquest script que has executat es la de configurar completament la xarxa.
Tant un client com un servidor.\e[1;32m[Enter]\e[0m per a continuar"
read
######################################################################################################################
function client_ipestatica {
	echo "IP estatica"
	echo "En quina targeta de xarxa vols configuraro:"
	targetes_client=`netstat -i | tail +3 | cut -d " " -f1`
	echo "$targetes_client"
	read targeta_ipestatica
	echo -e "Quina IP estatica vols assignar per a aquest client? \e[1;36mEXEMPLE: 10.0.1.5/24\e[0m"
	read IP
	echo -e "Quin gateway vols assignar per a aquest client? \e[1;36mEXEMPLE: 10.0.1.1\e[0m "
	read gateway4
	echo -e "Quins DNS vols assignar-li a aquest client? \e[1;36mEXEMPLE: 8.8.8.8, 8.8.4.4\e[0m"
	read nameservers
	echo "Resultat final ↓"
echo "# Let NetworkManager manage all devices on this system
network:
  version: 2
  ethernets:
   $targeta_ipestatica:
    addresses: [$IP]
    gateway4: $gateway4
    nameservers:
     addresses: [$nameservers]
     "
     netplan_client="# Let NetworkManager manage all devices on this system
network:
  version: 2
  ethernets:
   $targeta_ipestatica:
    addresses: [$IP]
    gateway4: $gateway4
    nameservers:
     addresses: [$nameservers]"
     
  
read
	sino_client_ipestatica
}

function client_dhcp {
echo "dhcp"
	echo "En quina targeta de xarxa vols configuraro:"
	targetes_client=`netstat -i | tail +3 | cut -d " " -f1`
	echo "$targetes_client"
	read targeta_dhcp
	echo "Resultat final ↓"
	echo "# Let NetworkManager manage all devices on this system
network:
  version: 2
  ethernets:
   $targeta_dhcp:
    dhcp4: true"
    netplan_client="# Let NetworkManager manage all devices on this system
network:
  version: 2
  ethernets:
   $targeta_dhcp:
    dhcp4: true"

    read
	sino_client_dhcp
}
function client {
clear
echo -e "\e[1;31mWARNING\e[0m aquesta funció és únicament per a clients, no per a servidors, assegurat que siga l'opció que vuigues, \e[1;32m[Enter]\e[0m per a continuar "
read
echo "Abans que res aquest script te que ejecutarse en la maquina que tinguem assignada per al client."
echo "Com vols configurar el client:
	1.IP estatica
	2.DHCP"
read conf_1_client
if [ $conf_1_client == "1" ]
	then 
		client_ipestatica
elif [ $conf_1_client == "2" ]
	then
		client_dhcp
else 
	echo -e "\e[1;31mERROR\e[0m opcio no disponible, cal repetir, \e[1;32m[Enter]\e[0m per a continuar"
	read
	client
fi
}
function servidor_in {
	echo "Quina targeta vols assignar per a rebre internet:"
        targetes_servidor=`netstat -i | tail +3 | cut -d " " -f1`
        echo "$targetes_servidor"		
       	read targeta_servidor_in
	echo "Com vols configurar la targeta $targeta_servidor_in:
        1.IP estatica
	2.DHCP (recomanada)"
	read conf_1_client
	
if [ $conf_1_client == "1" ]
        then
		servidor_dhcp=0
		echo -e "Quina IP estatica vols assignar per a aquesta tarjeta $targeta_servidor_in? \e[1;36mEXEMPLE: 192.168.1.25/24\e[0m"
                read targeta_servidor_in_ipestatica
	       	echo -e "Quin gateway vols assignar per a $targeta_servidor_in? \e[1;36mEXEMPLE: 192.168.1.1\e[0m "
        	read targeta_servidor_in_gateway
        	echo -e "Quins DNS vols assignar-li a $targeta_servidor_in? \e[1;36mEXEMPLE: 8.8.8.8, 8.8.4.4\e[0m"
        	read targeta_servidor_in_nameservers
        echo "Resultat final ↓"
		echo "Targeta: $targeta_servidor_in"
		echo "	IP estatica: $targeta_servidor_in_ipestatica"
		echo "	Gateway: $targeta_servidor_in_gateway"
		echo "	DNS: $targeta_servidor_in_nameservers"


elif [ $conf_1_client == "2" ]
        then
		servidor_dhcp=1
                echo "dhcp $targeta_servidor_in"
else
        echo -e "\e[1;31mERROR\e[0m opcio no disponible, cal repetir, \e[1;32m[Enter]\e[0m per a continuar"
        read
        servidor_in
fi
}
function servidor_out {
	echo "Quina targeta vols assignar per a proveïr internet:"
        targetes_servidor=`netstat -i | tail +3 | cut -d " " -f1`
       	echo "$targetes_servidor"
	read targeta_servidor_out
        echo -e "Quina IP vols assignar per a $targeta_servidor_out: \e[1;36mEXEMPLE: 10.0.1.1/24\e[0m "
	read targeta_servidor_out_ip
	echo "Targeta: $targeta_servidor_out"
	echo "IP: $targeta_servidor_out_ip"
}

function servidor_servidor_dhcp {

echo -e "Temps per a default-lease-time? \e[1;36mEXEMPLE: 600\e[0m"
read default
echo -e "Temps per a max-lease-time? \e[1;36mEXEMPLE: 7200\e[0m"
read max
echo -e "IP per a la subnet? \e[1;36mEXEMPLE: 10.0.1.0\e[0m"
read subnet
echo -e "Mascara de la subnet? \e[1;36mEXEMPLE: 255.255.255.0\e[0m"
read netmask
echo -e "Rango de IP's ? \e[1;36mEXEMPLE: 10.0.1.50 10.0.1.200\e[0m"
read range
echo -e "Gateway? \e[1;36mEXEMPLE: 10.0.1.1\e[0m"
read routers
echo -e "IP per al DNS? \e[1;36mEXEMPLE: 8.8.8.8\e[0m"
read servers
echo -e "Nom del domini? \e[1;36mEXEMPLE: mydomain.example\e[0m"
read domain
echo "Resultat final ↓"
echo "# minimal sample /etc/dhcp/dhcpd.conf
default-lease-time $default;
max-lease-time $max;

subnet $subnet netmask $netmask {
 range $range;
 option routers $routers;
 option domain-name-servers $servers;"
echo ' option domain-name "'$domain'" ;
}'
sino_dhcpd
servidor_dhcp_conf=`echo "# minimal sample /etc/dhcp/dhcpd.conf
default-lease-time $default;
max-lease-time $max;

subnet $subnet netmask $netmask {
 range $range;
 option routers $routers;
 option domain-name-servers $servers;"
echo ' option domain-name "'$domain'" ;
}'`

sudo chmod 777 /etc/dhcp/dhcpd.conf
        sudo echo "$servidor_dhcp_conf" > /etc/dhcp/dhcpd.conf
        sudo chmod 644 /etc/dhcp/dhcpd.conf
sudo sed -i 's/INTERFACESv4=""/INTERFACES="'$targeta_servidor_out'"/g' /etc/default/isc-dhcp-server
sudo sed -i 's/INTERFACESv6=""/#INTERFACESv6=""/g' /etc/default/isc-dhcp-server
sudo systemctl restart isc-dhcp-server.service

}


function servidor {
clear
echo -e "\e[1;31mWARNING\e[0m aquesta funció és únicament per a servidor, no per a clients, assegurat que siga l'opció que vuigues, \e[1;32m[Enter]\e[0m per a continuar "
read
echo "Abans que res aquest script te que ejecutarse en la maquina que tinguem assignada per al servidor."
servidor_in
servidor_out

############################
if [ $servidor_dhcp == "1" ]
	then
echo "Resultat final ↓"
echo "# This is the network config written by 'subiquity'
network:
  ethernets:
    $targeta_servidor_in:
      dhcp4: true
    $targeta_servidor_out:
      addresses: [$targeta_servidor_out_ip]
  version: 2"
  netplan_servidor=`echo "# This is the network config written by 'subiquity'
network:
  ethernets:
    $targeta_servidor_in:
      dhcp4: true
    $targeta_servidor_out:
      addresses: [$targeta_servidor_out_ip]
  version: 2"`
  sino_servidor
  sudo chmod 777 /etc/netplan/00-installer-config.yaml
        sudo echo "$netplan_servidor" > /etc/netplan/00-installer-config.yaml
        sudo chmod 644 /etc/netplan/00-installer-config.yaml
  sudo netplan apply

   sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf 
   sudo sysctl -p
	echo -e "Per a poder tindre el servidor dhcp hi ha que instalar \e[0;31mdhcp-server\e[0m \e[1;32m[Enter]\e[0m per a continuar "
	read
	sudo apt install isc-dhcp-server
	echo "Ara hi ha que configurar el dhcp"
	servidor_servidor_dhcp
	echo -e "\e[1;32m[Enter]\e[0m per a continuar "
  	read
  


############################
else
echo "Resultat final ↓"
echo "# This is the network config written by 'subiquity'
network:
  ethernets:
   $targeta_servidor_in:
    addresses: [$targeta_servidor_in_ipestatica]
    gateway4: $targeta_servidor_in_gateway
    nameservers:
     addresses: [$targeta_servidor_in_nameservers]
   $targeta_servidor_out:
    addresses: [$targeta_servidor_out_ip]
  version: 2"
netplan_servidor=`echo "# This is the network config written by 'subiquity'
network:
  ethernets:
   $targeta_servidor_in:
    addresses: [$targeta_servidor_in_ipestatica]
    gateway4: $targeta_servidor_in_gateway
    nameservers:
     addresses: [$targeta_servidor_in_nameservers]
   $targeta_servidor_out:
    addresses: [$targeta_servidor_out_ip]
  version: 2"` 
   sino_servidor

     sudo chmod 777 /etc/netplan/00-installer-config.yaml
        sudo echo "$netplan_servidor" > /etc/netplan/00-installer-config.yaml
        sudo chmod 644 /etc/netplan/00-installer-config.yaml

   sudo netplan apply
   sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
   sudo sysctl -p
   echo -e "\e[1;32m[Enter]\e[0m per a continuar "
   read
  
fi
echo "Per a enrutar gastarem el comando"
echo -e "\e[1;36mEXEMPLE: sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE \e[0m "
echo "Vols ficar un altre?"
sino_enrutar
echo -e "\e[1;32m[Enter]\e[0m[Enter]\e[om per a executar el camandament"
$ruta
echo "I ja tindriem el sevidor configurat, vols anar al menu principal?"
sino_menu_1

}
function correu {
	echo -e "Tens que tindre instal·lat \e[0;31mmainutils\e[0m \e[1;32m[Enter]\e[0m per a continuar "
	read
	sudo apt-get install mailutils 
	clear
	echo "Quina sugerencia me dones per a millorar aquest script: "
	read sugerencia
	mail -s "Sugerencies Script Xarxa" joaquim1smx@gmail.com  <<< "$sugerencia"
	echo "Gracies per les teves sugerencies, t'ho agraixc molt"
	echo "Vols tornar al menu principal?"
	sino_menu_1
}

function menu_1 {
clear
echo "Quin dispositiu vols configurar
	1. Client
	2. Servidor
	3. Cap, vuic eixir
	4. Altres
"
read dispositiu

case $dispositiu in 
	1) echo -e "Entrant a configuracio de Client, \e[1;32m[Enter]\e[0m per a passar al següent pas"
	   read
	   client;;
	2) echo -e "Entrant a configuracio de Servidor, \e[1;32m[Enter]\e[0m per a passar al següent pas"
	   read
	   servidor;;
	3) echo -e "Val, adeu \e[1;32m[Enter]\e[0m per a eixir"
	   read;;
	4) echo -e "Pots deixar la sugerencia de el que vols al meu correu \e[1;32m[Enter]\e[0m per a continuar"
	   read;;
	*) echo -e "\e[1;31mERROR\e[0m, Opcio no disponible"
	   menu_1;;
esac
}
menu_1
