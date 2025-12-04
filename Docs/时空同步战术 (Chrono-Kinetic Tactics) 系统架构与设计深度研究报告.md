## <font style="color:rgb(31, 31, 31);">1. 绪论：战术策略游戏的范式转移与时空重构</font>
<font style="color:rgb(31, 31, 31);">在电子游戏设计的漫长演变史中，策略类游戏（Strategy Games）始终在寻找“思考深度”与“动态表现”之间的平衡点。传统的战棋游戏（Turn-Based Tactics, TBT）如《XCOM》或《火焰纹章》，采用了“我方回合-敌方回合”（IGOUGO）的序列化时间模型。这种模型虽然赋予了玩家无限的思考时间，却在根本上切断了战斗的流动性与物理真实感——单位在移动时，敌人仿佛被定身，这种“时间冻结”的抽象机制导致了许多战术逻辑与现实物理直觉的背离</font><sup><font style="color:rgb(68, 71, 70);"></font></sup><font style="color:rgb(31, 31, 31);">。</font>

<font style="color:rgb(31, 31, 31);">本报告旨在深入探讨一种新兴的、极具潜力的战术子类——</font>**<font style="color:rgb(31, 31, 31);">时空同步战术（Chrono-Kinetic Tactics, 简称CKT）</font>**<font style="color:rgb(31, 31, 31);">。该体系的核心愿景是对时间和空间进行统一的各种量化与交互设计，将“速度”确立为统御战斗流变的第一性原理，彻底打破移动速率（Movement Speed）与施法速率（Casting Speed）的二元对立，将其统合为单一的“速度属性”</font><sup><font style="color:rgb(68, 71, 70);"></font></sup><font style="color:rgb(31, 31, 31);">。在CKT架构下，游戏采用</font>**<font style="color:rgb(31, 31, 31);">同时回合制（Simultaneous Turn-Based / WEGO）</font>**<font style="color:rgb(31, 31, 31);">的结算机制：玩家与AI在决策阶段预设行动卡牌，随后进入执行阶段，双方的动画演出在同一时间轴上并发演算。</font>

<font style="color:rgb(31, 31, 31);">这种设计范式的转变，标志着战术游戏的胜负判定机制从“概率主导”（RNG-based，如95%命中率却未命中）向“物理主导”（Physics-based，如通过走位移出攻击判定框）的根本性跨越。战斗结果——即攻击是否命中或闪避——不再依赖随机数生成器，而是取决于“时空窗口”内的物理交互：速度决定了单位在特定时间点的位置与状态，进而决定了其是否能从敌方攻击的判定框（Hitbox）中移出（即闪避），或在敌方防御生效前完成打击（即命中）</font><sup><font style="color:rgb(68, 71, 70);">5</font></sup><font style="color:rgb(31, 31, 31);">。</font>

<font style="color:rgb(31, 31, 31);">本报告将分为九个主要章节，全面剖析CKT的理论基础、核心机制、数学模型、AI架构以及基于Godot引擎的技术实现方案，旨在为构建一款具有高战术深度（Deep Tactics）与电影级视觉表现力（Cinematic Visualization）的策略游戏提供详尽的设计蓝图。</font>

---

## <font style="color:rgb(31, 31, 31);">2. 核心机制论：速度统一论与时空度量</font>
### <font style="color:rgb(31, 31, 31);">2.1 传统属性的割裂与统一化的哲学</font>
<font style="color:rgb(31, 31, 31);">在经典RPG与战棋设计中，角色的能力往往被拆解为多个互不干涉的维度：移动力（Move）决定了棋盘上的覆盖范围，敏捷（Agility）决定了出手顺序，而施法速度（Cast Speed）则影响技能的释放快慢。这种割裂导致了战术单位的同质化与刻板印象——例如“短腿但高频攻击的刺客”或“长腿但施法缓慢的法师”。然而，在物理现实中，速度是对时空的绝对支配能力：一个动作敏捷的人，既能在单位时间内跨越更远的距离，也能在更短的时间内完成复杂的动作</font><sup><font style="color:rgb(68, 71, 70);">7</font></sup><font style="color:rgb(31, 31, 31);">。</font>

<font style="color:rgb(31, 31, 31);">CKT体系提出“速度统一论”（Unified Speed Theory），将所有与时间相关的变量收敛为单一属性——</font>**<font style="color:rgb(31, 31, 31);">速度（Speed, </font>**$ \mathcal{S} $**<font style="color:rgb(31, 31, 31);">）</font>**<font style="color:rgb(31, 31, 31);">。这一属性同时控制两个维度的表现：</font>

1. **<font style="color:rgb(31, 31, 31);">空间跨度（Spatial Span）</font>**<font style="color:rgb(31, 31, 31);">：单位在特定时间窗口内（Time Window）能够覆盖的物理距离。</font>
2. **<font style="color:rgb(31, 31, 31);">时间压缩（Temporal Compression）</font>**<font style="color:rgb(31, 31, 31);">：单位完成特定动作（如施法前摇、挥剑动作、卡牌执行）所需的时间缩放系数。</font>

<font style="color:rgb(31, 31, 31);">在这一框架下，高速度属性的角色成为了战场上的“时空操控者”。他们不仅移动轨迹更长（跑得快），而且动作帧数更少（施法快）。这意味着在同样的5秒钟战斗回合内，低速角色可能只能完成一次“移动-射击”循环，而高速角色可能已经完成了“移动-攻击-再移动-防御”的复杂战术机动。这种设计使得速度属性的价值呈指数级上升，成为玩家构建战术体系（Build）的核心支柱</font><sup><font style="color:rgb(68, 71, 70);">9</font></sup><font style="color:rgb(31, 31, 31);">。</font>

### <font style="color:rgb(31, 31, 31);">2.2 时间轴映射与动作耗时模型</font>
<font style="color:rgb(31, 31, 31);">在CKT中，时间轴（Timeline）是战斗的绝对裁判官，它取代了传统战棋中的“网格距离”成为最重要的战术资源。所有战术行动（卡牌）都被定义为一段在时间轴上延展的“块”（Block），其长度由基础耗时（Base Duration）和单位速度共同决定。</font>

