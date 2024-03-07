# NVim Config

## Setup

### Windows

1. **Install Neovim and Python:** Use [Scoop](https://scoop.sh/), a command-line installer for Windows, to install Neovim and Python. Open PowerShell and execute the following commands:

   ```powershell
   scoop install neovim
   scoop install python
   ```

2. **Run the Installation Script:** After installing Neovim and Python, execute the `install_apps.py` Python script to install necessary packages and other Neovim dependencies:

   ```powershell
   python install_apps.py
   ```

3. **Install the Font:** Right-click on `font/LigaConsolas-NF-Regular.ttf` and select "Install" to add it to your system fonts. For all users, right-click and select "Install for all users" instead.

4. **(Optional) Add 'Edit with Vim' to the Context Menu:** Run the `AddNeovimToContextMenu.py` script as an administrator.

   ```powershell
   python AddNeovimToContextMenu.py
   ```

### macOS

1. **Install Neovim and Python:** Use [Homebrew](https://brew.sh/), a package manager for macOS, to install Neovim and Python. Open your terminal and run the following commands:

   ```sh
   brew install neovim
   brew install python
   ```

2. **Run the Installation Script:** Once Neovim and Python are installed, run the `install_apps.py` Python script to install the required packages and any other Neovim dependencies:

   ```sh
   python3 install_apps.py
   ```

3. **Install the Font:** Double-click `font/LigaConsolas-NF-Regular.ttf`. This will open the Font Book application. Click "Install Font" to add it to your system fonts.
