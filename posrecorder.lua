print("Zot logged the coordinates.")

local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local Workspace=game:GetService("Workspace")
local TweenService=game:GetService("TweenService")

local player=Players.LocalPlayer
local playerGui=player:WaitForChild("PlayerGui")
local env=getgenv and getgenv() or _G
local targetParent=playerGui

pcall(function()
	if gethui then
		targetParent=gethui()
	end
end)

if env.PositionSaverCleanup then
	pcall(env.PositionSaverCleanup)
end

for _,parent in ipairs({targetParent,playerGui}) do
	local old=parent:FindFirstChild("PositionSaverUI")
	if old then
		old:Destroy()
	end
end

local WINDOW=Color3.fromRGB(0,0,0)
local WINDOW_STROKE=Color3.fromRGB(45,45,50)
local PANEL=Color3.fromRGB(18,18,22)
local PANEL_STROKE=Color3.fromRGB(32,32,36)
local BUTTON=Color3.fromRGB(24,24,28)
local BUTTON_HOVER=Color3.fromRGB(32,32,38)
local BUTTON_STROKE=Color3.fromRGB(40,40,48)
local TEXT=Color3.fromRGB(240,240,245)
local BUTTON_TEXT=Color3.fromRGB(225,225,232)
local MUTED=Color3.fromRGB(120,120,130)

local FULL_WIDTH=360
local FULL_HEIGHT=180
local COLLAPSED_HEIGHT=38

local connections={}
local destroyed=false
local collapsed=false
local sizeTween=nil
local lastPosition=nil
local lastCFrame=nil

local function connect(signal,callback)
	local connection=signal:Connect(callback)
	table.insert(connections,connection)
	return connection
end

local function corner(object,radius)
	local c=Instance.new("UICorner",object)
	c.CornerRadius=UDim.new(0,radius)
	return c
end

local function stroke(object,color,thickness)
	local s=Instance.new("UIStroke",object)
	s.Color=color
	s.Thickness=thickness
	s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
	return s
end

local gui=Instance.new("ScreenGui")
gui.Name="PositionSaverUI"
gui.ResetOnSpawn=false
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
gui.Parent=targetParent

local function cleanup()
	if destroyed then
		return
	end

	destroyed=true

	for _,connection in ipairs(connections) do
		pcall(function()
			connection:Disconnect()
		end)
	end

	table.clear(connections)

	pcall(function()
		gui:Destroy()
	end)

	if env.PositionSaverCleanup==cleanup then
		env.PositionSaverCleanup=nil
	end
end

env.PositionSaverCleanup=cleanup

local function makeDraggable(dragHandle,targetFrame)
	targetFrame=targetFrame or dragHandle

	local dragging=false
	local dragStart
	local startPos

	connect(dragHandle.InputBegan,function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1
			or input.UserInputType==Enum.UserInputType.Touch then

			dragging=true
			dragStart=input.Position
			startPos=Vector2.new(
				targetFrame.Position.X.Offset,
				targetFrame.Position.Y.Offset
			)
		end
	end)

	connect(UIS.InputChanged,function(input)
		if not dragging then
			return
		end

		if input.UserInputType~=Enum.UserInputType.MouseMovement
			and input.UserInputType~=Enum.UserInputType.Touch then
			return
		end

		local camera=Workspace.CurrentCamera
		if not camera then
			return
		end

		local delta=input.Position-dragStart
		local size=targetFrame.AbsoluteSize
		local viewport=camera.ViewportSize

		local topOffset=-57
		local bottomOffset=57

		local x=math.clamp(
			startPos.X+delta.X,
			0,
			math.max(0,viewport.X-size.X)
		)

		local y=math.clamp(
			startPos.Y+delta.Y,
			topOffset,
			math.max(
				topOffset,
				viewport.Y-size.Y-bottomOffset
			)
		)

		targetFrame.Position=UDim2.fromOffset(x,y)
	end)

	connect(UIS.InputEnded,function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1
			or input.UserInputType==Enum.UserInputType.Touch then

			dragging=false
		end
	end)
end

local main=Instance.new("Frame",gui)
main.Name="SlateWindow_PositionSaver"
main.Size=UDim2.fromOffset(FULL_WIDTH,FULL_HEIGHT)
main.BackgroundColor3=WINDOW
main.BorderSizePixel=0
main.ClipsDescendants=true
main.Active=true

corner(main,10)
stroke(main,WINDOW_STROKE,1.2)

local camera=Workspace.CurrentCamera