#### <font style="color:rgb(31, 31, 31);">2.2.1 反比例衰减的数学模型</font>
<font style="color:rgb(31, 31, 31);">为了防止高速度导致游戏节奏失控（例如动作时间缩短为0），必须引入具有边际效应递减的数学模型。参考动作RPG与MOBA游戏中的攻击速度公式，建议采用反比例衰减模型而非线性减法模型</font><sup><font style="color:rgb(68, 71, 70);">9</font></sup><font style="color:rgb(31, 31, 31);">：</font>

<font style="color:rgb(31, 31, 31);"></font>$ T_{actual} = \frac{T_{base}}{1 + \alpha \times \frac{\mathcal{S}}{100}} $

<font style="color:rgb(31, 31, 31);">其中：</font>

+ $ T_{actual} $<font style="color:rgb(31, 31, 31);">：卡牌在时间轴上的实际执行时长（秒）。</font>
+ $ T_{base} $<font style="color:rgb(31, 31, 31);">：卡牌的基础耗时（例如“重火球术”基础耗时3.0秒）。</font>
+ $ \mathcal{S} $<font style="color:rgb(31, 31, 31);">：单位的当前速度属性值。</font>
+ $ \alpha $<font style="color:rgb(31, 31, 31);">：平衡系数，用于调整速度权重的敏感度（通常设为1.0）。</font>

深度解析与战术推论：

假设标准速度 $ \mathcal{S}=100 $，$ \alpha=1 $。

+ **<font style="color:rgb(31, 31, 31);">慢速重装单位（Speed 50）</font>**<font style="color:rgb(31, 31, 31);">：动作时长放大为 </font>$ T_{base} / 1.5 \approx 0.66 T_{base} $<font style="color:rgb(31, 31, 31);"> —— 此处需注意公式调整，通常对于低速单位（</font>$ \mathcal{S} < 100 $<font style="color:rgb(31, 31, 31);">），公式可能变形为 </font>$ T_{base} \times (1 + \text{slow\_factor}) $<font style="color:rgb(31, 31, 31);">，或者统一使用上述公式但 </font>$ \mathcal{S} $<font style="color:rgb(31, 31, 31);"> 值较小导致分母变小，从而 </font>$ T_{actual} $<font style="color:rgb(31, 31, 31);"> 变大。例如若 </font>$ \mathcal{S}=0 $<font style="color:rgb(31, 31, 31);">，时间为 </font>$ T_{base} $<font style="color:rgb(31, 31, 31);">；若 </font>$ \mathcal{S}=100 $<font style="color:rgb(31, 31, 31);">，时间为 </font>$ 0.5 T_{base} $<font style="color:rgb(31, 31, 31);">。</font>
+ **<font style="color:rgb(31, 31, 31);">极速刺客单位（Speed 300）</font>**<font style="color:rgb(31, 31, 31);">：分母为 </font>$ 1 + 3 = 4 $<font style="color:rgb(31, 31, 31);">，实际耗时仅为 </font>$ 0.25 T_{base} $<font style="color:rgb(31, 31, 31);">。</font>

<font style="color:rgb(31, 31, 31);">这种模型带来了一个深刻的战术博弈：</font>**<font style="color:rgb(31, 31, 31);">速度即是行动权（Action Economy）</font>**<font style="color:rgb(31, 31, 31);">。高速单位不仅能更早生效技能（先手优势），还能在敌方的一个大动作（如吟唱禁咒）期间，插入多次小动作进行打断或规避。这种机制直接响应了用户对于“速度快慢影响闪避/攻击”的需求，但不是通过RNG骰子，而是通过物理时间的压缩来实现</font><sup><font style="color:rgb(68, 71, 70);">12</font></sup><font style="color:rgb(31, 31, 31);">。</font>

### <font style="color:rgb(31, 31, 31);">2.3 移动与施法的同步结算逻辑</font>
<font style="color:rgb(31, 31, 31);">在传统的战棋（如《幽浮》系列）中，移动和攻击通常是串行的（先移动后攻击，或反之）。但在CKT的时空同步体系下，卡牌被定义为“混合动作向量”（Hybrid Action Vector）。</font>

+ **<font style="color:rgb(31, 31, 31);">移动施法（Mobile Casting）</font>**<font style="color:rgb(31, 31, 31);">：单位在移动过程中进行施法吟唱。此时，移动速度决定了位移的轨迹长度，而施法速度决定了火球出手的具体时刻（Frame）。</font>
+ **<font style="color:rgb(31, 31, 31);">战术博弈案例</font>**<font style="color:rgb(31, 31, 31);">：假设敌方AI预设了一张“定点爆破”卡牌，该攻击将在时间轴的 </font>$ T=2.5s $<font style="color:rgb(31, 31, 31);"> 时刻在坐标 </font>$ (x, y) $<font style="color:rgb(31, 31, 31);"> 处生效，爆炸半径 </font>$ r=3m $<font style="color:rgb(31, 31, 31);">。玩家单位位于该区域中心。</font>
    - <font style="color:rgb(31, 31, 31);">若玩家速度较低，移动出半径 </font>$ r $<font style="color:rgb(31, 31, 31);"> 需要 </font>$ 3.0s $<font style="color:rgb(31, 31, 31);">，则在 </font>$ T=2.5s $<font style="color:rgb(31, 31, 31);"> 时必然遭受打击。</font>
    - <font style="color:rgb(31, 31, 31);">若玩家通过装备或Buff提升了速度，使得移动出半径 </font>$ r $<font style="color:rgb(31, 31, 31);"> 仅需 </font>$ 2.0s $<font style="color:rgb(31, 31, 31);">，则在 </font>$ T=2.5s $<font style="color:rgb(31, 31, 31);"> 时，玩家单位已经位于安全区域。</font>
    - <font style="color:rgb(31, 31, 31);">系统判定：</font>$ Distance(Player_{t=2.5}, BlastCenter) > r $<font style="color:rgb(31, 31, 31);">，伤害为0。</font>

<font style="color:rgb(31, 31, 31);">这一过程完全移除了“闪避率”这一不透明的黑盒机制，取而代之的是清晰可见的物理博弈。玩家通过提升速度，实际上是在争取更大的</font>**<font style="color:rgb(31, 31, 31);">时空容错窗口（Spatio-Temporal Margin）</font>**<sup><font style="color:rgb(68, 71, 70);">14</font></sup><font style="color:rgb(31, 31, 31);">。</font>

---

