return {
    'jpalardy/vim-slime',
    config = function()
        vim.g.slime_target = 'tmux'
        vim.g.slime_bracketed_paste = 1
        vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }

        local function slime_send(send_to_repl)
            local start_line = vim.fn.search('# %%', 'bnW')


            if start_line == 0 then
                start_line = 1
            end


            local end_line = vim.fn.search('# %%', 'nW')
            if end_line == 0 then
                end_line = vim.fn.line('$')
            else
                end_line = end_line - 1
            end


            if send_to_repl then
                vim.fn['slime#send_range'](start_line, end_line)
            end

            return end_line
        end

        vim.keymap.set('n', '<leader>cc', function()
            slime_send(true)
        end, { noremap = true, silent = true })


        vim.keymap.set('n', '<C-X>', function()
            local end_line = slime_send(true)

            if vim.fn.search('# %%', 'nW') == 0 then
                vim.cmd('$')
                vim.cmd('normal o# %%')
            else
                vim.cmd([[normal ]] .. end_line + 2 .. 'G')
            end
        end, { noremap = true, silent = true })


        vim.keymap.set('n', '<leader>nc', function()
            local end_line = slime_send(false)

            if vim.fn.search('# %%', 'nW') == 0 then
                vim.cmd('$')
                vim.cmd('normal o')
                vim.cmd('normal o# %%')
            else
                vim.cmd([[normal ]] .. end_line .. 'GO')
                vim.cmd([[normal O# %%]])
            end

            vim.cmd('normal j')
            vim.cmd('startinsert')
        end, { noremap = true, silent = true })

        vim.keymap.set('n', '<leader>rr', function()
            vim.fn['slime#send']('exit()\n')
            vim.fn['slime#send']('ipython\n')
        end, { noremap = true, silent = true })

        vim.keymap.set('n', '<leader>ip', function()
            vim.fn['slime#send']('ipython\n')
        end, { noremap = true, silent = true })

        vim.keymap.set('n', '<leader>gm', function()
            --
            vim.fn['slime#send']('conda activate genomicsml\n')
        end, { noremap = true, silent = true })
    end,
}
