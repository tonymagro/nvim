"""Add or Remove "Edit with Vim" from the Windows context menu."""

import os
import argparse
import platform
import sys

if platform.system() != "Windows":
    print(f"Unsupported OS: {platform.system()}")
    sys.exit(1)

import winreg as reg

key_path = r"*\shell\Edit with Vim"
command_path = r"*\shell\Edit with Vim\command"


def fix_scoop_shims(full_path):
    if not os.path.isfile(full_path) or not os.access(full_path, os.X_OK):
        return full_path

    # Scoop shim execs open a terminal prior to opening nvim-qt.exe which is annoying
    # Try to detect a shim and reroute to the actual executable
    if "scoop" in full_path.lower():
        actual_path = os.path.expanduser(
            "~\\scoop\\apps\\neovim\\current\\bin\\nvim-qt.exe"
        )
        if os.path.isfile(actual_path) and os.access(actual_path, os.X_OK):
            full_path = actual_path

    return full_path


def find_nvim_qt():
    paths_to_check = [
        "C:\\Program Files\\Neovim\\bin\\nvim-qt.exe",
    ]

    for path in paths_to_check:
        if os.path.isfile(path) and os.access(path, os.X_OK):
            return path

    for path in os.environ["PATH"].split(os.pathsep):
        full_path = os.path.join(path, "nvim-qt.exe")
        if os.path.isfile(full_path) and os.access(full_path, os.X_OK):
            return fix_scoop_shims(full_path)

    return None


def add_to_context_menu(nvim_qt_path):
    try:
        with reg.CreateKey(reg.HKEY_CLASSES_ROOT, key_path) as key:
            reg.SetValue(key, "", reg.REG_SZ, "Edit with &Vim")

        with reg.CreateKey(reg.HKEY_CLASSES_ROOT, command_path) as command_key:
            command = f'"{nvim_qt_path}" "%1"'
            reg.SetValue(command_key, "", reg.REG_SZ, command)

        print(
            f'Context menu option "Edit with Vim" has been added for "{nvim_qt_path}"'
        )
    except PermissionError:
        print(
            f'Failed to add context menu option for "{nvim_qt_path}". Please run this script as an administrator.'
        )


def remove_from_context_menu():
    try:
        try:
            reg.DeleteKey(reg.HKEY_CLASSES_ROOT, command_path)
        except FileNotFoundError:
            print(f'Command path "{command_path}" was not found.')

        try:
            reg.DeleteKey(reg.HKEY_CLASSES_ROOT, key_path)
        except FileNotFoundError:
            print(f'Key path "{key_path}" was not found.')

        print('Context menu option "Edit with Vim" has been removed.')
    except PermissionError:
        print(
            "Failed to remove context menu. Please run this script as an administrator."
        )


def parse_arguments():
    parser = argparse.ArgumentParser(
        description='Add or Remove "Edit with Vim" from the Windows context menu.'
    )
    parser.add_argument(
        "-r",
        "--remove",
        action="store_true",
        help="Remove the context menu option instead of adding it.",
    )
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_arguments()

    if args.remove:
        remove_from_context_menu()
    else:
        nvim_qt_path = find_nvim_qt()
        if nvim_qt_path:
            add_to_context_menu(nvim_qt_path)
        else:
            print(
                "nvim-qt.exe not found. Please ensure Neovim is installed and try again."
            )
