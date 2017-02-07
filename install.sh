#!/bin/bash

log_file=$(mktemp)

backspace() {
    for i in $(seq 1 $1); do
        echo -n -e "\b"
    done
}

print_info() {
    str="$1"
    echo -n "[-] $str"
    obj="$str"
}

update_info() {
    str="$obj"
    len=$(echo -n "$str" | wc -c)
    backspace $(expr $len + 3)
    echo "+] $str"
}

something_went_wrong() {
    echo
    echo "Something went wrong! Check log file for details: $log_file"
    read -p "Press any key to view log file or 'q' to exit" -n 1 resp
    if [[ $resp != "q" ]]; then
        less $log_file
    fi
    echo
    exit
}

# Get correct permissions
sudo echo "test" >/dev/null || something_went_wrong

print_info "Installing dependencies"
sudo apt-get install git gdb python-pip python-dev build-essential -y >>$log_file 2>&1 || something_went_wrong
update_info

print_info "Installing vim+tmux"
sudo apt-get install vim tmux -y >>$log_file 2>&1 || something_went_wrong
update_info

print_info "Installing pexpect"
sudo pip install pexpect >>$log_file 2>&1 || something_went_wrong
update_info

echo "[*] Checking for Vundle"
if [ -d ~/.vim/bundle/Vundle.vim ]; then
    echo "[*] Vundle already installed"
else
    print_info "Installing Vundle"
    mkdir -p ~/.vim/bundle/
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim >>$log_file 2>&1 || something_went_wrong
    update_info
fi

print_info "Installing Vundle Packages"
py=$(mktemp)
cat << _EOF_ > $py
#!/usr/bin/env python
import pexpect
vim = pexpect.spawn("vim")
vim.send(":VundleInstall\n")
vim.expect("Done!", timeout=-1)
vim.send(":qa!\n")
vim.terminate()
_EOF_
chmod +x $py
$py >>$log_file 2>&1 || something_went_wrong
rm $py
update_info

read -p "Install YouCompleteMe? [y/n] " -n 1 resp
echo
if [[ $resp == "y" ]]; then
    print_info "Installing YouCompleteMe"
    sudo apt-get install nodejs nodejs-legacy npm -y >>$log_file 2>&1 || something_went_wrong
    CURR=$(pwd)
    cd ~/.vim/bundle/YouCompleteMe
    ./install.py --clang-completer --tern-completer >>$log_file 2>&1 || something_went_wrong
    cd "$CURR"
    update_info
fi

echo "[*] Checking for Tmux Plugin Manager"
if [ -d ~/.tmux/plugins ]; then
    echo "[*] TPM already installed"
else
    print_info "Installing Tmux Plugin Manager"
    mkdir -p ~/.tmux/plugins
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm >>$log_file 2>&1 || something_went_wrong
    update_info
fi

print_info "Installing TPM Packages"
~/.tmux/plugins/tpm/scripts/install_plugins.sh >>$log_file 2>&1 || something_went_wrong
update_info

rm $log_file
echo "[+] Completed setup"
