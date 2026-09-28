"""Generate synthetic retail CSV snippets for local pipeline demos."""

from __future__ import annotations

import csv
from datetime import datetime, timedelta
from pathlib import Path

OUT = Path(__file__).resolve().parents[1] / "sample_data"
OUT.mkdir(exist_ok=True)


def write_orders(n: int = 100) -> None:
    path = OUT / "orders.csv"
    start = datetime(2026, 1, 1)
    with path.open("w", newline="") as f:
        w = csv.writer(f)
        w.writerow(
            ["order_id", "customer_id", "order_ts", "status", "currency_code", "total_amount"]
        )
        for i in range(1, n + 1):
            w.writerow(
                [
                    f"O{i:06d}",
                    f"C{(i % 25) + 1:04d}",
                    (start + timedelta(hours=i)).isoformat(sep=" "),
                    "COMPLETE" if i % 7 else "PENDING",
                    "USD",
                    round(20 + (i % 50) * 3.5, 2),
                ]
            )


if __name__ == "__main__":
    write_orders()
    print(f"Wrote sample files to {OUT}")
