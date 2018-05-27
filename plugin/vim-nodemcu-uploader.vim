fun! NodemcuUploader_restart()
    exec ":!nodemcu-uploader node restart"
endfun

fun! NodemcuUploader_upload()
    exec ":!nodemcu-uploader upload --restart " . expand("%:p") . ":" . expand("%:t")
endfun

fun! NodemcuUploader_exec()
    exec ":!nodemcu-uploader exec %:p"
endfun

fun! NodemcuUploader_serial()
    exec ":!nodemcu-uploader terminal"
endfun

fun! NodemcuUploader_listFiles()
    exec ":!nodemcu-uploader file list"
endfun

fun! NodemcuUploader_test()
    call NodemcuUploader_upload()
    call NodemcuUploader_serial()
endfun

fun! s:NodemcuUploader_parseFile(key, val)
	return split(a:val, "\t")[0]
endfun

fun! NodemcuUploader_deleteFile()
	let l:Func = function("NodemcuUploader_parseFile")
	let l:files = split(system("nodemcu-uploader file list"), "\n")[3:-2]
	let l:processedFiles = map(l:files, 'split(v:val, "\t")[0]')
	let l:answer = confirm("Type the file to delete", join(l:processedFiles, "\n"), 0)
	if l:answer != 0
		let l:f = l:processedFiles[l:answer - 1]
		exec "!nodemcu-uploader file remove ".l:f
		echo l:f." deleted"
	else
		echo "No file deleted!"
	endif
endfun

command NMCUcp :call NodemcuUploader_upload()
command NMCUexec :call NodemcuUploader_exec()
command NMCUls :call NodemcuUploader_listFiles()
command NMCUrestart :call NodemcuUploader_restart()
command NMCUrm :call NodemcuUploader_deleteFile()
command NMCUsh :call NodemcuUploader_serial()
command NMCUtest :call NodemcuUploader_test()
