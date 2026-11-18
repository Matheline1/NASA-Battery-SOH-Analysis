import pandas as pd
import sqlite3

# 1. 读取你真实的 NASA metadata.csv
meta_df = pd.read_csv('./data/metadata.csv')

# 2. 连接到本地的 SQLite 数据库（如果不存在，会自动创建一个名为 nasa_battery.db 的文件）
conn = sqlite3.connect('nasa_battery.db')

# 3. 提取你需要的数据，存入两张表（模拟你的数仓）
# 表1：电池台账（去重取电池ID）
battery_info = meta_df[['battery_id']].drop_duplicates().copy()
battery_info['chemistry'] = 'Li-ion-18650' # 添加上化学材料
battery_info['nominal_capacity'] = 2.0      # 添加标称容量

# 写入数据库：表名 battery_info
battery_info.to_sql('battery_info', conn, if_exists='replace', index=False)

# 表2：充放电事实表（只保留放电数据，和容量、内阻）
battery_cycle = meta_df[meta_df['type'] == 'discharge'][['battery_id', 'uid', 'Capacity', 'Rct']].copy()
battery_cycle.columns = ['battery_id', 'cycle_num', 'capacity_ah', 'rct_ohm']

# 写入数据库：表名 battery_cycle
battery_cycle.to_sql('battery_cycle', conn, if_exists='replace', index=False)

# 关闭连接
conn.close()
print("✅ 真实 NASA 数据已成功导入 SQLite 数据库！")
