# DirDiscover
Web Server Directory Discovery

A simple Bash-based web directory scanner that discovers hidden directories and files on a web server using a wordlist.
This tool works over HTTP only and is designed for learning and basic reconnaissance.

### Features
- Check if the target host is online
- Scan web directories using a custom or default wordlist
- Detect HTTP response types:
  - Informational (1xx)
  - Success (2xx)
  - Redirection (3xx)
  - Client errors (4xx)
  - Server errors (5xx)
- Optional verbose mode
- Clean and readable output

### Requirements
- Linux / Unix environment
- Bash
- curl
- ping
- Wordlist (default: dirb wordlists)

Install dirb wordlists if missing:
```bash
sudo apt install dirb
```

### Installation

```bash
git clone https://github.com/yourusername/web-directory-discovery.git
cd web-directory-discovery
chmod +x scanner.sh
```

### Usage

```bash
./DirDiscover.sh
```
You will be prompted to enter:
- Target IP or domain
- Port (default: 80)
- Wordlist path
- Verbose mode (0 or 1)

### Example Output
```bash 
[+] HOST UP
[+] Found (200) : http://example.com/admin
[*] Redirect (301) : http://example.com/login
[-] Client Error (403) : http://example.com/private
```

### Limitations
- HTTP only (no HTTPS support)
- Single-threaded (slow for large wordlists)
- No request timeout configuration

### Legal Disclaimer
This tool is intended for educational and authorized testing purposes only.
Do NOT use it on systems you do not own or have explicit permission to test.
The author is not responsible for any misuse.
Furat Dehech
Version: 1.1
