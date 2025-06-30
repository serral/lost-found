echo "========================================"
echo

# Function to print colored output
print_status() {
    echo -e "\033[1;32m[INFO]\033[0m $1"
}

print_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
}

print_warning() {
    echo -e "\033[1;33m[WARNING]\033[0m $1"
}

# Check if running as root or with sudo
if [[ $EUID -eq 0 ]]; then
    SUDO=""
else
    SUDO="sudo"
    print_warning "This script requires sudo privileges"
fi

# Step 1: Update package lists
print_status "Updating package lists..."
$SUDO apt update

# Step 2: Install neofetch
print_status "Installing neofetch..."
$SUDO apt install neofetch -y

# Step 3: Create neofetch MOTD script
print_status "Creating neofetch MOTD script..."
$SUDO bash -c 'cat > /etc/update-motd.d/01-neofetch << "SCRIPT_EOF"
#!/bin/bash
neofetch
SCRIPT_EOF'

# Step 4: Make the script executable
print_status "Making MOTD script executable..."
$SUDO chmod +x /etc/update-motd.d/01-neofetch

# Step 5: Test the MOTD configuration
print_status "Testing MOTD configuration..."
echo
echo "========================================"
echo "MOTD Preview:"
echo "========================================"
$SUDO run-parts /etc/update-motd.d/ 2>/dev/null || {
    print_warning "Could not preview MOTD, but configuration should work on next login"
}

echo
print_status "Setup completed successfully!"
echo
echo "========================================"
echo "Summary:"
echo "========================================"
echo "✅ Neofetch installed"
echo "✅ MOTD script created at /etc/update-motd.d/01-neofetch"
echo "✅ Script made executable"
echo "✅ Configuration tested"
echo
echo "Neofetch will now appear in the MOTD for all users on login."
echo "To test: logout and login again, or run 'sudo run-parts /etc/update-motd.d/'"
echo