## <font style="color:rgb(31, 31, 31);">3. 空间-时间解析系统（Chrono-Spatial Resolution）与UI交互</font>
<font style="color:rgb(31, 31, 31);">在同时回合制游戏中，最大的痛点在于玩家难以预知双方行动交织后的复杂结果。因此，构建一个直观、精确且具备预测功能的空间-时间解析系统是CKT成功的关键。这不仅仅是UI设计，更是核心玩法的可视化载体。</font>

### <font style="color:rgb(31, 31, 31);">3.1 时间轴UI与预测可视化 (Predictive Timeline UI)</font>
<font style="color:rgb(31, 31, 31);">参考《Phantom Brigade》与《John Wick Hex》的优秀实践，UI设计必须将抽象的时间概念具象化为可交互的实体</font><sup><font style="color:rgb(68, 71, 70);">17</font></sup><font style="color:rgb(31, 31, 31);">。屏幕下方应设有一个核心组件——</font>**<font style="color:rgb(31, 31, 31);">战术时间轴（Tactical Scrubber）</font>**<font style="color:rgb(31, 31, 31);">。</font>

#### <font style="color:rgb(31, 31, 31);">3.1.1 动态时间轴设计</font>
<font style="color:rgb(31, 31, 31);">时间轴横向延展，代表未来的5-10秒（一个回合的时长）。纵向则分层显示不同单位的行动轨道：</font>

+ **<font style="color:rgb(31, 31, 31);">顶层轨道（敌方情报层）</font>**<font style="color:rgb(31, 31, 31);">：显示已被侦测到的敌方单位行动。例如，敌方狙击手的攻击呈现为一条红色的长条，其中的关键帧（开火时刻）用高亮图标标记。</font>
+ **<font style="color:rgb(31, 31, 31);">中层轨道（玩家规划层）</font>**<font style="color:rgb(31, 31, 31);">：显示玩家当前选定单位的行动序列。玩家拖拽卡牌到此轨道，卡牌会根据单位速度自动伸缩长度。</font>
+ **<font style="color:rgb(31, 31, 31);">底层轨道（全局事件层）</font>**<font style="color:rgb(31, 31, 31);">：显示环境变化，如列车经过、甚至地图机制的触发。</font>

#### <font style="color:rgb(31, 31, 31);">3.1.2 幽灵轨迹（Ghost Trails）与交互推演</font>
<font style="color:rgb(31, 31, 31);">当玩家按住时间轴上的滑块（Scrubber）左右拖动时，游戏画面不应静止，而应实时演算并显示所有单位在那个时间点的位置预览——这就是“幽灵轨迹”系统</font><sup><font style="color:rgb(68, 71, 70);">20</font></sup><font style="color:rgb(31, 31, 31);">。</font>

+ **<font style="color:rgb(31, 31, 31);">敌方幽灵（红色）</font>**<font style="color:rgb(31, 31, 31);">：展示AI预设的移动路径。</font>
+ **<font style="color:rgb(31, 31, 31);">我方幽灵（蓝色）</font>**<font style="color:rgb(31, 31, 31);">：展示玩家当前规划的路径。</font>
+ **<font style="color:rgb(31, 31, 31);">交互点高亮（Intersection Highlight）</font>**<font style="color:rgb(31, 31, 31);">：这是CKT的UI核心创新点。当玩家拖动滑块，如果敌方攻击弹道（Hitbox）与我方单位模型（Hurtbox）在某一帧发生重叠，系统应立即在时间轴上标记一个“碰撞警告点”（Impact Warning），并在3D场景中用醒目的特效连接攻击者与受击者。这不仅是信息提示，更是战术反馈——告诉玩家“按照当前计划，你将在2.3秒时被击中”。</font>

### <font style="color:rgb(31, 31, 31);">3.2 物理判定机制：无RNG的几何闪避</font>
在CKT中，“闪避”不再是一个概率事件，而是一个几何与时间的函数。

设定每个单位拥有一个精确的受击判定框（Hurtbox）。所有的攻击手段——无论是近战挥砍、子弹射击还是魔法爆炸——都拥有其对应的攻击判定框（Hitbox）或射线（Raycast）5。

#### <font style="color:rgb(31, 31, 31);">3.2.1 速度作为防御机制的深层逻辑</font>
当敌方发出一枚具有追踪能力的魔法飞弹，该飞弹具有特定的飞行速度 $ V_{missile} $ 和最大转向角速度 $ \omega_{turn} $。

玩家单位若速度 $ \mathcal{S} $ 极高，可以通过规划一条急转弯（Sharp Turn）的移动路径。在物理引擎的每帧模拟中，飞弹会尝试修正航向指向玩家，但如果玩家切向速度过快，导致飞弹需要的转向半径小于其物理极限（$ R_{turn} = V_{missile} / \omega_{turn} $），飞弹就会因转向不足而与玩家擦肩而过。

这种机制被称为惯性闪避（Inertial Evasion）。它完全移除了运气成分，转而考验玩家对矢量、速度和惯性的战术把控3。

#### <font style="color:rgb(31, 31, 31);">3.2.2 擦弹（Grazing）与伤害梯度</font>
<font style="color:rgb(31, 31, 31);">为了增加数值的连续性与博弈的丰富度，可以引入“擦弹”概念。如果攻击的Hitbox仅仅擦到了单位Hurtbox的边缘（例如重叠面积 < 20%），且单位此时处于高速移动状态（Speed > 阈值），则系统判定为“擦伤”（Graze），伤害大幅降低（如减少80%）。这模拟了高速移动中难以被实心命中的物理现实，同时也给了玩家“极限操作”的快感与收益——为了最大化输出，玩家可能会故意贴着敌人的攻击边缘进行移动，利用“擦弹”获得的额外资源（如怒气值）来反击</font><sup><font style="color:rgb(68, 71, 70);">6</font></sup><font style="color:rgb(31, 31, 31);">。</font>

---

## <font style="color:rgb(31, 31, 31);">4. 战斗交互模型（Kinetic Interaction Model）：帧数据与博弈</font>
<font style="color:rgb(31, 31, 31);">借鉴格斗游戏（Fighting Games）的帧数据（Frame Data）理论，CKT将宏观的策略对决细化到了微观的帧级博弈。这不仅增加了游戏的动作感，也让“速度”属性的意义更加具体</font><sup><font style="color:rgb(68, 71, 70);">23</font></sup><font style="color:rgb(31, 31, 31);">。</font>

