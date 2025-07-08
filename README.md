# PHP Web Shell Scanner

This is a simple Bash script to scan PHP files on a Linux server (especially Ubuntu) for potential web shells or backdoor code patterns.

It searches for suspicious functions and obfuscated code commonly used in PHP-based web shells such as:
- `eval`
- `system`
- `exec`
- `shell_exec`
- `htmlspecialchars_decode`
- `base64_decode`
- `gzinflate`
- `strrev`

## 🔍 What It Does

The script scans all `.php` files in the specified directory (and subdirectories), and reports any files containing potentially dangerous or obfuscated code patterns.

The output is saved in a file called `hasil_scan_webshell.tsv` (tab-separated), which includes:
- **File Path**: Full path to the suspicious PHP file
- **Suspicious Keywords**: The list of detected risky functions/keywords

---

## ✅ How to Use

### 1. Download the script

Save the script as `cari_webshell.sh` and make it executable:

```bash
chmod +x cari_webshell.sh

**2. Run the script**

You can run it with or without arguments:
Option 1: With --path argument (recommended)

sudo ./cari_webshell.sh --path /var/www/html

Option 2: Without arguments (interactive mode)

sudo ./cari_webshell.sh

It will prompt you:

Enter directory to scan (default: /var/www/html):

Press Enter to use default, or input another path.
📦 Output

The result will be saved to:

hasil_scan_webshell.tsv

You can open this file using text editors or import into Excel/LibreOffice for easier analysis.
