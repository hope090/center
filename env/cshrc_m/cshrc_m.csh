
#GROUP DIR /datatop/xhg0039a/local/linux64/gcc/
#echo "========================================"
#echo "*************Hello JasonTan*************"
#echo "========================================"
bindkey '\e[1~' beginning-of-line      # Home
bindkey '\e[3~' delete-char            # Delete
bindkey '\e[4~' end-of-line            # End
bindkey "^W" backward-delete-word      # Delete
bindkey -k up history-search-backward  # PageUp
bindkey -k down history-search-forward # PageDown

setenv LANG en_US.UTF-8

set cc = "%{\e[36m%}" #cyan
set cr = "%{\e[31m%}" #red
set cg = "%{\e[32m%}" #green
set c0 = "%{\e[0m%}"  #default

# Set some variables for interactive shells
if ( $?prompt ) then
    if ( "$uid" == "0" ) then
	set prompt = "$cc%B[%@]%b %B%U%n%u@%m.$cr%l$c0%b %c2 %B%#%b " 
    else if ( `uname` == "SunOS" ) then
	set prompt = "$cc%B[%@]%b %B%U%n%u@%m.$cr%l$c0%b %c2 %B%%%b "
    else if (`cat /etc/redhat-release | grep release\ 4 | wc -l`) then
	set prompt = "$cc%B[%@]%b %B%U%n%u@%m.$cg%l$c0%b %c2 %B%%%b "
    else
	set prompt = "$cc%B[%@]%b %B%U%n%u@%m.$cc%l$c0%b %c2 %B%%%b "
    endif
endif
#ls color on
setenv LSCOLORS ExGxFxdxCxegedabagExEx
setenv CLICOLOR yes
#grep match color on 
setenv GREP_OPTIONS --color=auto
#tab 
set autolist
#history
set autoexpand
set history = 100
set savehist = 10

set correct = cmd
#set noclobber

#svn alias
alias   svn_up  'setenv LANG ja_JP.UTF-8 ; svn up ; setenv LANG C'
alias   up_env  '$scr/test_case/gen_test_case.rb ../../../../../../test_case/excel/test_case_random.txt'
#job machine alias
alias	bli	'bsub -q re5i -Is'
alias   bs	'bsub -q sparc -Is'
alias	bl5	'bsub -q re5x07 -Is'
alias   blm	'bsub -q re5x07lm -Is'

alias	blx	'bsub -q re5i -Is -XF'
alias   blmx	'bsub -q re5x07lm -Is -XF'

#alias   pushd   'pushd \!*; chdir `pwd`; dirs'
alias   pushd   'pushd \!* > /dev/null; pwd; ls'
alias   popd   'popd \!* > /dev/null; pwd; ls'

if( `uname` == "SunOS" ) then
	alias   ls      'ls -F'
else
	alias   ls      'ls -F --color=tty'
endif

#alias   use4    'source ~/.cshrc_m/.cshrc.forte421'
#alias   use5    'source ~/.cshrc_m/.cshrc.forte'
#alias   uset    'source ~/.cshrc_m/.cshrc.forte_for_training'
alias	cd	'set old=$cwd; chdir \!*;pwd;ls'
alias	cdla	'set old=$cwd; chdir \!*;pwd;ls -a'
alias	back	'set back=$old; set old=$cwd; cd $back; unset back'
alias   emacs   'env LANG=japanese emacs'
alias   mule	'emacs'
alias   less    'less --RAW-CONTROL-CHARS -X'
alias	cmake	'bls make \!* |& logfilt'
#alias   svn     '/opt/nsug/subversion/1.5/bin/svn'
alias   pdf     'evince'

alias -	    'cd -'        #back to the up flood
alias ..    'cd ..'       #back to the top flood
alias q	    'exit'        
alias rm    'rm -i'       
alias del   'rm -r'       
alias mv    'mv -i'       
#alias cp   'cp -ia'    
alias la    'ls -a'      
alias ll    'ls -h -l'   
alias lr    'ls -R'     
alias dh    'df -h -a -T'
alias md    'mkdir'
alias ds    'du -sh'    
alias de    'du -ch'      #show the area for every files
alias d1    'du --max-depth=1 -h'  #show one level
alias vvim 'gvim `whereis \!* | cut -d: -f2` '
alias setjp 'setenv LANG ja_JP.UTF-8'
alias seten 'setenv LANG C'

alias title 'source ~/.cshrc_m/set_title.csh'

setenv SVN_EDITOR /usr/bin/gvim

alias ec    'v ~/.cshrc_m/.cshrc.m'
alias ev    'v ~/.vim_local/.vimrc'
alias find-c	'find . -name "*.h" -o -name "*.c"'
alias find-x	'find . -name "*.h" -o -name "*.hpp" -o -name "*.cpp" -o -name "*.cxx"'
alias find-py	'find . -name "*.py"'
alias wc-c	'find . -name "*.h" -o -name "*.c" | xargs wc | sort -k 4'
alias wc-x	'find . -name "*.h" -o -name "*.hpp" -o -name "*.cpp" -o -name "*.cxx" | xargs wc | sort -k 4'
alias wc-py	'find . -name ".py" | xargs wc | sort -k 4'

alias gv        "gvim" #gvim
alias v         "vim" #gvim
alias wave      'blx simvision wave.trn'