### <font style="color:rgb(31, 31, 31);">4.1 攻击阶段的三段式解析</font>
<font style="color:rgb(31, 31, 31);">在CKT的时间轴上，任何一张“攻击卡牌”的执行过程都被严格拆解为三个阶段，且这三个阶段的时长均受速度属性 </font>$ \mathcal{S} $<font style="color:rgb(31, 31, 31);"> 的修正：</font>

1. **<font style="color:rgb(31, 31, 31);">启动帧 (Startup / Wind-up)</font>**<font style="color:rgb(31, 31, 31);">：</font>
    - _<font style="color:rgb(31, 31, 31);">定义</font>_<font style="color:rgb(31, 31, 31);">：卡牌开始执行到伤害判定框（Hitbox）生成的这段时间。例如，法师举起法杖念咒，或者剑士向后蓄力。</font>
    - _<font style="color:rgb(31, 31, 31);">战术意义</font>_<font style="color:rgb(31, 31, 31);">：这是单位最脆弱的时刻（Vulnerability Window）。如果在此期间受到敌方的高冲击力攻击（如重锤），攻击可能会被</font>**<font style="color:rgb(31, 31, 31);">打断（Interrupt）</font>**<font style="color:rgb(31, 31, 31);">，导致卡牌失效且进入硬直。</font>
    - _<font style="color:rgb(31, 31, 31);">速度影响</font>_<font style="color:rgb(31, 31, 31);">：高速度极大地压缩启动帧，使得攻击更难被预判和打断，实现“先手压制”。</font>
2. **<font style="color:rgb(31, 31, 31);">持续帧 (Active / Hitbox Duration)</font>**<font style="color:rgb(31, 31, 31);">：</font>
    - _<font style="color:rgb(31, 31, 31);">定义</font>_<font style="color:rgb(31, 31, 31);">：伤害判定存在的窗口期。例如挥剑时的刀光轨迹，或持续喷射的火焰。</font>
    - _<font style="color:rgb(31, 31, 31);">战术意义</font>_<font style="color:rgb(31, 31, 31);">：这就是玩家需要规避的“危险时段”。对于多段攻击（如机枪扫射），持续帧越长，覆盖的区域和时间越广，封锁能力越强。</font>
    - _<font style="color:rgb(31, 31, 31);">速度影响</font>_<font style="color:rgb(31, 31, 31);">：通常不缩短持续帧的物理时长（为了保证特效与覆盖范围），但可能会增加伤害判定的频率（Tick Rate），例如从每0.5秒一跳变为每0.3秒一跳。</font>
3. **<font style="color:rgb(31, 31, 31);">恢复帧 (Recovery / Back-swing)</font>**<font style="color:rgb(31, 31, 31);">：</font>
    - _<font style="color:rgb(31, 31, 31);">定义</font>_<font style="color:rgb(31, 31, 31);">：攻击判定结束到单位恢复自由行动的时间。例如剑士收招的动作。</font>
    - _<font style="color:rgb(31, 31, 31);">战术意义</font>_<font style="color:rgb(31, 31, 31);">：这是攻击者的“破绽期”。如果一击未中（被对方利用速度闪避），攻击者将处于无法防御、无法移动的状态，极易遭受反击（Punish）。</font>
    - _<font style="color:rgb(31, 31, 31);">速度影响</font>_<font style="color:rgb(31, 31, 31);">：高速度显著缩短恢复帧，使得高速角色能够进行流畅的</font>**<font style="color:rgb(31, 31, 31);">连招（Combo）</font>**<font style="color:rgb(31, 31, 31);">，在极短的时间窗口内打出“位移-攻击-位移”的复杂操作序列，极大提升了操作上限</font><sup><font style="color:rgb(68, 71, 70);"></font></sup><font style="color:rgb(31, 31, 31);">。</font>

### <font style="color:rgb(31, 31, 31);">4.2 碰撞反馈：时停（Hitstop）与硬直（Stagger）</font>
<font style="color:rgb(31, 31, 31);">为了增强打击感并引入战术变数，当攻击命中时，应引入格斗游戏中的</font>**<font style="color:rgb(31, 31, 31);">时停/卡肉（Hitstop）</font>**<font style="color:rgb(31, 31, 31);">机制。</font>

+ **<font style="color:rgb(31, 31, 31);">机制描述</font>**<font style="color:rgb(31, 31, 31);">：当攻击判定成功（Hitbox与Hurtbox重叠），攻击者与受击者的动画时间轴同时暂停极短时间（例如0.1-0.2秒）。这在视觉上强化了“命中”的冲击力，同时给予玩家瞬间的确认感</font><sup><font style="color:rgb(68, 71, 70);">27</font></sup><font style="color:rgb(31, 31, 31);">。</font>
+ **<font style="color:rgb(31, 31, 31);">深层战术影响</font>**<font style="color:rgb(31, 31, 31);">：在多单位混战中，Hitstop不仅仅是视觉特效，它改变了时间流。如果一名角色正在高速移动穿越火线，被第一发子弹击中产生的Hitstop可能会导致其在后续的弹幕轨迹中“滞留”时间变长，从而吃到原本应该已经躲过的后续伤害。这种“被击中导致的微小时滞”引发的连锁反应（Ripple Effect），使得“避免第一次受击”变得至关重要，进一步强化了速度与闪避的价值。</font>

### <font style="color:rgb(31, 31, 31);">4.3 动画取消与变招（Animation Canceling）</font>
<font style="color:rgb(31, 31, 31);">在CKT的高级玩法中，可以允许玩家使用特殊资源（如“过载点数”或“专注值”）强制取消当前卡牌的后摇（Recovery Frames），直接衔接下一张卡牌。</font>

+ **<font style="color:rgb(31, 31, 31);">速度联动</font>**<font style="color:rgb(31, 31, 31);">：高速度属性可以降低取消动画所需的资源消耗，或者自动缩短不可取消的“僵直帧”比例。这使得高速角色在操作手感上更加“丝滑”，能够像格斗游戏一样进行“取消后摇-格挡”或“取消后摇-闪避”的高级博弈</font><sup><font style="color:rgb(68, 71, 70);"></font></sup><font style="color:rgb(31, 31, 31);">。</font>

---

