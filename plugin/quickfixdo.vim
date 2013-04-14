
" QFDo is like bufdo but it applies to all files listed in the quickfix window
" Very useful if you want to make a change after finding matches using ack
command! -nargs=+ Qfdo call QFDo(<q-args>)

function! QFDo(command)
    " Create a dictionary so that we can
    " get the list of buffers rather than the
    " list of lines in buffers (easy way
    " to get unique entries)
    let buffer_numbers = {}
    " For each entry, use the buffer number as 
    " a dictionary key (won't get repeats)
    for fixlist_entry in getqflist()
        let buffer_numbers[fixlist_entry['bufnr']] = 1
    endfor
    " Make it into a list as it seems cleaner
    let buffer_number_list = keys(buffer_numbers)

    " For each buffer
    for num in buffer_number_list
        " Select the buffer
        exe 'buffer' num

        " This is necessary otherwise sometimes it prompt for a command without 
        " showing the current buffer (eg. if you do a mass replace with confirm option)
        redraw

        " Run the command that's passed as an argument
        try
            exe a:command
        catch /.*/
            " ignore the error, since this will likely be a mass substitution, and the 
            " error will likely be not finding a match in one particular file, so who cares?
        endtry
    endfor
endfunction
