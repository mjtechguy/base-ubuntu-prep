#!/bin/bash 

set -e

G="\e[32m"
E="\e[0m"

if ! grep -q 'Ubuntu' /etc/issue
  then
    echo -----------------------------------------------
    echo "Not Ubuntu? Could not find Codename Ubuntu in lsb_release -a. Please switch to Ubuntu."
    echo -----------------------------------------------
    exit 1
fi

# Update OS
echo -e ${G}"Installing OS Updates..."${E}
sudo apt-get update > /dev/null 2>&1
sudo apt upgrade -y > /dev/null 2>&1

## Install prereq packages
echo -e ${G}"Installing packages..."${E}
sudo apt-get install ca-certificates curl gnupg lsb-release unzip haveged zsh -y > /dev/null 2>&1

## Install Docker
echo -e ${G}"Installing Docker..."${E}
sudo mkdir -p /etc/apt/keyrings  > /dev/null 2>&1
sudo rm -f -- /etc/apt/keyrings/docker.gpg  > /dev/null 2>&1
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg  > /dev/null 2>&1
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update  > /dev/null 2>&1
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y  > /dev/null 2>&1
sudo usermod -aG docker $USER  > /dev/null 2>&1

## Install Terraform
echo -e ${G}"Installing Terraform..."${E}
sudo apt-get update  > /dev/null 2>&1
sudo apt-get install -y gnupg software-properties-common curl  > /dev/null 2>&1
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -  > /dev/null 2>&1
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"  > /dev/null 2>&1
sudo apt-get update > /dev/null 2>&1
sudo apt-get install terraform  > /dev/null 2>&1

## Install Ansible
echo -e ${G}"Installing Ansible..."${E}
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py  > /dev/null 2>&1
python3 get-pip.py --user  > /dev/null 2>&1
python3 -m pip install --user ansible  > /dev/null 2>&1
echo 'PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc  > /dev/null 2>&1

## Install Kubectl
echo -e ${G}"Installing Kubectl..."${E}
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"  > /dev/null 2>&1
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl  > /dev/null 2>&1

## Make ZSH Default Shell
echo -e ${G}"Making ZSH the default shell..."${E}
sudo chsh -s /bin/zsh $USER  > /dev/null 2>&1

## Install oh-my-zsh
echo -e ${G}"Installing oh-my-zsh..."${E}
DIR1=~/.oh-my-zsh
if [ -d "$DIR1" ]; then
    echo -e ${G} "$DIR1 exists. No need to install oh-my-zsh again."${E}
else 
    echo -e ${G} "$DIR1 does not exist. Installing oh-my-zsh."${E}
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended  > /dev/null 2>&1
fi

## Install ZSH things
echo -e ${G}"Installing ZSH things..."${E}
DIR2=~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
if [ -d "$DIR2" ]; then
    echo -e ${G} "$DIR2 exists. No need to install plugins again."${E}
else
    echo -e ${G} "$DIR2 does not exist. Installing plugins."${E}
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting  > /dev/null 2>&1
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions  > /dev/null 2>&1
fi

## Copy files
echo -e ${G}"Copying dotfiles..."${E}
cp .aliases ~/.aliases  > /dev/null 2>&1
cp .zshrc ~/.zshrc  > /dev/null 2>&1

## Install complete
echo -e ${G}"Install complete...."${E}
echo -e ${G}"Some possible next steps:"${E}
echo -e " - Install a new theme on Oh-My-ZSH like PowerLevel10k: https://github.com/romkatv/powerlevel10k"
echo -e " - Install additional ZSH plugins: https://github.com/unixorn/awesome-zsh-plugins"
echo -e " - Update the ~/.aliases file with your own aliases"
echo -e ${G}"Install complete. Have a great day!!"${E}
cd ~
zsh



