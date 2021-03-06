
export PATH="$PATH":~/bin


alias ls='ls -GFh'
alias gs='git status'
alias bp="vim ~/.bash_profile"
alias bp-show="less ~/.bash_profile"
alias bp-src="source ~/.bash_profile"

alias asd="git add .; git commit -m"asd"; git rebase -i"

export PS1="\n\033[33m\](\d) \033[35m\][\w]\n\[\033[36m\]\u\[\033[m\] @ \[\033[32m\]mac\033[m\]: $ "
#\[\033[33;1m\]\W\export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
function cd {
    builtin cd "$@" && ls
        }

function find-ext {
  find . -print | grep -i '.*[.]"$@"'
}

function ls {
    /bin/ls -GFha "$@"
}



function cdn() {
  cd $(printf "%0.s../" $(seq 1 $1 ));
}


}

function git-multipush() {
  for var in "$@"
  do
    cd $var; git pull; git push; cd ..
  done
}

if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi
