all:
	stow --verbose --target=$$HOME --restow */

delete:
	stow --verbose --target=$$HOME --delete */

stow-nvim:
	stow --verbose --target=$$HOME --restow neovim
	
stow-tmux:
	stow --verbose --target=$$HOME --restow tmux

stow-zsh:
	stow --verbose --target=$$HOME --restow zsh

stow-sway:
	stow --verbose --target=$$HOME --restow sway

stow-fuzzel:
	stow --verbose --target=$$HOME --restow fuzzel

delete-fuzzel:
	stow --verbose --target=$$HOME --delete fuzzel

delete-sway:
	stow --verbose --target=$$HOME --delete sway

delete-nvim:
	stow --verbose --target=$$HOME --delete neovim
	
delete-tmux:
	stow --verbose --target=$$HOME --delete tmux

delete-zsh:
	stow --verbose --target=$$HOME --delete zsh
