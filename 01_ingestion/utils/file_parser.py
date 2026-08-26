import pandas as pd

def read_file(file):

    if file.suffix.lower() == ".csv":
        return pd.read_csv(file)

    elif file.suffix.lower() in [".xlsx", ".xlsm"]:
        return pd.read_excel(file)

    elif file.suffix.lower() == ".xlsb":
        return pd.read_excel(file, engine="pyxlsb")

    else:
        raise ValueError(f"Unsupported file: {file}")