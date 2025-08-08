#!/bin/bash

echo "[+]------ Starting Sub-Subdomains Enumeration ------[+]"

echo "[+] Enumerating Sub-Subdomains [+]"
cd ~/tools/altdns
python3 -m altdns -i ~/scripts/target/alive.txt -o data_output -w words.txt -r -s ~/scripts/target/sub-subdomains.txt

echo "[+] Removing Trash Files [+]"
[ -f data_output ] && rm data_output
