import platform
import subprocess

def install_with_brew(applications):
    for app in applications:
        print(f"Installing {app} with Homebrew...")
        subprocess.run(["brew", "install", app])


def install_with_scoop(applications):
    for app in applications:
        print(f"Installing {app} with Scoop...")
        command = f'PowerShell -Command "scoop install {app}"'
        subprocess.run(command, check=True)


if __name__ == "__main__":
    apps = [
        "ripgrep",
        "stylua",
        "tree-sitter",
    ]
    darwin_apps = [
        "black",
        "prettier",
    ]

    os_name = platform.system()
    if os_name == "Darwin":
        apps.extend(darwin_apps)
        install_with_brew(apps)
    elif os_name == "Windows":
        install_with_scoop(apps)
    else:
        print("Unsupported OS. This script only supports macOS and Windows.")
