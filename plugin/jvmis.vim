" Add Java Virtual Machine Instruction Set to webdict.vim site.
" Version: 0.1
" Author : ebc_2in2crc <ebc_2in2crc+vim@gmail.com>
" License: MIT License

if exists("g:loaded_jvmis")
  finish
endif
let g:loaded_jvmis = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists(":Jvmis")
  command -nargs=0 Jvmis :call ref#jvmis#jvm_instruction_set()
endif

let &cpo = s:save_cpo
unlet s:save_cpo
