if exists('g:loaded_notes')
    finish
endif
let g:loaded_notes = 1

" Configuration
let g:notes_directory = get(g:, 'notes_directory', expand('~/.vim-notes'))
let g:notes_extension = get(g:, 'notes_extension', '.md')
let g:notes_default_template = get(g:, 'notes_default_template', [
    \ '# {title}',
    \ '',
    \ 'Created: {date}',
    \ 'Tags: ',
    \ '',
    \ '## Content',
    \ ''
    \ ])

" Travis CI specific templates
let g:notes_travis_build_template = get(g:, 'notes_travis_build_template', [
    \ '# Travis Build: {title}',
    \ '',
    \ 'Build Date: {date}',
    \ 'Tags: travis, ci, build',
    \ '',
    \ '## Build Information',
    \ '- Repository: ',
    \ '- Branch: ',
    \ '- Build Number: ',
    \ '- Build Status: ',
    \ '',
    \ '## Build Configuration',
    \ '```yaml',
    \ '# .travis.yml',
    \ '',
    \ '```',
    \ '',
    \ '## Build Logs',
    \ '```',
    \ '',
    \ '```',
    \ '',
    \ '## Notes',
    \ ''
    \ ])

let g:notes_travis_debug_template = get(g:, 'notes_travis_debug_template', [
    \ '# Travis Debug: {title}',
    \ '',
    \ 'Debug Date: {date}',
    \ 'Tags: travis, ci, debug',
    \ '',
    \ '## Issue Description',
    \ '',
    \ '## Environment',
    \ '- OS: ',
    \ '- Language: ',
    \ '- Dependencies: ',
    \ '',
    \ '## Reproduction Steps',
    \ '1. ',
    \ '',
    \ '## Error Logs',
    \ '```',
    \ '',
    \ '```',
    \ '',
    \ '## Solution',
    \ '',
    \ '## Prevention Notes',
    \ ''
    \ ])

" Create notes directory if it doesn't exist
if !isdirectory(g:notes_directory)
    call mkdir(g:notes_directory, 'p')
endif

" Commands
command! -nargs=1 -complete=customlist,s:note_name_complete Note call s:open_note(<q-args>)
command! Notes call s:list_notes()
command! -nargs=? NoteSearch call s:search_notes(<q-args>)
command! -nargs=1 NoteTag call s:search_tags(<q-args>)
command! NoteTags call s:list_tags()
command! -range NoteLink call s:create_note_link(<line1>, <line2>)

" Travis CI specific commands
command! -nargs=1 -complete=customlist,s:note_name_complete TravisBuildNote call s:create_travis_note('build', <q-args>)
command! -nargs=1 -complete=customlist,s:note_name_complete TravisDebugNote call s:create_travis_note('debug', <q-args>)
command! TravisNotes call s:list_travis_notes()
command! TravisFailures call s:list_travis_failures()

" Function to create note with template
function! s:create_note(note_path, title)
    let l:content = []
    for line in g:notes_default_template
        let l:line = substitute(line, '{title}', a:title, 'g')
        let l:line = substitute(l:line, '{date}', strftime('%Y-%m-%d %H:%M'), 'g')
        call add(l:content, l:line)
    endfor
    call writefile(l:content, a:note_path)
endfunction

" Function to open a note
function! s:open_note(note_name)
    let l:note_path = g:notes_directory . '/' . a:note_name . g:notes_extension
    if !filereadable(l:note_path)
        call s:create_note(l:note_path, a:note_name)
    endif
    execute 'edit' l:note_path
    
    " Set up note-specific mappings
    nnoremap <buffer> <leader>nt :NoteTags<CR>
    nnoremap <buffer> <leader>ns :NoteSearch<CR>
    nnoremap <buffer> <leader>nl :call <SID>create_note_link(line('.'), line('.'))<CR>
endfunction

" Function to list notes with preview
function! s:list_notes()
    let l:notes = globpath(g:notes_directory, '*' . g:notes_extension, 0, 1)
    if empty(l:notes)
        echo "No notes found!"
        return
    endif
    
    let l:preview_height = 10
    let l:choices = ['Choose a note (preview window will show content):']
    let l:note_names = []
    
    for note in l:notes
        let l:name = fnamemodify(note, ':t:r')
        call add(l:choices, len(l:choices) . '. ' . l:name)
        call add(l:note_names, l:name)
    endfor
    
    " Create preview window
    botright new
    resize l:preview_height
    setlocal buftype=nofile bufhidden=hide noswapfile

    let l:choice = inputlist(l:choices)
    if l:choice > 0 && l:choice <= len(l:note_names)
        bdelete
        call s:open_note(l:note_names[l:choice - 1])
    else
        bdelete
        echo "Invalid choice!"
    endif
