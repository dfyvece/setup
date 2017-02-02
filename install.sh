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

echo "[+] Completed setup"
