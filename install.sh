#!/bin/bash

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

# Get correct permissions
sudo echo "test" >/dev/null || exit

print_info "Installing dependencies"
sudo apt-get install git python-pip python-dev build-essential -y >/dev/null 2>&1 || exit
update_info

print_info "Installing vim+tmux"
sudo apt-get install vim tmux -y >/dev/null 2>&1 || exit
update_info

print_info "Installing pexpect"
sudo pip install pexpect >/dev/null 2>&1 || exit
update_info

echo "[*] Checking for Vundle"
if [ -d ~/.vim/bundle/Vundle.vim ]; then
    echo "[*] Vundle already installed"
else
    print_info "Installing Vundle"
    mkdir -p ~/.vim/bundle/
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim || exit
    update_info
fi

print_info "Installing Vundle Packages"
py=$(mktemp)
cat << _EOF_ > $py
#!/usr/bin/env python
import pexpect
vim = pexpect.spawn("vim")
vim.send(":VundleInstall\n")
vim.expect("Done!")
vim.send(":qa!\n")
vim.terminate()
_EOF_
chmod +x $py
$py || exit
rm $py
update_info

read -p "Install YouCompleteMe? [y/n] " -n 1 resp
echo
if [[ $resp == "y" ]]; then
    print_info "Installing YouCompleteMe"
    sudo apt-get install nodejs nodejs-legacy npm -y >/dev/null 2>&1 || exit
    CURR=$(pwd)
    cd ~/.vim/bundle/YouCompleteMe
    ./install.py --clang-completer --tern-completer >/dev/null 2>&1 || exit
    cd "$CURR"
    update_info
fi

echo "[*] Checking for Tmux Plugin Manager"
if [ -d ~/.tmux/plugins ]; then
    echo "[*] TPM already installed"
else
    print_info "Installing Tmux Plugin Manager"
    mkdir -p ~/.tmux/plugins
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || exit
    update_info
fi

print_info "Installing TPM Packages"
~/.tmux/plugins/tpm/scripts/install_plugins.sh >/dev/null 2>&1 || exit
update_info


echo "[+] Completed setup"