## <font style="color:rgb(31, 31, 31);">5. 卡牌系统设计：时空指令集</font>
<font style="color:rgb(31, 31, 31);">在CKT中，卡牌是玩家干涉物理世界与时间流的唯一接口。不同于传统卡牌游戏的“造成X点伤害”，CKT的卡牌更像是“时空指令脚本”。</font>

### <font style="color:rgb(31, 31, 31);">5.1 卡牌的分类与速度耦合</font>
#### <font style="color:rgb(31, 31, 31);">5.1.1 动能系卡牌 (Kinetic Cards)</font>
<font style="color:rgb(31, 31, 31);">这类卡牌专注于位移与位置控制，受移动速度影响最大。</font>

+ **<font style="color:rgb(31, 31, 31);">瞬发位移 (Dash)</font>**<font style="color:rgb(31, 31, 31);">：</font>
    - _<font style="color:rgb(31, 31, 31);">机制</font>_<font style="color:rgb(31, 31, 31);">：提供极高的瞬间速度加成，持续时间极短（如0.2秒）。</font>
    - _<font style="color:rgb(31, 31, 31);">战术</font>_<font style="color:rgb(31, 31, 31);">：专门用于在敌方AOE落地的瞬间（Impact Frame）脱离判定范围。类似于《黑暗之魂》的翻滚，但不依赖无敌帧（i-frames），而是依赖物理移除。</font>
+ **<font style="color:rgb(31, 31, 31);">惯性滑步 (Drift)</font>**<font style="color:rgb(31, 31, 31);">：</font>
    - _<font style="color:rgb(31, 31, 31);">机制</font>_<font style="color:rgb(31, 31, 31);">：允许单位在保持当前朝向和射击姿态的同时，利用惯性向侧方高速移动。</font>
    - _<font style="color:rgb(31, 31, 31);">战术</font>_<font style="color:rgb(31, 31, 31);">：用于“风筝”战术（Kiting），一边后退/侧滑一边输出，保持敌人在射程内但自己在敌方射程外。</font>

#### <font style="color:rgb(31, 31, 31);">5.1.2 时空系卡牌 (Chrono Cards)</font>
<font style="color:rgb(31, 31, 31);">这类卡牌直接干涉时间轴的流速，受施法速度影响。</font>

+ **<font style="color:rgb(31, 31, 31);">时缓力场 (Time Dilation Field)</font>**<font style="color:rgb(31, 31, 31);">：</font>
    - _<font style="color:rgb(31, 31, 31);">机制</font>_<font style="color:rgb(31, 31, 31);">：在指定区域生成力场，进入该区域的所有单位（不分敌我）时间流速减半（</font>$ k = 0.5 $<font style="color:rgb(31, 31, 31);">）。</font>
    - _<font style="color:rgb(31, 31, 31);">战术</font>_<font style="color:rgb(31, 31, 31);">：用来限制敌方高速刺客的切入，或者延长敌方炸弹的倒计时，给我方争取撤离时间。</font>
+ **<font style="color:rgb(31, 31, 31);">超频 (Overclock)</font>**<font style="color:rgb(31, 31, 31);">：</font>
    - _<font style="color:rgb(31, 31, 31);">机制</font>_<font style="color:rgb(31, 31, 31);">：消耗生命值，使自身在接下来的3秒内速度翻倍（</font>$ k = 2.0 $<font style="color:rgb(31, 31, 31);">）。</font>
    - _<font style="color:rgb(31, 31, 31);">战术</font>_<font style="color:rgb(31, 31, 31);">：绝境反击，利用超高速度在极短时间内打空手牌，瞬间爆发输出</font><sup><font style="color:rgb(68, 71, 70);">32</font></sup><font style="color:rgb(31, 31, 31);">。</font>

#### <font style="color:rgb(31, 31, 31);">5.1.3 攻防系卡牌 (Combat Cards)</font>
<font style="color:rgb(31, 31, 31);">这类卡牌是主要的输出手段，受攻击速度影响。</font>

+ **<font style="color:rgb(31, 31, 31);">居合斩 (Flash Draw)</font>**<font style="color:rgb(31, 31, 31);">：</font>
    - _<font style="color:rgb(31, 31, 31);">机制</font>_<font style="color:rgb(31, 31, 31);">：启动帧极长，攻击范围大，伤害高。但如果速度够快，可以压缩启动帧到敌人反应不过来的程度。</font>
    - _<font style="color:rgb(31, 31, 31);">战术</font>_<font style="color:rgb(31, 31, 31);">：配合“预读”能力，预判敌人移动路径，在其必经之路上“置放”一次强力斩击。</font>
+ **<font style="color:rgb(31, 31, 31);">弹幕压制 (Suppression Fire)</font>**<font style="color:rgb(31, 31, 31);">：</font>
    - _<font style="color:rgb(31, 31, 31);">机制</font>_<font style="color:rgb(31, 31, 31);">：持续帧很长，扫射一个扇形区域。</font>
    - _<font style="color:rgb(31, 31, 31);">战术</font>_<font style="color:rgb(31, 31, 31);">：区域封锁（Area Denial）。逼迫敌方必须绕路或使用防御技能，限制其高速度带来的走位优势。</font>

### <font style="color:rgb(31, 31, 31);">5.2 资源循环：热量与行动力</font>
<font style="color:rgb(31, 31, 31);">为了平衡高速度带来的绝对优势，必须引入**负荷（Load/Heat）**机制。</font>

+ **<font style="color:rgb(31, 31, 31);">热量积累</font>**<font style="color:rgb(31, 31, 31);">：高速移动和快速攻击会产生大量的“热量”。</font>
+ **<font style="color:rgb(31, 31, 31);">过热惩罚</font>**<font style="color:rgb(31, 31, 31);">：当热量超过阈值，单位将进入“过热状态”，速度属性 </font>$ \mathcal{S} $<font style="color:rgb(31, 31, 31);"> 强制降低50%，且无法使用位移类卡牌。</font>
+ **<font style="color:rgb(31, 31, 31);">博弈循环</font>**<font style="color:rgb(31, 31, 31);">：玩家必须在“爆发输出/闪避”与“控温/恢复”之间做决策。是现在爆发极速躲避并反击，导致下一回合过热任人宰割？还是保留体力，承受轻微伤害？这种资源管理增加了战术的厚度。</font>

---

