#!/bin/bash

clear

echo "=============================="
echo " Web-Server Directory Scanner "
echo " Coded by FuratDehech"
echo " Version 1.1"
echo "=============================="
sleep 1

# --- User inputs ---
read -rp "Type Webserver IP or domain (HTTP only): " URL
read -rp "Type Port [default: 80]: " PORT
PORT=${PORT:-80}

# --- Check host availability ---
echo "[*] Checking host availability..."

while true; do
    if ping -c 1 "$URL" &>/dev/null; then
        echo "[+] HOST UP"
        break
    else
        echo "[-] HOST DOWN"
        read -rp "Verify URL: " URL
    fi
done

# --- Wordlist & options ---
read -rp "Enter wordlist path [default: /usr/share/wordlists/dirb/big.txt]: " WORDLIST_PATH
WORDLIST_PATH=${WORDLIST_PATH:-"/usr/share/wordlists/dirb/big.txt"}

read -rp "Verbose mode? (0 = No, 1 = Yes) [default: 0]: " VERBOSE
VERBOSE=${VERBOSE:-0}

clear
echo "[*] Target : http://$URL:$PORT"
echo "[*] Wordlist : $WORDLIST_PATH"
echo "--------------------------------"

# --- Validate wordlist ---
if [[ ! -f "$WORDLIST_PATH" ]]; then
    echo "[!] Wordlist not found!"
    exit 1
fi

# --- Directory discovery ---
while IFS= read -r DIR; do
    LINK="http://$URL:$PORT/$DIR"
    echo -ne "Fetching: $LINK\r"

    STATUS=$(curl -o /dev/null -s -w "%{http_code}" "$LINK")

    case $STATUS in
        1*)
            echo "[!] Informational ($STATUS) : $LINK"
            ;;
        2*)
            echo "[+] Found ($STATUS) : $LINK"
            ;;
        3*)
            echo "[*] Redirect ($STATUS) : $LINK"
            ;;
        4*)
            [[ $VERBOSE -eq 1 ]] && echo "[-] Client Error ($STATUS) : $LINK"
            ;;
        5*)
            [[ $VERBOSE -eq 1 ]] && echo "[-] Server Error ($STATUS) : $LINK"
            ;;
    esac

done < "$WORDLIST_PATH"
