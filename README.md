# 🏁 Project: Rush Race

## Game Design Document (Short Version)

---

## 1. Game Overview

**Rush Race** is a simple 2D racing game that simulates forward movement using a horizontal **Parallax2D** scrolling system.

The player controls a car that switches lanes while random AI cars spawn ahead as obstacles. Collisions reduce speed instead of causing an instant game over. The goal is to survive as long as possible while maintaining high speed.

**Genre:** Arcade / Endless Racing  
**Platform:** PC  
**Status:** Prototype  

---

## 2. Core Gameplay

### Core Loop

1. Drive at increasing speed.
2. Avoid randomly spawned cars.
3. Collide → lose speed.
4. Recover speed over time.
5. Survive and increase score.

---

## 3. Core Mechanics

### Movement
- Player switches between fixed lanes (left/right).
- The car stays centered horizontally.
- Background scrolls to simulate movement.

### Parallax System
Multiple background layers move at different speeds:
- Sky (slowest)
- Mid background
- Foreground
- Road (full speed)

Layer speed = `currentSpeed × multiplier`

### Traffic System
- Cars spawn at random intervals.
- Random lane selection.
- Spawn rate increases over time.
- Different vehicle sizes possible.

### Collision System
- On impact: speed decreases by a percentage.
- Speed regenerates gradually.
- Game over when speed reaches 0.

---

## 4. Scoring

Score is based on distance traveled and current speed.
