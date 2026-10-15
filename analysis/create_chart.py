
import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

root = Path(__file__).resolve().parents[1]
df = pd.read_csv(root / "data/employment_trends.csv")

df.columns = df.columns.str.lower()
df["employment_month"] = pd.to_datetime(df["employment_month"])

pivot = df.pivot(
    index="employment_month",
    columns="province",
    values="employed_thousands"
).sort_index()

output = root / "images"
output.mkdir(exist_ok=True)

# Chart 1: Actual employment levels
ax = pivot.plot(figsize=(11, 5), linewidth=2)
ax.set_title("Canadian Employment Trends by Province")
ax.set_ylabel("Employed persons (thousands)")
ax.set_xlabel("")
ax.grid(alpha=0.25)
plt.tight_layout()
plt.savefig(output / "employment_trends.png", dpi=180)
plt.close()

# Chart 2: Indexed employment growth
indexed = (pivot / pivot.iloc[0] - 1) * 100

ax = indexed.plot(figsize=(11, 5), linewidth=2)
ax.set_title("Employment Change Since September 2024")
ax.set_ylabel("Change from baseline (%)")
ax.set_xlabel("")
ax.axhline(0, color="gray", linewidth=1)
ax.grid(alpha=0.25)
plt.tight_layout()
plt.savefig(output / "employment_growth.png", dpi=180)
plt.close()

print("Charts created in images/")
