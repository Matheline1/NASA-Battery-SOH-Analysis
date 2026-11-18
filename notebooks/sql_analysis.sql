/*
 * 储能电池数据多表查询分析
 * 数据来源：NASA metadata.csv (已通过 Python ETL 脚本导入)
 * 核心技能：LEFT JOIN 多表关联、ROW_NUMBER() 窗口函数
 */

-- 说明：建表与数据导入已通过 Python 脚本 (etl_to_sql.py) 
-- 使用 Pandas.to_sql() 完成自动化 ETL，此处直接进行核心查询。

-- ==========================================
-- 核心查询 1：LEFT JOIN 关联并计算真实 SOH
-- ==========================================
-- 业务场景：以放电事实表为主，关联台账获取标称容量。
SELECT 
    c.battery_id,
    c.cycle_num,
    c.capacity_ah,
    b.nominal_capacity,
    -- 计算真实的 SOH（容量/标称容量 * 100）
    ROUND(c.capacity_ah / b.nominal_capacity * 100, 2) AS soh_percentage
FROM 
    battery_cycle c
LEFT JOIN 
    battery_info b ON c.battery_id = b.battery_id
WHERE 
    c.capacity_ah > 0 -- 排除脏数据
ORDER BY 
    c.battery_id, c.cycle_num
LIMIT 20;

-- ==========================================
-- 核心查询 2：ROW_NUMBER() 窗口函数排名
-- ==========================================
-- 业务场景：找出真实数据中，每块电池容量衰减最严重的 Top 2 循环记录，用于排查异常。
SELECT 
    battery_id,
    cycle_num,
    capacity_ah,
    rct_ohm
FROM (
    SELECT 
        battery_id,
        cycle_num,
        capacity_ah,
        rct_ohm,
        ROW_NUMBER() OVER(PARTITION BY battery_id ORDER BY capacity_ah ASC) AS rank_num
    FROM 
        battery_cycle
    WHERE 
        capacity_ah > 0
) AS ranked_table
WHERE 
    rank_num <= 2;
