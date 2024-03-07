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

    if "pnpm" in applications:
        print("Running 'pnpm setup'...")
        command = f'PowerShell -Command "pnpm setup"'
        subprocess.run(command, check=True)


def install_with_pip(packages):
    for package in packages:
        print(f"Installing {package} with pip...")
        subprocess.run(["pip", "install", package], check=True)


def install_with_pnpm(packages):
    for package in packages:
        print(f"Installing {package} with pnpm...")
        subprocess.run(["pnpm", "add", "-g", package], check=True)


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
    windows_apps = ["nodejs-lts", "pnpm"]
    windows_pip_apps = ["black"]
    windows_pnpm_apps = ["prettier"]

    os_name = platform.system()
    if os_name == "Darwin":
        install_with_brew(apps)
        install_with_brew(darwin_apps)
    elif os_name == "Windows":
        install_with_scoop(apps)
        install_with_scoop(windows_apps)
        install_with_pip(windows_pip_apps)
        install_with_pnpm(windows_pnpm_apps)
    else:
        print("Unsupported OS. This script only supports macOS and Windows.")
