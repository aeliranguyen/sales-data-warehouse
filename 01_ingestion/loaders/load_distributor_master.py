import sys
from pathlib import Path

# Cho phép import utils
sys.path.append(str(Path(__file__).resolve().parents[1]))

from utils.file_parser import read_file
from utils.db_utils import engine, add_metadata

# ==============================
# Đường dẫn project
# ==============================

project_root = Path(__file__).resolve().parents[2]

# Đường dẫn tới file nguồn
file = (
    project_root
    / "Raw data"
    / "VietDist_SampleData"
    / "SRC06_distributor_master.csv"
)

# ==============================
# Đọc dữ liệu
# ==============================

df = read_file(file)

# Thêm metadata
df = add_metadata(df, file.name)

# ==============================
# Load vào Bronze (raw)
# ==============================

df.to_sql(
    name="distributor_master",
    con=engine,
    schema="raw",
    if_exists="replace",
    index=False
)

print(f"{file.name} loaded successfully!")