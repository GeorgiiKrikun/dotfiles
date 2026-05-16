#!/usr/bin/env python3
"""Convert KeePass 2.x CSV export to Bitwarden CSV import format."""

import csv
import sys
from pathlib import Path

KEEPASS_COLUMNS = {"Group", "Title", "Username", "Password", "URL", "Notes"}

BITWARDEN_FIELDNAMES = [
    "folder", "favorite", "type", "name", "notes",
    "fields", "reprompt", "login_uri", "login_username",
    "login_password", "login_totp",
]


def convert(input_path: str, output_path: str) -> None:
    in_file = Path(input_path)
    if not in_file.exists():
        sys.exit(f"Error: file not found: {input_path}")

    with open(in_file, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        if not KEEPASS_COLUMNS.issubset(set(reader.fieldnames or [])):
            missing = KEEPASS_COLUMNS - set(reader.fieldnames or [])
            sys.exit(f"Error: input is missing expected KeePass columns: {missing}")

        rows = list(reader)

    out_file = Path(output_path)
    with open(out_file, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=BITWARDEN_FIELDNAMES)
        writer.writeheader()
        for row in rows:
            writer.writerow({
                "folder":         row["Group"],
                "favorite":       "0",
                "type":           "login",
                "name":           row["Title"],
                "notes":          row["Notes"],
                "fields":         "",
                "reprompt":       "0",
                "login_uri":      row["URL"],
                "login_username": row["Username"],
                "login_password": row["Password"],
                "login_totp":     "",
            })

    print(f"Converted {len(rows)} entries -> {out_file}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <keepass_export.csv> <bitwarden_import.csv>")
        sys.exit(1)
    convert(sys.argv[1], sys.argv[2])