endfunction

" Function to search notes content
function! s:search_notes(query)
    let l:query = empty(a:query) ? input('Search notes for: ') : a:query
    if empty(l:query)
        return
    endif
    
    let l:notes = globpath(g:notes_directory, '*' . g:notes_extension, 0, 1)
    let l:matches = []
    
    for note in l:notes
        let l:content = readfile(note)
        let l:line_matches = filter(copy(l:content), 'v:val =~ l:query')
        if !empty(l:line_matches)
            call add(l:matches, {
                \ 'note': fnamemodify(note, ':t:r'),
                \ 'lines': l:line_matches
                \ })
        endif
    endfor
    
    if empty(l:matches)
        echo "No matches found!"
        return
    endif
    
    let l:choices = ['Select a match:']
    for idx in range(len(l:matches))
        let l:match = l:matches[idx]
        call add(l:choices, printf('%d. %s (%d matches)',
            \ len(l:choices),
            \ l:match.note,
            \ len(l:match.lines)))
    endfor
    
    let l:choice = inputlist(l:choices)
    if l:choice > 0 && l:choice <= len(l:matches)
        call s:open_note(l:matches[l:choice - 1].note)
    endif
endfunction

" Function to extract tags from notes
function! s:get_all_tags()
    let l:notes = globpath(g:notes_directory, '*' . g:notes_extension, 0, 1)
    let l:all_tags = {}
    
    for note in l:notes
        let l:content = readfile(note)
        for line in l:content
            if line =~ '^Tags:'
                let l:tags = split(substitute(line, '^Tags:\s*', '', ''), ',\s*')
                for tag in l:tags
                    let l:all_tags[tag] = get(l:all_tags, tag, 0) + 1
                endfor
            endif
        endfor
    endfor
    
    return l:all_tags
endfunction

" Function to list all tags
function! s:list_tags()
    let l:tags = s:get_all_tags()
    if empty(l:tags)
        echo "No tags found!"
        return
    endif
    
    echo "Available tags (with note count):"
    for [tag, count] in items(l:tags)
        echo printf("  %s (%d)", tag, count)
    endfor
endfunction

" Function to search by tag
function! s:search_tags(tag)
    let l:notes = globpath(g:notes_directory, '*' . g:notes_extension, 0, 1)
    let l:matches = []
    
    for note in l:notes
        let l:content = readfile(note)
        for line in l:content
            if line =~ '^Tags:' && line =~ a:tag
                call add(l:matches, fnamemodify(note, ':t:r'))
                break
            endif
        endfor
    endfor
    
    if empty(l:matches)
        echo "No notes found with tag: " . a:tag
        return
    endif
    
    let l:choices = ['Select a note with tag "' . a:tag . '":']
    let l:choices += map(copy(l:matches), 'len(l:choices) . ". " . v:val')
    
    let l:choice = inputlist(l:choices)
    if l:choice > 0 && l:choice <= len(l:matches)
        call s:open_note(l:matches[l:choice - 1])
    endif
endfunction

" Function to create wiki-style links between notes
function! s:create_note_link(line1, line2) range
    let l:text = join(getline(a:line1, a:line2), ' ')
    let l:note_name = input('Create link to note (default: ' . l:text . '): ')
    if empty(l:note_name)
        let l:note_name = l:text
    endif
    
    let l:link = '[[' . l:note_name . ']]'
    execute a:line1 . ',' . a:line2 . 'delete'
    call append(a:line1 - 1, l:link)
    
    " Create the linked note if it doesn't exist
    let l:note_path = g:notes_directory . '/' . l:note_name . g:notes_extension
    if !filereadable(l:note_path)
        call s:create_note(l:note_path, l:note_name)
    endif
endfunction

" Autocomplete function for note names
function! s:note_name_complete(ArgLead, CmdLine, CursorPos)
    let l:notes = globpath(g:notes_directory, '*' . g:notes_extension, 0, 1)
    let l:names = map(l:notes, 'fnamemodify(v:val, ":t:r")')
    return filter(l:names, 'v:val =~ "^" . a:ArgLead')
endfunction

