#!/data/data/com.termux/files/usr/bin/bash

echo "[*] Installing proxychains-ng..."
pkg update -y && pkg install -y proxychains-ng

echo "[*] Creating user config directory..."
mkdir -p ~/.proxychains

echo "[*] Copying default config..."
cp /data/data/com.termux/files/usr/etc/proxychains.conf ~/.proxychains/proxychains.conf

echo "[*] Switching to dynamic_chain mode..."
sed -i 's/^strict_chain/#strict_chain/' ~/.proxychains/proxychains.conf
sed -i 's/^#dynamic_chain/dynamic_chain/' ~/.proxychains/proxychains.conf

echo "[*] Removing default proxy entry..."
sed -i '/^socks4 127.0.0.1 9050/d' ~/.proxychains/proxychains.conf

read -p "[?] Enter proxy type (socks4/socks5/http): " ptype
read -p "[?] Enter proxy IP (e.g., 127.0.0.1): " pip
read -p "[?] Enter proxy port (e.g., 1080): " pport

echo "[*] Adding your proxy to config..."
echo "$ptype $pip $pport" >> ~/.proxychains/proxychains.conf

echo "[*] Creating alias: pc"
echo "alias pc='proxychains4 -f ~/.proxychains/proxychains.conf'" >> ~/.bashrc
source ~/.bashrc

echo "[✔] Done! Test with: pc curl https://ipinfo.io"
