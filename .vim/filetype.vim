" Latex
autocmd BufRead,BufNewFile *.tex setf tex

" C++
autocmd BufRead,BufNewFile *.hpp setf cpp
autocmd BufRead,BufNewFile *.tpp setf cpp
autocmd BufRead,BufNewFile *.ipp setf cpp

" Javascript (ES6)
autocmd BufRead,BufNewFile *.es6 setf javascript
autocmd BufRead,BufNewFile *.less setf css

" OpenFOAM
autocmd BufRead,BufNewFile */0/* setf cpp
autocmd BufRead,BufNewFile */0.org/* setf cpp
autocmd BufRead,BufNewFile */constant/* setf cpp
autocmd BufRead,BufNewFile */system/* setf cpp
autocmd BufRead,BufNewFile */processor*/* setf cpp

" Gmesh
autocmd BufRead,BufNewFile *.geo setf c
