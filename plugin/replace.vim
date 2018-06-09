command! -nargs=+ ReplaceScope call ReplaceScope(<f-args>)
nnoremap <Leader>r :ReplaceScope 

function! ReplaceScope(toReplace, replacedBy)
	let l:scope2 = FindScope()
	call SearchAndReplace(l:scope2[0], l:scope2[1], a:toReplace, a:replacedBy)
endfunction

function! FindScope()	
	let l:cursorPos = getcurpos()
	let l:lowerEnd = GetEnd(-1)
	call setpos('.', l:cursorPos)
	let l:upperEnd = GetEnd(1)
	call setpos('.', l:cursorPos)
	return [l:lowerEnd, l:upperEnd]
endfunction

function! SearchAndReplace(lineStart, lineEnd, toReplace, replacedBy)
	let l:commandToExe = ':'.a:lineStart.','.a:lineEnd.'s/'.a:toReplace.'/'.a:replacedBy.'/gc'
	execute l:commandToExe
endfunction

function! GetColumn()
	let l:curPos = getcurpos()
	echo l:curPos[4]
endfunction

function! GetIndent()
	let l:line = getline('.')
	let l:len = len(l:line)
	let l:count = 0
	while l:count < l:len
		if l:line[l:count] != "\t"
			break
		endif
		let l:count = l:count + 1
	endwhile
	return l:count
endfunction

function! GetEnd(lineChange)
	let l:curLine = line('.')
	let l:maxIndent = GetIndent()
	if l:maxIndent == 0
		return l:curLine
	endif

	let l:indent = GetIndent()
	while l:indent >= l:maxIndent || getline('.') == ""
		let l:curLine = l:curLine + a:lineChange
		call cursor(l:curLine, 0)
		let l:curLine = line('.')
		let l:indent = GetIndent()
	endwhile
	return l:curLine
endfunction 
