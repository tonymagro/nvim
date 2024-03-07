import platform
import subprocess

applications = [
    "ripgrep",
    "black",
    "stylua",
    "tree-sitter",
    "prettier",
]


def install_with_brew(applications):
    for app in applications:
        print(f"Installing {app} with Homebrew...")
        subprocess.run(["brew", "install", app])


def install_with_scoop(applications):
    for app in applications:
        print(f"Installing {app} with Scoop...")
        subprocess.run(["scoop", "install", app])


if __name__ == "__main__":
    os_name = platform.system()
    if os_name == "Darwin":
        install_with_brew(applications)
    elif os_name == "Windows":
        install_with_scoop(applications)
    else:
        print("Unsupported OS. This script only supports macOS and Windows.")
