# Strategy Grid Game

A 2D game built with LÖVE (Love2D) framework featuring grid-based strategy elements and NPC interactions.

## Requirements

- [LÖVE](https://love2d.org/) (version 11.4 or later)
- Any operating system that supports LÖVE (Windows, macOS, Linux)

## Installation

1. Install LÖVE from https://love2d.org/
2. Clone this repository or download the source code
3. Run the game using one of these methods:
   - Drag the game folder onto the LÖVE executable
   - From command line: `love /path/to/game/folder`

## Features

- Grid-based movement system
- Player character with smooth controls (keyboard and gamepad support)
- NPC system with interaction zones
- Dialog system for NPC interactions
- Collision detection system (physical and trigger zones)
- Debug visualization mode

## Controls

- Movement:
  - Keyboard: Arrow keys or WASD
  - Gamepad: Left analog stick
- Interact with NPCs: (When in range)
  - Keyboard: [Key not yet implemented]
  - Gamepad: [Button not yet implemented]

## Project Structure

```
StrategyGridGame/
├── assets/           # Game assets (images, etc.)
├── entities/         # Game entities
│   ├── player.lua    # Player implementation
│   └── npc.lua       # NPC implementation
├── module/           # Core game modules
│   ├── class.lua     # Base class implementation
│   ├── collision_box.lua  # Collision detection
│   ├── dialog.lua    # Dialog system
│   ├── grid.lua      # Grid system
│   └── sprite.lua    # Sprite handling
├── struct/           # Data structures
├── main.lua         # Game entry point
└── README.md        # This file
```

## Development

The game is built with a modular architecture:
- Entity system for game objects (player, NPCs)
- Collision system supporting both physical collisions and trigger zones
- Sprite system with fallback rendering
- Dialog system for NPC interactions

### Debug Mode

Set `DEBUG = true` in the code to enable debug visualization:
- Green circles for physical collision boxes
- Red circles for interaction trigger zones
- Visual indicators for grid cells

## Contributing

Feel free to submit issues and pull requests for:
- New features
- Bug fixes
- Documentation improvements
- Performance optimizations

## License

[License type not yet specified] 