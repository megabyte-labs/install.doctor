if executable('volta') then
  let g:node_host_prog = trim(system("volta which neovim-node-host"))
endif