" Set up auto-commands for notes
augroup notes_plugin
    autocmd!
    " Handle following wiki-style links
    autocmd BufRead,BufNewFile **/vim-notes/*.md nnoremap <buffer> <CR> :call <SID>follow_link()<CR>
    " Auto-save notes
    autocmd TextChanged,TextChangedI **/vim-notes/*.md silent write
    " Travis CI integration
    autocmd BufRead,BufNewFile **/vim-notes/*travis*.md call s:setup_travis_mappings()
augroup END

" Function to set up Travis CI specific mappings
function! s:setup_travis_mappings()
    nnoremap <buffer> <leader>tb :call <SID>fetch_travis_build()<CR>
    nnoremap <buffer> <leader>tl :call <SID>fetch_travis_logs()<CR>
    nnoremap <buffer> <leader>tc :call <SID>fetch_travis_config()<CR>
    nnoremap <buffer> <leader>ts :call <SID>update_travis_status()<CR>
endfunction

" Travis CI specific functions
function! s:create_travis_note(type, note_name)
    let l:note_path = g:notes_directory . '/' . a:note_name . g:notes_extension
    let l:template = a:type ==# 'build' ? g:notes_travis_build_template : g:notes_travis_debug_template
    
    let l:content = []
    for line in l:template
        let l:line = substitute(line, '{title}', a:note_name, 'g')
        let l:line = substitute(l:line, '{date}', strftime('%Y-%m-%d %H:%M'), 'g')
        call add(l:content, l:line)
    endfor
    
    call writefile(l:content, l:note_path)
    execute 'edit' l:note_path
endfunction

function! s:list_travis_notes()
    let l:notes = globpath(g:notes_directory, '*travis*' . g:notes_extension, 0, 1)
    if empty(l:notes)
        echo "No Travis CI notes found!"
        return
    endif
    
    let l:choices = ['Choose a Travis CI note:']
    let l:note_names = []
    
    for note in l:notes
        let l:name = fnamemodify(note, ':t:r')
        call add(l:choices, len(l:choices) . '. ' . l:name)
        call add(l:note_names, l:name)
    endfor
    
    let l:choice = inputlist(l:choices)
    if l:choice > 0 && l:choice <= len(l:note_names)
        call s:open_note(l:note_names[l:choice - 1])
    else
        echo "Invalid choice!"
    endif
endfunction

function! s:list_travis_failures()
    let l:notes = globpath(g:notes_directory, '*travis*' . g:notes_extension, 0, 1)
    let l:failures = []
    
    for note in l:notes
        let l:content = readfile(note)
        for line in l:content
            if line =~ 'Build Status:\s*failed' || line =~ 'Build Status:\s*error'
                call add(l:failures, fnamemodify(note, ':t:r'))
                break
            endif
        endfor
    endfor
    
    if empty(l:failures)
        echo "No failed Travis builds found!"
        return
    endif
    
    let l:choices = ['Choose a failed build note:']
    let l:choices += map(copy(l:failures), 'len(l:choices) . ". " . v:val')
    
    let l:choice = inputlist(l:choices)
    if l:choice > 0 && l:choice <= len(l:failures)
        call s:open_note(l:failures[l:choice - 1])
    endif
endfunction

function! s:fetch_travis_build()
    " Placeholder for Travis CI API integration
    " This would fetch build details using Travis CI API
    echo "TODO: Implement Travis CI API integration for build details"
endfunction

function! s:fetch_travis_logs()
    " Placeholder for Travis CI API integration
    " This would fetch build logs using Travis CI API
    echo "TODO: Implement Travis CI API integration for logs"
endfunction

function! s:fetch_travis_config()
    " Placeholder for Travis CI API integration
    " This would fetch .travis.yml configuration
    echo "TODO: Implement Travis CI API integration for config"
endfunction

function! s:update_travis_status()
    " Placeholder for Travis CI API integration
    " This would update the build status using Travis CI API
    echo "TODO: Implement Travis CI API integration for status updates"
endfunction

" Function to follow wiki-style links
function! s:follow_link()
    let l:line = getline('.')
    let l:col = col('.')
    let l:link_pattern = '\[\[\([^\]]\+\)\]\]'
    let l:start = searchpos(l:link_pattern, 'bcn', line('.'))
    let l:end = searchpos(l:link_pattern, 'en', line('.'))
    
    if l:start[0] && l:end[0] && l:col >= l:start[1] && l:col <= l:end[1]
        let l:match = matchstr(l:line, l:link_pattern)
        let l:note_name = substitute(l:match, '^\[\[\(.*\)\]\]$', '\1', '')
        call s:open_note(l:note_name)
    endif
endfunction