## <font style="color:rgb(31, 31, 31);">6. AI架构：预测与反预测的博弈</font>
<font style="color:rgb(31, 31, 31);">在同时回合制（WEGO）游戏中，AI设计的核心难点在于：它不能简单地“对当前状态”做出反应，因为它必须处理“未来状态”。同时，为了保证公平性和乐趣，AI不能作弊（即在玩家确定行动后才决定行动）。</font>

### <font style="color:rgb(31, 31, 31);">6.1 预测模型：蒙特卡洛与热图</font>
<font style="color:rgb(31, 31, 31);">参考《Frozen Synapse》的AI逻辑，CKT的AI应基于**概率场（Probability Fields）**进行决策</font><sup><font style="color:rgb(68, 71, 70);">34</font></sup><font style="color:rgb(31, 31, 31);">。</font>

1. **<font style="color:rgb(31, 31, 31);">意图模拟</font>**<font style="color:rgb(31, 31, 31);">：AI分析玩家单位当前的位置、速度矢量、朝向以及剩余手牌类型。基于这些信息，AI在后台运行多次蒙特卡洛模拟（Monte Carlo Simulation），预测玩家未来3-5秒内最可能到达的位置。</font>
2. **<font style="color:rgb(31, 31, 31);">热图生成 (Heatmap Generation)</font>**<font style="color:rgb(31, 31, 31);">：</font>
    - <font style="color:rgb(31, 31, 31);">系统将模拟结果叠加，生成一张“玩家位置热图”。</font>
    - **<font style="color:rgb(31, 31, 31);">速度的影响</font>**<font style="color:rgb(31, 31, 31);">：玩家单位速度越快，其在5秒内能到达的区域越大，热图越分散（熵值越高）。这意味着高速玩家让AI更难预测准确位置，从而降低了AI攻击的命中率。这从AI逻辑层面赋予了速度属性“隐性闪避”的价值。</font>
3. **<font style="color:rgb(31, 31, 31);">最优解选择</font>**<font style="color:rgb(31, 31, 31);">：AI计算各种攻击方案的期望收益（Expected Value）。</font>
    - <font style="color:rgb(31, 31, 31);">针对低速玩家（热图集中），AI会选择高伤害定点打击。</font>
    - <font style="color:rgb(31, 31, 31);">针对高速玩家（热图分散），AI会选择宽范围、低伤害的覆盖射击，或者预判玩家必须经过的“咽喉点”（Choke Points）。</font>

### <font style="color:rgb(31, 31, 31);">6.2 信号释放（Telegraphing）与信息战</font>
<font style="color:rgb(31, 31, 31);">为了给玩家提供反制机会，AI的意图必须以某种形式可视化，但这种可视化可以是“模糊”的</font><sup><font style="color:rgb(68, 71, 70);">36</font></sup><font style="color:rgb(31, 31, 31);">。</font>

+ **<font style="color:rgb(31, 31, 31);">视线锥（Vision Cones）</font>**<font style="color:rgb(31, 31, 31);">：显示AI当前关注的区域。</font>
+ **<font style="color:rgb(31, 31, 31);">预瞄线（Aim Lines）</font>**<font style="color:rgb(31, 31, 31);">：</font>
    - <font style="color:rgb(31, 31, 31);">对于简单的敌人，预瞄线直接锁定玩家</font>**<font style="color:rgb(31, 31, 31);">当前</font>**<font style="color:rgb(31, 31, 31);">位置（玩家只要动就能躲开）。</font>
    - <font style="color:rgb(31, 31, 31);">对于精英敌人，预瞄线锁定玩家的</font>**<font style="color:rgb(31, 31, 31);">未来预测位置</font>**<font style="color:rgb(31, 31, 31);">（即热图最热点）。玩家需要通过“假动作”（先向左跑，在回合结算前突然改向右）来欺骗AI的预测算法。</font>
+ **<font style="color:rgb(31, 31, 31);">信息迷雾</font>**<font style="color:rgb(31, 31, 31);">：玩家可以使用“干扰”类卡牌，隐藏自己的意图线，或者制造虚假的幽灵轨迹来诱导AI攻击错误位置。</font>

---

## <font style="color:rgb(31, 31, 31);">7. 技术实现方案：基于Godot引擎的架构</font>
<font style="color:rgb(31, 31, 31);">鉴于Godot引擎在节点系统、GDScript脚本语言以及轻量级架构方面的优势，它是实现CKT系统的理想选择。本节将深入探讨如何在Godot中从零构建这一复杂的时空同步系统。</font>

### <font style="color:rgb(31, 31, 31);">7.1 核心架构：命令模式（Command Pattern）</font>
<font style="color:rgb(31, 31, 31);">为了实现时间轴的拖动回溯、撤销（Undo）、重做（Redo）以及最终的同步回放，必须采用严格的</font>**<font style="color:rgb(31, 31, 31);">命令模式</font>**<font style="color:rgb(31, 31, 31);">将所有游戏行为对象化</font><sup><font style="color:rgb(68, 71, 70);">38</font></sup><font style="color:rgb(31, 31, 31);">。</font>

#### <font style="color:rgb(31, 31, 31);">7.1.1 数据结构设计</font>
<font style="color:rgb(68, 71, 70);">GDScript</font>

```plain
class_name CombatAction extends Resource

# 核心属性
var unit_id: int          # 执行单位ID
var action_type: int      # 动作类型 (MOVE, ATTACK, SKILL)
var start_time: float     # 在时间轴上的开始时间
var duration: float       # 持续时长 (由速度计算得出)
var target_data: Dictionary # 目标坐标或目标单位ID
var curve: Curve2D        # 移动路径 (如果是移动动作)

# 关键方法：状态预览
# 用于在拖动时间轴时，计算该动作在特定时间点t的状态
func evaluate_state(t: float) -> Dictionary:
    var progress = (t - start_time) / duration
    progress = clamp(progress, 0.0, 1.0)
    
    # 比如对于移动，返回插值后的位置
    if action_type == ACTION_MOVE:
        return { "position": curve.sample_baked(progress * curve.get_baked_length()) }
    return {}
```

