import os
import platform
import subprocess


def run_powershell_command(command):
    completed_process = subprocess.run(["powershell", "-Command", command], check=True)
    return completed_process


def install_with_brew(applications):
    for app in applications:
        print(f"Installing {app} with Homebrew...")
        subprocess.run(["brew", "install", app])


def install_with_scoop(applications):
    for app in applications:
        print(f"Installing {app} with Scoop...")
        run_powershell_command(f"scoop install {app}")

    if "pnpm" in applications:
        print("Running 'pnpm setup'...")
        run_powershell_command("pnpm setup")


def install_with_pip(packages):
    for package in packages:
        print(f"Installing {package} with pip...")
        subprocess.run(["pip", "install", package], check=True)


def install_with_pnpm(packages):
    for package in packages:
        print(f"Installing {package} with pnpm...")
        run_powershell_command(f"pnpm add -g {package}")


if __name__ == "__main__":
    apps = [
        "ripgrep",
        "stylua",
        "tree-sitter",
        "cmake",
    ]
    darwin_apps = [
        "black",
        "prettier",
    ]
    windows_apps = ["llvm", "nodejs-lts", "pnpm"]
    windows_pip_apps = ["black"]
    windows_pnpm_apps = ["prettier"]

    os_name = platform.system()
    if os_name == "Darwin":
        install_with_brew(apps)
        install_with_brew(darwin_apps)
    elif os_name == "Windows":
        # Set PNPM_HOME and PATH for the subprocess
        pnpm_home = os.path.expanduser("~\\AppData\\Local\\pnpm")
        os.environ["PNPM_HOME"] = pnpm_home
        os.environ["PATH"] += os.pathsep + pnpm_home
        install_with_scoop(apps)
        install_with_scoop(windows_apps)
        install_with_pip(windows_pip_apps)
        install_with_pnpm(windows_pnpm_apps)
    else:
        print("Unsupported OS. This script only supports macOS and Windows.")
        sys.exit(1)

    print("Setup complete. Please open a new terminal to start using nvim.")
