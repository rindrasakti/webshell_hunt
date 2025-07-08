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
                echo "Error: --path membutuhkan argumen"
                exit 1
            fi
            ;;
        *)
            echo "Penggunaan: $0 [--path /path/to/scan]"
            exit 1
            ;;
    esac
done

# Jika --path tidak diberikan, minta input manual
if [[ -z "$TARGET_PATH_SET" && -z "$1" ]]; then
    read -rp "Masukkan direktori yang ingin discan (default: /var/www/html): " USER_INPUT
    if [[ -n "$USER_INPUT" ]]; then
        TARGET_PATH="$USER_INPUT"
    fi
fi

# Validasi direktori
if [[ ! -d "$TARGET_PATH" ]]; then
    echo "Direktori tidak ditemukan: $TARGET_PATH"
    exit 1
fi

# Pola kata kunci yang sering digunakan dalam webshell/backdoor
PATTERNS=(
    "eval"
    "system"
    "exec"
    "shell_exec"
    "htmlspecialchars_decode"
    "base64_decode"
    "gzinflate"
    "strrev"
)

# Output file
OUTPUT="hasil_scan_webshell.tsv"
echo -e "File Path\t\t\t\tKeyword Dicurigai" > "$OUTPUT"

# Fungsi scanning
scan_file() {
    local file=$1
    for pattern in "${PATTERNS[@]}"; do
        if grep -Ea "$pattern" "$file" >/dev/null 2>&1; then
            match=$(grep -Eao "$pattern" "$file" | sort | uniq | paste -sd ", " -)
            echo -e "$file\t$match" >> "$OUTPUT"
            break
        fi
    done
}

# Jalankan scanning
echo "Memindai direktori: $TARGET_PATH ..."
find "$TARGET_PATH" -type f -name "*.php" 2>/dev/null | while read -r file; do
    scan_file "$file"
done

echo "Scan selesai. Hasil disimpan di: $OUTPUT"
