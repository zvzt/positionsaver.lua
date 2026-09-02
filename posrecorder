-- Zot was here fr

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

UIS.InputBegan:Connect(function(input, processed)
    if processed or input.KeyCode ~= Enum.KeyCode.P then
        return
    end

    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        return
    end

    local p = root.Position
    local cf = root.CFrame

    print("POSITION:")
    print(string.format("X = %.3f, Y = %.3f, Z = %.3f", p.X, p.Y, p.Z))

    print("CFRAME:")
    print(string.format(
        "CFrame.new(%.3f, %.3f, %.3f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f)",
        cf:GetComponents()
    ))

    print("_______________________________________________")
end)

print("Coordinate rec loaded. Click P to record your current position.")
