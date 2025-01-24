local M = {}

-- Default settings
M.config = {
    width = 140,              -- Width of the floating window
    height = 40,              -- Height of the floating window
    border = "rounded",       -- Border style of the window
    close_key = "q",          -- Key to close the window
    open_key = "o",           -- Key to open the file
    max_width_percent = 0.8,  -- Maximum width of the window as a percentage of the screen
    max_height_percent = 0.8, -- Maximum height of the window as a percentage of the screen
}

-- Function to set user configurations
function M.setup(user_config)
    M.config = vim.tbl_deep_extend("force", M.config, user_config or {})
end

-- Main function to open the definition in a floating window
function M.open_definition_in_float()
    local params = vim.lsp.util.make_position_params()

    -- Request definition from LSP
    vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result, ctx, _)
        if not result or vim.tbl_isempty(result) then
            vim.notify("No definition found for the symbol", vim.log.levels.INFO)
            return
        end

        -- Get the URI and range of the definition
        local definition = result[1]
        local uri = definition.uri or definition.targetUri
        local range = definition.range or definition.targetRange

        -- Open the file and get its buffer
        local bufnr = vim.uri_to_bufnr(uri)
        if not vim.api.nvim_buf_is_loaded(bufnr) then
            vim.fn.bufload(bufnr)
        end

        -- Calculate window size based on settings
        local width = math.min(
            math.floor(vim.o.columns * M.config.max_width_percent),
            M.config.width
        )
        local height = math.min(
            math.floor(vim.o.lines * M.config.max_height_percent),
            M.config.height
        )

        -- Parameters for the floating window
        local opts = {
            relative = "editor",
            width = width,
            height = height,
            row = (vim.o.lines - height) / 2,
            col = (vim.o.columns - width) / 2,
            style = "minimal",
            border = M.config.border,
        }

        -- Create the floating window
        local win_id = vim.api.nvim_open_win(bufnr, true, opts)

        -- Set the cursor to the definition line
        vim.api.nvim_win_set_cursor(win_id, { range.start.line + 1, range.start.character })

        -- Add a keybinding to close the window
        vim.api.nvim_buf_set_keymap(bufnr, "n", M.config.close_key, "", {
            noremap = true,
            silent = true,
            callback = function()
                vim.api.nvim_win_close(win_id, true)
            end,
        })

        -- Add a keybinding to open the file
        vim.api.nvim_buf_set_keymap(bufnr, "n", M.config.open_key, "", {
            noremap = true,
            silent = true,
            callback = function()
                -- Close all open floating windows
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    local win_config = vim.api.nvim_win_get_config(win)
                    if win_config.relative == "editor" then
                        vim.api.nvim_win_close(win, true)
                    end
                end

                -- Open the file by URI
                vim.cmd("edit " .. vim.uri_to_fname(uri))
            end,
        })
    end)
end

return M
