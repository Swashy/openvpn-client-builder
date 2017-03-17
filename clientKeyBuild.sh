#!/bin/bash

#Check if user is root. if not, sudo it.
#(( EUID != 0 )) && exec sudo -- "$0" "$@"

echo "Welcome to shitty DO vpn guide automator 2000"
cd /etc/openvpn/
checkclient=$(ls -la | grep client.conf)
checkovpn=$(ls -la | grep $1.ovpn)
checkkey=$(ls -la /etc/openvpn/easy-rsa/keys | grep $1.key)
checkcrt=$(ls -la /etc/openvpn/easy-rsa/keys | grep $1.crt)
checkcsr=$(ls -la /etc/openvpn/easy-rsa/keys | grep $1.csr)

#Check if $1 parameter was given with script
if [ -z "$1" ]; then
    echo "You didn't provide a client name!"
#Is the example clientconf file copied in this dir?"
elif [ -z "$checkclient" ]; then
    echo "ERROR! No client.conf!"
#Do we already have a final .ovpn file made?
elif ! [ -z "$checkovpn" ]; then
    echo "ERROR! $1.ovpn file already exists!"
#Does the key already exist?
elif ! [ -z "$checkkey" ]; then
    echo "ERROR! $1.key file already exists! This script generates a new one!"
#Check if $1.crt exists
elif ! [ -z "$checkcrt" ]; then
    echo "ERROR! $1.crt file already exists! This script generates a new one!"
#csr?
elif ! [ -z "$checkcsr" ]; then
    echo "ERROR! $1.csr file already exists! This script generates a new one!"
else

########
echo ""
echo "This tool will automatically append all yer filez into an .ovpn file"
echo "Assumes your generated keys are in /etc/openvpn/easy-rsa/keys"
echo "Also assumes client.conf example file is in here"
echo "Put in the client's name as the 1st parameter"
printf "\n"
echo "Sourcing ./vars"
cd /etc/openvpn/easy-rsa
source ./vars
echo "Running ./build-key"
./build-key $1
echo "Copying client.conf..."
printf "\n"
cp /etc/openvpn/client.conf /etc/openvpn/$1.ovpn
cd /etc/openvpn/
echo "Appending certs and what not into $1.openvpn"
echo "<ca>" >> $1.ovpn
cat ca.crt >> $1.ovpn
echo "</ca>" >> $1.ovpn
echo "<cert>" >> $1.ovpn
cat /etc/openvpn/easy-rsa/keys/$1.crt >> $1.ovpn
echo "</cert>" >> $1.ovpn
echo "<key>" >> $1.ovpn
cat /etc/openvpn/easy-rsa/keys/$1.key >> $1.ovpn
echo "</key>" >> $1.ovpn
#########
printf "\n"
printf "Done"
printf "\n"
fi
