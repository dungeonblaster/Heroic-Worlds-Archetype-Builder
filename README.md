# Ping Pong Paddle Game

A classic Pong-style game built with Godot 4.5.1, featuring ping pong paddles and ball physics.

## Features

- Two-player local multiplayer
- Realistic ball physics with speed increase on paddle hits
- Score tracking (first to 5 points wins)
- Clean, minimalist UI
- Smooth paddle movement with boundary detection

## Controls

- **Player 1 (Left Paddle)**: W (up) / S (down)
- **Player 2 (Right Paddle)**: I (up) / K (down)
- **Restart**: R (after game over)

## How to Play

1. Open the project in Godot 4.5.1
2. Run the game (F5 or click the Play button)
3. Use the controls to move your paddle up and down
4. Hit the ball to keep it in play
5. Score points by getting the ball past your opponent
6. First player to reach 5 points wins!

## Project Structure

- `scenes/Main.tscn` - Main game scene with paddles, ball, and UI
- `scenes/Paddle.tscn` - Paddle scene (used for both players)
- `scenes/Ball.tscn` - Ball scene with physics
- `scripts/GameManager.gd` - Handles scoring and game state
- `scripts/Paddle.gd` - Paddle movement and input handling
- `scripts/Ball.gd` - Ball physics and collision detection

## Game Mechanics

- Ball speed increases slightly with each paddle hit
- Ball bounces at different angles based on where it hits the paddle
- Top and bottom walls bounce the ball
- Ball resets to center after each point