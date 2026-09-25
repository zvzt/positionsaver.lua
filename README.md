# Position Saver

A Roblox Luau utility for recording your current position and full `CFrame`, with a clean, draggable, minimizable interface.

## Usage

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/zvzt/positionsaver.lua/refs/heads/main/posrecorder.lua"))()
```

## Features

- Press **P** or click **Record** to capture the current position
- Displays the latest X, Y, and Z values in the UI
- Prints the complete `CFrame.new(...)` value to the console
- Copy Position button when `setclipboard` is available
- Copy CFrame button when `setclipboard` is available
- clean, draggable, minimizable interface
- Header-only minimize/restore behavior
- Screen-edge drag clamping with `-57 / 57` vertical offsets
- Rerun cleanup prevents duplicate **P** key handlers

## Files

- `posrecorder.lua` — main script
- `README.md` — documentation

## License

MIT — see [LICENSE](LICENSE).
