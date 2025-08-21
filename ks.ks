# Fedora KDE Gaming-Optimized Kickstart
# Target: Fedora 42 (KDE-only, OEM-style first boot)
# Features: KDE Plasma 6, Snapper (Btrfs), NVIDIA auto-detect, RPM Fusion, Plymouth, gaming stack
# Use with: Fedora Everything NetInstall or Server ISO (NOT Live ISO)

# --- Locale, keyboard, time ---
lang en_US.UTF-8
keyboard --vckeymap=us --xlayouts='us'
timezone America/New_York --utc

# --- Installer mode ---
graphical

# --- Networking ---
network --bootproto=dhcp --device=link --activate

# --- Mirrors / repos used by Anaconda ---
url --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch

# --- OEM first-boot experience ---
firstboot --reconfig
# Ensure Initial Setup runs BEFORE any display manager; defer SDDM until after Initial Setup
services --enabled=initial-setup,initial-setup-graphical --disabled=sddm

# Lock root (user will be created by Initial Setup)
rootpw --lock

# --- Bootloader ---
# UEFI system assumed (we create /boot/efi). Keep quiet/splash and clean boot.
bootloader --append="quiet splash loglevel=3 rd.udev.log_level=3 vt.global_cursor_default=0 systemd.show_status=false rd.systemd.show_status=false"

# --- Disk layout (WARNING: wipes sda) ---
clearpart --all --initlabel --drives=sda

part /boot/efi --fstype="efi"  --size=512  --ondisk=sda
part /boot     --fstype="ext4" --size=2048 --ondisk=sda
part btrfs.01  --fstype="btrfs" --size=1 --grow --ondisk=sda

btrfs none --label=fedora --data=single btrfs.01
btrfs /           --subvol --name=@           LABEL=fedora
btrfs /home       --subvol --name=@home       LABEL=fedora
btrfs /var        --subvol --name=@var        LABEL=fedora
btrfs /.snapshots --subvol --name=@snapshots  LABEL=fedora

# --- License ---
eula --agreed

# --- Extra repos for install time ---
repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f$releasever&arch=$basearch
repo --name=rpmfusion-free --install --mirrorlist=https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-$releasever&arch=$basearch
repo --name=rpmfusion-free-updates --install --mirrorlist=https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree --install --mirrorlist=https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree-updates --install --mirrorlist=https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-$releasever&arch=$basearch

# ============================
# Packages
# ============================
%packages --excludedocs
# Core System
@core
@base-x
@fonts
@standard
@hardware-support
@networkmanager-submodules

# KDE Plasma Desktop (Plasma 6)
@kde-desktop
kde-settings
kde-settings-pulseaudio
kde-settings-plasma
sddm
sddm-themes
sddm-kcm
plasma-desktop
plasma-workspace
plasma-wayland-protocols
plasma-systemmonitor
plasma-pa
plasma-nm
plasma-thunderbolt
plasma-systemsettings
plasma-browser-integration
plasma-discover
plasma-discover-packagekit
plasma-discover-flatpak
plasma-disks
plasma-firewall
dolphin
dolphin-plugins
konsole
kate
ark
spectacle
gwenview
okular
kcalc
kwalletmanager
kscreen
kinfocenter
krdp

# KDE Apps & tools
yakuake
krfb
krdc
ksystemlog
filelight
kdf
kcharselect
kdialog

# Initial Setup (GUI)
initial-setup
initial-setup-gui

# Plymouth (boot animation)
plymouth
plymouth-theme-breeze
plymouth-theme-spinner
plymouth-plugin-script
plymouth-plugin-fade-throbber
plymouth-scripts
plymouth-system-theme
kernel-core

# GRUB tools & Btrfs integration
grub2-tools-extra
grub2-tools-efi
# grub-btrfs installed in %post (from RPM Fusion if available)

# Btrfs & Snapper
btrfs-progs
snapper
libdnf5-plugin-actions
inotify-tools

# Gaming Core
gamemode
gamescope
mangohud
goverlay
steam
lutris
wine
wine-dxvk
wine-dxvk-dxgi
winetricks
protontricks
bottles

# Vulkan & Graphics
vulkan-tools
vulkan-loader
vulkan-headers
vulkan-validation-layers
vkbasalt
mesa-vulkan-drivers
mesa-vdpau-drivers
mesa-va-drivers
libva-utils
vdpauinfo

