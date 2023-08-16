#!/bin/bash

# Show current firewall rules
sudo iptables -L

# Ask user if they wish to continue
echo -e "\n\nPlease review your current firewall rules."
read -p "Do you wish to continue? (y/n): " choice

# Check response
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo -e "\n\n\n\n========================================================="
    # Allow localhost to communicate with itself 
    sudo iptables -A INPUT -i lo -j ACCEPT

    # Allow established connections and related traffic
    sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

    # Allow new SSH connections 
    sudo iptables -A INPUT -p tcp --dport ssh -j ACCEPT

    # Drop all other ingress traffic 
    sudo iptables -A INPUT -j DROP

    sudo iptables -L
    echo -e "\n\nDone! Please review changes and ensure all services are still accessible."

# If no, exit
elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
    echo -e "\nBye! :]"
    exit 

else
    echo "Invalid choice. Please enter 'y' or 'n'."
fi