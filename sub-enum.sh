#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# Color codes for output
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
NORMAL="\e[0m"
BOLD="\e[1m"

domain="$1"
base_dir="$(pwd)/results_$domain"
mkdir -p "$base_dir"

echo -e "${BOLD}${GREEN}Starting Subdomain On $domain${NORMAL}"

# Create directories for categories
mkdir -p "$base_dir/subdomains"

# 1. Subdomain Enumeration
echo -e "${GREEN}[*] Enumerating subdomains...${NORMAL}"
subfinder -d "$domain" -o "$base_dir/subdomains/subfinder.txt"
amass enum -d "$domain" -o "$base_dir/subdomains/amass.txt"
/usr/bin/sublist3r -d "$domain" -o "$base_dir/subdomains/sublist3r.txt"
assetfinder --subs-only "$domain" > "$base_dir/subdomains/assetfinder.txt"


cat "$base_dir/subdomains/"*.txt | sort -u > "$base_dir/subdomains/all_subdomains.txt"
echo -e "${GREEN}[+] Total unique subdomains: $(wc -l < "$base_dir/subdomains/all_subdomains.txt")${NORMAL}"


echo -e "${GREEN}[*] Checking alive subdomains with httpx...${NORMAL}"
httpx -silent -threads 50 -status-code -ip -title -location -tech-detect -l "$base_dir/subdomains/all_subdomains.txt" -o "$base_dir/subdomains/alive.txt"
echo -e "${GREEN}[+] Alive subdomains saved to $base_dir/subdomains/alive.txt${NORMAL}"
