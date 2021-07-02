vim.g.gutentags_modules={'ctags'}
vim.g.gutentags_project_root={'.git'}
vim.g.gutentags_add_default_project_roots=0
vim.g.gutentags_define_advanced_commands=1
vim.g.gutentags_cache_dir=os.getenv('HOME')..'/.cache/tags'

--vim.g.gutentags_trace=1
--augroup MyGutentagsStatusLineRefresher
--    autocmd!
--    autocmd User GutentagsUpdating call lightline#update()
--    autocmd User GutentagsUpdated call lightline#update()
--augroup END
