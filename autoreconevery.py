import dns.resolver
import whois
import requests
import base64

class DomainReconTool:
    def __init__(self, domain):
        self.domain = domain
        self.dns_records = {}
        self.whois_info = {}
        self.subdomains = []
        self.wayback_urls = []
        self.virustotal_info = {}
        self.shodan_info = {}
        self.censys_info = {}
        self.virustotal_api_key = "YOUR_VIRUSTOTAL_API_KEY"
        self.shodan_api_key = "YOUR_SHODAN_API_KEY"
        self.censys_api_id = "YOUR_CENSYS_API_ID"
        self.censys_secret = "YOUR_CENSYS_SECRET"

    def get_dns_records(self):
        """Fetch DNS records for the given domain."""
        records = {}
        resolver = dns.resolver.Resolver()
        resolver.timeout = 10
        resolver.lifetime = 10
        
        try:
            a_records = [r.address for r in resolver.resolve(self.domain, 'A')]
            records['A'] = a_records
        except (dns.resolver.NoAnswer, dns.resolver.NXDOMAIN, dns.resolver.Timeout):
            records['A'] = []

        try:
            mx_records = [r.exchange.to_text() for r in resolver.resolve(self.domain, 'MX')]
            records['MX'] = mx_records
        except (dns.resolver.NoAnswer, dns.resolver.NXDOMAIN, dns.resolver.Timeout):
            records['MX'] = []

        try:
            ns_records = [r.target.to_text() for r in resolver.resolve(self.domain, 'NS')]
            records['NS'] = ns_records
        except (dns.resolver.NoAnswer, dns.resolver.NXDOMAIN, dns.resolver.Timeout):
            records['NS'] = []

        try:
            txt_records = [r.to_text() for r in resolver.resolve(self.domain, 'TXT')]
            records['TXT'] = txt_records
        except (dns.resolver.NoAnswer, dns.resolver.NXDOMAIN, dns.resolver.Timeout):
            records['TXT'] = []

        self.dns_records = records
        return records

    def get_whois_info(self):
        """Fetch WHOIS information for the given domain."""
        try:
            info = whois.whois(self.domain)
            self.whois_info = {
                'Domain Name': info.domain_name,
                'Registrar': info.registrar,
                'Creation Date': info.creation_date,
                'Expiration Date': info.expiration_date,
                'Updated Date': info.updated_date,
                'Name Servers': info.name_servers,
                'Emails': info.emails
            }
            return self.whois_info
        except Exception as e:
            print(f"Error fetching WHOIS info: {e}")
            return {}

    def find_subdomains(self):
        """Find subdomains using a basic wordlist."""
        subdomains = ['www', 'mail', 'ftp', 'admin', 'test']
        found_subdomains = []
        for subdomain in subdomains:
            try:
                full_domain = f"{subdomain}.{self.domain}"
                dns.resolver.resolve(full_domain, 'A')
                found_subdomains.append(full_domain)
            except (dns.resolver.NoAnswer, dns.resolver.NXDOMAIN):
                continue
        self.subdomains = found_subdomains
        return found_subdomains

    def fetch_wayback_urls(self):
        """Fetch archived URLs from the Wayback Machine."""
        wayback_api_url = f"http://web.archive.org/cdx/search/cdx?url={self.domain}&output=json"
        try:
            response = requests.get(wayback_api_url)
            response.raise_for_status()
            data = response.json()
            urls = [item[2] for item in data[1:]]
            self.wayback_urls = urls
            return urls
        except requests.RequestException as e:
            print(f"Error fetching Wayback Machine URLs: {e}")
            return []

    def fetch_virustotal_info(self):
        """Fetch information from VirusTotal for the given domain."""
        virustotal_api_url = f"https://www.virustotal.com/api/v3/domains/{self.domain}"
        headers = {
            'x-apikey': self.virustotal_api_key
        }
        try:
            response = requests.get(virustotal_api_url, headers=headers)
            response.raise_for_status()
            data = response.json()
            self.virustotal_info = data
            return data
        except requests.RequestException as e:
            print(f"Error fetching VirusTotal information: {e}")
            return {}

    def fetch_shodan_info(self):
        """Fetch information from Shodan for the given domain."""
        shodan_api_url = f"https://api.shodan.io/shodan/host/{self.domain}?key={self.shodan_api_key}"
        try:
            response = requests.get(shodan_api_url)
            response.raise_for_status()
            data = response.json()
            self.shodan_info = data
            return data
        except requests.RequestException as e:
            print(f"Error fetching Shodan information: {e}")
            return {}

    def fetch_censys_info(self):
        """Fetch information from Censys for the given domain."""
        censys_api_url = f"https://search.censys.io/api/v2/hosts/{self.domain}"
        credentials = base64.b64encode(f"{self.censys_api_id}:{self.censys_secret}".encode()).decode()
        headers = {
            'Authorization': f'Basic {credentials}'
        }
        try:
            response = requests.get(censys_api_url, headers=headers)
            response.raise_for_status()
            data = response.json()
            self.censys_info = data
            return data
        except requests.RequestException as e:
            print(f"Error fetching Censys information: {e}")
            return {}

    def start(self):
        print("Domain Reconnaissance Tool")

        print("\nFetching DNS Records...")
        dns_records = self.get_dns_records()
        print(f"\nDNS Records:\n{dns_records}")

        print("\nFetching WHOIS Information...")
        whois_info = self.get_whois_info()
        print(f"\nWHOIS Information:\n{whois_info}")

        print("\nFinding Subdomains...")
        subdomains = self.find_subdomains()
        print(f"\nFound Subdomains:\n{subdomains}")

        print("\nFetching URLs from Wayback Machine...")
        wayback_urls = self.fetch_wayback_urls()
        print(f"\nArchived URLs:\n{wayback_urls}")

        print("\nFetching VirusTotal Information...")
        virustotal_info = self.fetch_virustotal_info()
        print(f"\nVirusTotal Information:\n{virustotal_info}")

        print("\nFetching Shodan Information...")
        shodan_info = self.fetch_shodan_info()
        print(f"\nShodan Information:\n{shodan_info}")

        print("\nFetching Censys Information...")
        censys_info = self.fetch_censys_info()
        print(f"\nCensys Information:\n{censys_info}")

if __name__ == "__main__":
    domain = input("Enter target domain: ").strip()
    tool = DomainReconTool(domain)
    tool.start()
