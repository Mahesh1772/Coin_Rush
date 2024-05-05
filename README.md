# Coin Rush: A 2D FPGA Video Game

Coin Rush is an immersive 2D video game developed on a Xilinx Artix-7 FPGA using Verilog HDL. This project aims to recreate the classic Super Mario gameplay experience, featuring captivating graphics, physics-based mechanics, and challenging gameplay elements.

## Game Overview

- **VGA Display**: The game is designed to be displayed on screens and TVs with a standard VGA output, providing a high-resolution and vibrant visual experience.
- **Character Physics and Animation**: The main character, inspired by Mario, exhibits realistic physics-based movement and momentum. Intricate animations for idle, walking, and jumping states enhance the visual feedback and immersion.
- **Enemy Behavior and Collision Detection**: Multiple enemy types with distinct behaviors, such as the pulsating fire ghost and the spark, add complexity to the gameplay. Precise collision detection mechanisms ensure responsive feedback when the character interacts with enemies or obstacles.
- **Score and Lives System**: Players can track their progress through a dynamic scoring system and a lives counter, reflecting the challenges faced throughout the game.
- **Mini-Game Integration**: A unique mini-game feature challenges players to match randomly generated numbers using switches within set intervals. Visual and auditory cues, including LED blinking and a 7-segment display, provide guidance and enhance the gaming experience.

## Game Mechanics

### Physics and Gravity

The game's physics engine accurately simulates gravity and momentum-based movement. Players can control the main character's jumps using the designated button, with the ability to adjust the jump height by prolonging the button press. If the character reaches the upper bound of the game area, they immediately transition to a falling state until landing on the nearest platform.

### Grounded State

The character can initiate a jump only when in a grounded state, meaning they are standing on solid ground or on top of a platform. While in the air, the character's left or right movement is treated as mid-air strafing, distinct from the walking mechanics on the ground.

### Enemy Behavior

The game features two distinct enemy types:

1. **Pulsating Fire Ghost**: This enemy locks onto the character's current position and moves directly towards them while they remain on certain platforms. However, if the character jumps off these platforms, the fire ghost remains stationary.

2. **Spark**: This relentless enemy continuously pursues the character, regardless of their location, adding an extra layer of challenge to the gameplay.

### Collision and Damage

If the character collides with an enemy, their damaged sprite is displayed, indicating a hit. During this state, players cannot control the character's jump but can still move left or right. Collisions also affect the character's lives, which are displayed on the screen.

### Sprite Design and Animations

The game features meticulously crafted sprites based on images from the Super Mario World game. Some sprites, such as coins and the character's damaged state, have been hand-crafted or modified using online tools. Character animations for idle, walking, and jumping states, as well as alternating animations for enemies, contribute to the game's vibrant and immersive atmosphere.

### Coin Collection and Scoring

Different colored coins represent varying point values, with blue being 20 points, red being 40 points, bronze being 60 points, silver being 200 points, and gold being 500 points. The coin spawning system appears randomized to the player, but higher-value coins have an increased chance of appearing as the game progresses, incentivizing players to survive longer.

## References

- [PNG to/from Verilog Converter](https://github.com/abbati-simone/Png-to-from-Verilog)
