# bashbox
bash/shell/CLI toolkit

## Installation
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/xkortex/bashbox/master/uber-setup.sh)"
```


## Goals
The purpose of this library is to facilitate liquid - moving seamlessly between
systems/containers and having a consistent experience across hosts. This involves:
- Tools (shell, aliases, scripts)
- Certain environment variables
- History persistence

## uber-setup
Install all the tools that I like. 
- shell aliases
- install zsh
- install zsh plugins (histdb, autosuggestions, docker)
- configure zshrc
- configure history & archiving

## exo-history
A virtual exo-cortex - brain dump of ALL commands ever executed 
(sans sensitive ones). 

## Path information dependency graph
(variable default blurb) <- xdg
xdg <- bashbox-paths
xdg <- .zshenv
bashbox-paths <- aliases
bashbox-paths <- .zshrc
