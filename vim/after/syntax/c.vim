if exists('g:no_vim_conceal') || !has('conceal') || &enc != 'utf-8'
	finish
endif

syntax match cNiceOperator "==" conceal cchar=≡
syntax match cNiceOperator "!=" conceal cchar=≠
syntax match cNiceOperator ">=" conceal cchar=≥
syntax match cNiceOperator "<=" conceal cchar=≤

syntax match cNiceOperator "<<" conceal cchar=≺
syntax match cNiceOperator ">>" conceal cchar=≻

syntax match cNiceOperator "->" conceal cchar=➞

hi link cNiceOperator Operator
hi! link Conceal Operator

set conceallevel=1
