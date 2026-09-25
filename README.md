# Position Saver

A Roblox Luau utility for recording your current position and full `CFrame`, with an Onyx-style control panel.

## Preview

<img width="955" height="219" alt="Position Saver console output" src="https://github.com/user-attachments/assets/5dd11e32-a050-4c11-88cf-c4e570215c05" />

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
- Onyx-style draggable interface
- Header-only minimize/restore behavior
- Screen-edge drag clamping with `-57 / 57` vertical offsets
- Rerun cleanup prevents duplicate **P** key handlers

## Files

- `posrecorder.lua` — main script
- `README.md` — documentation

## License

MIT — see [LICENSE](LICENSE).
