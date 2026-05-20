wt() {
    local branch="${1:?Usage: wt <branch-name>}"
    local wt_root="$HOME/.dev/worktrees"

    local git_dir
    git_dir=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) \
        || { echo "Not in a git repo"; return 1; }

    local repo_root project
    repo_root=$(dirname "$git_dir")
    project=$(basename "$repo_root")

    local wt_dir="$wt_root/$project"
    mkdir -p "$wt_dir"

    local safe_branch="${branch//\//-}"
    local wt_path="$wt_dir/$safe_branch"
    local session="${project}_${safe_branch}"

    if [[ ! -d "$wt_path" ]]; then
        if git -C "$repo_root" rev-parse --verify "$branch" &>/dev/null; then
            git -C "$repo_root" worktree add "$wt_path" "$branch" || return 1
        else
            git -C "$repo_root" worktree add "$wt_path" -b "$branch" || return 1
        fi
    fi
    _wt_session "$session" "$wt_path"
}

_wt_session() {
    local session="$1"
    local wt_path="$2"

    if ! tmux has-session -t "$session" 2>/dev/null; then
        tmux new-session -d -s "$session" -c "$wt_path"

        # Window 1 "runner": lazygit top, shell bottom
        tmux rename-window -t "${session}:1" "runner"
        tmux send-keys -t "${session}:runner" "lazygit" Enter
        tmux split-window -v -p 20 -t "${session}:runner" -c "$wt_path"

        # Window 2 "editor"
        tmux new-window -t "$session" -c "$wt_path" -n "editor"
        tmux send-keys -t "${session}:editor" "nvim ." Enter

        # Window 3 "ai": opencode attached to running server
        tmux new-window -t "$session" -c "$wt_path" -n "ai"
        tmux send-keys -t "${session}:ai" "oc" Enter
    fi

    if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$session"
    else
        tmux attach-session -t "$session"
    fi
}

_wt() {
    local -a branches
    branches=("${(@f)$(git branch --all --format='%(refname:short)' 2>/dev/null \
        | grep -v 'HEAD' \
        | sed 's|^origin/||' \
        | sort -u)}")
    compadd -a branches
}
compdef _wt wt


# # wt: create worktree + tmux session, switch to it
# # Usage (from anywhere inside the project): wt <branch> [base]
# wt() {
#   local branch="${1:?Usage: wt <branch-name> [base-branch]}"
#   local base="${2:-main}"
#
#   # Resolve project root via .bare (works from any worktree depth)
#   local git_common
#   git_common=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) \
#     || { echo "Not in a git repo"; return 1; }
#   local proj_root
#   proj_root=$(dirname "$git_common")   # .bare → project root
#   local project
#   project=$(basename "$proj_root")
#
#   local safe_branch="${branch//\//-}"
#   local worktree_path="${proj_root}/wt/${safe_branch}"
#   local session_name="${project}_${safe_branch}"
#
#   if [[ ! -d "$worktree_path" ]]; then
#     git -C "$proj_root" worktree add "$worktree_path" -b "$branch" "$base" || return 1
#     zoxide add "$worktree_path"
#   fi
#
#   _wt_session "$session_name" "$worktree_path"
# }

# # wt-primary: open/switch to the primary worktree session
# wt-primary() {
#   local git_common
#   git_common=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) \
#     || { echo "Not in a git repo"; return 1; }
#   local proj_root=$(dirname "$git_common")
#   local project=$(basename "$proj_root")
#   local session_name="${project}_primary"
#   _wt_session "$session_name" "${proj_root}/primary"
# }
#
# # wa: fzf picker across all tmux sessions
# wa() {
#   local session
#   session=$(tmux list-sessions -F '#{session_name}  (#{session_windows}w, #{?session_attached,attached,detached})' \
#     | fzf --prompt="session> " --with-nth=1 --delimiter='  ' \
#     | cut -d' ' -f1) || return
#   [[ -z "$session" ]] && return
#   if [[ -n "$TMUX" ]]; then
#     tmux switch-client -t "$session"
#   else
#     tmux attach-session -t "$session"
#   fi
# }
#
# # wrm: remove a worktree and kill its session
# # Usage (from anywhere inside the project): wrm <branch>
# wrm() {
#   local branch="${1:?Usage: wrm <branch-name>}"
#   local git_common
#   git_common=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) \
#     || { echo "Not in a git repo"; return 1; }
#   local proj_root=$(dirname "$git_common")
#   local project=$(basename "$proj_root")
#   local safe_branch="${branch//\//-}"
#   local worktree_path="${proj_root}/wt/${safe_branch}"
#   local session_name="${project}:${safe_branch}"
#
#   tmux kill-session -t "$session_name" 2>/dev/null && echo "Killed session: $session_name"
#   git -C "$proj_root" worktree remove "$worktree_path" --force
#   zoxide remove "$worktree_path" 2>/dev/null
#   echo "Removed worktree: $worktree_path"
# }

