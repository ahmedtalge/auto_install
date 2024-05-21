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
    "md.obsidian.Obsidian"
    "com.todoist.Todoist"
    "io.github.brunofin.Cohesion"
    "io.github.mimbrero.WhatsAppDesktop"
    "org.telegram.desktop"
    "org.telegram.desktop.webview"
    "com.github.unrud.VideoDownloader"
    "org.qbittorrent.qBittorrent"
    "io.github.giantpinkrobots.varia"
    "org.flameshot.Flameshot"
    "org.kde.okular"
    "org.keepassxc.KeePassXC"
    "org.libreoffice.LibreOffice"
    "org.localsend.localsend_app"
    "com.spotify.Client"
    "org.gimp.GIMP"
    "org.inkscape.Inkscape"
    "com.github.vikdevelop.photopea_app"
    "org.upscayl.Upscayl"
    "org.videolan.VLC"
    "org.prismlauncher.PrismLauncher"
    "io.github.flattool.Warehouse"
    "com.github.tchx84.Flatseal"
    "io.github.giantpinkrobots.flatsweep"
    " io.github.prateekmedia.appimagepool"
)

for flatpak in "${flatpaks[@]}"; do
  sudo flatpak install -y flathub "$flatpak"
done

# Instalar programas essenciais
essentials=(
    "mint-meta-codecs"
    "curl"
    "git"
    "htop"
    "vim"
    "build-essential"
    "ubuntu-restricted-extras"
    "ttf-mscorefonts-installer"
    "q4wine"
)

sudo apt-get update
sudo apt-get install -y "${essentials[@]}"

# Instalação do Wine Staging
sudo dpkg --add-architecture i386
wget -nc https://dl.winehq.org/wine-builds/winehq.key -O- | sudo apt-key add -
sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ jammy main'
sudo apt-get update
sudo apt-get install -y --install-recommends winehq-staging

# Limpeza do sistema
sudo apt-get autoremove -y
sudo apt-get clean

# Excluir arquivos .deb
rm -rf ~/DEB

echo "Instalação e limpeza concluídas!"
