#
# ------------- Your existing shell code here --------------
#

### COLORIZE TERMINAL AND GIT ############################################
function parse_git_branch_and_add_brackets {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ (\1\)/'
}

function branch_color {
    local git_status="`git status -unormal 2>&1`"
    if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
        if [[ "$git_status" =~ nothing\ to\ commit ]]; then
            local fontColor=32 # GREEN
        elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
            local fontColor=31 # RED
        else
            local fontColor=33 # YELLOW, files modified etc..
        fi
        if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
            branch=${BASH_REMATCH[1]}
            #test "$branch" != master || branch=' '
        else
            # Detached HEAD.  (branch=HEAD is a faster alternative.)
            branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null ||
            echo HEAD`)"
        fi
        echo -n $fontColor
    fi
}
export PS1="\[\033[30m\]\u@\h\[\033[00m\]:\[\033[m\]\w\[\033[00m\]\[\033[0;\$(branch_color)m\]\$(parse_git_branch_and_add_brackets)\[\033[00m\]$ "
