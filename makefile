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

stow-ghostty:
	stow --verbose --target=$$HOME --restow ghostty

stow-gowall:
	stow --verbose --target=$$HOME --restow gowall

stow-swaylock:
	stow --verbose --target=$$HOME --restow swaylock

delete-swaylock:
	stow --verbose --target=$$HOME --delete swaylock

delete-gowall:
	stow --verbose --target=$$HOME --delete gowall

delete-ghostty:
	stow --verbose --target=$$HOME --delete ghostty

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
