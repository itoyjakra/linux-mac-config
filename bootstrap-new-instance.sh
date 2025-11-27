#!/bin/bash
#
# Bootstrap script for new g4dn instance
# Sets up zsh, tmux, nvim, and dotfiles from git
#
# Usage: curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/linux-mac-config/main/bootstrap-new-instance.sh | bash
# Or: wget -O - https://raw.githubusercontent.com/YOUR_USERNAME/linux-mac-config/main/bootstrap-new-instance.sh | bash

set -e  # Exit on error

echo "🚀 Starting instance bootstrap..."

# Update system
echo "📦 Updating system packages..."
sudo yum update -y

# Install essential packages
echo "📦 Installing zsh, tmux, git, and dependencies..."
sudo yum install -y \
    zsh \
    tmux \
    git \
    curl \
    wget \
    gcc \
    make \
    cmake \
    unzip \
    ripgrep \
    fd-find \
    fzf

# Install UV (for Python package management)
echo "🐍 Installing UV..."
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"

# Install Neovim (latest stable or build from source)
echo "📝 Installing Neovim..."
if ! command -v nvim &> /dev/null; then
    # Option 1: Download prebuilt binary
    wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
    tar xzf nvim-linux64.tar.gz
    sudo mv nvim-linux64 /opt/nvim
    sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
    rm nvim-linux64.tar.gz

    # Option 2: Uncomment to build from source instead
    # cd /tmp
    # git clone https://github.com/neovim/neovim
    # cd neovim && make CMAKE_BUILD_TYPE=Release
    # sudo make install
    # cd ~ && rm -rf /tmp/neovim
fi

# Clone your dotfiles repo
echo "📂 Cloning dotfiles repository..."
if [ ! -d "$HOME/linux-mac-config" ]; then
    git clone git@github.com:itoyjakra/linux-mac-config.git "$HOME/linux-mac-config"
else
    echo "⚠️  linux-mac-config already exists, pulling latest changes..."
    cd "$HOME/linux-mac-config" && git pull
fi

# Install Oh My Zsh
echo "🎨 Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k theme
echo "✨ Installing Powerlevel10k theme..."
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
fi

# Create symlinks for dotfiles
echo "🔗 Creating symlinks for dotfiles..."

# Backup existing configs (if any)
backup_dir="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

# Function to safely create symlink
create_symlink() {
    local source="$1"
    local target="$2"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "  Backing up existing $target"
        mv "$target" "$backup_dir/"
    elif [ -L "$target" ]; then
        rm "$target"
    fi

    ln -sf "$source" "$target"
    echo "  ✓ Linked $target -> $source"
}

# Symlink configs
create_symlink "$HOME/linux-mac-config/lazyvim" "$HOME/.config/nvim"
create_symlink "$HOME/linux-mac-config/tmux/config" "$HOME/.tmux.conf"

# Copy zsh configs (need to modify, not symlink)
echo "📝 Setting up zsh configuration..."
if [ ! -f "$HOME/.zshrc" ]; then
    cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"
fi

# Update .zshrc to use powerlevel10k
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"

# Copy p10k config if it exists in your repo
if [ -f "$HOME/linux-mac-config/.p10k.zsh" ]; then
    cp "$HOME/linux-mac-config/.p10k.zsh" "$HOME/.p10k.zsh"
    echo "  ✓ Copied powerlevel10k configuration"
fi

# Add p10k source to .zshrc if not already there
if ! grep -q "p10k.zsh" "$HOME/.zshrc"; then
    echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> "$HOME/.zshrc"
fi

# Add UV to PATH in .zshrc
if ! grep -q 'uv' "$HOME/.zshrc"; then
    echo '' >> "$HOME/.zshrc"
    echo '# UV package manager' >> "$HOME/.zshrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
fi

# Install tmux plugin manager (TPM)
echo "🔌 Installing Tmux Plugin Manager..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# Change default shell to zsh
echo "🐚 Setting zsh as default shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
    sudo chsh -s $(which zsh) $(whoami)
    echo "  ✓ Default shell changed to zsh (will take effect on next login)"
fi

# Install AWS CLI if not present (useful for spot instance management)
if ! command -v aws &> /dev/null; then
    echo "☁️  Installing AWS CLI..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
fi

echo ""
echo "✅ Bootstrap complete!"
echo ""
echo "Next steps:"
echo "1. Exit and log back in (or run: exec zsh)"
echo "2. Open tmux and press Ctrl+b then Shift+I to install tmux plugins"
echo "3. Open nvim - LazyVim will auto-install plugins on first launch"
echo "4. Restore your projects from git"
echo ""
echo "Backup of previous configs (if any): $backup_dir"
