# %%
import sys
import os
import warnings
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import matplotlib.dates as mdates

from functions import simple_collections

our_func = simple_collections()

warnings.filterwarnings("ignore")

sns.set(style='ticks', font_scale=1.25)

# %%
test = pd.read_csv('daily/wea1980',skiprows=4, header = None)
# test[3].plot()
# test[4].plot()
test[7].sum()

# %%
workdir = './daily/outputs'

Depth = [0.01,0.055,0.1,0.11,0.155,0.2,0.21,0.255,0.3,0.31,0.355,0.4,0.45,0.5,0.55,0.6,0.7,0.9,1.1,1.3]
# Depth = [0.01,0.05,0.1,0.15,0.2,0.25,0.3,0.4,0.5,0.6,0.7,0.8,1.0,1.2,1.5,2.0,2.5,3.0,3.5,4.0]

year_list = range(1971, 1980)

# year_list = np.arange(1981, 1986)
# year_list = np.arange(1991, 1996)
# year_list = np.arange(2001, 2006)
# year_list = np.arange(2011, 2015)

# %%
df_eco = our_func.merge_mult_files(year_list, subfix = 'eco', workdir=workdir)

df_eco = df_eco.set_index('DATE')

df_eco['ECO_LAI'].plot()

plt.legend()

plt.show()

# %%
df_tsl = our_func.merge_mult_files(year_list, subfix = 'tsl', workdir=workdir)

df_tsl = df_tsl.set_index('DATE')

# print(df_tsl.columns)

df_tsl[['TEMP_3','TEMP_5','TEMP_20']].plot()
plt.show()

# %%
df_wat = our_func.merge_mult_files(year_list, subfix = 'atm', workdir=workdir)

df_wat = df_wat.set_index('DATE')

(df_wat['SNOWPACK']*0.01).plot()
plt.ylabel('Snow Depth (m)')
# (df_wat['ACTV_LYR']).plot()

df_wat

# %%
# df1 = read_data_file_robust(os.path.join(workdir, '010101805tsl'))

dump1 = df_tsl[['TEMP_1', 'TEMP_2', 'TEMP_3', 'TEMP_4', 'TEMP_5', 'TEMP_6', 'TEMP_7',
       'TEMP_8', 'TEMP_9', 'TEMP_10', 'TEMP_11', 'TEMP_12','TEMP_13',
       'TEMP_14', 'TEMP_15', 'TEMP_16', 'TEMP_17', 'TEMP_18', 'TEMP_19',
       'TEMP_20']]

plt.figure(figsize=[12,4])
c0 = plt.pcolor(df_tsl.index, Depth, dump1.T, cmap = 'coolwarm', vmin = -25, vmax = 25)
plt.contour(df_tsl.index, Depth, dump1.T, levels = [0])
plt.ylim([1,0])
plt.gcf().autofmt_xdate()
plt.colorbar(c0, extend = 'both')

# %%
# df_tsl['SOIL_RN'].plot()
df_tsl.columns#[['TEMP_3','TEMP_5']].plot()
df_tsl[['TEMP_20']].resample('1A').mean().plot(marker = 'o')

# %%



