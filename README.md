# NVim Config

## Setup

### Windows

1. **Install Neovim and Python:** Use [Scoop](https://scoop.sh/), a command-line installer for Windows, to install Neovim and Python. Open PowerShell and execute the following commands:

   ```powershell
   scoop install git python neovim
   ```

2. **Clone Neovim Config**:

   ```powershell
   cd $HOME\AppData\Local\
   git clone https://github.com/tonymagro/nvim
   ```

3. **Run the Installation Script:** Run the `install_apps.py` Python script to install necessary packages and other Neovim dependencies:

   ```powershell
   cd $HOME\AppData\Local\nvim
   python install_apps.py
   ```

4. **Install the Font:** Right-click on `font/LigaConsolas-NF-Regular.ttf` and select "Install" to add it to your system fonts. For all users, right-click and select "Install for all users" instead.

5. **(Optional) Add 'Edit with Vim' to the Context Menu:** Run the `AddNeovimToContextMenu.py` script as an administrator.

   ```powershell
   python AddNeovimToContextMenu.py
   ```

### macOS

1. **Install Neovim and Python:** Use [Homebrew](https://brew.sh/), a package manager for macOS, to install Neovim and Python. Open your terminal and run the following commands:

   ```sh
   brew install git python neovim
   ```

2. **Clone Neovim Config**:

   ```sh
   cd ~/.config/
   git clone https://github.com/tonymagro/nvim
   ```

3. **Run the Installation Script:** Run the `install_apps.py` Python script to install the required packages and any other Neovim dependencies:

   ```sh
   cd ~/.config/nvim
   python3 install_apps.py
   ```

4. **Install the Font:** Double-click `font/LigaConsolas-NF-Regular.ttf`. This will open the Font Book application. Click "Install Font" to add it to your system fonts.

5. **(Optional) Add Neovim-Qt to Applications:**

   ```sh
   ln -s /opt/homebrew/opt/neovim-qt/nvim-qt.app /Applications
   ```

6. **(Optional) Substitute Vim commands with Neovim:** Add the following aliases to `~/.zprofile` or the corresponding initialization file for your shell.

   ```sh
   alias vi="nvim"
   alias vim="nvim"
   alias gvim="nvim-qt"
   ```

   To deliberately bypass these aliases, prepend the command with a backslash `\`. For instance, executing `\vim` will initiate the original Vim application.
