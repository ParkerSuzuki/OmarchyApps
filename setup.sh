#!/bin/bash
# Personal app setup script for Omarchy
# Run after a fresh Omarchy install to restore personal tools

set -eEo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}==>${NC} $1"; }
ok()  { echo -e "${GREEN} ✓${NC} $1"; }

# ---------------------------------------------------------------------------
# Pacman / official repo packages
# ---------------------------------------------------------------------------
log "Installing packages from official repos..."

PACMAN_PKGS=(
  anki
  calibre
  gpodder
  intellij-idea-community-edition
  python-dotenv
  python-mutagen
  python-pip
  python-pipx
)

MISSING_PACMAN=()
for pkg in "${PACMAN_PKGS[@]}"; do
  if pacman -Qi "$pkg" &>/dev/null; then
    ok "$pkg already installed"
  else
    MISSING_PACMAN+=("$pkg")
  fi
done

if [ ${#MISSING_PACMAN[@]} -gt 0 ]; then
  log "Installing: ${MISSING_PACMAN[*]}"
  sudo pacman -S --needed --noconfirm "${MISSING_PACMAN[@]}"
fi

# ---------------------------------------------------------------------------
# AUR / omarchy-repo packages (via yay)
# ---------------------------------------------------------------------------
log "Installing AUR/omarchy packages..."

YAY_PKGS=(
  teams-for-linux
  visual-studio-code-bin
)

MISSING_YAY=()
for pkg in "${YAY_PKGS[@]}"; do
  if pacman -Qi "$pkg" &>/dev/null; then
    ok "$pkg already installed"
  else
    MISSING_YAY+=("$pkg")
  fi
done

if [ ${#MISSING_YAY[@]} -gt 0 ]; then
  log "Installing: ${MISSING_YAY[*]}"
  yay -S --needed --noconfirm "${MISSING_YAY[@]}"
fi

# ---------------------------------------------------------------------------
# Mise: Node.js
# ---------------------------------------------------------------------------
log "Configuring mise (Node.js)..."

MISE_CONFIG="$HOME/.config/mise/config.toml"
mkdir -p "$(dirname "$MISE_CONFIG")"

if ! grep -q 'node' "$MISE_CONFIG" 2>/dev/null; then
  cat >> "$MISE_CONFIG" <<'EOF'
[tools]
node = "26.2.0"
EOF
fi

# Make sure mise installs the configured tools
mise install 2>/dev/null || true
ok "mise node configured (26.2.0)"

# ---------------------------------------------------------------------------
# npm global packages
# ---------------------------------------------------------------------------
log "Installing npm global packages..."

NPM_GLOBALS=(
  "@angular/cli"
  "typescript"
)

for pkg in "${NPM_GLOBALS[@]}"; do
  if npm list -g --depth=0 "$pkg" &>/dev/null; then
    ok "$pkg already installed globally"
  else
    npm install -g "$pkg"
  fi
done

# ---------------------------------------------------------------------------
# pipx packages
# ---------------------------------------------------------------------------
log "Installing pipx packages..."

PIPX_PKGS=(
  spotdl
)

for pkg in "${PIPX_PKGS[@]}"; do
  if pipx list | grep -q "package $pkg"; then
    ok "$pkg already installed via pipx"
  else
    pipx install "$pkg"
  fi
done

# ---------------------------------------------------------------------------
echo ""
echo -e "${GREEN}Setup complete!${NC}"
echo ""
echo "Manual steps (can't be automated cleanly):"
echo "  • Sign into 1Password"
echo "  • Sign into Microsoft Teams"
echo "  • Restore Anki decks from backup"
echo "  • Restore Obsidian vault (git clone or sync)"
