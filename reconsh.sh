#!/bin/bash

# Function to check if a command exists
function command_exists() {
    command -v "$1" &> /dev/null
}

# Ensure required tools are installed
required_tools=(whois dig nslookup nmap whatweb dirb theHarvester amass sublist3r)

for tool in "${required_tools[@]}"; do
    if ! command_exists "$tool"; then
        echo "Error: $tool is not installed."
        exit 1
    fi
done

# Get domain from user
read -p "Enter the domain: " domain

# Create a directory for the domain
output_dir="${domain}_recon"
mkdir -p "$output_dir"

# Function to perform WHOIS lookup
function whois_lookup() {
    echo "Running WHOIS lookup..."
    whois "$domain" > "$output_dir/whois.txt"
    echo "WHOIS lookup completed."
    sleep 2
}

# Function to perform DNS enumeration with dig and nslookup
function dns_enum() {
    echo "Running DNS enumeration..."
    dig "$domain" > "$output_dir/dig.txt"
    nslookup "$domain" > "$output_dir/nslookup.txt"
    echo "DNS enumeration completed."
    sleep 2
}

# Function to perform Nmap scan
function nmap_scan() {
    echo "Running Nmap scan..."
    nmap -A "$domain" -oN "$output_dir/nmap.txt"
    echo "Nmap scan completed."
    sleep 2
}

# Function to perform web technology scan with WhatWeb
function whatweb_scan() {
    echo "Running WhatWeb scan..."
    whatweb "$domain" > "$output_dir/whatweb.txt"
    echo "WhatWeb scan completed."
    sleep 2
}

# Function to perform directory brute-forcing with Dirb
function dirb_scan() {
    echo "Running Dirb scan..."
    dirb "http://$domain" > "$output_dir/dirb.txt"
    echo "Dirb scan completed."
    sleep 2
}

# Function to perform subdomain enumeration with theHarvester
function theharvester_scan() {
    echo "Running theHarvester scan..."
    theHarvester -d "$domain" -b all > "$output_dir/theHarvester.txt"
    echo "theHarvester scan completed."
    sleep 2
}

# Function to perform subdomain enumeration with Amass
function amass_scan() {
    echo "Running Amass scan..."
    amass enum -d "$domain" > "$output_dir/amass.txt"
    echo "Amass scan completed."
    sleep 2
}

# Function to perform subdomain enumeration with Sublist3r
function sublist3r_scan() {
    echo "Running Sublist3r scan..."
    sublist3r -d "$domain" -o "$output_dir/sublist3r.txt"
    echo "Sublist3r scan completed."
    sleep 2
}

# Run all the functions
whois_lookup
dns_enum
nmap_scan
whatweb_scan
dirb_scan
theharvester_scan
amass_scan
sublist3r_scan

echo "Reconnaissance completed. Results are saved in the $output_dir directory."














