#!/usr/bin/env bash
# install.sh — Symlink dotfiles files into their expected locations
#
# Usage:
#   ./install.sh          # Interactive: prompts before each symlink
#   ./install.sh --force  # Overwrite existing files without prompting
#
# What this does:
#   Creates symbolic links from this repo's files to where each tool expects them.
#   Existing files are backed up to <file>.bak before overwriting.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FORCE=false
[[ "${1:-}" == "--force" ]] && FORCE=true

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

link_file() {
  local src="$1"
  local dst="$2"

  if [[ ! -f "$src" && ! -d "$src" ]]; then
    echo -e "${RED}SKIP${NC} $src (source not found)"
    return
  fi

  # Create parent directory if needed
  mkdir -p "$(dirname "$dst")"

  if [[ -L "$dst" ]]; then
    local current_target
    current_target="$(readlink "$dst")"
    if [[ "$current_target" == "$src" ]]; then
      echo -e "${GREEN}OK${NC}   $dst -> $src (already linked)"
      return
    fi
  fi

  if [[ -e "$dst" ]] && ! $FORCE; then
    echo -n "Overwrite $dst? [y/N] "
    read -r answer
    [[ "$answer" != "y" && "$answer" != "Y" ]] && return
  fi

  # Backup existing file
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    cp -r "$dst" "${dst}.bak"
    echo -e "${YELLOW}BACKUP${NC} $dst -> ${dst}.bak"
  fi

  ln -sf "$src" "$dst"
  echo -e "${GREEN}LINK${NC} $dst -> $src"
}

link_dir() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"

  if [[ -L "$dst" ]]; then
    local current_target
    current_target="$(readlink "$dst")"
    if [[ "$current_target" == "$src" ]]; then
      echo -e "${GREEN}OK${NC}   $dst -> $src (already linked)"
      return
    fi
  fi

  if [[ -e "$dst" ]] && ! $FORCE; then
    echo -n "Overwrite $dst? [y/N] "
    read -r answer
    [[ "$answer" != "y" && "$answer" != "Y" ]] && return
  fi

  if [[ -d "$dst" && ! -L "$dst" ]]; then
    mv "$dst" "${dst}.bak"
    echo -e "${YELLOW}BACKUP${NC} $dst -> ${dst}.bak"
  fi

  ln -sf "$src" "$dst"
  echo -e "${GREEN}LINK${NC} $dst -> $src"
}

echo "=== Terminal Config Installer ==="
echo ""

# ── Shell ──────────────────────────────────────────────────────
echo "--- Shell ---"
link_file "$SCRIPT_DIR/zsh/zshrc"    "$HOME/.zshrc"
link_file "$SCRIPT_DIR/zsh/zprofile" "$HOME/.zprofile"
link_file "$SCRIPT_DIR/zsh/zshenv"   "$HOME/.zshenv"

# ── Ghostty ────────────────────────────────────────────────────
echo ""
echo "--- Ghostty ---"
link_file "$SCRIPT_DIR/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

# ── tmux ───────────────────────────────────────────────────────
echo ""
echo "--- tmux ---"
link_file "$SCRIPT_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

for script in "$SCRIPT_DIR"/tmux/scripts/*; do
  name="$(basename "$script")"
  link_file "$script" "$HOME/.local/bin/$name"
  chmod +x "$HOME/.local/bin/$name" 2>/dev/null
done

# ── Neovim ─────────────────────────────────────────────────────
echo ""
echo "--- Neovim ---"
link_dir "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"

# ── OpenCode ──────────────────────────────────────────────────
echo ""
echo "--- OpenCode ---"
link_file "$SCRIPT_DIR/opencode/opencode.json"         "$HOME/.config/opencode/opencode.json"
link_file "$SCRIPT_DIR/opencode/oh-my-opencode.json"   "$HOME/.config/opencode/oh-my-opencode.json"

# ── Git ────────────────────────────────────────────────────────
echo ""
echo "--- Git ---"
if [[ -f "$HOME/.gitconfig" ]]; then
  echo -e "${YELLOW}NOTE${NC} ~/.gitconfig exists. Template available at: $SCRIPT_DIR/git/gitconfig.template"
  echo "  To use: cp git/gitconfig.template ~/.gitconfig && edit with your name/email"
else
  cp "$SCRIPT_DIR/git/gitconfig.template" "$HOME/.gitconfig"
  echo -e "${GREEN}COPY${NC} gitconfig.template -> ~/.gitconfig (edit with your name/email)"
fi

# ── Dependencies ───────────────────────────────────────────────
echo ""
echo "--- Dependency Check ---"

check_cmd() {
  if command -v "$1" &>/dev/null; then
    echo -e "  ${GREEN}OK${NC} $1"
  else
    echo -e "  ${RED}MISSING${NC} $1 — $2"
  fi
}

check_cmd brew      "Install from https://brew.sh"
check_cmd nvim      "brew install neovim"
check_cmd tmux      "brew install tmux"
check_cmd fzf       "brew install fzf"
check_cmd rg        "brew install ripgrep"
check_cmd fd        "brew install fd"
check_cmd lazygit   "brew install lazygit"
check_cmd node      "brew install node"
check_cmd python3   "brew install python"
check_cmd rustc     "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
check_cmd cargo     "Installed with rustup"
check_cmd rust-analyzer "rustup component add rust-analyzer"
check_cmd bun       "curl -fsSL https://bun.sh/install | bash"
check_cmd pngpaste  "brew install pngpaste"
check_cmd zoxide    "brew install zoxide"
check_cmd eza       "brew install eza"

echo ""
echo "--- Post-Install Steps ---"
echo "  1. source ~/.zshrc"
echo "  2. Open tmux: dev-mode"
echo "  3. In tmux, press Ctrl+A then I to install tmux plugins (TPM)"
echo "  4. Open nvim — lazy.nvim will auto-install plugins on first launch"
echo "  5. In nvim, run :Mason to verify LSP servers are installed"
echo "  6. Install font: Hack Nerd Font Mono (https://www.nerdfonts.com/)"
echo ""
echo "Done!"
