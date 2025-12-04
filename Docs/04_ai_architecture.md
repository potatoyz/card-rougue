# 04. AI Architecture: Prediction & Counter-Prediction

## 1. The WEGO Challenge
AI cannot react to *current* state; it must predict *future* state. It must not cheat (i.e., it decides before the player finalizes).

## 2. Probability Fields
AI uses Monte Carlo simulations to generate **Heatmaps** of probable player positions.
*   **Input**: Player's current position, velocity, and available cards.
*   **Output**: A probability distribution of where the player *could* be in 3-5 seconds.
*   **Speed Factor**: Higher player speed = wider heat spread (higher entropy) = lower AI accuracy.

## 3. Decision Logic
*   **Vs. Low Speed**: Pinpoint attacks on high-probability clusters.
*   **Vs. High Speed**: Area denial (AoE) or Choke Point camping.

## 4. Telegraphing (Information Warfare)
AI intentions must be visualized to allow counter-play.
*   **Vision Cones**: Where AI is looking.
*   **Aim Lines**:
    *   **Static**: Aiming at current position.
    *   **Predictive**: Aiming at predicted future position (requires player to juke).
