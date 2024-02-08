#!/bin/bash

clear

echo "Web-Server Directory Discovery"
echo "Coded by FuratDehech"
echo "Version 1.0"

sleep 1

read -p "Type Webserver IP (Only HTTP SUPPORTED): " URL
read -p "Type Port (Leave blank for default=80): " PORT

PORT=${PORT:-80}
CMD="ping -c 1 -p $PORT $URL"
HOST_STATUS=0

while [ $HOST_STATUS -eq 0 ]; do
    HOST_CHECK=$($CMD)
    if [[ $HOST_CHECK == *" 0% packet loss"* ]]; then
        echo "HOST [UP]"
        HOST_STATUS=1
    else
        echo "HOST [DOWN]"
        read -p "VERIFY URL : " URL
    fi
done

read -p "Enter wordlist path: " WORDLIST_PATH
WORDLIST_PATH=${WORDLIST_PATH:-"/usr/share/wordlists/dirb/big.txt"}
read -p "VERBOSE 0-1: " VERBOSE
VERBOSE=${VERBOSE:-0}
clear
echo "URL : http://$URL:$PORT"
echo "Worlist : $WORDLIST_PATH"


if [ -f "$WORDLIST_PATH" ]; then
    exec 3< "$WORDLIST_PATH"
    while IFS= read -r try <&3; do
        Link="http://$URL:$PORT/$try"
        echo -ne "Fetchin : $Link\r"
        RES=$(curl -I -s "$Link" | head -n 1)
        if [[ $RES == "HTTP/1.1 1"* ]];then
                echo "[!] Informational : $Link"
        elif [[ $RES == "HTTP/1.1 2"* ]];then
                echo "[+] Success : $Link"
        elif [[ $RES == "HTTP/1.1 3"* ]];then
                echo "[*] Redirection : $Link"
        elif [[ $RES == "HTTP/1.1 4"* ]];then
                if [[ $VERBOSE == 1 ]];then
                        echo "[-] Client Error : $Link"
                fi
        elif [[ $RES == "HTTP/1.1 5"* ]];then
                if [[ $VERBOSE == 1 ]];then
                        echo "[-] Server Error : $Link"
                fi
        fi
    done
fi
