#!/usr/bin/env bash
# Some parts from http://kappataumu.com/articles/vagrant-jekyll-github-pages-streamlined-content-creation.html

start_seconds="$(date +%s)"
echo "Initializing dev environment on VM."

apt_packages=(
    vim
    curl
    wget
    git-core
    xorg
    nodejs
    zip # to unzip netlify-git-api binary
)

ping_result="$(ping -c 2 8.8.4.4 2>&1)"
if [[ $ping_result != *bytes?from* ]]; then
    echo "Network connection unavailable. Try again later."
    exit 1
fi

# Needed for nodejs.
# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
curl -sSL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo add-apt-repository -y ppa:git-core/ppa

echo ---Updating packages---
sudo apt-get update
sudo apt-get upgrade -y

echo ---Installing apt-get packages---
echo "Installing apt-get packages..."
sudo apt-get install -y ${apt_packages[@]}
sudo apt-get clean

echo ---Telling git to use CRLF for line endings \(Ahem, windows\!\)---
sudo git config --global core.autocrlf true

echo ---Installing RVM---
# http://rvm.io/rvm/install
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable --ruby --quiet-curl
source ~/.rvm/scripts/rvm
#source /home/vagrant/.rvm/scripts/rvm

echo ---Installing Jekyll---
gem install jekyll bundler --no-ri --no-rdoc

# echo ---Installing netlify-git-api binary---
# mkdir ~/tmp
# wget -P ~/tmp/ https://github.com/netlify/netlify-git-api/releases/download/0.0.3/linux.zip
# unzip -d ~/tmp/ ~/tmp/linux.zip
# sudo cp ~/tmp/linux/netlify-git-api /usr/bin/
# sudo chmod +x /usr/bin/netlify-git-api
# rm -rf ~/tmp

echo ---Installing bower for dependency management---
sudo npm install -g bower
