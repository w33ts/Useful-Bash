# Enables a RHEL-based firewalld to only allow communication from Cloudflare IPs to protect the web ui of Splunk. Run as sudo. This assumes a single deployment.

echo "Downloading current Cloudflare IP list into /tmp/cloudflareips.txt..."
wget -O /tmp/cloudflareips.txt https://www.cloudflare.com/ips-v4

echo "Creating firewalld ipset..."
sudo firewall-cmd --permanent --new-ipset=cloudflareips --type=hash:net

echo "Loading Cloudflare IPs into new ipset..."
sudo firewall-cmd --permanent --ipset=cloudflareips --add-entries-from-file=/tmp/cloudflareips.txt

echo "Creating firewalld rule to only allow Cloudflare IPs to communicate with Splunk Web UI..."

sudo firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source ipset="cloudflareips" forward-port port="443" protocol="tcp" to-port="8000"'

echo "Reloading firewalld..."
sudo firewall-cmd --reload

echo "Cleaning up..."

rm /tmp/cloudflareips.txt

echo "Finished!"
