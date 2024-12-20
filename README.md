# 🔧 travis-notes.vim

<div align="center">

[![Vim Compatible](https://img.shields.io/badge/Vim-8.0%2B-brightgreen.svg)](https://www.vim.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

*A powerful Vim plugin for Travis CI build management and debugging*

[Installation](#-installation) •
[Features](#-features) •
[Usage](#-usage) •
[Configuration](#-configuration) •
[Contributing](#-contributing)

</div>

---

## 📋 Overview

`travis-notes.vim` transforms your Vim environment into a powerful Travis CI documentation and debugging station. Built for developers who need quick access to build information and structured note-taking capabilities, this plugin seamlessly integrates with your existing Vim workflow.

### Why travis-notes.vim?

- 📝 **Smart Templates** - Pre-configured templates for builds and debugging
- 🔍 **Quick Access** - Instant access to build logs and configuration
- 🏷️ **Organized** - Automatic tagging and categorization of notes
- 🔄 **Integration Ready** - Prepared for Travis CI API integration
- 💡 **Developer Focused** - Built by developers, for developers

## 🚀 Installation

### Prerequisites

- Vim 8.0 or higher
- Git (for plugin manager installation)

### Using Plugin Managers

**[vim-plug](https://github.com/junegunn/vim-plug)**
```vim
Plug 'mendy/travis-notes.vim'
```

**[Vundle](https://github.com/VundleVim/Vundle.vim)**
```vim
Plugin 'mendy/travis-notes.vim'
```

**[Pathogen](https://github.com/tpope/vim-pathogen)**
```bash
git clone https://github.com/mendy/travis-notes.vim.git ~/.vim/bundle/travis-notes.vim
```

### Manual Installation

```bash
# Clone the repository
git clone https://github.com/mendy/travis-notes.vim.git

# Create plugin directory if it doesn't exist
mkdir -p ~/.vim/plugin

# Copy the plugin
cp travis-notes.vim/plugin/travis-notes.vim ~/.vim/plugin/
```

## ✨ Features

### 📑 Smart Templates

#### Build Notes Template
```markdown
# Travis Build: {title}
Build Date: {date}
Tags: travis, ci, build

## Build Information
- Repository: 
- Branch: 
- Build Number: 
- Status: 
```

#### Debug Notes Template
```markdown
# Travis Debug: {title}
Debug Date: {date}
Tags: travis, ci, debug

## Issue Description
## Environment
## Steps to Reproduce
## Solution
```

### ⌨️ Commands

| Command | Description | Example |
|---------|-------------|---------|
| `:TravisBuildNote <name>` | Create build note | `:TravisBuildNote feature-auth` |
| `:TravisDebugNote <name>` | Create debug note | `:TravisDebugNote login-fail` |
| `:TravisNotes` | List all notes | `:TravisNotes` |
| `:TravisFailures` | Show failed builds | `:TravisFailures` |

### 🎯 Key Mappings

Quick access mappings in Travis note buffers:

| Key | Action | Context |
|-----|--------|---------|
| `<leader>tb` | Fetch build details | Build note |
| `<leader>tl` | Fetch build logs | Any note |
| `<leader>tc` | Get Travis config | Build note |
| `<leader>ts` | Update build status | Build note |

## 🛠️ Configuration

### Basic Configuration
```vim
" Directory for notes
let g:notes_directory = '~/.vim-notes'

" File extension for notes
let g:notes_extension = '.md'
```

### Template Customization
```vim
" Custom build template
let g:notes_travis_build_template = [
    \ '# Travis Build: {title}',
    \ 'Build Date: {date}',
    \ 'Tags: travis, ci, build',
    \ '',
    \ '## Build Information'
]

" Custom debug template
let g:notes_travis_debug_template = [
    \ '# Travis Debug: {title}',
    \ 'Debug Date: {date}',
    \ 'Tags: travis, ci, debug',
    \ '',
    \ '## Issue Description'
]
```

## 📖 Usage

### Quick Start Guide

1. Create a new build note:
   ```vim
   :TravisBuildNote my-feature
   ```

2. List all Travis-related notes:
   ```vim
   :TravisNotes
   ```

3. Find failed builds:
   ```vim
   :TravisFailures
   ```

### Best Practices

- Create a note for each significant build failure
- Use consistent naming conventions for notes
- Tag notes appropriately for better organization
- Link related notes using wiki-style links

## 🔄 Upcoming Features

- [ ] Travis CI API Integration
  - Authentication handling
  - Real-time build status updates
  - Direct log fetching
- [ ] Advanced Search Capabilities
- [ ] Build Statistics Dashboard
- [ ] Multi-Repository Support

## 🤝 Contributing

Contributions make the open source community thrive. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.

## ✍️ Author

**Michael Mendy**  
*Software Engineer at Idera Inc & Travis CI, GmbH*

Created: December 20th, 2024

---

<div align="center">
Made with ❤️ for the Vim community
</div>
