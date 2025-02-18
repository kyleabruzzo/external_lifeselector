# Life Selector for FiveM [WIP]

⚠️ **This resource is currently a Work in Progress. Features and documentation may change.**

A dynamic life path selector resource for FiveM servers that allows players to choose their starting path in the game with a sleek UI, custom cutscenes, and starter items.

## Features

- 🎮 Immersive path selection interface
- 🎥 Custom cutscene integration for each path
- 🎁 Automatic starter item distribution
- 👥 Character-specific mentor system
- 🌈 Dynamic weather and time settings
- 🐛 Debug commands for development
- 📱 Responsive and modern UI design

## Preview

![Main Interface](https://i.imgur.com/sEinMjO.jpeg)

The interface presents players with different life paths, each featuring:
- Custom background images
- Path descriptions
- Assigned mentors
- Unique scenarios
- Starting locations
- Path-specific cutscenes
- Starter item packages

### Path Description
![Path Selection](https://i.imgur.com/wtFCN0I.jpeg)



## Installation

1. Download the latest release
2. Extract the `life-selector` folder to your server's `resources` directory
3. Add `ensure life-selector` to your `server.cfg`
4. Configure paths in `config.lua`

## Dependencies

- FiveM Server
- [ox_inventory](https://github.com/overextended/ox_inventory) (for item management)

## Configuration

Example path configuration in `config.lua`:

```lua
Paths = {
    racing = {
        id = "racing",
        title = "Street Racing Elite",
        description = "Join the high-stakes world of illegal street racing.",
        mentor = "Hao",
        image = "your_image_url.jpg",
        scenario = "Hao has noticed your driving skills...",
        spawnLocation = vector4(782.93, -1867.95, 29.29, 78.92),
        cutscene = {
            name = "tun_meet_int",
            duration = 30000,
            weather = "CLEAR",
            coords = vector3(-2201.717, 1132.0045, -23.26399),
            time = {hour = 21, minute = 0},
        },
        items = {
            {name = 'radio', label = 'Phone', amount = 1},
            {name = 'armour', label = 'Repair Kit', amount = 1}
        }
    }
}
```

## Usage

### Player Usage
- Access the life selector through configured commands or server events
- Browse available paths
- Select a path to view detailed information
- Confirm selection to begin the journey

### Developer Usage

The Life Selector can be triggered from any resource using the export:

```lua
-- Show life selector UI
exports['life-selector']:showLifeSelector()

-- Debug Commands (when enabled)
/lifeselector -- Opens the life selector UI
/playcutscene [cutscene_name] -- Plays specified cutscene
/stopcut -- Stops current cutscene
```

#### Integration Example
```lua
-- Basic implementation in your resource
RegisterCommand('selectpath', function()
    exports['life-selector']:showLifeSelector()
end)
```

Make sure to call the export at appropriate times in your server's logic to avoid showing the selector repeatedly.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.

## Credits

- UI Design inspired by modern gaming interfaces
- Cutscene system adapted for FiveM
- Original module loading system based on ox_lib