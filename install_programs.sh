#!/bin/bash

# Criação da pasta para os arquivos .deb
mkdir -p ~/DEB
cd ~/DEB

# URLs dos arquivos .deb
urls=(
  "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
  "https://steamcdn-a.akamaihd.net/client/installer/steam.deb"
  "https://github.com/Ulauncher/Ulauncher/releases/download/5.14.2/ulauncher_5.14.2_all.deb"
  "https://discord.com/api/download?platform=linux&format=deb"
  "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v2.6.2/heroic_2.6.2_amd64.deb"
)

# Baixar arquivos .deb
for url in "${urls[@]}"; do
  wget -O "$(basename $url)" "$url"
done

# Instalar arquivos .deb
sudo dpkg -i *.deb

# Corrigir dependências faltantes
sudo apt-get install -f -y

# Instalar Flatpak se não estiver instalado
if ! command -v flatpak &> /dev/null
then
  sudo apt-get install -y flatpak
fi

# Adicionar repositório Flathub
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Instalar programas via Flatpak
flatpaks=(
  "org.flameshot.Flameshot"
  "io.github.jackulu.localsend_app"
  "com.github.unrud.VideoDownloader"
  "org.keepassxc.KeePassXC"
)

for flatpak in "${flatpaks[@]}"; do
  sudo flatpak install -y flathub "$flatpak"
done

# Instalar programas essenciais
essentials=(
  "curl"
  "git"
  "vim"
  "gnome-tweaks"
  "build-essential"
  "ubuntu-restricted-extras"
)

sudo apt-get update
sudo apt-get install -y "${essentials[@]}"

# Limpeza do sistema
sudo apt-get autoremove -y
sudo apt-get clean

# Excluir arquivos .deb
rm -rf ~/DEB

echo "Instalação e limpeza concluídas!"
