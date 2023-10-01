return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      -- prefer C-g for grep because <leader>/ is remapped to commenting
      "<C-g>",
      require("lazyvim.util").telescope("live_grep"),
      desc = "Grep (root dir)",
    },
  },
  config = function()
    local select_one_or_multi = function(prompt_bufnr)
      local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
      local multi = picker:get_multi_selection()
      if not vim.tbl_isempty(multi) then
        require("telescope.actions").close(prompt_bufnr)
        for _, j in pairs(multi) do
          if j.path ~= nil then
            vim.cmd(string.format("%s %s", "edit", j.path))
          end
        end
      else
        require("telescope.actions").select_default(prompt_bufnr)
      end
    end

    require("telescope").setup({
      defaults = {
        mappings = {
          -- FIXME:
          n = {
            ["<CR>"] = select_one_or_multi,
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })
    require("telescope").load_extension("fzf")
  end,
}