# 32-bit libs (Steam & legacy games)
glibc.i686
glibc-devel.i686
libgcc.i686
libstdc++.i686
mesa-libGL.i686
mesa-libGLU.i686
mesa-dri-drivers.i686
mesa-vulkan-drivers.i686
vulkan-loader.i686
libXcomposite.i686
libXcursor.i686
libXi.i686
libXinerama.i686
libXrandr.i686
libXrender.i686
libXxf86vm.i686
alsa-lib.i686
openal-soft.i686
pulseaudio-libs.i686
libva.i686
libvdpau.i686
libgcrypt.i686
gtk2.i686
gtk3.i686
libjpeg-turbo.i686
libpng.i686
ocl-icd.i686
SDL2.i686
SDL2_image.i686
SDL2_mixer.i686
SDL2_ttf.i686
unixODBC.i686
samba-libs.i686
gnutls.i686

# Performance & System Tools
corectrl
earlyoom
zram-generator
irqbalance
tuned
tuned-utils
htop
btop
nvtop
inxi

# Multimedia / Codecs
ffmpeg
ffmpeg-libs
gstreamer1-plugins-base
gstreamer1-plugins-good
gstreamer1-plugins-good-extras
gstreamer1-plugins-bad-free
gstreamer1-plugins-bad-free-extras
gstreamer1-plugins-ugly-free
gstreamer1-libav
gstreamer1-vaapi
libheif
pipewire
pipewire-alsa
pipewire-jack-audio-connection-kit
pipewire-pulseaudio
pipewire-utils
wireplumber
easyeffects
pavucontrol

# Gamepad & extras
antimicrox

# Flatpak support
flatpak
xdg-desktop-portal
xdg-desktop-portal-kde

# System Utilities
kernel-tools
kernel-devel
kernel-headers
kernel-modules-extra
pciutils
wget
curl
grub2-efi-x64
grub2-efi-x64-modules
shim-x64

# Dev tools (Proton-GE builds & misc)
git
gcc
gcc-c++
make
cmake
meson
ninja-build
patch
autoconf
automake

# Python
python3-pip
python3-setuptools

# Filesystems
ntfs-3g
exfatprogs

# Compression tools
p7zip
p7zip-plugins
unrar
unzip

# Shells & terminals
fish
zsh
alacritty

# Editors
vim
nano
micro

%end

# ============================
# Post-install configuration
# ============================
%post --log=/root/kickstart-post.log
#!/bin/bash
set -euo pipefail

echo "Starting post-installation configuration..."

# --- Ensure Initial Setup runs on first boot ---
echo "Configuring Initial Setup..."
systemctl enable initial-setup.service
systemctl enable initial-setup-graphical.service
touch /etc/reconfigSys
rm -f /etc/sysconfig/initial-setup
rm -f /var/lib/initial-setup/initial-setup-done
cat > /etc/sysconfig/initial-setup << 'EOF'
RUN_INITIAL_SETUP=YES
EOF

# Gate SDDM until after Initial Setup completes, then enable+start it
cat > /etc/systemd/system/oem-after-initial-setup.service << 'EOF'
[Unit]
Description=Enable and start SDDM after Initial Setup completes
After=initial-setup-graphical.service
Requires=initial-setup-graphical.service

[Service]
Type=oneshot
ExecStart=/usr/bin/systemctl enable sddm.service
ExecStart=/usr/bin/systemctl --no-block start sddm.service

[Install]
WantedBy=graphical.target
EOF
systemctl enable oem-after-initial-setup.service

# --- NVIDIA auto-detect and driver install ---
echo "Checking for NVIDIA GPU..."
if lspci | grep -qi nvidia; then
  echo "NVIDIA GPU detected. Installing drivers..."
  dnf install -y akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686
  dnf install -y nvidia-vaapi-driver nvidia-settings
  dnf install -y xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-cuda-libs
  dnf install -y nvidia-gpu-firmware || true
  cat > /etc/modprobe.d/nvidia.conf << 'EOF'
options nvidia-drm modeset=1
options nvidia NVreg_UsePageAttributeTable=1
options nvidia NVreg_EnablePCIeGen3=1
EOF
  systemctl enable nvidia-hibernate.service || true
  systemctl enable nvidia-suspend.service || true
  systemctl enable nvidia-resume.service || true
else
  echo "No NVIDIA GPU detected. Skipping NVIDIA driver installation."
fi

# --- RPM Fusion enable (runtime safety) ---
FEDORA_VERSION=$(rpm -E %fedora)
dnf install -y \
  "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm" \
  "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm" || {
    echo "RPM Fusion release rpms not fetched; trying package names..."
    dnf install -y rpmfusion-free-release rpmfusion-nonfree-release || true
}

