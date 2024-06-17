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

            return start_line, end_line
        end

        vim.keymap.set('n', '<leader>cc', function()
            slime_send(true)
        end, { noremap = true, silent = true })


        vim.keymap.set('n', '<leader>ss', function()
            local _, end_line = slime_send(true)

            if vim.fn.search('# %%', 'nW') == 0 then
                vim.cmd('$')
                vim.cmd('normal o# %%')
            else
                vim.cmd([[normal ]] .. end_line + 2 .. 'G')
            end
        end, { noremap = true, silent = true })


        vim.keymap.set('n', '<leader>sc', function()
            local _, end_line = slime_send(false)

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

        vim.keymap.set('n', '<leader>sr', function()
            vim.fn['slime#send']('exit()\n')
            vim.fn['slime#send']('ipython\n')
        end, { noremap = true, silent = true })

        vim.keymap.set('n', '<leader>sp', function()
            vim.fn['slime#send']('ipython\n')
        end, { noremap = true, silent = true })

        vim.keymap.set('n', '<leader>sb', function()
            -- activate the goml conda environment
            vim.fn['slime#send']('conda activate goml\n')
        end, { noremap = true, silent = true })

        vim.keymap.set('n', '<leader>sg', function()
            -- activate the goml conda environment
            vim.fn['slime#send']('conda activate goml\n')
        end, { noremap = true, silent = true })

        vim.keymap.set('n', '<leader>st', function()
            -- create a my_script.py from the repl
            vim.fn['slime#send']('cat <<EOF > my_script.py\n')
            slime_send(true)
            vim.fn['slime#send']('EOF\n')
        end, { noremap = true, silent = true })

        vim.keymap.set('v', '<leader>st', function()
            vim.fn['slime#send']('cat <<EOF > my_script.py\n')
            -- send code under the cursor
            local start_pos = vim.fn.getpos("v")
            local end_pos = vim.fn.getpos(".")
            local start_line = start_pos[2]
            local end_line = end_pos[2]
            vim.fn['slime#send_range'](start_line, end_line)
            vim.fn['slime#send']('EOF\n')
        end, { noremap = true, silent = true })

        local function add_indent(lines, indent)
            local new_lines = ""
            for _, line in ipairs(lines) do
                new_lines = new_lines .. indent .. line .. "\n"
            end
            return new_lines
        end

        vim.keymap.set('n', '<leader>sm', function()
            vim.fn['slime#send']('cat <<EOF > my_script.py\n')
            -- send code under the cursor
            local start_line, end_line = slime_send(false)
            local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
            vim.fn['slime#send']("def main():\n")
            lines = add_indent(lines, '    ')
            local buf = "def main():\n" .. lines .. "\nif __name__ == '__main__':\n    main()\n"
            vim.fn['slime#send']('EOF\n')
        end, { noremap = true, silent = true })

        vim.keymap.set('v', '<leader>sm', function()
            vim.fn['slime#send']('cat <<EOF > my_script.py\n')
            -- send code under the cursor
            local start_pos = vim.fn.getpos("v")
            local end_pos = vim.fn.getpos(".")
            local start_line = start_pos[2]
            local end_line = end_pos[2]
            local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
            lines = add_indent(lines, '    ')
            local buf = "def main():\n" .. lines .. "\nif __name__ == '__main__':\n    main()\n"
            vim.fn['slime#send'](buf)
            vim.fn['slime#send']('EOF\n')
        end, { noremap = true, silent = true })

        vim.keymap.set('n', '<leader>sb', function()
            -- creates a slurm job
            -- prompt user for the name of the job
            local job_name = vim.fn.input('Enter the name of the script: ')
            if job_name == nil or job_name == "" then
                job_name = "PS_JOB"
            end
            cmd = "sbatch --job-name=" ..
                job_name ..
                " --output=" ..
                job_name ..
                ".out --error=" ..
                job_name .. ".err"

            -- if its a number add a prefix
            if tonumber(job_name:sub(1, 1)) then
                job_name = "ps_job_" .. job_name
            end

            local cpu_count = vim.fn.input('Enter the number of cpus: ')
            if cpu_count == nil or cpu_count == "" then
                cpu_count = 16
            end

            local gpu_count = vim.fn.input('Enter the number of gpus: ')
            if gpu_count == nil or gpu_count == "" then
                gpu_count = 1
            end
        end, { noremap = true, silent = true })
    end,
}
