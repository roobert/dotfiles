-- vim.cmd([[autocmd FileType text,latex,tex,md,markdown setlocal spell]])
--
-- vim.cmd([[autocmd BufNewFile *.sh 0put = \"#!/usr/bin/env bash\nset -euo pipefail\" | normal G]])
--
-- vim.cmd(
--   [[autocmd BufNewFile *.py 0put = \"#!/usr/bin/env python\n\n\ndef main():\n    pass\n\n\nif __name__ == '__main__':\n    main()\" | normal G]]
-- )

return {}
