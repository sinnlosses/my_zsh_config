# 注意事項
# brew がインストールされていることが前提
# 必要なソフトウェアがインストールされていない場合 brew 経由でインストールします

# 日本語設定
export LANG=ja_JP.UTF-8

# 色の使用
autoload -Uz colors
colors

# プロンプトカスタマイズ
PROMPT="${fg[green]}[${USER}@${HOST%%.*} %1~]${reset_color}\$ "

# emacs 風キーバインドにする
bindkey -e

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# オプション
# ヒストリ拡張
setopt extended_history
alias history='history -t "%F %T"'
# 日本語ファイル名を表示可能にする
setopt print_eight_bit
# '#' 以降をコメントとして扱う
setopt interactive_comments
# beep を無効にする
setopt no_beep
# 同時に起動したzshの間でヒストリを共有する
setopt share_history
# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# インストールするソフトウェアのインストールチェックとインストール
software_list=("ghq" "peco" "nodebrew" "zsh-completions" "zsh-syntax-highlighting" "zsh-autosuggestions")
brew_list=($(brew list))
for software in "${software_list[@]}"; do
    if ! printf '%s\n' "${brew_list[@]}" | grep -x $software &> /dev/null; then
        echo "$software not found. installing..."
        brew install "$software"
    fi
done

# 補完
FPATH=$HOMEBREW_PREFIX/share/zsh-completions:$FPATH
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# zsh プラグイン
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ghq のリポジトリに対する peco 設定
function peco-ghq () {
    local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
    fi
    zle clear-screen
}
zle -N peco-ghq
# peco の起動コマンド
bindkey '^]' peco-ghq

# path 設定
export PATH=$HOME/.nodebrew/current/bin:$PATH
