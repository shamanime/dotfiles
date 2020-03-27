let SessionLoad = 1
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/.dotfiles
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +1 gitignore
badd +31 .gitignore
badd +1 vim/farignore
badd +1 .editorconfig
badd +1 .gitattributes
badd +1 .projections.json
badd +1 ackrc
badd +1 apps_osx.sh
badd +1 asdf.sh
badd +1 ctags
badd +1 extra.sh
badd +1 gemrc
badd +1 gitconfig
badd +5 iex.exs
badd +13 install.sh
badd +1 irbrc
badd +1 my.cnf
badd +1 npmrc
badd +1 osx.sh
badd +1 pryrc
badd +1 psqlrc
badd +1 README.md
badd +1 sensitive.example
badd +1 setup_ubuntu.sh
badd +1 spacemacs
badd +37 tmux.conf
badd +1 xinitrc
badd +1 zshenv
badd +1 zshrc
badd +1 config/kitty/kitty.conf
badd +1 config/pgcli/config
argglobal
%argdel
$argadd .
edit .projections.json
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 87 - ((86 * winheight(0) + 59) / 118)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
87
normal! 0
tabnext 1
if exists('s:wipebuf') && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 winminheight=1 winminwidth=1 shortmess=filnxtToOFc
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