# --- Extras from RPM Fusion / fallbacks ---
dnf install -y libdvdcss || echo "libdvdcss not available"
dnf install -y grub-btrfs || echo "grub-btrfs not available"
dnf install -y heroic-games-launcher || {
  echo "heroic-games-launcher not in repos, installing Flatpak..."
  flatpak install -y flathub com.heroicgameslauncher.hgl
}
dnf install -y joystickwake || echo "joystickwake not available"
dnf install -y neofetch || dnf install -y fastfetch || echo "fetch tool not available"
dnf install -y kde-partitionmanager || dnf install -y partitionmanager || true

# --- Configure Snapper (root + home) ---
sleep 3
if [ -d /.snapshots ]; then
  snapper -c root create-config / || echo "Snapper root config may already exist"
else
  echo "/.snapshots missing; skipping root config"
fi
if [ -d /home ]; then
  snapper -c home create-config /home || echo "Snapper home config may already exist"
fi

cat > /etc/snapper/configs/root << 'EOF'
SUBVOLUME="/"
FSTYPE="btrfs"
ALLOW_USERS=""
ALLOW_GROUPS=""
TIMELINE_CREATE="yes"
TIMELINE_CLEANUP="yes"
TIMELINE_LIMIT_HOURLY="5"
TIMELINE_LIMIT_DAILY="7"
TIMELINE_LIMIT_WEEKLY="4"
TIMELINE_LIMIT_MONTHLY="6"
TIMELINE_LIMIT_YEARLY="2"
TIMELINE_MIN_AGE="1800"
EMPTY_PRE_POST_CLEANUP="yes"
EMPTY_PRE_POST_MIN_AGE="1800"
NUMBER_CLEANUP="yes"
NUMBER_MIN_AGE="1800"
NUMBER_LIMIT="50"
NUMBER_LIMIT_IMPORTANT="10"
EOF

cat > /etc/snapper/configs/home << 'EOF'
SUBVOLUME="/home"
FSTYPE="btrfs"
ALLOW_USERS=""
ALLOW_GROUPS=""
TIMELINE_CREATE="yes"
TIMELINE_CLEANUP="yes"
TIMELINE_LIMIT_HOURLY="3"
TIMELINE_LIMIT_DAILY="3"
TIMELINE_LIMIT_WEEKLY="2"
TIMELINE_LIMIT_MONTHLY="2"
TIMELINE_LIMIT_YEARLY="1"
TIMELINE_MIN_AGE="1800"
EMPTY_PRE_POST_CLEANUP="yes"
EMPTY_PRE_POST_MIN_AGE="1800"
NUMBER_CLEANUP="yes"
NUMBER_MIN_AGE="1800"
NUMBER_LIMIT="30"
NUMBER_LIMIT_IMPORTANT="10"
EOF

systemctl enable snapper-timeline.timer
systemctl enable snapper-cleanup.timer
systemctl enable snapper-boot.timer

# --- Hook Snapper into DNF5 transactions ---
mkdir -p /etc/dnf/actions.d
cat > /etc/dnf/actions.d/snapper.actions << 'EOF'
pre_transaction  = /usr/bin/snapper -c root create -t pre  -d "DNF5 pre-transaction"
post_transaction = /usr/bin/snapper -c root create -t post -d "DNF5 post-transaction"
EOF

# --- grub-btrfs config ---
cat > /etc/default/grub-btrfs/config << 'EOF'
GRUB_BTRFS_SHOW_SNAPSHOTS_FOUND="true"
GRUB_BTRFS_SHOW_SNAPSHOTS_FOUND_TITLE="Fedora Linux Snapshots"
GRUB_BTRFS_TITLE_FORMAT="(%s) %y-%m-%d %H:%M:%S %r"
GRUB_BTRFS_LIMIT="10"
GRUB_BTRFS_SUBVOLUME_SORT="descending"
GRUB_BTRFS_SHOW_KERNEL_PARAMETERS="true"
GRUB_BTRFS_SNAPSHOT_KERNEL_PARAMETERS=""
GRUB_BTRFS_GRUB_DIRNAME="/boot/grub2"
GRUB_BTRFS_MKCONFIG="/usr/sbin/grub2-mkconfig"
GRUB_BTRFS_SCRIPT_CHECK="grub2-script-check"
EOF
systemctl enable grub-btrfs.path || true

