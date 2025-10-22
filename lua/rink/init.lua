local M = {}

-- Ensure local rink is in PATH
local local_bin = vim.fn.stdpath("data") .. "/rink/bin"
vim.env.PATH = local_bin .. ":" .. vim.env.PATH

local function is_rink_available()
	return vim.fn.executable("rink") == 1
end

local function run_rink_async(cmd_args)
	local args = table.concat(cmd_args, " ")
	if args:gsub("%s+", "") == "" then
		print("Nothing to calc provided.")
		return
	end

	local output_chunks = {}

	vim.fn.jobstart({ "rink", unpack(cmd_args) }, {
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, data)
			if data then
				for _, line in ipairs(data) do
					table.insert(output_chunks, line)
				end
			end
		end,
		on_stderr = function(_, data)
			if data then
				local msg = table.concat(data, "\n")
				if msg ~= "" then
					print("Error:", msg)
				end
			end
		end,
		on_exit = function(_, code)
			if code ~= 0 then
				print("Rink process exited with code:", code)
				return
			end

			local output = table.concat(output_chunks, "\n")
			local input = "> " .. table.concat(cmd_args, "\n")

			local _, idx = output:find(input, 1, true)

			local trimmed_output
			if idx then
				trimmed_output = output:sub(idx + 1)
			else
				trimmed_output = output
			end

			trimmed_output = trimmed_output:gsub("^%s+", "")

			print(trimmed_output)
		end,
	})
end

local function install_rink(callback)
	print("Rink not found! Installing locally via cargo...")
	local install_dir = vim.fn.stdpath("data") .. "/rink"
	vim.fn.mkdir(install_dir, "p")
	vim.fn.jobstart({ "cargo", "install", "--root", install_dir, "rink" }, {
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, data)
			if data then
				print(table.concat(data, "\n"))
			end
		end,
		on_stderr = function(_, data)
			if data then
				local msg = table.concat(data, "\n")
				if msg ~= "" then
					print("Error:", msg)
				end
			end
		end,
		on_exit = function(_, code)
			if code == 0 then
				print("Rink installed locally!")
			else
				print("Failed to install Rink locally (exit code: " .. code .. ")")
			end
			if callback then
				callback(code == 0)
			end
		end,
	})
end

local function get_visual_selection()
	-- Save current register
	local save_reg = vim.fn.getreg('"')
	local save_regtype = vim.fn.getregtype('"')

	-- Yank the visual selection into the unnamed register
	vim.cmd('normal! ""y')

	-- Get the yanked text
	local selection = vim.fn.getreg('"')

	-- Restore previous register
	vim.fn.setreg('"', save_reg, save_regtype)

	return selection
end

function M.rink()
	if is_rink_available() then
		local input = get_visual_selection()
		run_rink_async({ input })
	else
		install_rink(function(success) end)
	end
end

function M.setup(opts)
	opts = opts or {}
end

return M
