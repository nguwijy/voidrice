################ data #################
import akshare as ak
import pandas as pd
import tqdm

res = []

tmp = ak.stock_us_spot_em().rename(columns={'代码': 'symbol'})[['symbol']]
tmp['ticker'] = tmp['symbol'].str.split('.').str[1]
universe = tmp[tmp['ticker'].isin(pd.read_csv('index/spx.csv')['Symbol'].to_list())]['symbol'].to_list()

for symbol in tqdm.tqdm(universe):
    df = (
        ak.stock_us_hist(symbol=symbol, period="daily", adjust="qfq")
        .rename(columns={
            "日期": "date",
            "开盘": "open",
            "收盘": "close",
            "最高": "high",
            "最低": "low",
            "成交量": "volume",
            "成交额": "amount",
            "涨跌幅": "pctChg",
            "换手率": "turnover"
        })
        .drop(columns=['振幅', '涨跌额'])
    ).merge(
        ak.stock_us_hist(symbol=symbol, period="daily", adjust="")
        .rename(columns={"日期": "date", '收盘': 'close_unadjusted'})
        [['date', 'close_unadjusted']]
    )
    df['inst'] = symbol
    res.append(df)
pd.concat(res, ignore_index=True).to_csv('data_qfq/us_top500.csv', index=False)


################ gen alphas #################
import pandas as pd
import numpy as np
import tqdm
df = pd.read_csv('data_qfq/us_top500.csv')
df = df[~np.isclose(df['amount'], 0)]
df['vwap'] = df['amount'] / df['volume'] / df['close_unadjusted'] * df['close']
df = df.drop_duplicates(subset=['date', 'inst']).pivot(index='date', columns='inst')
alphas = Alphas101(df)
methods = alphas.get_alpha_methods(alphas)

aa = pd.DataFrame()
for m in tqdm.tqdm(methods):
    factor = getattr(alphas, m)
    if aa.empty:
        aa = factor().stack().to_frame(m).reset_index()
    else:
        aa = aa.merge(factor().stack().to_frame(m).reset_index(), how='outer')
aa.to_pickle('data_qfq/alpha_us_top500.pkl')

import pandas as pd
from sklearn.feature_selection import mutual_info_regression

alphas = pd.read_pickle('data_qfq/alpha_us_top500.pkl').merge(
    pd.read_csv('data_qfq/us_top500.csv')
    .drop_duplicates(subset=['date', 'inst'])
    .pivot(index='date', columns='inst', values='close')
    .pct_change(1).shift(-1).stack().to_frame('c2c').reset_index()
).drop_duplicates(['date', 'inst']).dropna().set_index(['date', 'inst'])
cols = list(set(alphas.columns) - {'alpha084', 'c2c'})

correl = alphas[cols].corrwith(alphas['c2c'], method='spearman')
mi = mutual_info_regression(alphas[cols], alphas['c2c'])




import torch
import torch.nn as nn
import time
import psutil
import os

# ---- Define Network ----
class BigNet(nn.Module):
    def __init__(self, input_dim=5000, hidden_dim=5000, output_dim=1, num_hidden=5):
        super(BigNet, self).__init__()
        layers = []
        layers.append(nn.Linear(input_dim, hidden_dim))
        layers.append(nn.ReLU())
        for _ in range(num_hidden - 1):
            layers.append(nn.Linear(hidden_dim, hidden_dim))
            layers.append(nn.ReLU())
        layers.append(nn.Linear(hidden_dim, output_dim))
        self.net = nn.Sequential(*layers)

    def forward(self, x):
        return self.net(x)

# ---- Utility: measure CPU memory ----
def get_cpu_memory():
    process = psutil.Process(os.getpid())
    return process.memory_info().rss / (1024**2)  # MB

# ---- Profiling function ----
def profile(device, batch_size=64, runs=50):
    print(f"\nRunning on {device} (batch={batch_size})...")
    model = BigNet().to(device)
    model.eval()
    x = torch.randn(batch_size, 5000, device=device)

    # Warm-up
    for _ in range(5):
        _ = model(x)

    # Reset memory stats
    if device.type == "cuda":
        torch.cuda.reset_peak_memory_stats(device)

    start_mem = get_cpu_memory()
    start = time.time()

    with torch.no_grad():
        for _ in range(runs):
            _ = model(x)

    if device.type == "cuda":
        torch.cuda.synchronize()

    end = time.time()
    end_mem = get_cpu_memory()

    runtime = (end - start) / runs  # average per inference
    cpu_mem_used = end_mem - start_mem
    gpu_mem_used = (
        torch.cuda.max_memory_allocated(device) / (1024**2)
        if device.type == "cuda"
        else 0
    )

    print(f"Avg Runtime per inference: {runtime*1000:.3f} ms")
    print(f"CPU Memory Δ: {cpu_mem_used:.2f} MB")
    if device.type == "cuda":
        print(f"GPU Memory Peak: {gpu_mem_used:.2f} MB")

# ---- Run on CPU ----
profile(torch.device("cpu"))

# ---- Run on GPU if available ----
if torch.cuda.is_available():
    profile(torch.device("cuda"))
    
