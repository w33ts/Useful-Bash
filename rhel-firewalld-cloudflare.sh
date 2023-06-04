# Downloads the current Cloudflare IP list into a text file and creates a firewalld ipset for use with source ipset="cloudflareips" in firewalld rich rules or whatever you want. Run as sudo.

echo "Downloading current Cloudflare IP list into /tmp/cloudflareips.txt..."
wget -O /tmp/cloudflareips.txt https://www.cloudflare.com/ips-v4

echo "Creating firewalld ipset..."
sudo firewall-cmd --permanent --new-ipset=cloudflareips --type=hash:net

echo "Loading Cloudflare IPs into new ipset..."
sudo firewall-cmd --permanent --ipset=cloudflareips --add-entries-from-file=/tmp/cloudflareips.txt

echo "Reloading firewalld..."
sudo firewall-cmd --reload

echo "You can now use --ipset=cloudflareips to restrict traffic sources to Cloudflare. Useful for http/https traffic."

echo "Cleaning up..."

rm /tmp/cloudflareips.txt

echo "Finished!"
