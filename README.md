# dotfiles

A collection of configs for different tools that I use while developing

## What's included?
- [zsh](#zsh) (shell)
- [alacritty](#alacritty) (terminal)
- [nvim](#neovim) (editor)
- [tmux](#tmux) (terminal multiplexer)

## Installation Notes

### Configurations
My dotfiles are managed through this git repo along with [GNU stow](https://www.gnu.org/software/stow/) to symlink individual configs to their respective locations in the home directory, allowing me to modify configs in one spot easily

Included with this repo is a `makefile` that contains two targets: `all` and `delete`
- Running `make` will use stow to create or regenerate symlinks
- Running `make delete` will remove all of those symlinks

GNU stow may not be included by default in some environments (like Mac). Make sure to install with your respective package manager prior to running `make`

### zsh
- Install with apt: `apt install zsh`
- Set to default shell with `chsh -s /use/bin/zsh`

### alacritty
Note: This repo currently assumes alacritty versions < 13, as [configuration was changed from yaml to toml](https://github.com/alacritty/alacritty/commit/bd4906722a1a026b01f06c94c33b13ff63a7e044) and I haven't gotten around to updating my config just yet

- Installation instructions can be found [here](https://github.com/alacritty/alacritty). I typically build the source with `cargo build --release`
- In gnome, update default terminal with `sudo update-alternatives --config x-terminal-emulator`
  - "Open with Terminal" context menu continued to open gnome-terminal

### neovim
- Install with apt: `apt install neovim`
- I use Packer to manage my plugins. Follow the [quickstart's installation](https://github.com/wbthomason/packer.nvim?tab=readme-ov-file#quickstart) and Run `:PackerCompile`, `:PackerInstall` within nvim to update everything

### tmux
- Install with apt: `apt install tmux`
- I use [tpm](https://github.com/tmux-plugins/tpm) to manage and install tmux plugins. Use `prefix I` to fetch new plugins
