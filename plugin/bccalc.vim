vnoremap ;bc "ey:call CalcBC(1)<CR>

noremap ;bc "eyy:call CalcBC(0)<CR>

command! -nargs=+ Calculate echo Calculate (<args>)

function! Calculate (s)

	let str = a:s

	" remove newlines and trailing spaces
	let str = substitute (str, "\n", "", "g")
	let str = substitute (str, '\s*$', "", "g")

	" if we end with an equal, strip, and remember for output
	"if str =~ "=$"
	"	let str = substitute (str, '=$', "", "")
	"	let has_equal = 1
	"endif

	" sub common func names for bc equivalent
	let str = substitute (str, '\csin\s*(', "s (", "")
	let str = substitute (str, '\ccos\s*(', "c (", "")
	let str = substitute (str, '\catan\s*(', "a (", "")
	let str = substitute (str, "\cln\s*(", "l (", "")

	" exponitiation
	"let str = substitute (str, '**', '^', "")

	" escape chars for shell
	let str = escape (str, '*();&><|')

	let preload = exists ("g:bccalc_preload") ? g:bccalc_preload : ""

	" run bc, strip newline
	"let answer = substitute (system ("echo " . str . " \| bc -l"), "\n", "", "")
	let answer = system ("echo " . str . " \| bc -l " . preload)
	let answer = substitute (answer, "\n", "", "")
	let answer = substitute (answer, '\.\(\d*[1-9]\)0\+', '.\1', "")

	return answer
endfunction


function! CalcBC(vsl)

	let has_equal = 0

	" remove newlines and trailing spaces
	let @e = substitute (@e, "\n", "", "g")
	let @e = substitute (@e, '\s*$', "", "g")

	" if we end with an equal, strip, and remember for output
	if @e =~ "=$"
		let @e = substitute (@e, '=$', "", "")
		let has_equal = 1
	endif

	let answer = Calculate (@e)

	" append answer or echo
	if has_equal == 1
		if a:vsl == 1
			normal `>
		else
			normal $
		endif
		exec "normal a" . answer
	else
		echo "answer = " . answer
	endif
endfunction
