echo "1. Uninstalling any conflicting old Docker packages..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    sudo apt-get remove -y $pkg 2>/dev/null || true
done
echo "Conflicting Docker packages uninstalled (if present)."

# Add Docker's official GPG key
echo "2. Adding Docker's official GPG key..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl apt-transport-https software-properties-common
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "Docker GPG key added."

# Add the Docker repository to Apt sources
echo "3. Adding the Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "Docker repository added."

# Update the apt package index
echo "4. Updating apt package index with Docker repository..."
sudo apt-get update
echo "Apt package index updated."

# Install Docker Engine, containerd, and Docker Compose
echo "5. Installing Docker Engine, containerd, and Docker Compose plugins..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Docker Engine and related components installed."

# Verify Docker installation
echo "6. Verifying Docker installation by running 'hello-world' container..."
sudo docker run hello-world
echo "Docker installation verified successfully."

# --- Docker Post-Installation Steps (from https://docs.docker.com/engine/install/linux-postinstall/) ---

echo "--- Docker Post-Installation ---"

# Manage Docker as a non-root user
echo "1. Configuring Docker to be managed as a non-root user..."
if ! getent group docker > /dev/null; then
    echo "Creating 'docker' group..."
    sudo groupadd docker
else
    echo "'docker' group already exists."
fi

if ! id -nG "$USER" | grep -qw "docker"; then
    echo "Adding current user '$USER' to the 'docker' group..."
    sudo usermod -aG docker "$USER"
    echo "User '$USER' added to 'docker' group. You may need to log out and log back in for changes to take full effect."
else
    echo "User '$USER' is already a member of the 'docker' group."
fi
echo "Docker permissions configured. Please re-login or run 'newgrp docker' for changes to apply without re-login."
