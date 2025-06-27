# NVIDIA Container Toolkit Installation on Ubuntu 24.04 LTS

This guide provides a step-by-step process to install the NVIDIA Container Toolkit on a clean Ubuntu 24.04 LTS system, ensuring compatibility with Docker for GPU-accelerated containers.

## Prerequisites
- Ubuntu 24.04 LTS installed.
- `sudo` privileges.
- Internet connection.
- NVIDIA GPU and drivers already installed (verify with `nvidia-smi`).

## Step-by-Step Installation

1. **Add the NVIDIA Container Toolkit Repository**
   - Run the following command to download the NVIDIA GPG key and configure the APT repository:
     ```bash
     curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor --yes -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
     ```
   - **Explanation**: This command:
     - Downloads the NVIDIA GPG key and saves it to `/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg` with `--yes` to overwrite if the file exists.
     - Downloads the repository list, modifies it to include the GPG key, and saves it to `/etc/apt/sources.list.d/nvidia-container-toolkit.list`.

2. **Update the APT Package List**
   - Refresh the package list to include the NVIDIA Container Toolkit repository:
     ```bash
     sudo apt update
     ```

3. **Install the NVIDIA Container Toolkit**
   - Install the toolkit and its dependencies:
     ```bash
     sudo apt install -y nvidia-container-toolkit
     ```

4. **Configure Docker to Use the NVIDIA Container Runtime**
   - Set up Docker to use the NVIDIA runtime:
     ```bash
     sudo nvidia-ctk runtime configure --runtime=docker
     ```
   - **Explanation**: This configures Docker to recognize the NVIDIA runtime for GPU support.

5. **Restart Docker**
   - Restart the Docker service to apply the changes:
     ```bash
     sudo systemctl restart docker
     ```

6. **Verify the Installation**
   - Test the NVIDIA Container Toolkit by running a sample GPU container:
     ```bash
     docker run --rm --runtime=nvidia --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi
     ```
   - **Expected Output**: You should see the output of `nvidia-smi` from within the container, showing your GPU details.

## Troubleshooting
- **Syntax Errors**: Ensure there are no extra spaces or curly quotes in the commands. Use straight single quotes (`'`) in the `sed` command.
- **File Overwrite Prompt**: The `--yes` flag in the GPG command prevents prompts. If issues persist, check file permissions:
  ```bash
  ls -l /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
  cat /etc/apt/sources.list.d/nvidia-container-toolkit.list
  ```
- **Repository Issues**: Verify the repository file contains:
  ```
  deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://nvidia.github.io/libnvidia-container/stable/deb/$(ARCH) /
  ```
- **Shell Compatibility**: Ensure you’re using `bash` (`echo $SHELL`). If using another shell, run commands with:
  ```bash
  bash -c '<command>'
  ```
- **Check System Details**: If errors occur, provide:
  - Distribution: `cat /etc/os-release`
  - Shell: `echo $SHELL`
  - Error messages and command output.

## Notes
- This guide assumes NVIDIA drivers are installed. Install them with `sudo apt install nvidia-driver-<version>` if needed.
- For other Ubuntu versions, replace the repository URL with the appropriate version (e.g., `/ubuntu20.04/` for 20.04).
- Official documentation: [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html).