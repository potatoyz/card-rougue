# 01. Core Mechanics: Speed, Time, and Actions

## 1. Introduction: The Paradigm Shift
Chrono-Kinetic Tactics (CKT) represents a shift from "IGOUGO" (I Go, You Go) turn-based systems to a **Simultaneous Turn-Based (WEGO)** model. The core vision is to unify "Speed" as the governing attribute for both space and time, replacing RNG-based outcomes with physics-based interactions.

## 2. Unified Speed Theory
In CKT, **Speed ($\mathcal{S}$)** is the single attribute that controls:
1.  **Spatial Span**: Distance covered in a time window.
2.  **Temporal Compression**: Time required to execute actions.

### 2.1 The Formula
To prevent infinite speed scaling, we use an inverse proportional formula:

$$ T_{actual} = \frac{T_{base}}{1 + \alpha \times \frac{\mathcal{S}}{100}} $$

Where:
*   $T_{actual}$: Actual duration of the action (seconds).
*   $T_{base}$: Base duration of the action.
*   $\mathcal{S}$: Unit's Speed attribute.
*   $\alpha$: Scaling factor (default 1.0).

**Implication**: Speed is Action Economy. A unit with double speed acts twice as often (or moves twice as far) in the same timeframe.

### 2.2 Mobile Casting & Hybrid Actions
Actions are not static. Units can move while casting or attacking.
*   **Mobile Casting**: A mage can channel a spell while moving. Speed determines the distance traveled during the channel time.
*   **Evasion**: Dodge is not a % chance. It is a physical act of moving out of a hitbox's path before it activates.

## 3. Card System: Chrono-Kinetic Directives
Cards are the interface for intervening in the timeline.

### 3.1 Kinetic Cards (Movement)
*   **Dash**: High speed burst, short duration. Used to escape impact frames.
*   **Drift**: Lateral movement while maintaining facing/aim.

### 3.2 Chrono Cards (Time Manipulation)
*   **Time Dilation Field**: Slows time ($k=0.5$) in an area.
*   **Overclock**: Costs HP to double speed ($k=2.0$) for a short duration.

### 3.3 Combat Cards (Offense)
*   **Flash Draw**: Long startup, high damage. Speed compresses startup.
*   **Suppression Fire**: Long active frames, area denial.

### 3.4 Resource: Heat/Load
High speed generates **Heat**. Exceeding a threshold causes **Overheat** (Speed halved, movement locked). This creates a "Burst vs. Sustain" economy.
