# 03. Timeline UI & Visualization

## 1. The Tactical Scrubber
The core UI component is the Timeline Scrubber at the bottom of the screen.
*   **Horizontal Axis**: Time (Future 5-10s).
*   **Vertical Tracks**:
    *   **Intel Layer**: Known enemy actions (Red).
    *   **Planning Layer**: Player actions (Blue).
    *   **Global Layer**: Environmental events.

## 2. Ghost Trails (Predictive Visualization)
Dragging the scrubber must update the 3D scene to show the state of the world at that specific time $t$.
*   **Ghost Units**: Semi-transparent models representing future positions.
*   **Interpolation**: Smooth movement between keyframes.

## 3. Intersection Highlights
*   **Collision Warning**: If a Ghost Unit intersects a future Hitbox at the scrubber time, visual indicators (Red Lines/Flash) must appear.
*   **Snapping**: The scrubber should snap to critical events (Impact frames, Start/End of actions).

## 4. UX Hierarchy
1.  **Immediate Threat (High Contrast)**: Incoming damage.
2.  **Potential Threat (Translucent)**: Enemy vision cones, aim lines.
3.  **Data (Tooltip)**: Exact numbers, hit chances (if any).
