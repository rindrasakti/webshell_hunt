#!/bin/bash

# Default path
TARGET_PATH="/var/www/html"

# Parsing argumen
while [[ $# -gt 0 ]]; do
    case "$1" in
        --path)
            if [[ -n "$2" ]]; then
                TARGET_PATH="$2"
                shift 2
            else
                echo "Error: --path requires a directory path."
                exit 1
            fi
            ;;
        *)
            echo "Usage: $0 [--path /path/to/scan]"
            exit 1
            ;;
    esac
done

# Input fallback
if [[ -z "$TARGET_PATH_SET" && -z "$1" ]]; then
    read -rp "Enter directory to scan (default: /var/www/html): " USER_INPUT
    if [[ -n "$USER_INPUT" ]]; then
        TARGET_PATH="$USER_INPUT"
    fi
fi

# Check if directory exists
if [[ ! -d "$TARGET_PATH" ]]; then
    echo "Directory not found: $TARGET_PATH"
    exit 1
fi

# Suspicious patterns often used in obfuscated backdoors
PATTERNS=(
    "eval"
    "system"
    "exec"
    "shell_exec"
    "htmlspecialchars_decode"
    "base64_decode"
    "gzinflate"
    "strrev"
    "assert"
    "preg_replace.*\/e"
)

# Output file
OUTPUT="hasil_scan_webshell.tsv"
echo -e "File Path\t\t\t\tSuspicious Keywords" > "$OUTPUT"

# Function to scan each file
scan_file() {
    local file=$1
    for pattern in "${PATTERNS[@]}"; do
        if grep -aE "$pattern" "$file" >/dev/null 2>&1; then
            match=$(grep -aEo "$pattern" "$file" | sort | uniq | paste -sd ", " -)
            echo -e "$file\t$match" >> "$OUTPUT"
            break
        fi
    done
}

# Start scanning
echo "Scanning directory: $TARGET_PATH ..."
find "$TARGET_PATH" -type f 2>/dev/null | while read -r file; do
    scan_file "$file"
done

echo "Scan complete. Results saved to: $OUTPUT"
