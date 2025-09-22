return {
  { -- Molten Nvim: Juputer Notebook in Neovim
    'benlubas/molten-nvim',

    dependencies = {
      'nvim-lua/plenary.nvim',
      '3rd/image.nvim',
    },

    lazy = true,

    build = ':UpdateRemotePlugins',

    init = function()
      -- Automatically open image outputs
      vim.g.molten_auto_image_popup = true -- (false) Disable auto-opening images with Image.show()

      -- Behavior when a kernel is not running
      vim.g.molten_auto_init_behavior = 'init' -- ("init") Default, initializes kernel if not running, instead of raising an error

      -- Auto-open HTML outputs in browser
      vim.g.molten_auto_open_html_in_browser = true -- (false) Automatically open HTML in browser when output is generated

      -- Auto-open the floating output window when cursor moves into a cell
      vim.g.molten_auto_open_output = false -- (true) Automatically open output window when cursor enters a cell

      -- Display output below the last line of code in the cell (not above it)
      vim.g.molten_cover_empty_lines = true -- (false) Don't show output for empty lines

      -- Specify lines that should trigger output covering
      vim.g.molten_cover_lines_starting_with = { '# %%' } -- (empty) Trigger covering for lines starting with '# %%'

      -- Automatically copy output to clipboard
      vim.g.molten_copy_output = false -- (true) Automatically copy evaluation output to clipboard

      -- Behavior when entering the output window
      vim.g.molten_enter_output_behavior = 'open_then_enter' -- ("open_then_enter") Open output and then focus, "open_and_enter" focuses automatically

      -- Where images will be displayed: 'float' = floating window, 'virt' = virtual text below the cell
      vim.g.molten_image_location = 'virt' -- ("both") Display images in both virtual text and floating windows

      -- Provider for displaying images
      vim.g.molten_image_provider = 'image.nvim' -- ("none") Use 'image.nvim' to display images, or none

      -- Command for opening files, can be customized
      vim.g.molten_open_cmd = nil -- (nil) Default command for opening files based on OS

      -- Crop the output window border
      vim.g.molten_output_crop_border = true -- (false) Crop the bottom border of the output window

      -- Show execution time for the current cell
      vim.g.molten_output_show_exec_time = true -- (false) Display execution time in the output window

      -- Show the number of extra lines when output doesn't fit
      vim.g.molten_output_show_more = true -- (false) Show extra lines in the footer when output is too large

      -- Pad the main buffer with virtual lines to avoid overlapping floating windows
      vim.g.molten_output_virt_lines = true -- (false) Enable virtual lines for padding

      -- Set output window border appearance
      vim.g.molten_output_win_border = { '', '━', '', '' } -- (empty) Customize the border style of the output window

      -- Should the output window cover the gutter (numbers and sign column)
      vim.g.molten_output_win_cover_gutter = false -- (false) Enable gutter cover

      -- Hide output window after leaving it
      vim.g.molten_output_win_hide_on_leave = false -- (false) Hide output window when switching away

      -- Max height and width of the output window
      vim.g.molten_output_win_max_height = 999999 -- (999999) Max height for the output window
      vim.g.molten_output_win_max_width = 999999 -- (999999) Max width for the output window

      -- Style for the output window, 'false' means default, 'minimal' for a minimal appearance
      vim.g.molten_output_win_style = 'false' -- (false) Default style for the output window

      -- Path for saving/loading data from Molten
      vim.g.molten_save_path = vim.fn.stdpath 'data' .. '/molten' -- (stdpath("data").."/molten") Path for saving Molten data

      -- Direction of the split for terminal-based providers like wezterm
      vim.g.molten_split_direction = 'right' -- ("right") Direction of the terminal split, options are left, right, top, or bottom

      -- Size of the split window (in percentage)
      vim.g.molten_split_size = 40 -- (40) Size of the split window in percentage (0-100)

      -- Tick rate in milliseconds for polling kernel updates
      vim.g.molten_tick_rate = 500 -- (500) How frequently (in ms) we poll the kernel for updates

      -- Use border highlights for the output window
      vim.g.molten_use_border_highlights = true -- (false) Enable border highlights for output window states

      -- Limit the number of characters in output
      vim.g.molten_limit_output_chars = 1000000 -- (1000000) Limit the output characters to prevent lagging

      -- Offsets virtual lines by one
      vim.g.molten_virt_lines_off_by_1 = false -- (true) Allow output window to cover exactly one line of code

      -- Enable or disable virtual text output for cells
      vim.g.molten_virt_text_output = true -- (false) Enable virtual text output below the cell

      -- Max height of the virtual text
      vim.g.molten_virt_text_max_lines = 12 -- (12) Max number of lines for virtual text

      -- Wrap the output text
      vim.g.molten_wrap_output = true -- (false) Enable output text wrapping

      -- Debug flag for MIME type output (for debugging)
      vim.g.molten_show_mimetype_debug = false -- (false) Show mime-type before non-iostream output (for debugging)
    end,
  },
}
