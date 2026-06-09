-- Godot integration: start Neovim server mode so Godot can open files/line
-- See: https://simondalvai.org/blog/godot-neovim/

local fs = vim.uv or vim.loop
local cwd = vim.fn.getcwd()

-- Try to find the project root by git root first
local godot_project_path = nil

local git_root = vim.fn.systemlist('git -C ' .. vim.fn.shellescape(cwd) .. ' rev-parse --show-toplevel')[1]
if vim.v.shell_error == 0 then
  -- In a git repo; check if project.godot is at the git root
  if fs.fs_stat(git_root .. '/project.godot') then
    godot_project_path = git_root
  end
end

-- Fallback: if not in a git repo or project.godot not at git root,
-- search cwd and parent directories for project.godot
if not godot_project_path then
  local current = cwd
  for _ = 1, 4 do
    if fs.fs_stat(current .. '/project.godot') then
      godot_project_path = current
      break
    end
    local parent = vim.fn.fnamemodify(current, ':h')
    if parent == current then
      break -- reached filesystem root
    end
    current = parent
  end
end

-- Set a global flag so other config (e.g. LSP) can check
vim.g.is_godot_project = godot_project_path ~= nil

-- Start the server pipe if this is a Godot project and pipe isn't already present
if vim.g.is_godot_project then
  local pipe_path = godot_project_path .. '/server.pipe'
  if not fs.fs_stat(pipe_path) then
    vim.fn.serverstart(pipe_path)
  end
end
