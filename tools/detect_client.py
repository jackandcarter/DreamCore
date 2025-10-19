#!/usr/bin/env python3
import sys, os, csv

def detect(build_info_path):
    if not os.path.isfile(build_info_path):
        print(f"File not found: {build_info_path}", file=sys.stderr)
        sys.exit(2)
    with open(build_info_path, newline='', encoding='utf-8', errors='ignore') as f:
        # build.info is CSV-ish with a header row; one row per product channel
        rows = list(csv.reader(f, delimiter='|'))
    if not rows:
        print("Empty build.info")
        sys.exit(3)
    # Try to find the _retail_ row (Product = wow)
    header = rows[0]
    # Heuristic: last column often contains the version like "8.3.7.35662"
    best = None
    for r in rows[1:]:
        if len(r) != len(header):  # skip malformed lines
            continue
        line = "|".join(r)
        if "wow" in line.lower() or "_retail_" in line.lower():
            best = r
            break
    target = best or (rows[1] if len(rows) > 1 else None)
    if not target:
        print("Could not parse build.info")
        sys.exit(4)
    # Extract a version token like 8.3.7.35662 anywhere in the row
    version = None
    for cell in target:
        if cell.count('.') >= 3 and all(p.isdigit() for p in cell.split('.') if p.isdigit() or p.isnumeric()):
            version = cell
            break
    print(version or "|".join(target))

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: detect_client.py /path/to/_retail_/Data/build.info")
        sys.exit(1)
    detect(sys.argv[1])