if camera then
	local viewport=camera.ViewportSize

	main.Position=UDim2.fromOffset(
		math.floor((viewport.X-FULL_WIDTH)/2),
		math.floor((viewport.Y-FULL_HEIGHT)/2)
	)
else
	main.Position=UDim2.new(.5,-180,.5,-90)
end

local header=Instance.new("Frame",main)
header.Name="HeaderBar"
header.Size=UDim2.new(1,0,0,38)
header.BackgroundTransparency=1
header.BorderSizePixel=0
header.Active=true

local title=Instance.new("TextLabel",header)
title.Text="Position Saver"
title.TextSize=20
title.TextColor3=TEXT
title.FontFace=Font.new(
	"rbxasset://fonts/families/SourceSansPro.json",
	Enum.FontWeight.Bold,
	Enum.FontStyle.Normal
)
title.Position=UDim2.fromOffset(12,0)
title.Size=UDim2.new(1,-90,1,0)
title.BackgroundTransparency=1
title.TextXAlignment=Enum.TextXAlignment.Left

local minimizeBtn=Instance.new("TextButton",header)
minimizeBtn.Name="MinimizeBtn"
minimizeBtn.Text="—"
minimizeBtn.TextSize=16
minimizeBtn.TextColor3=Color3.fromRGB(150,150,160)
minimizeBtn.Font=Enum.Font.GothamBold
minimizeBtn.Size=UDim2.fromOffset(20,20)
minimizeBtn.Position=UDim2.new(1,-52,0,9)
minimizeBtn.BackgroundTransparency=1
minimizeBtn.BorderSizePixel=0
minimizeBtn.AutoButtonColor=false
minimizeBtn.ZIndex=20

local closeBtn=Instance.new("TextButton",header)
closeBtn.Name="CloseBtn"
closeBtn.Text="X"
closeBtn.TextSize=14
closeBtn.TextColor3=Color3.fromRGB(150,150,160)
closeBtn.Font=Enum.Font.GothamBold
closeBtn.Size=UDim2.fromOffset(20,20)
closeBtn.Position=UDim2.new(1,-28,0,9)
closeBtn.BackgroundTransparency=1
closeBtn.BorderSizePixel=0
closeBtn.AutoButtonColor=false
closeBtn.ZIndex=20

local function headerHover(button)
	connect(button.MouseEnter,function()
		TweenService:Create(
			button,
			TweenInfo.new(.15),
			{TextColor3=TEXT}
		):Play()
	end)

	connect(button.MouseLeave,function()
		TweenService:Create(
			button,
			TweenInfo.new(.15),
			{TextColor3=Color3.fromRGB(150,150,160)}
		):Play()
	end)
end

headerHover(minimizeBtn)
headerHover(closeBtn)
makeDraggable(header,main)

local content=Instance.new("Frame",main)
content.Name="Content"
content.Position=UDim2.new(0,10,0,42)
content.Size=UDim2.new(1,-20,1,-50)
content.BackgroundTransparency=1

local panel=Instance.new("Frame",content)
panel.Size=UDim2.new(1,0,1,0)
panel.BackgroundColor3=PANEL
panel.BorderSizePixel=0

corner(panel,9)
stroke(panel,PANEL_STROKE,1)

local info=Instance.new("TextLabel",panel)
info.Size=UDim2.new(1,-16,0,18)
info.Position=UDim2.fromOffset(8,6)
info.BackgroundTransparency=1
info.Text="Press P or click Record to save your current position."
info.TextColor3=MUTED
info.TextSize=11
info.Font=Enum.Font.GothamMedium
info.TextXAlignment=Enum.TextXAlignment.Left

local positionLabel=Instance.new("TextLabel",panel)
positionLabel.Size=UDim2.new(1,-16,0,36)
positionLabel.Position=UDim2.fromOffset(8,27)
positionLabel.BackgroundTransparency=1
positionLabel.Text="No position recorded"
positionLabel.TextColor3=TEXT
positionLabel.TextSize=12
positionLabel.Font=Enum.Font.GothamMedium
positionLabel.TextXAlignment=Enum.TextXAlignment.Left
positionLabel.TextYAlignment=Enum.TextYAlignment.Center
positionLabel.TextWrapped=true

local status=Instance.new("TextLabel",panel)
status.Size=UDim2.new(1,-16,0,18)
status.Position=UDim2.fromOffset(8,67)
status.BackgroundTransparency=1
status.Text="Ready"
status.TextColor3=MUTED
status.TextSize=10
status.Font=Enum.Font.GothamMedium
status.TextXAlignment=Enum.TextXAlignment.Left

