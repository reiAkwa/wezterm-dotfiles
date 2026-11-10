#!/bin/sh
# Install the wezterm dotfiles.
#
#   ./install.sh                  # symlink (falls back to copy)
#   ./install.sh --copy           # always copy
#   ./install.sh --config-dir DIR # override target directory
#
# Works on Linux and macOS.

set -eu

copy=0
config_dir=""

usage() {
    cat <<EOF
Usage: $0 [--copy] [--config-dir DIR]

  --copy             Copy files instead of symlinking (default: symlink)
  --config-dir DIR   WezTerm config directory
                     (default: \${XDG_CONFIG_HOME:-\$HOME/.config}/wezterm)
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --copy|-c) copy=1 ;;
        --config-dir) shift; config_dir=$1 ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
    esac
    shift
done

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if [ -z "$config_dir" ]; then
    config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/wezterm"
fi
themes_dir="$config_dir/themes"

mkdir -p "$themes_dir"

install_item() {
    src=$1
    dst=$2
    name=$(basename "$dst")

    if [ -L "$dst" ]; then
        rm -f "$dst"
    elif [ -e "$dst" ]; then
        if cmp -s "$src" "$dst"; then
            rm -f "$dst"
        else
            echo "  backup  $name -> $name.bak"
            mv -f "$dst" "$dst.bak"
        fi
    fi

    if [ "$copy" -eq 0 ] && ln -s "$src" "$dst" 2>/dev/null; then
        echo "  symlink $name"
    else
        cp -f "$src" "$dst"
        echo "  copy    $name"
    fi
}

echo "Installing wezterm config to $config_dir"

install_item "$repo_dir/.wezterm.lua" "$config_dir/wezterm.lua"

for src in "$repo_dir"/theme/*.toml; do
    [ -e "$src" ] || continue
    install_item "$src" "$themes_dir/$(basename "$src")"
done

echo "Done."

if [ -e "$HOME/.wezterm.lua" ] && [ ! -L "$HOME/.wezterm.lua" ]; then
    echo "warning: $HOME/.wezterm.lua still exists and is shadowed by $config_dir/wezterm.lua; you can remove it." >&2
fi
