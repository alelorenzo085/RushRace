# 🏁 Project: Rush Race

---

## 1. Game Overview

**Rush Race** is a 2D arcade racing game built in **Godot 4 / GDScript**. The player drives a car across a horizontally scrolling highway, dodging randomly spawned traffic vehicles. The goal is to reach the **finish line at 4,000 m** without colliding with any obstacle. A single collision ends the run immediately.

**Genre:** Arcade / Racing  
**Platform:** PC  
**Engine:** Godot 4 — GDScript  
**Status:** Prototype  

---

## 2. Core Gameplay

### Core Loop

1. **Accelerate** — hold Right Arrow / D to gain speed (up to 1,500 px/s).
2. **Steer** — use Up / Down arrows to move within road boundaries.
3. **Avoid** obstacles spawned 1,500 px ahead of the car.
4. **Survive** long enough to reach the finish line at X = 40,000 px.
5. **Collide** with any obstacle → instant Game Over.

### Win / Lose Conditions

| Condition | Trigger | Result |
|-----------|---------|--------|
| ✅ Win | Car enters `FinishLine` Area2D at X = 40,000 | `Win.tscn` — score displayed |
| ❌ Game Over | Obstacle `body_entered` fires on the player car | `GameOver.tscn` — score displayed |

---

## 3. Core Mechanics

### Movement — `car.gd`

Input actions: `move_left` / `move_right` / `move_up` / `move_down`

| Parameter | Value | Notes |
|-----------|-------|-------|
| `max_speed` | 1,500 px/s | Top horizontal speed |
| `acceleration` | 1,200 px/s² | Speed gained per second while key held |
| `deceleration` | 100 px/s² | Speed lost per second when key released |
| Road Y limits | 180 – 310 px | Enforced by `clamp()` every frame |
| Steer ratio | `velocity.x × 0.1` | Vertical speed proportional to horizontal |

- The car **cannot reverse** (negative X velocity is clamped to 0).
- Steering is only active when `velocity.x > 0`.
- Animation `speed_scale` is set to `velocity.x / max_speed`.
- Engine audio plays when speed exceeds **50 px/s**.

### Parallax System — `road.tscn`

| Layer | Node | Scroll Scale | Effect |
|-------|------|-------------|--------|
| Sky / background | `Background` | 0.05 | Barely moves — distant horizon |
| Sun | `Sun` | autoscroll 10 px/s | Slow constant drift |
| City buildings | `Buildings` | 0.075 | Slow parallax mid-distance |
| Palm trees (bg) | `Palms` | 0.25 | Medium parallax |
| Road / highway | `Highway` | 1.0 | Full speed — ground layer |
| Palm trees (fg) | `PalmTree` | 1.5 | Faster than road — foreground depth |

### Traffic System — `rush-race.gd` + `obstacle.gd`

A `Timer` node fires repeatedly and instantiates `obstacle.tscn` each timeout.

| Parameter | Value | Notes |
|-----------|-------|-------|
| Spawn offset | `car.global_position.x + 1,500 px` | Always outside camera view |
| Spawn Y | `randi_range(180, 310)` | Random position within road |
| `min_speed` | 500 px/s | Slowest traffic car |
| `max_speed` | 1,500 px/s | Fastest traffic car |
| Sprite pool | 17 vehicles | Picked randomly on each spawn |
| Despawn | `VisibleOnScreenNotifier2D` | `queue_free()` when off screen |

Collision shape is sized dynamically: `width × 1.5`, `height ÷ 3`, aligned to the bottom of the sprite.

### Collision System

- **Obstacle → Player:** `body_entered` sets `car.velocity = Vector2.ZERO` and emits `hit_player` → main scene calls `_game_over()` via `call_deferred`.
- **Player → Finish Line:** `FinishLine` Area2D at X = 40,000 detects `CharacterBody2D` entry → calls `_win()` via `call_deferred`.

---

## 4. Scoring

Score equals the **distance traveled in metres**, calculated each frame:

```gdscript
distance = int(car.global_position.x / 10)
```

The HUD updates every frame:

```
Score: X m  |  Meta: Y m
```

On Game Over or Win, the final distance is stored in `Global.score` (Autoload singleton) and shown on the result screen.

| Event | Score Value |
|-------|------------|
| Game Over | Distance at moment of collision |
| Win | Distance at finish line crossing (≈ 4,000 m) |

---

## 5. Scenes & Architecture

```
rush-race/
├── rush-race.tscn        # Main gameplay scene
├── rush-race.gd          # Game loop, spawner, finish line, win/lose logic
├── car/
│   ├── car.tscn          # Player CharacterBody2D
│   └── car.gd            # Movement, animation, engine sound
├── obstacle/
│   ├── obstacle.tscn     # Traffic Area2D
│   └── obstacle.gd       # Random sprite, speed, collision signal
├── road/
│   └── road.tscn         # Parallax background layers
├── finish_line.gd        # Visual draw (_draw) for the finish line
└── menus/
    ├── MainMenu.tscn     # Entry point — Play / Quit
    ├── GameOver.tscn     # Defeat screen — Retry / Menu
    ├── Win.tscn          # Victory screen — Play Again / Menu
    └── global.gd         # Autoload — stores score across scenes
```

---

## 6. Audio

| Asset | Type | Usage |
|-------|------|-------|
| `Western Cyberhorse.ogg` | Music | Random background track (picked at game start) |
| `Diamonds on The Ceiling.ogg` | Music | Random background track (picked at game start) |
| `loop_5.wav` | SFX | Engine loop — plays when speed > 50 px/s |

---

## 7. Controls

| Action | Key | Effect |
|--------|-----|--------|
| `move_right` | D / Right Arrow | Accelerate |
| `move_left` | A / Left Arrow | Decelerate (no reverse) |
| `move_up` | W / Up Arrow | Steer up |
| `move_down` | S / Down Arrow | Steer down |

---

## 8. Possible Improvements

- Progressive difficulty: reduce `Timer.wait_time` as distance increases.
- Speed-based score multiplier instead of pure distance.
- Lives system: allow N collisions before Game Over.
- Visual feedback on collision (flash, screen shake).
- Leaderboard / best score persistence.
- Mobile touch controls.
- Varied finish line distances / level selection.