#### <font style="color:rgb(31, 31, 31);">7.1.2 时间轴管理器 (TimelineManager)</font>
<font style="color:rgb(31, 31, 31);">创建一个全局单例或主场景节点 </font>`<font style="color:rgb(68, 71, 70);">TimelineManager</font>`<font style="color:rgb(31, 31, 31);">，维护一个 </font>`<font style="color:rgb(68, 71, 70);">commands</font>`<font style="color:rgb(31, 31, 31);"> 数组。</font>

+ **<font style="color:rgb(31, 31, 31);">录制阶段</font>**<font style="color:rgb(31, 31, 31);">：玩家的操作不直接修改单位属性，而是实例化 </font>`<font style="color:rgb(68, 71, 70);">CombatAction</font>`<font style="color:rgb(31, 31, 31);"> 对象并推入数组。</font>
+ **<font style="color:rgb(31, 31, 31);">预览阶段</font>**<font style="color:rgb(31, 31, 31);">：当玩家拖动UI上的Scrubber（滑块）时，</font>`<font style="color:rgb(68, 71, 70);">TimelineManager</font>`<font style="color:rgb(31, 31, 31);"> 获取当前滑块时间 </font>$ T $<font style="color:rgb(31, 31, 31);">，遍历所有 </font>`<font style="color:rgb(68, 71, 70);">CombatAction</font>`<font style="color:rgb(31, 31, 31);">，调用 </font>`<font style="color:rgb(68, 71, 70);">evaluate_state(T)</font>`<font style="color:rgb(31, 31, 31);">，并将结果应用到场景中的“幽灵单位”（Ghost Units）上，实现实时预览</font><sup><font style="color:rgb(68, 71, 70);">41</font></sup><font style="color:rgb(31, 31, 31);">。</font>

### <font style="color:rgb(31, 31, 31);">7.2 确定性物理模拟 (Deterministic Physics Implementation)</font>
<font style="color:rgb(31, 31, 31);">Godot的内置物理引擎（PhysicsServer2D/3D）通常基于迭代解算器，可能因帧率波动（Delta Time）导致微小的非确定性。在CKT中，必须保证玩家在预览时看到的结果与最终执行时完全一致。</font>

#### <font style="color:rgb(31, 31, 31);">7.2.1 分离物理空间与逻辑模拟</font>
<font style="color:rgb(31, 31, 31);">建议不直接依赖 </font>`<font style="color:rgb(68, 71, 70);">_physics_process</font>`<font style="color:rgb(31, 31, 31);"> 进行游戏逻辑判定，而是构建一套独立的逻辑模拟层</font><sup><font style="color:rgb(68, 71, 70);">43</font></sup><font style="color:rgb(31, 31, 31);">。</font>

1. **<font style="color:rgb(31, 31, 31);">影子世界 (Shadow World)</font>**<font style="color:rgb(31, 31, 31);">：利用 </font>`<font style="color:rgb(68, 71, 70);">PhysicsServer2D.space_create()</font>`<font style="color:rgb(31, 31, 31);"> 创建一个独立的、不用于渲染的物理空间。</font>
2. **<font style="color:rgb(31, 31, 31);">定点数数学库 (Fixed-point Math)</font>**<font style="color:rgb(31, 31, 31);">：或者使用严格控制步长的浮点数计算。所有移动和碰撞检测通过纯数学公式（如射线检测 </font>`<font style="color:rgb(68, 71, 70);">intersect_ray</font>`<font style="color:rgb(31, 31, 31);">、形状检测 </font>`<font style="color:rgb(68, 71, 70);">intersect_shape</font>`<font style="color:rgb(31, 31, 31);">）在逻辑层完成。</font>

<font style="color:rgb(31, 31, 31);">预演算法：</font>

<font style="color:rgb(31, 31, 31);">在玩家做出决策的一瞬间，系统在后台快速运行（Fast-forward）：</font>

3. <font style="color:rgb(68, 71, 70);">GDScript</font>

```plain
# 伪代码：预测未来5秒的物理状态
var simulated_time = 0.0
var time_step = 0.05 # 20Hz模拟
while simulated_time < turn_duration:
    for unit in all_units:
        unit.update_logic_position(time_step)
    check_collisions() # 检测碰撞并记录
    simulated_time += time_step
```

<font style="color:rgb(31, 31, 31);">这一过程计算出的碰撞事件、伤害数值将被缓存，用于驱动UI上的“红线警告”绘制</font><sup><font style="color:rgb(68, 71, 70);">45</font></sup><font style="color:rgb(31, 31, 31);">。</font>

### <font style="color:rgb(31, 31, 31);">7.3 视觉表现与轨迹绘制</font>
<font style="color:rgb(31, 31, 31);">利用Godot强大的2D/3D绘图能力实现战术信息的可视化。</font>

+ **<font style="color:rgb(31, 31, 31);">轨迹线 (Trajectory Lines)</font>**<font style="color:rgb(31, 31, 31);">：使用 </font>`<font style="color:rgb(68, 71, 70);">Line2D</font>`<font style="color:rgb(31, 31, 31);"> 节点。根据 </font>`<font style="color:rgb(68, 71, 70);">CombatAction</font>`<font style="color:rgb(31, 31, 31);"> 中的路径数据点进行绘制。可以在直线上应用 </font>`<font style="color:rgb(68, 71, 70);">Shader</font>`<font style="color:rgb(31, 31, 31);">，使线条流动，流速代表单位的移动速度——高速单位的轨迹线流动更快，视觉上更具动感</font><sup><font style="color:rgb(68, 71, 70);"></font></sup><font style="color:rgb(31, 31, 31);">。</font>
+ **<font style="color:rgb(31, 31, 31);">时间轴渲染</font>**<font style="color:rgb(31, 31, 31);">：使用自定义的 </font>`<font style="color:rgb(68, 71, 70);">Control</font>`<font style="color:rgb(31, 31, 31);"> 节点，重写 </font>`<font style="color:rgb(68, 71, 70);">_draw()</font>`<font style="color:rgb(31, 31, 31);"> 方法。在矩形块上绘制波形或关键帧图标（如攻击判定的起始点），帮助玩家精确把控时机</font><sup><font style="color:rgb(68, 71, 70);"></font></sup><font style="color:rgb(31, 31, 31);">。</font>

### <font style="color:rgb(31, 31, 31);">7.4 动画同步 (Animation Sync)</font>
<font style="color:rgb(31, 31, 31);">在执行阶段（Resolution Phase），必须确保动画与逻辑完美同步。</font>

