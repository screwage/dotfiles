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

delete-nvim:
	stow --verbose --target=$$HOME --delete neovim
	
delete-tmux:
	stow --verbose --target=$$HOME --delete tmux

delete-zsh:
	stow --verbose --target=$$HOME --delete zsh
