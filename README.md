<img width="1378" height="670" alt="image" src="https://github.com/user-attachments/assets/9ec57edf-2afd-45f2-a1ef-64adfbd3b46a" /># NASA-Battery-SOH-Analysis

#项目介绍
本项目基于 NASA 锂离子电池公开数据集，使用 Python 进行深度的数据清洗与特征工程。项目贯穿了从微观单次充放电过程到宏观全生命周期老化的分析，核心聚焦电池的两大关键指标：容量衰减（SOH） 与 内阻抗增长（Re/Rct），旨在从海量、含噪的真实传感器数据中提取电池退化规律。

#核心技术栈
数据处理与分析：Python, Pandas, Numpy, Ast (复杂数据解析)，
数据可视化：Matplotlib (双 Y 轴绘制、滚动平滑趋势线)，
数据分析方法：安时积分法 (Ah-integration)、滑动平均滤波 (Rolling Mean)、Pearson 相关性分析。

#核心发现
1、容量衰减：电池容量在初期因 SEI 膜形成快速下降，随后进入线性衰减期。阻抗测试后的容量“反弹”是测试静置导致的极化恢复现象，而非真实容量提升。
2、阻抗退化：B0047 电池老化主要由欧姆电阻（Re，增幅 32%）主导，而非界面活性丧失（Rct，增幅 22%），提示电解液与导电网络退化是该电池主要失效机理。
3、数据质量：真实传感器数据（如阻抗复数、放电末端静置电流、异常0容量）必须经过严格清洗，否则会导致趋势线严重失真。

#可视化结果
1、充放电物理过程仿真
<img width="1371" height="681" alt="image" src="https://github.com/user-attachments/assets/784d025d-1b00-409a-b661-bdf0b445c097" />
<img width="1382" height="692" alt="image" src="https://github.com/user-attachments/assets/d23816a5-586e-4aca-9b64-3ac94e6c3581" />
采用安时积分法计算单次放电容量，解决放电末端“极化恢复”导致的电压回弹现象。
2、全生命周期容量衰减趋势
<img width="1378" height="670" alt="image" src="https://github.com/user-attachments/assets/fe53e362-c963-434d-bea5-2bc8aedf5a69" />
剔除 0 值异常并应用滑动平均（Rolling Mean），还原电池真实的容量衰减主干（1.67Ah → 1.15Ah）。
3、阻抗演化深度分析 (Re vs Rct)
<img width="1382" height="680" alt="image" src="https://github.com/user-attachments/assets/f9337b4b-422e-41da-8996-533297a049b5" />
处理复杂复数并过滤极端噪声，揭示 Re 与 Rct 的强共线性，深度解释锯齿状波动（温度与SOC影响）及寿命末期 Rct 异常下降的物理机理。





