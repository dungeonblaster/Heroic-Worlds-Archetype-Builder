# Ping Pong Paddle Game

A classic Pong clone built with Godot 4.5.1, themed around ping pong paddles.

## Features

- Classic Pong gameplay with ping pong paddle theme
- Two-player local multiplayer
- Score tracking (first to 11 wins)
- Ball physics with speed increase on paddle hits
- Smooth paddle movement with boundary detection

## Controls

### Left Paddle (Player 1)
- **W** or **Arrow Up** - Move up
- **S** or **Arrow Down** - Move down

### Right Paddle (Player 2)
- **I** - Move up
- **K** - Move down

## How to Play

1. Open the project in Godot 4.5.1
2. Press F5 or click the Play button to run the game
3. Use the controls above to move your paddle
4. Hit the ball with your paddle to keep it in play
5. Score points by getting the ball past your opponent's paddle
6. First player to reach 11 points wins!

## Project Structure

```
/workspace/
├── project.godot          # Main project configuration
├── scenes/
│   ├── Main.tscn         # Main game scene
│   ├── Paddle.tscn       # Paddle scene
│   └── Ball.tscn         # Ball scene
└── scripts/
    ├── Paddle.gd         # Paddle movement and controls
    ├── Ball.gd           # Ball physics and collision
    └── GameManager.gd    # Score tracking and game logic
```

## Game Mechanics

- The ball bounces off the top and bottom walls
- Ball speed increases slightly with each paddle hit (up to a maximum)
- Ball angle changes based on where it hits the paddle
- Ball resets to center after each point is scored
- Game automatically resets scores after a player wins

Enjoy playing!
