"""
Export every table from brightmart_retail_oltp.sqlite to CSV files with headers.
Run from the project root:

python scripts/export_sqlite_to_csv.py --sqlite-path ../brightmart_retail_oltp.sqlite --out-dir exports/csv
"""
import argparse
import csv
import sqlite3
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument('--sqlite-path', required=True)
parser.add_argument('--out-dir', required=True)
args = parser.parse_args()

out_dir = Path(args.out_dir)
out_dir.mkdir(parents=True, exist_ok=True)
conn = sqlite3.connect(args.sqlite_path)
cur = conn.cursor()
cur.execute("select name from sqlite_master where type='table' and name not like 'sqlite_%' order by name")
tables = [r[0] for r in cur.fetchall()]

for table in tables:
    cur.execute(f'select * from {table}')
    rows = cur.fetchall()
    headers = [d[0] for d in cur.description]
    out_file = out_dir / f'{table}.csv'
    with out_file.open('w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(headers)
        writer.writerows(rows)
    print(f'Exported {table}: {len(rows)} rows -> {out_file}')
