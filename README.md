## Ping Pong Paddle

A lightweight Godot 4.5.1 project that recreates the feel of classic Pong with a ping pong table aesthetic and rounded paddles. Everything lives in this repository - open it with the Godot editor and press play to rally.

### Getting Started
- Install [Godot 4.5.1](https://godotengine.org/download/archive/4.5.1).
- Open the editor and choose **Import** -> point it at this folder (`project.godot` is in the repo root).
- Press **F5** (or click the Play button) to launch the game.

### Controls
- `W` / `S`: Move the left paddle up and down.
- `Up Arrow` / `Down Arrow`: Move the right paddle (or let the built-in AI handle it by toggling `use_ai` on the paddle node).
- `Space`: Serve the ball to start the round.
- `R`: Restart the entire match after someone wins.

### Gameplay Notes
- First to 11 points wins, but you must lead by 2 - just like real table tennis.
- The ball speeds up each time it rebounds off a paddle.
- Aim your shots by striking nearer the paddle's edges to apply topspin or slice.

Feel free to extend the project - swap in custom art, sound effects, or experiment with different AI behaviors. Pull requests are welcome!
