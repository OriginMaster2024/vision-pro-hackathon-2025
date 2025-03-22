import time
from math import pi, tau
from pathlib import Path

import numpy as np
import pandas as pd

def dataframes():
    tmp = Path("/tmp")
    if not tmp.is_dir():
        tmp = Path("/temp")
    
    hip_lite_major = tmp / "hip_lite_major.csv"
    if not hip_lite_major.exists():
        url = "http://astro.starfree.jp/commons/hip/hip_lite_major.csv"
        _df = pd.read_csv(url, header=None, index_col=0)
        _df.to_csv(hip_lite_major, header=None)
        time.sleep(0.1)
    df = pd.read_csv(hip_lite_major, header=None, index_col=0)
    df.columns = "赤経時 赤経分 赤経秒 赤緯符号 赤緯度 赤緯分 赤緯秒 視等級".split()

    hip_constellation_line = tmp / "hip_constellation_line.csv"
    if not hip_constellation_line.exists():
        url = "http://astro.starfree.jp/commons/hip/hip_constellation_line.csv"
        _df = pd.read_csv(url, header=None)
        _df.to_csv(hip_constellation_line, header=None, index=False)
        time.sleep(0.1)
    dfl = pd.read_csv(hip_constellation_line, header=None)
    dfl.columns = "Abbr HIP1 HIP2".split()

    df.insert(0, "ID", range(len(df)))
    df["Long"] = (df.赤経時 / 24 + df.赤経分 / 1440 + df.赤経秒 / 86400) * tau
    df["Lati"] = (df.赤緯度 / 90 + df.赤緯分 / 5400 + df.赤緯秒 / 324000) * pi
    df.Lati *= df.赤緯符号 - 0.5
    df["Z"] = np.sin(df.Lati)
    r = np.cos(df.Lati)
    df["X"] = r * np.cos(df.Long)
    df["Y"] = r * np.sin(df.Long)

    dfl = dfl[dfl.HIP1.isin(df.index) & dfl.HIP2.isin(df.index)]
    dfl = dfl.join(df.ID.rename("ID1"), "HIP1")
    dfl = dfl.join(df.ID.rename("ID2"), "HIP2")

    # 50倍にする
    df["X"] = df["X"] * 50
    df["Y"] = df["Y"] * 50
    df["Z"] = df["Z"] * 50

    return df, dfl

def main():
    df, dfl = dataframes()
    dfl = dfl[dfl["Abbr"] == "Ori"]

    ids = list(set(list(dfl["ID1"].unique()) + list(dfl["ID2"].unique())))
    df = df[df["ID"].isin(ids)]
    df.insert(0, "Index", range(len(df)))
    dfl = dfl.join(df.Index.rename("Index1"), "HIP1")
    dfl = dfl.join(df.Index.rename("Index2"), "HIP2")
    print(df)

if __name__ == "__main__":
    main()
