#!/bin/bash
# Reference: https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/deploy-tunnels/tunnel-with-firewall/#cloud-vm-firewall

# Function to undo iptables changes
undo_iptables_changes() {
    echo -e "\nUndoing iptables changes..."
    sudo iptables -D INPUT -i lo -j ACCEPT
    sudo iptables -D INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    sudo iptables -D INPUT -p tcp --dport ssh -j ACCEPT
    sudo iptables -D INPUT -j DROP
    echo -e "Iptables changes undone. Ensure services are accessible."
}

# Check if dig dependency is installed, if not, install it
if ! command -v dig &> /dev/null; then
    echo "dig is not installed. Installing..."
    sudo apt update
    sudo apt install dnsutils -y
    echo "dig has been installed."
fi

# Show current firewall rules
sudo iptables -L

# Ask user if they wish to continue
echo -e "\n\nPlease review your current firewall rules."
read -rp "Do you wish to continue? (y/n): " choice

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

    # Test connectivity to Cloudflare
    dig_tests=(
        "A region1.v2.argotunnel.com"
        "AAAA region1.v2.argotunnel.com"
        "A region2.v2.argotunnel.com"
        "AAAA region2.v2.argotunnel.com"
        "api.cloudflare.com"
        "update.argotunnel.com"
    )

    # Iterate through dig_tests array
    for test in "${dig_tests[@]}"; do
        echo -e "\nTesting: $test"
        dig_output=$(dig "$test")

        # Check dig results
        if echo "$dig_output" | grep -q "status: NOERROR"; then
            echo "Result: Successful! Connection is okay."
        else
            echo "Result: Failed! Check your internet connection or DNS settings. Is the cloudflared daemon installed?"
        fi
    done

    sudo iptables -L
    echo -e "\n\nDone! Please review changes and ensure all services are still accessible.\n"

    # Ask user if they want to undo iptables changes
    read -rp "Do you wish to undo iptables changes? (y/n): " undo_choice
    if [[ "$undo_choice" == "y" || "$undo_choice" == "Y" ]]; then
        undo_iptables_changes
        echo -e "Changes to IPtables have been removed:"
        sudo iptables -L
        echo -e "\nBye! :]"
        exit
    else
        echo -e "\nBye! :]"
        exit
    fi

# If no, exit
elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
    echo -e "\nBye! :]"
    exit 

else
    echo "Invalid choice. Please enter 'y' or 'n'."
fi
# end
