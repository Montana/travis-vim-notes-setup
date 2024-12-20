# My custom Travis CI Templating and Notation Vim Config for Work

Save my pluin to the following directory:

```bash
~/.vim/plugin/travis-notes.vim
```
It is worth noting when I was building this I kept in mind this was technically an extension of a notes plugin with Travis features, so _feasibly_ you could use:

```bash
travis-enhanced-notes.vim
```

This would go in your ~/.vim/plugin/ directory, so the full path would be:
```bash
~/.vim/plugin/travis-notes.vim
```

# travis-notes.vim

A Vim plugin for managing Travis CI build notes and debugging information with smart templates and integration hooks.

## Overview

`travis-notes.vim` is a specialized Vim plugin that helps developers document, track, and debug Travis CI builds. It provides structured templates, quick commands, and powerful organization features specifically designed for Travis CI workflows.

## Installation

Using [vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'yourusername/travis-notes.vim'
```

Using [Vundle](https://github.com/VundleVim/Vundle.vim):
```vim
Plugin 'yourusername/travis-notes.vim'
```

Manual installation:
```bash
git clone https://github.com/yourusername/travis-notes.vim.git
cp travis-notes.vim ~/.vim/plugin/
```

## Features

### Smart Templates
- **Build Notes Template**: Pre-formatted structure for documenting Travis CI builds
- **Debug Notes Template**: Specialized template for tracking and resolving build issues
- **Auto-populated Fields**: Automatic date stamping and build information sections

### Commands
| Command | Description |
|---------|-------------|
| `:TravisBuildNote <name>` | Create a new Travis build note |
| `:TravisDebugNote <name>` | Create a new Travis debugging note |
| `:TravisNotes` | List all Travis-related notes |
| `:TravisFailures` | List all failed Travis builds |

### Key Mappings
All mappings are available in Travis note buffers:

| Mapping | Action |
|---------|--------|
| `<leader>tb` | Fetch build details* |
| `<leader>tl` | Fetch build logs* |
| `<leader>tc` | Fetch Travis configuration* |
| `<leader>ts` | Update build status* |

*Currently placeholders for future API integration

### Template Sections

#### Build Notes Include:
- Build Information
  - Repository details
  - Branch information
  - Build number
  - Build status
- Configuration section with YAML formatting
- Build logs section
- Notes section

#### Debug Notes Include:
- Issue Description
- Environment Details
- Reproduction Steps
- Error Logs
- Solution
- Prevention Notes

### Organization Features
- Automatic tagging of Travis-related notes
- Special filtering for failed builds
- Quick access to common Travis CI information
- Structured tracking of build statuses

## Configuration

Default configuration:
```vim
" Set custom notes directory
let g:notes_directory = '~/.vim-notes'

" Customize file extension
let g:notes_extension = '.md'

" Override default build template
let g:notes_travis_build_template = [
    \ '# Travis Build: {title}',
    \ '',
    \ 'Build Date: {date}',
    \ ...
]

" Override default debug template
let g:notes_travis_debug_template = [
    \ '# Travis Debug: {title}',
    \ '',
    \ 'Debug Date: {date}',
    \ ...
]
```

## Usage Examples

### Creating a Build Note
```vim
:TravisBuildNote build-123
```

Creates a new note with the build template.

### Listing Failed Builds
```vim
:TravisFailures
```

Shows an interactive list of all notes marked as failed builds.

### Quick Build Log Access
In a Travis note buffer:
```vim
<leader>tl
```

Will fetch build logs (requires API integration).

## Future Enhancements

The plugin includes placeholders for Travis CI API integration. To fully implement these features, you would need to:

1. Add Travis CI API authentication
2. Implement the API calls in the placeholder functions
3. Add proper error handling for API responses
4. Handle rate limiting and caching

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Author 

Michael Mendy, December 20th, 2024 for Idera Inc & Travis CI, GmbH. 
