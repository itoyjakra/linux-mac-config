# Linux/Mac Configuration Files

My development environment setup for terminal-based workflow.

## Quick Setup

On a new instance/machine:

```bash
# Clone this repo
git clone git@github.com:itoyjakra/linux-mac-config.git ~/linux-mac-config

# Run bootstrap script
cd ~/linux-mac-config
./bootstrap-new-instance.sh

# Exit and re-login
exit
```

## What's Included

- **Neovim**: LazyVim configuration
- **Tmux**: Custom configuration with plugins
- **Zsh**: Oh-My-Zsh with Powerlevel10k theme
- **Fonts**: Nerd fonts for terminal icons

## Manual Setup

If bootstrap script doesn't work, see installation steps in the script.

## Structure

```
.
├── lazyvim/          # Neovim config (LazyVim)
├── nvim/             # Alternative nvim config
├── tmux/             # Tmux configuration
│   └── config        # Main tmux config file
├── alacritty/        # Alacritty terminal config
├── .p10k.zsh         # Powerlevel10k theme config
└── bootstrap-new-instance.sh  # Automated setup script
```

## Updating

After making changes:

```bash
cd ~/linux-mac-config
git add .
git commit -m "Update configs"
git push
```

On other machines:

```bash
cd ~/linux-mac-config
git pull
```
