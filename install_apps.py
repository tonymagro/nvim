import sys
import platform
import subprocess
from typing import List
from subprocess import CompletedProcess

"""
Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vs_BuildTools.exe' -OutFile "$env:TEMP\vs_BuildTools.exe"

& "$env:TEMP\vs_BuildTools.exe" --passive --wait --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --remove Microsoft.VisualStudio.Component.VC.CMake.Project	
"""


def run_powershell_command(command: str, check=True) -> CompletedProcess:
    print(f"Running PowerShell command: {command}")
    completed_process = subprocess.run(["powershell", "-Command", command], check=check)
    return completed_process


def install_with_brew(packages: List[str]) -> None:
    for package in packages:
        print(f"Installing {package} with Homebrew...")
        command = ["brew", "install", package]
        print(f"Executing command: {' '.join(command)}")
        subprocess.run(command)


def install_with_scoop(packages: List[str]) -> None:
    for package in packages:
        print(f"Installing {package} with Scoop...")
        command = f"scoop install {package}"
        run_powershell_command(command)


def install_with_pip(packages: List[str]) -> None:
    for package in packages:
        print(f"Installing {package} with pip...")
        command = f"pip install {package}"
        run_powershell_command(command)


def install_with_npm(packages: List[str]) -> None:
    for package in packages:
        print(f"Installing {package} with npm...")
        command = f"npm install -g {package}"
        run_powershell_command(command)


def main():
    apps: List[str] = [
        "7zip",
        "llvm",
        "cmake",
        "make",
        "ripgrep",
        "stylua",
        "tree-sitter",
        "go",
        "rust",
        "lazygit"
    ]
    darwin_apps: List[str] = [
        "black",
        "prettier",
    ]
    windows_apps: List[str] = [
        "nodejs",
    ]
    windows_pip_apps: List[str] = ["black"]
    windows_npm_apps: List[str] = ["prettier"]

    os_name: str = platform.system()
    if os_name == "Darwin":
        install_with_brew(apps)
        install_with_brew(darwin_apps)
    elif os_name == "Windows":
        run_powershell_command("scoop bucket add main", False)
        run_powershell_command("scoop bucket add extras", False)
        install_with_scoop(apps)
        install_with_scoop(windows_apps)
        install_with_pip(windows_pip_apps)
        install_with_npm(windows_npm_apps)
    else:
        print("Unsupported OS. This script only supports macOS and Windows.")
        sys.exit(1)

    print("Setup complete. Please open a new terminal to start using nvim.")


if __name__ == "__main__":
    main()
