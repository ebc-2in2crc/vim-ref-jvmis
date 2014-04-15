" Add Java Virtual Machine Instruction Set to webdict.vim site.
" Version: 0.1
" Author : ebc_2in2crc <ebc_2in2crc+vim@gmail.com>
" License: MIT License

let s:save_cpo = &cpo
set cpo&vim

if exists('s:loaded_jvmis')
  finish
endif
let s:loaded_jvmis = 1

if !exists('g:ref_source_webdict_jvmis_cache')
  let g:ref_source_webdict_jvmis_cache = 1
endif

if !exists('g:ref_source_webdict_sites')
  let g:ref_source_webdict_sites = {}
endif
let g:ref_source_webdict_sites.jvm_instruction_set = {
\   'url': 'http://docs.oracle.com/javase/specs/jvms/se8/html/jvms-6.html#jvms-6.5.%s',
\   'cache': g:ref_source_webdict_jvmis_cache
\ }

let s:keyword = ''

let s:jvm_general_opecodes = {
\   'aload_[0-3]': 'aload_<n>',
\   'astore_[0-3]': 'astore_<n>',
\   'dcmp[gl]': 'dcmp<op>',
\   'dconst_[01]': 'dconst_<d>',
\   'dload_[0-3]': 'dload_<n>',
\   'dstore_[0-3]': 'dstore_<n>',
\   'fcmp[gl]': 'fcmp<op>',
\   'fconst_[012]': 'fconst_<f>',
\   'fload_[0-3]': 'fload_<n>',
\   'fstore_[0-3]': 'fstore_<n>',
\   'iconst_\(m1\|[0-5]\)': 'iconst_<i>',
\   'if_acmp\(eq\|ne\)': 'if_acmp<cond>',
\   'if_icmp\(eq\|ne\|lt\|ge\|gt\|le\)': 'if_icmp<cond>',
\   'if\(eq\|ne\|lt\|ge\|gt\|le\)': 'if<cond>',
\   'iload_[0-3]': 'iload_<n>',
\   'istore_[0-3]': 'istore_<n>',
\   'lconst_[01]': 'lconst_<l>',
\   'lload_[0-3]': 'lload_<n>',
\   'lstore_[0-3]': 'lstore_<n>',
\ }

let s:sections = {
\   'Operation': '',
\   'Format': '',
\   'Forms': '',
\   'Operand Stack': '',
\   'Description': '',
\   'Notes': '',
\   'Linking Exceptions': '',
\   'Run-time Exception': '',
\   'Run-time Exceptions': '',
\ }

function! ref#jvmis#jvm_instruction_set()
  let s:keyword = s:GeneralizeOpecode(expand("<cword>"))
  execute "Ref webdict jvm_instruction_set " . s:keyword
endfunction

function! s:GeneralizeOpecode(keyword)
  let result = a:keyword

  for [key, value] in items(s:jvm_general_opecodes)
    if match(a:keyword, key) != -1
      let result = value
      break
    endif
  endfor

  return result
endfunction

function! g:ref_source_webdict_sites.jvm_instruction_set.filter(output)
  let pos = match(a:output, "\n" . s:keyword . "\n", 0, 1)

  if pos < 0
    return 'no match: ' . s:keyword
  endif
  let pos = pos + 1

  let lines = split(a:output[pos + strlen(s:keyword) : ], "\n")
  let result = [s:keyword]
  let operation_section_was_read = 0

  for line in lines
    if line == ""
      continue
    endif

    if line == "Operation"
      if operation_section_was_read == 1
        call remove(result, -1)
        break
      else
        let operation_section_was_read = 1
      endif
    endif

    let line = (has_key(s:sections, line) ? "\n" : "\t") . line
    call add(result, line)
  endfor

  return join(result, "\n")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
