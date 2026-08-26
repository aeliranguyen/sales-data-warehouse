import sys
from pathlib import Path
import pandas as pd

# Cho phép import utils
sys.path.append(str(Path(__file__).resolve().parents[1]))

from utils.db_utils import engine, add_metadata

# ==========================================
# Đường dẫn project
# ==========================================

project_root = Path(__file__).resolve().parents[2]

file = (
    project_root
    / "Raw data"
    / "VietDist_SampleData"
    / "SRC07_employee_master.xlsx"
)

# ==========================================
# Đọc tất cả sheet
# ==========================================

excel = pd.ExcelFile(file)

print("Sheets found:", excel.sheet_names)

# ==========================================
# Load từng sheet
# ==========================================

for sheet in excel.sheet_names:

    # Bỏ qua sheet Change_Log
    if sheet.lower() == "change_log":
        continue

    print(f"Loading {sheet}...")

    # Đọc dữ liệu của sheet
    df = pd.read_excel(file, sheet_name=sheet)

    # Thêm tên version (sheet)
    df["version_label"] = sheet

    # Thêm metadata
    df = add_metadata(df, file.name)

    # Load vào Bronze
    df.to_sql(
        name="employee_master",
        con=engine,
        schema="raw",
        if_exists="append",
        index=False
    )

    print(f"{sheet}: {len(df)} rows loaded.")

print("Employee Master loaded successfully!")