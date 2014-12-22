# https://gist.github.com/mollifier/4964803

# 補完機能を有効にする
autoload -Uz compinit
compinit

# 色を使用出来るようにする
autoload -Uz colors
colors 

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

# ディレクトリ名を入力するだけで移動
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd

# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# コマンド訂正
setopt correct 

# 補完候補を詰めて表示する
setopt list_packed 

# 補完候補表示時などにピッピとビープ音をならないように設定
setopt nolistbeep

# その他とりあえずいるもの
export LANG=ja_JP.UTF-8
 
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# http://blog.hekt.org/archives/5085
alias sudo='sudo '
 
# vim
alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'

# gvim
alias gvim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/mvim "$@"'

# rvm
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/bin:$PATH"

# golang
export GOPATH=~/go
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:/usr/local/Cellar/go/1.4/libexec/bin"

typeset -U name_of_the_variable