+ <font style="color:rgb(31, 31, 31);">使用 </font>`<font style="color:rgb(68, 71, 70);">AnimationPlayer</font>`<font style="color:rgb(31, 31, 31);">，但不依赖它的自动播放。</font>
+ <font style="color:rgb(31, 31, 31);">在 _process(delta) 中，根据当前的全局战斗时间 battle_time，手动设置动画进度：</font>

`<font style="color:rgb(31, 31, 31);">animation_player.seek(battle_time - action_start_time, true)</font>`

+ **<font style="color:rgb(31, 31, 31);">速度映射</font>**<font style="color:rgb(31, 31, 31);">：利用 </font>`<font style="color:rgb(68, 71, 70);">AnimationPlayer.playback_speed</font>`<font style="color:rgb(31, 31, 31);"> 属性，将其绑定为单位速度 </font>$ \mathcal{S} $<font style="color:rgb(31, 31, 31);"> 的函数。当单位速度变化时（如触发加速Buff），动画播放速度实时平滑过渡</font><sup><font style="color:rgb(68, 71, 70);"></font></sup><font style="color:rgb(31, 31, 31);">。</font>

---

## <font style="color:rgb(31, 31, 31);">8. 用户体验（UX）设计：从认知负荷到心流体验</font>
<font style="color:rgb(31, 31, 31);">CKT系统极其复杂，包含四维信息（3D空间+时间）。如果UI设计不当，极易造成玩家的认知过载（Cognitive Overload）。UX设计的核心目标是“降维打击”——将复杂信息直观化。</font>

### <font style="color:rgb(31, 31, 31);">8.1 信息的层级展示</font>
+ **<font style="color:rgb(31, 31, 31);">一级信息（关注点）</font>**<font style="color:rgb(31, 31, 31);">：直接的威胁。例如，即将命中的红色弹道线应高亮、加粗并伴有脉冲动画。</font>
+ **<font style="color:rgb(31, 31, 31);">二级信息（背景）</font>**<font style="color:rgb(31, 31, 31);">：潜在的威胁。例如，敌人的视线锥、环境的掩体位置，应使用半透明、低饱和度的颜色显示。</font>
+ **<font style="color:rgb(31, 31, 31);">三级信息（数据）</font>**<font style="color:rgb(31, 31, 31);">：具体的数值（如“命中率30%”、“伤害50”）。这些应折叠，只有当鼠标悬停时才显示浮窗（Tooltip），避免满屏数字干扰视线。</font>

### <font style="color:rgb(31, 31, 31);">8.2 智能辅助系统</font>
<font style="color:rgb(31, 31, 31);">为了降低操作门槛，系统应提供智能辅助：</font>

+ **<font style="color:rgb(31, 31, 31);">吸附功能 (Snapping)</font>**<font style="color:rgb(31, 31, 31);">：当玩家拖动时间轴时，如果某个关键事件（如闪避成功的瞬间、攻击命中的瞬间）临近，滑块应有轻微的“吸附感”，帮助玩家精确定位到那个毫秒</font><sup><font style="color:rgb(68, 71, 70);">36</font></sup><font style="color:rgb(31, 31, 31);">。</font>
+ **<font style="color:rgb(31, 31, 31);">自动规划建议</font>**<font style="color:rgb(31, 31, 31);">：对于新手玩家，AI助手可以提供一键规划功能（例如“最大化闪避”或“最大化输出”），生成一条参考的时间轴序列，玩家可以在此基础上进行微调。</font>

### <font style="color:rgb(31, 31, 31);">8.3 速度感知的多感官反馈</font>
<font style="color:rgb(31, 31, 31);">除了数值，必须通过视听语言让玩家“感觉”到速度</font><sup><font style="color:rgb(68, 71, 70);"></font></sup><font style="color:rgb(31, 31, 31);">。</font>

+ **<font style="color:rgb(31, 31, 31);">视觉</font>**<font style="color:rgb(31, 31, 31);">：高速单位移动时产生残影（TrailRenderer）、运动模糊（Motion Blur）。当发生极高速度的闪避时，画面可以瞬间轻微色差偏移（Chromatic Aberration），模拟极速对空间的扰动。</font>
+ **<font style="color:rgb(31, 31, 31);">听觉</font>**<font style="color:rgb(31, 31, 31);">：音效的音调（Pitch）随速度变化。高速动作的音效更尖锐、急促。进入“子弹时间”规划模式时，背景音乐低通滤波（Low-pass Filter），营造沉浸的思维空间。</font>

---

## <font style="color:rgb(31, 31, 31);">9. 结论与展望</font>
<font style="color:rgb(31, 31, 31);">“时空同步战术”（CKT）体系是对传统策略游戏的一次大胆解构与重组。通过引入“速度统一论”，它解决了传统回合制中移动与施法割裂的痛点；通过“同时回合制”与“确定性物理模拟”，它移除了令人沮丧的RNG机制，代之以纯粹的战术博弈与物理直觉。</font>

<font style="color:rgb(31, 31, 31);">本报告所提出的架构，从底层的数学模型（反比例速度公式），到中层的AI预测逻辑（热图与蒙特卡洛），再到上层的Godot技术实现（命令模式与幽灵世界），构成了一个闭环的、可落地的设计方案。</font>

<font style="color:rgb(31, 31, 31);">未来的开发重点应集中在：</font>

1. **<font style="color:rgb(31, 31, 31);">算法优化</font>**<font style="color:rgb(31, 31, 31);">：确保在大量单位存在时，后台的物理预演（Prediction）仍能保持60FPS的流畅度。</font>
2. **<font style="color:rgb(31, 31, 31);">UI打磨</font>**<font style="color:rgb(31, 31, 31);">：不断迭代时间轴的交互体验，使其像视频剪辑软件一样精准且易用。</font>
3. **<font style="color:rgb(31, 31, 31);">内容扩展</font>**<font style="color:rgb(31, 31, 31);">：设计更多利用时空机制的创意卡牌（如时间倒流、空间置换），充分挖掘CKT系统的玩法潜力。</font>

<font style="color:rgb(31, 31, 31);">CKT不仅是一个游戏机制，更是一种全新的交互语言。它让玩家不再仅仅是指挥官，更是编排死亡与艺术的舞蹈家，在毫秒级的时空缝隙中，体验智力与反应的双重巅峰。</font>

