# Enables a RHEL-based firewalld to only allow communication from Cloudflare IPs to protect the web ui of Nessus. Run as sudo. This assumes a single deployment.

echo "Downloading current Cloudflare IP list into /tmp/cloudflareips.txt..."
wget -O /tmp/cloudflareips.txt https://www.cloudflare.com/ips-v4

echo "Creating firewalld ipset..."
sudo firewall-cmd --permanent --new-ipset=cloudflareips --type=hash:net

echo "Loading Cloudflare IPs into new ipset..."
sudo firewall-cmd --permanent --ipset=cloudflareips --add-entries-from-file=/tmp/cloudflareips.txt

echo "Creating firewalld rich rule to allow https traffic only from Cloudflare IP range..."

sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source ipset="cloudflareips" service name="https" accept'

echo "Reloading firewalld..."
sudo firewall-cmd --reload

echo "Cleaning up..."

rm /tmp/cloudflareips.txt

echo "Finished!"