# --- Install and configure Vimix GRUB theme ---
mkdir -p /boot/grub2/themes
cd /tmp
git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes
./install.sh -b -t vimix -s 1080p || true
if [ ! -d /boot/grub2/themes/Vimix ]; then
  mkdir -p /boot/grub2/themes/Vimix
  cp -r themes/Vimix/* /boot/grub2/themes/Vimix/ 2>/dev/null || true
fi

# /etc/default/grub aligned with Fedora (BLS on)
cat > /etc/default/grub << 'EOF'
GRUB_TIMEOUT=5
GRUB_TIMEOUT_STYLE=menu
GRUB_DISTRIBUTOR="Fedora Gaming"
GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true
GRUB_DISABLE_SUBMENU=false
GRUB_TERMINAL_OUTPUT="gfxterm"
GRUB_GFXMODE=1920x1080,1366x768,1024x768,auto
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_DISABLE_OS_PROBER=false
GRUB_ENABLE_BLSCFG=true

GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=3 rd.udev.log_level=3 vt.global_cursor_default=0 systemd.show_status=false rd.systemd.show_status=false"
GRUB_CMDLINE_LINUX="rhgb quiet"

GRUB_THEME="/boot/grub2/themes/Vimix/theme.txt"
GRUB_BACKGROUND="/boot/grub2/themes/Vimix/background.png"
EOF
chmod -R 755 /boot/grub2/themes

# --- Plymouth theme & initramfs ---
plymouth-set-default-theme breeze
dracut --regenerate-all --force

# --- Regenerate GRUB config the Fedora way (BLS-friendly) ---
if [ -d /sys/firmware/efi ]; then
  grub2-mkconfig -o /etc/grub2-efi.cfg
else
  grub2-mkconfig -o /etc/grub2.cfg
fi

# --- Flatpak (Flathub) & apps (Discord via Flatpak for reliability) ---
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.heroicgameslauncher.hgl
flatpak install -y flathub net.davidotek.pupgui2
flatpak install -y flathub com.github.Matoking.protontricks
flatpak install -y flathub io.github.flattool.Warehouse
flatpak install -y flathub org.kde.kdenlive
flatpak install -y flathub org.kde.krita
flatpak install -y flathub com.discordapp.Discord

# --- Proton-GE helper ---
mkdir -p /usr/local/bin
cat > /usr/local/bin/install-proton-ge << 'EOF'
#!/bin/bash
PROTON_GE_URL="https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest"
STEAM_COMPAT_DIR="$HOME/.steam/root/compatibilitytools.d"
echo "Installing latest Proton-GE for $USER..."
mkdir -p "$STEAM_COMPAT_DIR"
LATEST_RELEASE=$(curl -s $PROTON_GE_URL | grep "browser_download_url.*tar.gz" | cut -d '"' -f 4 | head -1)
[ -z "$LATEST_RELEASE" ] && { echo "Could not fetch latest Proton-GE release"; exit 1; }
FILENAME=$(basename "$LATEST_RELEASE")
cd /tmp
wget -q --show-progress "$LATEST_RELEASE"
tar -xzf "$FILENAME" -C "$STEAM_COMPAT_DIR"
rm "$FILENAME"
echo "Proton-GE installed. Restart Steam."
EOF
chmod +x /usr/local/bin/install-proton-ge

# --- Snapshot manager helper (uses correct GRUB targets) ---
cat > /usr/local/bin/snapshot-manager << 'EOF'
#!/bin/bash
set -e
target_cfg="/etc/grub2.cfg"
[ -d /sys/firmware/efi ] && target_cfg="/etc/grub2-efi.cfg"
case "$1" in
  create)
    snapper -c root create -d "${2:-Manual snapshot}" --userdata important=yes || true
    snapper -c home create -d "${2:-Manual snapshot}" --userdata important=yes || true
    grub2-mkconfig -o "$target_cfg" || true
    echo "Snapshot created."
    ;;
  list)
    echo "=== Root snapshots ==="; snapper -c root list || true
    echo; echo "=== Home snapshots ==="; snapper -c home list || true
    ;;
  cleanup)
    snapper -c root cleanup number || true
    snapper -c home cleanup number || true
    grub2-mkconfig -o "$target_cfg" || true
    echo "Cleanup done."
    ;;
  *)
    echo "Usage: snapshot-manager {create|list|cleanup} [description]"
    ;;
esac
EOF
chmod +x /usr/local/bin/snapshot-manager

# --- First-login gaming init (per-user) ---
cat > /etc/profile.d/gaming-first-login.sh << 'EOF'
#!/bin/bash
if [ ! -f ~/.gaming-setup-complete ] && [ -n "$DISPLAY" ]; then
  mkdir -p ~/Games ~/.local/share/applications ~/.config/MangoHud ~/.config/vkBasalt
  cat > ~/.config/MangoHud/MangoHud.conf << 'MHEOF'
toggle_fps_limit=F1
toggle_hud=Shift_R+F12
fps_limit=144,60,0
vsync=0
gpu_stats
gpu_temp
gpu_load_change
gpu_load_value=50,90
gpu_text=GPU
cpu_stats
cpu_temp
cpu_load_change
core_load_change
cpu_load_value=50,90
fps
background_alpha=0.3
font_size=24
position=top-left
text_color=ffffff
round_corners=10
MHEOF
  cat > ~/.config/vkBasalt/vkBasalt.conf << 'VKEOF'
effects = cas
casSharpness = 0.5
VKEOF
  /usr/local/bin/install-proton-ge || true
  cat > ~/Games/steam-launch-options.txt << 'SLEOF'
gamemoderun mangohud %command%
__GL_GSYNC_ALLOWED=1 __GL_VRR_ALLOWED=1 %command%
PROTON_ENABLE_NVAPI=1 PROTON_HIDE_NVIDIA_GPU=0 VKD3D_CONFIG=dxr %command%
PROTON_USE_WINED3D=1 %command%
SLEOF
  notify-send "Gaming Setup Complete" "Proton-GE installed. See ~/Games/steam-launch-options.txt" -i applications-games || true
  touch ~/.gaming-setup-complete
fi
EOF
chmod +x /etc/profile.d/gaming-first-login.sh

# --- GameMode ---
cat > /etc/gamemode.ini << 'EOF'
[general]
renice=10
inhibit_screensaver=1

[gpu]
apply_gpu_optimisations=accept-responsibility
gpu_device=0
amd_performance_level=high
nvidia_powermizer_mode=1
nvidia_perf_level_min=2
nvidia_perf_level_max=3

[cpu]
park_cores=no
pin_cores=yes

[custom]
start=notify-send "GameMode started"
end=notify-send "GameMode ended"
EOF

# --- Enable key services (but NOT sddm yet) ---
systemctl enable tuned
systemctl enable earlyoom
systemctl enable irqbalance

# --- Tuned profile ---
tuned-adm profile balanced || true

# --- zram ---
cat > /etc/systemd/zram-generator.conf << 'EOF'
[zram0]
zram-size = min(ram / 2, 4096)
compression-algorithm = zstd
EOF

# --- sysctl tweaks ---
mkdir -p /etc/sysctl.d
echo "vm.swappiness=10"            > /etc/sysctl.d/99-gaming.conf
echo "vm.vfs_cache_pressure=50"   >> /etc/sysctl.d/99-gaming.conf

# --- ulimit ---
cat > /etc/security/limits.d/99-gaming.conf << 'EOF'
* soft nofile 524288
* hard nofile 524288
EOF

# --- DNF config ---
echo "multilib_policy=best"       >> /etc/dnf/dnf.conf
echo "max_parallel_downloads=10"  >> /etc/dnf/dnf.conf
echo "fastestmirror=True"         >> /etc/dnf/dnf.conf

# --- SDDM basic config (no autologin) ---
mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/initial-setup.conf << 'EOF'
[Autologin]
User=
Session=

[Theme]
Current=breeze

[Users]
MaximumUid=60000
MinimumUid=1000
EOF

# --- README in new users' homes ---
mkdir -p /etc/skel
cat > /etc/skel/README-GAMING.txt << 'EOF'
Welcome to your Fedora KDE Gaming System!

This system is optimized for gaming:
- Steam + Proton (with Proton-GE helper)
- Lutris, GameMode, MangoHud, Vulkan + 32-bit libs
- Automatic Btrfs snapshots (Snapper + grub-btrfs)
- KDE Plasma desktop, Plymouth theming

Useful:
- install-proton-ge  (update Proton-GE)
- snapshot-manager   (create/list/cleanup snapshots)
- See ~/Games/steam-launch-options.txt for tips.
EOF

# --- Initial snapshots (if configured) ---
if snapper list-configs | grep -q root; then
  snapper -c root create -d "Initial system installation" --userdata important=yes || true
fi
if snapper list-configs | grep -q home; then
  snapper -c home create -d "Initial system installation" --userdata important=yes || true
fi

# --- Final GRUB refresh (BLS) ---
if [ -d /sys/firmware/efi ]; then
  grub2-mkconfig -o /etc/grub2-efi.cfg || true
else
  grub2-mkconfig -o /etc/grub2.cfg || true
fi

echo "Post-installation configuration complete."
%end

# Reboot after installation
reboot
