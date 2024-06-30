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