# # wls: list worktrees + their session status for current project
# wls() {
#   local git_common
#   git_common=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) \
#     || { echo "Not in a git repo"; return 1; }
#   local proj_root=$(dirname "$git_common")
#   local project=$(basename "$proj_root")
#
#   git -C "$proj_root" worktree list | while read -r path head branch; do
#     local rel="${path#$proj_root/}"
#     # Derive session name
#     local session_name
#     if [[ "$rel" == "primary" ]]; then
#       session_name="${project}:primary"
#     else
#       session_name="${project}:${rel#wt/}"
#     fi
#     local status
#     tmux has-session -t "$session_name" 2>/dev/null \
#       && status="[session]" || status="[no session]"
#     printf "%-40s %-20s %s\n" "$rel" "$branch" "$status"
#   done
# }


# # proj-clone: replace `git clone` for worktree-first projects
# # Usage: proj-clone <git-url> [dirname]
# # Run from the category dir (e.g. ~/Projects/lab)
# proj-clone() {
#   local url="${1:?Usage: proj-clone <git-url> [dirname]}"
#   local name="${2:-$(basename "$url" .git)}"
#   local dest="${PWD}/${name}"
#
#   mkdir -p "$dest/wt"
#   git clone --bare "$url" "$dest/.bare"
#
#   # Bare clones don't set up the fetch refspec — without this,
#   # `git fetch` won't populate refs/remotes/origin/* in worktrees
#   git -C "$dest/.bare" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
#
#   # The .git file lets normal git commands work from the project root
#   echo "gitdir: ./.bare" > "$dest/.git"
#
#   # Add primary worktree (assumes `main` branch; swap for `master` if needed)
#   git -C "$dest" worktree add "$dest/primary" main
#
#   zoxide add "$dest"
#   zoxide add "$dest/primary"
#
#   echo "Ready: $dest"
# }
#
# # proj-migrate: convert an existing clone in-place
# # Run from inside the repo, e.g. cd ~/Projects/lab/pingalong && proj-migrate
# proj-migrate() {
#   local dest="${PWD}"
#   local name=$(basename "$dest")
#   local tmp="${dest}.migrating"
#
#   # Sanity check
#   [[ -d "${dest}/.git" ]] || { echo "Not a regular clone (no .git dir)"; return 1; }
#   [[ -d "${dest}/.bare" ]] && { echo "Already migrated"; return 1; }
#
#   # Clone the bare repo from the existing remote
#   local remote_url
#   remote_url=$(git remote get-url origin 2>/dev/null) || { echo "No origin remote"; return 1; }
#
#   mv "$dest" "$tmp"
#   mkdir -p "$dest/wt"
#   git clone --bare "$remote_url" "$dest/.bare"
#   git -C "$dest/.bare" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
#   echo "gitdir: ./.bare" > "$dest/.git"
#
#   # Restore any uncommitted work from the old clone
#   local current_branch
#   current_branch=$(git -C "$tmp" rev-parse --abbrev-ref HEAD)
#   git -C "$dest" worktree add "$dest/primary" "$current_branch"
#
#   # Copy over any untracked/ignored files you care about (.env, etc.)
#   echo "Old clone is at $tmp — copy over .env files etc., then rm -rf $tmp"
#
#   zoxide add "$dest"
#   zoxide add "$dest/primary"
# }