local function makeButton(text,x,width)
	local button=Instance.new("TextButton",panel)
	button.Size=UDim2.fromOffset(width,26)
	button.Position=UDim2.fromOffset(x,92)
	button.BackgroundColor3=BUTTON
	button.BorderSizePixel=0
	button.AutoButtonColor=false
	button.Text=text
	button.TextColor3=BUTTON_TEXT
	button.TextSize=10
	button.Font=Enum.Font.GothamMedium

	corner(button,4)
	stroke(button,BUTTON_STROKE,1)

	connect(button.MouseEnter,function()
		TweenService:Create(
			button,
			TweenInfo.new(.1),
			{BackgroundColor3=BUTTON_HOVER}
		):Play()
	end)

	connect(button.MouseLeave,function()
		TweenService:Create(
			button,
			TweenInfo.new(.1),
			{BackgroundColor3=BUTTON}
		):Play()
	end)

	return button
end

local recordBtn=makeButton("Record (P)",8,102)
local copyPosBtn=makeButton("Copy Position",118,102)
local copyCFrameBtn=makeButton("Copy CFrame",228,104)

local function recordPosition()
	local character=player.Character
	local root=character and character:FindFirstChild("HumanoidRootPart")

	if not root then
		status.Text="HumanoidRootPart not found"
		return
	end

	local p=root.Position
	local cf=root.CFrame

	lastPosition=string.format(
		"Vector3.new(%.3f, %.3f, %.3f)",
		p.X,
		p.Y,
		p.Z
	)

	lastCFrame=string.format(
		"CFrame.new(%.3f, %.3f, %.3f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f)",
		cf:GetComponents()
	)

	positionLabel.Text=string.format(
		"X %.3f   Y %.3f   Z %.3f",
		p.X,
		p.Y,
		p.Z
	)

	status.Text="Recorded and printed to console"

	print("POSITION:")
	print(string.format(
		"X = %.3f, Y = %.3f, Z = %.3f",
		p.X,
		p.Y,
		p.Z
	))

	print("CFRAME:")
	print(lastCFrame)
	print("_______________________________________________")
end

local function copyText(text,successMessage)
	if not text then
		status.Text="Record a position first"
		return
	end

	if type(setclipboard)~="function" then
		status.Text="Clipboard unavailable"
		return
	end

	local ok=pcall(function()
		setclipboard(text)
	end)

	status.Text=ok and successMessage or "Clipboard failed"
end

connect(recordBtn.MouseButton1Click,recordPosition)

connect(copyPosBtn.MouseButton1Click,function()
	copyText(lastPosition,"Position copied")
end)

connect(copyCFrameBtn.MouseButton1Click,function()
	copyText(lastCFrame,"CFrame copied")
end)

connect(UIS.InputBegan,function(input,processed)
	if processed then
		return
	end

	if input.KeyCode==Enum.KeyCode.P then
		recordPosition()
	end
end)

local function clampMain(height)
	local camera=Workspace.CurrentCamera
	if not camera then
		return
	end

	local viewport=camera.ViewportSize
	local topOffset=-57
	local bottomOffset=57

	local x=math.clamp(
		main.Position.X.Offset,
		0,
		math.max(0,viewport.X-FULL_WIDTH)
	)

	local y=math.clamp(
		main.Position.Y.Offset,
		topOffset,
		math.max(
			topOffset,
			viewport.Y-height-bottomOffset
		)
	)

	main.Position=UDim2.fromOffset(x,y)
end

local function setCollapsed(state)
	if collapsed==state then
		return
	end

	collapsed=state

	if sizeTween then
		sizeTween:Cancel()
		sizeTween=nil
	end

	if collapsed then
		content.Visible=false

		sizeTween=TweenService:Create(
			main,
			TweenInfo.new(
				.18,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			),
			{
				Size=UDim2.fromOffset(
					FULL_WIDTH,
					COLLAPSED_HEIGHT
				)
			}
		)

		sizeTween:Play()
	else
		clampMain(FULL_HEIGHT)

		sizeTween=TweenService:Create(
			main,
			TweenInfo.new(
				.18,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			),
			{
				Size=UDim2.fromOffset(
					FULL_WIDTH,
					FULL_HEIGHT
				)
			}
		)

		local thisTween=sizeTween

		connect(thisTween.Completed,function()
			if destroyed then
				return
			end

			if not collapsed
				and sizeTween==thisTween
				and main.Parent then

				content.Visible=true
			end
		end)

		thisTween:Play()
	end
end

connect(minimizeBtn.MouseButton1Click,function()
	setCollapsed(not collapsed)
end)

connect(closeBtn.MouseButton1Click,cleanup)

print("Coordinate rec loaded. Press P to record your current position.")
