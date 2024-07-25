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

        local function add_indent(lines, indent, tbl)
            if tbl == nil then
                local new_lines = ""
                for _, line in ipairs(lines) do
                    new_lines = new_lines .. indent .. line .. "\n"
                end
                return new_lines
            else
                local new_lines = tbl
                for _, line in ipairs(lines) do
                    table.insert(new_lines, indent .. line)
                end
                return new_lines
            end
        end

        local bash_header_script = [[
#!/bin/bash

#SBATCH --partition=NMLResearch
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=24:00:00]]

        local bash_footer_script = [[
# source conda if not already done
if [ -z "$CONDA_EXE" ]; then
      # check if conda is installed in root
      if [ -f "/opt/conda/etc/profile.d/conda.sh" ]; then
            source /opt/conda/etc/profile.d/conda.sh
      elif [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
            source $HOME/miniconda3/etc/profile.d/conda.sh
      else
            echo "Conda not found. Please install conda and re-run this script."
            exit 1
      fi
fi

source activate goml
python3]]

        local function create_bash_script()
            local file_name = vim.fn.input('Enter the name of the scripts (default: my_script.*): ')
            if file_name == nil or file_name == "" then
                file_name = "my_script"
            end

            local new_bash_script = bash_header_script .. "\n#SBATCH --job-name=" ..
                file_name .. "\n" .. "#SBATCH --output=" .. file_name .. "_%j.out\n" ..
                "#SBATCH --error=" .. file_name .. "_%j.err\n"

            local dev_type = vim.fn.input('Enter the device type (default: cpu): ')
            if dev_type == nil or dev_type == "" then
                dev_type = "cpu"
            end
            if dev_type == "cpu" then
                local cpu_count = vim.fn.input('Enter the number of cpus (default: 16): ')
                if cpu_count == nil or cpu_count == "" then
                    cpu_count = 16
                end
                new_bash_script = new_bash_script .. "#SBATCH --cpus-per-task=" .. cpu_count .. "\n"
            else
                local gpu_count = vim.fn.input('Enter the number of gpus (default: 1): ')
                if gpu_count == nil or gpu_count == "" then
                    gpu_count = 1
                end
                new_bash_script = new_bash_script .. "#SBATCH --gres=gpu:" .. gpu_count .. "\n"
            end

            local mem = vim.fn.input('Enter the memory in gigabytes (default: 64): ')
            if mem == nil or mem == "" then
                mem = "64"
            end
            new_bash_script = new_bash_script .. "#SBATCH --mem=" .. mem .. "G\n"

            new_bash_script = new_bash_script .. bash_footer_script .. " " .. file_name .. ".py\n"
            return new_bash_script, file_name
        end

        vim.keymap.set('n', '<leader>sm', function()
            -- ask for file name
            local bash_script, file_name = create_bash_script()
            vim.fn['slime#send']('cat <<EOF > ' .. file_name .. '.py\n')
            local start_line = 0
            local end_line = vim.fn.line('$')
            local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
            lines = add_indent(lines, '    ')
            local buf = "def main():\n" .. lines .. "\nif __name__ == '__main__':\n    main()\n"
            vim.fn['slime#send'](buf)
            vim.fn['slime#send']('EOF\n')
            vim.fn['slime#send']('cat <<EOF > ' .. file_name .. '.sh\n')
            vim.fn['slime#send'](bash_script .. "\n")
            vim.fn['slime#send']('EOF\n')
        end, { noremap = true, silent = true })

        vim.keymap.set('v', '<leader>sm', function()
            -- ask for file name
            local bash_script, file_name = create_bash_script()
            vim.fn['slime#send']('cat <<EOF > ' .. file_name .. '.py\n')
            local start_pos = vim.fn.getpos("v")
            local end_pos = vim.fn.getpos(".")
            local start_line = start_pos[2]
            local end_line = end_pos[2]
            local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
            lines = add_indent(lines, '    ')
            local buf = "def main():\n" .. lines .. "\nif __name__ == '__main__':\n    main()\n"
            vim.fn['slime#send'](buf)
            vim.fn['slime#send']('EOF\n')
            vim.fn['slime#send']('cat <<EOF > ' .. file_name .. '.sh\n')
            vim.fn['slime#send'](bash_script .. "\n")
            vim.fn['slime#send']('EOF\n')
        end, { noremap = true, silent = true })

        vim.keymap.set('v', '<leader>sn', function()
            -- convert code under the cursor to a main function and
            -- add the if __name__ == '__main__' block
            local start_pos = vim.fn.getpos("v")
            local end_pos = vim.fn.getpos(".")
            local start_line = start_pos[2]
            local end_line = end_pos[2]
            if start_line > end_line then
                start_line, end_line = end_line, start_line
            end
            local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
            local tbl = { "def main():" }
            tbl = add_indent(lines, '    ', tbl)
            table.insert(tbl, "if __name__ == '__main__':")
            table.insert(tbl, "    main()")
            -- replace the selected lines with the new code
            -- split the buffer via \n
            vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, tbl)
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
