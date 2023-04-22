local Library = {}

function Library:Notify(tt, tx)
	Services.StarterGui:SetCore("SendNotification", {
		Title = tt,
		Text = tx,
		Duration = 5
	})
end

local blacklisted_keys = {
	Return = true,
	Space = true,
	Tab = true,
	W = true,
	A = true,
	S = true,
	D = true,
	I = true,
	O = true,
	Unknown = true
}

local short_keys = {
	RightControl = "RCtrl",
	LeftControl = "LCtrl",
	LeftShift = "LShift",
	RightShift = "RShift",
	MouseButton1 = "M1",
	MouseButton2 = "M2",
	LeftAlt = "LAlt",
	RightAlt = "RAlt"
}

local function Dragify(frame, parent)
	parent = parent or frame

	local dragging = false
	local dragInput, mousePos, framePos
	
	LibraryMaid:GiveTask(
		frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 and isUIopened then
				dragging = true
				mousePos = input.Position
				framePos = parent.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End or not isUIopened then
						dragging = false
					end
				end)
			end
		end)
	)
	LibraryMaid:GiveTask(
		frame.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement and isUIopened then
				dragInput = input
			end
		end)
	)
	LibraryMaid:GiveTask(
		Services.UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging and isUIopened then
				local delta = input.Position - mousePos
				parent.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
			end
		end)
	)
end

local function round(num, bracket)
	bracket = bracket or 1
	local a = math.floor(num/bracket + (math.sign(num) * 0.5)) * bracket
	if a < 0 then
		a = a + bracket
	end
	return a
end

local function buttoneffect(options)
	pcall(function()
		options.entered.MouseEnter:Connect(function()
			if options.frame.TextColor3 ~= Color3.fromRGB(234, 239, 246) then
				Services.TweenService:Create(options.frame, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
					TextColor3 = Color3.fromRGB(234, 239, 245)
				}):Play()
			end
		end)
		options.entered.MouseLeave:Connect(function()
			if options.frame.TextColor3 ~= Color3.fromRGB(157, 171, 182) and options.frame.TextColor3 ~= Color3.fromRGB(234, 239, 246) then
				Services.TweenService:Create(options.frame, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
					TextColor3 = Color3.fromRGB(157, 171, 182)
				}):Play()
			end
		end)
	end)
end

local function clickEffect(options)
	options.button.MouseButton1Click:Connect(function()
		local new = options.textsize - tonumber(options.amount)
		local revert = new + tonumber(options.amount)
		Services.TweenService:Create(options.button, TweenInfo.new(0.15, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {TextSize = new}):Play()
		wait(0.1)
		Services.TweenService:Create(options.button, TweenInfo.new(0.1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {TextSize = revert}):Play()
	end)
end

function Library:PlayerInfo()
	local PIMaid = Maid()
	local Profile = Instance("ScreenGui",{
		Name = "Profile",
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 2147483647,
		Enabled = false
	},Services.CoreGui)
	local Container = Instance("Frame",{
		Name = "Container",
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
		BackgroundTransparency = 0.8,
		ClipsDescendants = true,
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, 250, 0, 110)
	},Profile)
	Instance("UIListLayout",{
		SortOrder = Enum.SortOrder.LayoutOrder
	},Container)
	Instance("UIStroke",{
		Color = Color3.fromRGB(54,47,255),
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
		Enabled = true
	},Container)

	local HP = Instance("Frame",{
		Name = "HP",
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0.2, 0)
	},Container)
	local HP_Bar = Instance("Frame",{
		Name = "Over",
		BackgroundColor3 = Color3.fromRGB(208, 148, 27),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0)
	},HP)
	local HP_Label = Instance("TextLabel",{
		Name = "Label",
		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.Code,
		Text = "0/0",
		TextColor3 = Color3.new(1,1,1),
		TextSize = 14
	},HP)
	Instance("UIPadding",{
		PaddingLeft = UDim.new(0, 4)
	},Instance("TextLabel",{ -- HP TLabel
		Name = "_",
		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.Code,
		Text = "HP:",
		TextColor3 = Color3.new(1,1,1),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	},HP))

	local STAMR = Instance("Frame",{ -- Real Stamina
		Name = "STAMR",
		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0.2, 0)
	},Container)
	local STAM = Instance("Frame",{
		Name = "STAM",
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		LayoutOrder = 1,
		Size = UDim2.new(0.5, 0, 1, 0)
	},STAMR)
	local STAM_Bar = Instance("Frame",{
		Name = "Over",
		BackgroundColor3 = Color3.fromRGB(74, 179, 176),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0)
	},STAM)
	local STAM_Label = Instance("TextLabel",{
		Name = "Label",
		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.Code,
		Text = "0/0",
		TextColor3 = Color3.new(1,1,1),
		TextSize = 14
	},STAM)
	Instance("UIPadding",{
		PaddingLeft = UDim.new(0, 4)
	},Instance("TextLabel",{ -- STAM TLabel
		Name = "_",
		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.Code,
		Text = "ST:",
		TextColor3 = Color3.new(1,1,1),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	},STAM))

	local RSTAM = Instance("Frame",{ -- Dodge Stamina
		Name = "RSTAM",
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		LayoutOrder = 1,
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(0.5, 0, 1, 0)
	},STAMR)
	local RSTAM_Bar = Instance("Frame",{
		Name = "Over",
		BackgroundColor3 = Color3.fromRGB(54, 130, 127),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0)
	},RSTAM)
	local RSTAM_Label = Instance("TextLabel",{
		Name = "Label",
		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.Code,
		Text = "0/0",
		TextColor3 = Color3.new(1,1,1),
		TextSize = 14
	},RSTAM)
	Instance("UIPadding",{
		PaddingLeft = UDim.new(0, 4)
	},Instance("TextLabel",{ -- RSTAM TLabel
		Name = "_",
		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.Code,
		Text = "DG:",
		TextColor3 = Color3.new(1,1,1),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	},RSTAM))

	Instance("UIListLayout",{ -- STAMR FRAME LIST
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center
	},STAMR)

	local MANA = Instance("Frame",{
		Name = "MANA",
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		LayoutOrder = 3,
		Size = UDim2.new(1, 0, 0.2, 0)
	},Container)
	local MANA_Bar = Instance("Frame",{
		Name = "Over",
		BackgroundColor3 = Color3.fromRGB(104, 127, 208),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0)
	},MANA)
	local MANA_Label = Instance("TextLabel",{
		Name = "Label",
		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.Code,
		Text = "0/0",
		TextColor3 = Color3.new(1,1,1),
		TextSize = 14
	},MANA)
	Instance("UIPadding",{
		PaddingLeft = UDim.new(0, 4)
	},Instance("TextLabel",{ -- MANA TLabel
		Name = "_",
		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.Code,
		Text = "MN:",
		TextColor3 = Color3.new(1,1,1),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
	},MANA))

	local INFO = Instance("Frame",{
		Name = "INFO",
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
		BackgroundTransparency = 0.6,
		ClipsDescendants = true,
		LayoutOrder = 4,
		Size = UDim2.new(1, 0, 0.2, 0)
	},Container)
	local isBlockedLABEL = Instance("TextLabel",{
		Name = "isBlocked",
		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = 1,
		LayoutOrder = 0,
		Size = UDim2.new(0.3, 0, 1, 0),
		Font = Enum.Font.Code,
		Text = "Blocked",
		TextColor3 = Color3.fromRGB(255, 53, 53),
		TextSize = 15,
		TextWrapped = true
	},INFO)
	local isStunnedLABEL = Instance("TextLabel",{
		Name = "isStunned",
		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Size = UDim2.new(0.3, 0, 1, 0),
		Font = Enum.Font.Code,
		Text = "Stunned",
		TextColor3 = Color3.fromRGB(255, 53, 53),
		TextSize = 15,
		TextWrapped = true
	},INFO)
	local isFrozenLABEL = Instance("TextLabel",{
		Name = "isFrozen",
		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(0.3, 0, 1, 0),
		Font = Enum.Font.Code,
		Text = "Frozen",
		TextColor3 = Color3.fromRGB(255, 53, 53),
		TextSize = 15,
		TextWrapped = true
	},INFO)
	Instance("UIListLayout",{ -- LIST FOR BLOCKED/STUNNED
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center
	},INFO)

	local PLAYER = Instance("Frame",{
		Name = "PLAYER",
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
		BackgroundTransparency = 0.6,
		ClipsDescendants = true,
		Size = UDim2.new(1, 0, 0.2, 0)
	},Container)
	local NAME = Instance("TextLabel",{
		Name = "NAME",
		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.Code,
		Text = "NAME",
		TextColor3 = Color3.new(1,1,1),
		TextSize = 14,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left
	},PLAYER)
	Instance("UIPadding",{
		PaddingLeft = UDim.new(0, 9)
	},NAME)
	local ID = Instance("TextLabel",{
		Name = "ID",
		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.Code,
		Text = "ID",
		TextColor3 = Color3.new(1,1,1),
		TextSize = 14,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Right
	},PLAYER)
	Instance("UIPadding",{
		PaddingRight = UDim.new(0, 9)
	},ID)
	
	if MINERVA.globset.tgpin == true then
		Profile.Enabled = true
	end
	
	--local function colorize(w,c)
	--	w.BackgroundColor3 = c
	--end
	
	return {
		PR = Profile,
		Maid = PIMaid,
		CONTAINER=Container,
		PLAYER={name=NAME,id=ID},
		INFO={isb=isBlockedLABEL,iss=isStunnedLABEL,isf=isFrozenLABEL},
		HP={bar=HP_Bar,text=HP_Label},
		MANA={bar=MANA_Bar,text=MANA_Label},
		dSTAMR=STAMR,
		STAMINA={bar=STAM_Bar,text=STAM_Label},
		DODGE={bar=RSTAM_Bar,text=RSTAM_Label},
		--callback1=colorize
	}
end

function Library:Window(options)
	if not options.children then return Library:Notify(bozoname,'children function should be valid!') end
	options.text = options.text or "No name"

	local SG = Instance("ScreenGui",{
		Name = options.text,
		DisplayOrder = 2147483647
	},Services.CoreGui)
	
	local Body = Instance("Frame",{
		Name = "Body",
		Active = true,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(9, 8, 13),
		BorderSizePixel = 0,
		Position = UDim2.new(0.465730786, 0, 0.5, 0),
		Size = UDim2.new(0, 658, 0, 516)
	},SG)
	Dragify(Body, Body)
	
	MINERVA.UI = {s=SG,b=Body}
	
	Instance("UICorner",{ -- bodyCorner
		Name = "bodyCorner",
		CornerRadius = UDim.new(0, 4)
	},Body)

	local SideBar = Instance("Frame",{
		Name = "SideBar",
		BackgroundColor3 = Color3.fromRGB(26, 36, 48),
		BorderSizePixel = 0,
		Size = UDim2.new(0, 187, 0, 516)
	},Body)
	Instance("UICorner",{ -- sidebarCorner
		Name = "sidebarCorner",
		CornerRadius = UDim.new(0, 4)
	},SideBar)
	Instance("Frame",{ -- sbLine
		Name = "sbLine",
		BackgroundColor3 = Color3.fromRGB(15, 23, 36),
		BorderSizePixel = 0,
		Position = UDim2.new(0.99490571, 0, 0, 0),
		Size = UDim2.new(0, 3, 0, 516)
	},SideBar)

	local TopBar = Instance("Frame",{
		Name = "TopBar",
		BackgroundColor3 = Color3.fromRGB(9, 8, 13),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(14, 21, 32),
		BorderSizePixel = 0,
		Position = UDim2.new(0.25166446, 0, 0, 0),
		Size = UDim2.new(0, 562, 0, 49)
	},Body)
	Instance("Frame",{ -- tbLine
		Name = "tbLine",
		BackgroundColor3 = Color3.fromRGB(15, 23, 36),
		BorderSizePixel = 0,
		Position = UDim2.new(0.0400355868, 0, 1, 0),
		Size = UDim2.new(0, 469, 0, 3)
	},TopBar)
	Instance("TextLabel",{ -- Title
		Name = "Title",
		BackgroundColor3 = Color3.fromRGB(234, 239, 245),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0.0614973232, 0, 0.0213178284, 0),
		Size = UDim2.new(0, 162, 0, 26),
		Font = Enum.Font.ArialBold,
		Text = options.text,
		TextColor3 = Color3.fromRGB(234, 239, 245),
		TextSize = 28,
		TextWrapped = true
	},SideBar)

	local allPages = Instance("Frame",{
		Name = "allPages",
		BackgroundColor3 = Color3.fromRGB(234, 239, 245),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0.29508087, 0, 0.100775197, 0),
		Size = UDim2.new(0, 463, 0, 464)
	},Body)
	local tabContainer = Instance("Frame",{
		Name = "tabContainer",
		BackgroundColor3 = Color3.fromRGB(234, 239, 245),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0.100775197, 0),
		Size = UDim2.new(0, 187, 0, 464)
	},SideBar)

	local tabsections = {}

	function tabsections:TabSection(options)
		if not options.children then return Library:Notify(bozoname,'children function should be valid!') end
		options.text = options.text or "Tab Section"

		Instance("UIListLayout",{ -- tabLayout
			Name = "tabLayout"
		},tabContainer)
		local tabSection = Instance("Frame",{
			Name = "tabSection",
			BackgroundColor3 = Color3.fromRGB(234, 239, 245),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 189, 0, 22)
		},tabContainer)
		Instance("TextLabel",{ -- tabSectionLabel
			Name = "tabSectionLabel",
			BackgroundColor3 = Color3.fromRGB(234, 239, 245),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 190, 0, 22),
			Font = Enum.Font.Gotham,
			Text = "     ".. options.text,
			TextColor3 = Color3.fromRGB(79, 107, 126),
			TextSize = 17,
			TextXAlignment = Enum.TextXAlignment.Left
		},tabSection)
		Instance("UIListLayout",{ -- tabSectionLayout
			Name = "tabSectionLayout",
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 7)
		},tabSection)
		
		local function ResizeTS(num)
			tabSection.Size = tabSection.Size + UDim2.new(0, 0, 0, num)
		end

		local tabs = {}

		function tabs:Tab(options)
			if not options.children then return Library:Notify(bozoname,'children function should be valid!') end
			options.text = options.text or "New Tab"
			options.icon = options.icon or "rbxassetid://7999345313"

			local tabButton = Instance("TextButton",{
				Name = "tabButton",
				BackgroundColor3 = Color3.fromRGB(13, 57, 84),
				BorderSizePixel = 0,
				Position = UDim2.new(0.0714285746, 0, 0.402777791, 0),
				Size = UDim2.new(0, 165, 0, 30),
				AutoButtonColor = false,
				Font = Enum.Font.GothamSemibold,
				Text = "         " .. options.text,
				TextColor3 = Color3.fromRGB(234, 239, 245),
				TextSize = 14,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left
			},tabSection)
			Instance("UICorner",{ -- tabButtonCorner
				Name = "tabButtonCorner",
				CornerRadius = UDim.new(0, 4)
			},tabButton)
			Instance("ImageLabel",{ -- tabIcon
				Name = "tabIcon",
				BackgroundColor3 = Color3.fromRGB(234, 239, 245),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(0.0408859849, 0, 0.133333355, 0),
				Size = UDim2.new(0, 21, 0, 21),
				Image = options.icon,
				ImageColor3 = Color3.fromRGB(43, 154, 198)
			},tabButton)

			local newPage = Instance("ScrollingFrame",{
				Name = "newPage",
				Visible = false,
				BackgroundColor3 = Color3.fromRGB(234, 239, 245),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				Position = UDim2.new(0.021598272, 0, 0.0237068962, 0),
				Size = UDim2.new(0, 442, 0, 440),
				ScrollBarThickness = 4,
				CanvasSize = UDim2.new(0,0,0,0)
			},allPages)
			local pageLayout = Instance("UIGridLayout",{
				Name = "pageLayout",
				SortOrder = Enum.SortOrder.LayoutOrder,
				CellPadding = UDim2.new(0, 12, 0, 12),
				CellSize = UDim2.new(0, 215, 0, -10)
			},newPage)

			tabButton.MouseButton1Click:Connect(function()
				for i,v in pairs(allPages:GetChildren()) do
					v.Visible = false
				end
				newPage.Visible = true

				for i,v in pairs(SideBar:GetDescendants()) do
					if v:IsA("TextButton") then
						Services.TweenService:Create(v, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
							BackgroundTransparency = 1
						}):Play()
					end
				end

				Services.TweenService:Create(tabButton, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
					BackgroundTransparency = 0
				}):Play()
			end)

			pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				newPage.CanvasSize = UDim2.new(0,0,0,pageLayout.AbsoluteContentSize.Y) 
			end)

			ResizeTS(50)

			local sections = {}

			function sections:Section(options)
				if not options.children then return Library:Notify(bozoname,'children function should be valid!') end
				options.text = options.text or "Section"

				local sectionFrame = Instance("Frame",{
					Name = "sectionFrame",
					BackgroundColor3 = Color3.fromRGB(0, 15, 30),
					BorderSizePixel = 0,
					Size = UDim2.new(0, 215, 0, 134)
				},newPage)
				Instance("TextLabel",{ -- sectionLabel
					Name = "sectionLabel",
					BackgroundColor3 = Color3.fromRGB(234, 239, 245),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.new(0.0121902823, 0, 0, 0),
					Size = UDim2.new(0, 213, 0, 25),
					Font = Enum.Font.GothamSemibold,
					Text = "   " .. options.text,
					TextColor3 = Color3.fromRGB(234, 239, 245),
					TextSize = 14,
					TextXAlignment = Enum.TextXAlignment.Left
				},sectionFrame)
				Instance("UICorner",{ -- sectionFrameCorner
					Name = "sectionFrameCorner",
					CornerRadius = UDim.new(0, 4)
				},sectionFrame)
				Instance("UIListLayout",{ -- sectionLayout
					Name = "sectionLayout",
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 2)
				},sectionFrame)
				Instance("TextLabel",{ -- sLine
					Name = "sLine",
					BackgroundColor3 = Color3.fromRGB(13, 28, 44),
					BorderSizePixel = 0,
					Position = UDim2.new(0.0255813953, 0, 0.41538462, 0),
					Size = UDim2.new(0, 202, 0, 3),
					Font = Enum.Font.SourceSans,
					Text = "",
					TextColor3 = Color3.new(0,0,0),
					TextSize = 0
				},sectionFrame)
				local sectionSizeConstraint = Instance("UISizeConstraint",{
					Name = "sectionSizeConstraint",
					MinSize = Vector2.new(215, 35)
				},sectionFrame)

				local function Resize(num)
					sectionSizeConstraint.MinSize = sectionSizeConstraint.MinSize + Vector2.new(0, num)
				end

				local elements = {}

				function elements:Button(options)
					if not options.text  then Library:Notify("Button", "Missing arguments!") return end

					local TextButton = Instance("TextButton",{
						BackgroundColor3 = Color3.fromRGB(13, 57, 84),
						BorderSizePixel = 0,
						Position = UDim2.new(0.0348837227, 0, 0.355555564, 0),
						Size = UDim2.new(0, 200, 0, 22),
						AutoButtonColor = false,
						Text = options.text,
						Font = Enum.Font.Gotham,
						TextColor3 = Color3.fromRGB(157, 171, 182),
						TextSize = 14,
						BackgroundTransparency = 1
					},sectionFrame)
					
					buttoneffect({frame = TextButton, entered = TextButton})
					clickEffect({button = TextButton, amount = 5, textsize = TextButton.TextSize})
					
					TextButton.MouseButton1Click:Connect(function()
						options.callback(TextButton)
					end)

					Resize(25)
				end

				function elements:Toggle(options)
					if not options.text  or not options.id then Library:Notify("Toggle", "Missing arguments!") return end
					local defupdate
					if not options.notsave then
						defupdate = updateInGlob(options.id)
						if MINERVA.globset[options.id] then
							options.state = MINERVA.globset[options.id]
						else
							defupdate(options.state)
						end
					else
						MINERVA.globset[options.id] = options.state
					end
					
					local State = options.state or false

					local toggleLabel = Instance("TextLabel",{
						Name = "toggleLabel",
						BackgroundColor3 = Color3.fromRGB(157, 171, 182),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.0348837227, 0, 0.965517223, 0),
						Size = UDim2.new(0, 200, 0, 22),
						Font = Enum.Font.Gotham,
						Text = " " .. options.text,
						TextColor3 = Color3.fromRGB(157, 171, 182),
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left
					},sectionFrame)
					local toggleFrame = Instance("TextButton",{
						Name = "toggleFrame",
						BackgroundColor3 = Color3.fromRGB(4, 4, 11),
						BorderSizePixel = 0,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.9, 0, 0.5, 0),
						Size = UDim2.new(0, 38, 0, 18),
						AutoButtonColor = false,
						Font = Enum.Font.SourceSans,
						Text = "",
						TextColor3 = Color3.new(0,0,0),
						TextSize = 14
					},toggleLabel)
					Instance("UICorner",{ -- togFrameCorner
						Name = "togFrameCorner",
						CornerRadius = UDim.new(0, 50)
					},toggleFrame)
					local toggleButton = Instance("TextButton",{
						Name = "toggleButton",
						Parent = toggleFrame,
						BackgroundColor3 = Color3.fromRGB(77, 77, 77),
						BorderSizePixel = 0,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.25, 0, 0.5, 0),
						Size = UDim2.new(0, 16, 0, 16),
						AutoButtonColor = false,
						Font = Enum.Font.SourceSans,
						Text = "",
						TextColor3 = Color3.new(0,0,0),
						TextSize = 14
					},toggleFrame)
					Instance("UICorner",{ -- togBtnCorner
						Name = "togFrameCorner",
						CornerRadius = UDim.new(0, 50)
					},toggleButton)

					buttoneffect({frame = toggleLabel, entered = toggleLabel})

					local function PerformToggle()
						State = not State
						options.callback(toggleButton,State)
						if not options.notsave then
							defupdate(State)
						else
							MINERVA.globset[options.id] = State
						end
						Services.TweenService:Create(toggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
							Position = State and UDim2.new(0.74, 0, 0.5, 0) or UDim2.new(0.25, 0, 0.5, 0)
						}):Play()
						Services.TweenService:Create(toggleLabel, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
							TextColor3 = State and Color3.fromRGB(234, 239, 246) or Color3.fromRGB(157, 171, 182)
						}):Play()
						Services.TweenService:Create(toggleButton, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
							BackgroundColor3 = State and Color3.fromRGB(2, 162, 243) or Color3.fromRGB(77, 77, 77)
						}):Play()
						Services.TweenService:Create(toggleFrame, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
							BackgroundColor3 = State and Color3.fromRGB(2, 23, 49) or Color3.fromRGB(4, 4, 11)
						}):Play()
					end
					
					toggleFrame.MouseButton1Click:Connect(function()
						PerformToggle()
					end)
					
					toggleButton.MouseButton1Click:Connect(function()
						PerformToggle()
					end)
					
					if options.state then
						toggleButton.Position = UDim2.new(0.74, 0, 0.5, 0)
						toggleLabel.TextColor3 = Color3.fromRGB(234, 239, 246)
						toggleButton.BackgroundColor3 = Color3.fromRGB(2, 162, 243)
						toggleFrame.BackgroundColor3 = Color3.fromRGB(2, 23, 49)
					end

					Resize(25)
					return PerformToggle
				end

				function elements:Slider(options)
					if not options.text or not options.min or not options.max  or not options.id then Library:Notify("Slider", "Missing arguments!") return end
					local Value
					local defupdate = updateInGlob(options.id)
					if MINERVA.globset[options.id] then
						Value = MINERVA.globset[options.id]
					else
						defupdate(options.min)
					end

					local Slider = Instance("Frame",{
						Name = "Slider",
						BackgroundColor3 = Color3.fromRGB(157, 171, 182),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.0395348854, 0, 0.947335422, 0),
						Size = UDim2.new(0, 200, 0, 22)
					},sectionFrame)
					local sliderLabel = Instance("TextLabel",{
						Name = "sliderLabel",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(157, 171, 182),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.2, 0, 0.5, 0),
						Size = UDim2.new(0, 77, 0, 22),
						Font = Enum.Font.Gotham,
						Text = " " .. options.text,
						TextColor3 = Color3.fromRGB(157, 171, 182),
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left
					},Slider)
					local sliderFrame = Instance("TextButton",{
						Name = "sliderFrame",
						BackgroundColor3 = Color3.fromRGB(29, 87, 118),
						BorderSizePixel = 0,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(1.6, 0, 0.5, 0),
						Size = UDim2.new(0, 72, 0, 2),
						Text = "",
						AutoButtonColor = false
					},sliderLabel)
					local sliderBall = Instance("TextButton",{
						Name = "sliderBall",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(67, 136, 231),
						BorderSizePixel = 0,
						Position = UDim2.new(0, 0, 0.5, 0),
						Size = UDim2.new(0, 14, 0, 14),
						AutoButtonColor = false,
						Font = Enum.Font.SourceSans,
						Text = "",
						TextColor3 = Color3.new(0,0,0),
						TextSize = 14
					},sliderFrame)
					Instance("UICorner",{ -- sliderBallCorner
						Name = "sliderBallCorner",
						CornerRadius = UDim.new(0, 50)
					},sliderBall)
					local sliderTextBox = Instance("TextBox",{
						Name = "sliderTextBox",
						BackgroundColor3 = Color3.fromRGB(1, 7, 17),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(2.4, 0, 0.5, 0),
						Size = UDim2.new(0, 31, 0, 15),
						Font = Enum.Font.Gotham,
						Text = options.min,
						TextColor3 = Color3.fromRGB(234, 239, 245),
						TextSize = 11,
						TextWrapped = true
					},sliderLabel)
					buttoneffect({frame = sliderLabel, entered = Slider})

					local Held = false
					
					local Mouse = game.Players.LocalPlayer:GetMouse()

					local percentage = 0
					local step = 0.01

					local function snap(number, factor)
						if factor == 0 then
							return number
						else
							return math.floor(number/factor+0.5)*factor
						end
					end
					
					LibraryMaid:GiveTask(
						Services.UserInputService.InputEnded:Connect(function(Mouse)
							Held = false
						end)
					)
					
					sliderLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
						if sliderLabel.TextBounds.X > 75 then
							sliderLabel.TextScaled = true
						else
							sliderLabel.TextScaled = false
						end
					end)
					sliderFrame.MouseButton1Down:Connect(function()
						Held = true
					end)
					sliderBall.MouseButton1Down:Connect(function()
						Held = true
					end)

					LibraryMaid:GiveTask(
						Services.RunService.Heartbeat:Connect(function()
							if Held then
								local BtnPos = sliderBall.Position
								local MousePos = Services.UserInputService:GetMouseLocation().X
								local FrameSize = sliderFrame.AbsoluteSize.X
								local FramePos = sliderFrame.AbsolutePosition.X
								local pos = snap((MousePos-FramePos)/FrameSize,step)
								percentage = math.clamp(pos,0,0.9)

								Value = ((((options.max - options.min) / 0.9) * percentage)) + options.min
								Value = round(Value, options.float)
								Value = math.clamp(Value, options.min, options.max)
								sliderTextBox.Text = Value
								options.callback(Slider,Value)
								defupdate(Value)
								sliderBall.Position = UDim2.new(percentage,0,BtnPos.Y.Scale, BtnPos.Y.Offset)
							end
						end)
					)
					
					sliderTextBox.Focused:Connect(function()
						Services.TweenService:Create(sliderLabel, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextColor3 = Color3.fromRGB(234, 239, 246)}):Play()
					end)
					sliderTextBox.FocusLost:Connect(function(Enter)
						Services.TweenService:Create(sliderLabel, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextColor3 = Color3.fromRGB(157, 171, 182)}):Play()
						local TEXTO = sliderTextBox.Text
						if Enter then
							if TEXTO ~= nil and TEXTO and tonumber(TEXTO) then
								if tonumber(TEXTO) > options.max then
									Value = options.max
								elseif tonumber(TEXTO) < options.min then
									Value = options.min
								else
									Value = tonumber(TEXTO)
								end
								sliderTextBox.Text = Value
								options.callback(Slider,Value)
								defupdate(Value)
							end
						end
					end)
					
					percentage = math.clamp(snap((Services.UserInputService:GetMouseLocation().X-sliderFrame.AbsolutePosition.X)/sliderFrame.AbsoluteSize.X,step),0,0.9)

					Value = ((((options.max - options.min) / 0.9) * percentage)) + options.min
					Value = round(Value, options.float)
					Value = math.clamp(Value, options.min, options.max)
					sliderTextBox.Text = Value
					sliderBall.Position = UDim2.new(percentage,0,sliderBall.Position.Y.Scale, sliderBall.Position.Y.Offset)

					Resize(25)
				end

				function elements:Dropdown(options)
					if not options.text or not options.default or not options.list  or not options.id then Library:Notify("Dropdown", "Missing arguments!") return end
					local defupdate = updateInGlob(options.id)
					if MINERVA.globset[options.id] then
						options.default = MINERVA.globset[options.id]
					else
						defupdate(options.default)
					end

					local DropYSize = 0
					local Dropped = false

					local Dropdown = Instance("Frame",{
						Name = "Dropdown",
						BackgroundColor3 = Color3.new(1,1,1),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new(0.0697674453, 0, 0.237037033, 0),
						Size = UDim2.new(0, 200, 0, 22),
						ZIndex = 2
					},sectionFrame)
					local dropdownLabel = Instance("TextLabel",{
						Name = "dropdownLabel",
						BackgroundColor3 = Color3.new(1,1,1),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.new(0, 105, 0, 22),
						Font = Enum.Font.Gotham,
						Text = " " .. options.text,
						TextColor3 = Color3.fromRGB(157, 171, 182),
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextWrapped = true
					},Dropdown)
					local dropdownText = Instance("TextLabel",{
						Name = "dropdownText",
						BackgroundColor3 = Color3.fromRGB(2, 5, 12),
						Position = UDim2.new(1.08571434, 0, 0.0909090936, 0),
						Size = UDim2.new(0, 87, 0, 18),
						Font = Enum.Font.Gotham,
						Text = " " .. options.default,
						TextColor3 = Color3.fromRGB(234, 239, 245),
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextWrapped = true
					},dropdownLabel)
					local dropdownArrow = Instance("ImageButton",{
						Name = "dropdownArrow",
						BackgroundColor3 = Color3.fromRGB(2, 5, 12),
						BorderSizePixel = 0,
						Position = UDim2.new(0.87356323, 0, 0.138888866, 0),
						Size = UDim2.new(0, 11, 0, 13),
						AutoButtonColor = false,
						Image = "rbxassetid://8008296380",
						ImageColor3 = Color3.fromRGB(157, 171, 182)
					},dropdownText)
					local dropdownList = Instance("Frame",{
						Name = "dropdownList",
						BackgroundColor3 = Color3.fromRGB(2, 5, 12),
						Position = UDim2.new(0, 0, 1, 0),
						Size = UDim2.new(0, 87, 0, 0),
						ClipsDescendants = true,
						BorderSizePixel = 0,
						ZIndex = 10
					},dropdownText)

					Instance("UIListLayout",{ -- dropListLayout
						Name = "dropListLayout",
						SortOrder = Enum.SortOrder.LayoutOrder
					},dropdownList)
					buttoneffect({frame = dropdownLabel, entered = Dropdown})

					dropdownArrow.MouseButton1Click:Connect(function()
						Dropped = not Dropped
						if Dropped then
							if dropdownLabel.TextColor3 ~= Color3.fromRGB(234, 239, 245) then
								Services.TweenService:Create(dropdownLabel, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
									TextColor3 = Color3.fromRGB(234, 239, 246)
								}):Play()
							end
							Services.TweenService:Create(dropdownList, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
								Size = UDim2.new(0, 87, 0, DropYSize)
							}):Play()
							Services.TweenService:Create(dropdownList, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
								BorderSizePixel = 1
							}):Play()
						elseif not Dropped then
							if dropdownLabel.TextColor3 ~= Color3.fromRGB(157, 171, 182) then
								Services.TweenService:Create(dropdownLabel, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
									TextColor3 = Color3.fromRGB(157, 171, 182)
								}):Play()
							end
							Services.TweenService:Create(dropdownList, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
								Size = UDim2.new(0, 87, 0, 0)
							}):Play()
							Services.TweenService:Create(dropdownList, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
								BorderSizePixel = 0
							}):Play()
						end
					end)
					
					Resize(25)

					for i,v in pairs(options.list) do
						local dropdownBtn = Instance("TextButton",{
							Name = "dropdownBtn",
							BackgroundColor3 = Color3.fromRGB(234, 239, 245),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = UDim2.new(-0.0110929646, 0, 0.0305557251, 0),
							Size = UDim2.new(0, 87, 0, 18),
							AutoButtonColor = false,
							Font = Enum.Font.Gotham,
							TextColor3 = Color3.fromRGB(234, 239, 245),
							TextSize = 12,
							Text = v,
							ZIndex = 15
						},dropdownList)
						local Count = 1
						
						clickEffect({button = dropdownBtn, amount = 5, textsize = dropdownBtn.TextSize})

						Count = Count + 1
						dropdownList.ZIndex -= Count
						DropYSize = DropYSize + 18

						dropdownBtn.MouseButton1Click:Connect(function()
							dropdownText.Text = " " .. v
							options.callback(Dropdown,v)
							defupdate(v)
						end)
					end
				end

				function elements:Textbox(options)
					if not options.text or not options.value  then Library:Notify("Textbox", "Missing arguments!") return end

					local Textbox = Instance("Frame",{
						Name = "Textbox",
						BackgroundColor3 = Color3.new(1,1,1),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new(0.0348837227, 0, 0.945454538, 0),
						Size = UDim2.new(0, 200, 0, 22)
					},sectionFrame)
					local textBoxLabel = Instance("TextLabel",{
						Name = "textBoxLabel",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(157, 171, 182),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.237000003, 0, 0.5, 0),
						Size = UDim2.new(0, 99, 0, 22),
						Font = Enum.Font.Gotham,
						Text = "  " .. options.text,
						TextColor3 = Color3.fromRGB(157, 171, 182),
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left
					},Textbox)
					local textBox = Instance("TextBox",{
						Name = "textBox",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(1, 7, 17),
						Position = UDim2.new(0.850000024, 0, 0.5, 0),
						Size = UDim2.new(0, 53, 0, 15),
						Font = Enum.Font.Gotham,
						Text = options.value,
						TextColor3 = Color3.fromRGB(234, 239, 245),
						TextSize = 11,
						TextWrapped = true
					},Textbox)

					buttoneffect({frame = textBoxLabel, entered = Textbox})
					Resize(25)

					textBox.Focused:Connect(function()
						Services.TweenService:Create(textBoxLabel, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextColor3 = Color3.fromRGB(234, 239, 246)}):Play()
					end)

					textBox.FocusLost:Connect(function(Enter)
						Services.TweenService:Create(textBoxLabel, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextColor3 = Color3.fromRGB(157, 171, 182)}):Play()
						if Enter then
							if textBox.Text ~= nil and textBox.Text ~= "" then
								options.callback(textBox,textBox.Text)
							end
						end
					end)
				end

				function elements:Colorpicker(options)
					if not options.text or not options.color  or not options.id then Library:Notify("Colorpicker", "Missing arguments!") return end
					local hue, sat, val = Color3.toHSV(options.color)
					local defupdate = updateInGlob(options.id)
					if MINERVA.globset[options.id] then
						local rhg = MINERVA.globset[options.id]
						hue,sat,val = rhg[1],rhg[2],rhg[3]
					else
						defupdate({hue,sat,val})
					end

					local Colorpicker = Instance("Frame",{
						Name = "Colorpicker",
						BackgroundColor3 = Color3.new(1,1,1),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new(0.0348837227, 0, 0.945454538, 0),
						Size = UDim2.new(0, 200, 0, 22),
						ZIndex = 2
					},sectionFrame)
					local colorpickerLabel = Instance("TextLabel",{
						Name = "colorpickerLabel",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(157, 171, 182),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(0, 200, 0, 22),
						Font = Enum.Font.Gotham,
						Text = " " .. options.text,
						TextColor3 = Color3.fromRGB(157, 171, 182),
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left
					},Colorpicker)
					local colorpickerButton = Instance("ImageButton",{
						Name = "colorpickerButton",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.new(1,1,1),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new(0.920, 0, 0.57, 0),
						Size = UDim2.new(0, 15, 0, 15),
						Image = "rbxassetid://8023491332"
					},colorpickerLabel)
					local colorpickerFrame = Instance("Frame",{
						Name = "colorpickerFrame",
						Visible = false,
						BackgroundColor3 = Color3.fromRGB(0, 10, 21),
						Position = UDim2.new(1.15, 0, 0.5, 0),
						Size = UDim2.new(0, 251, 0, 221),
						ZIndex = 15
					},Colorpicker)
					local RGB = Instance("ImageButton",{
						Name = "RGB",
						BackgroundColor3 = Color3.new(1,1,1),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new(0.0670000017, 0, 0.0680000037, 0),
						Size = UDim2.new(0, 179, 0, 161),
						AutoButtonColor = false,
						Image = "rbxassetid://6523286724",
						ZIndex = 16
					},colorpickerFrame)
					local RGBCircle = Instance("ImageLabel",{
						Name = "RGBCircle",
						BackgroundColor3 = Color3.new(1,1,1),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(27, 42, 53),
						BorderSizePixel = 0,
						Size = UDim2.new(0, 14, 0, 14),
						Image = "rbxassetid://3926309567",
						ImageRectOffset = Vector2.new(628, 420),
						ImageRectSize = Vector2.new(48, 48),
						ZIndex = 16
					},RGB)
					local Darkness = Instance("ImageButton",{
						Name = "Darkness",
						BackgroundColor3 = Color3.new(1,1,1),
						BorderSizePixel = 0,
						Position = UDim2.new(0.831940293, 0, 0.0680000708, 0),
						Size = UDim2.new(0, 33, 0, 161),
						AutoButtonColor = false,
						Image = "rbxassetid://156579757",
						ZIndex = 16
					},colorpickerFrame)
					local DarknessCircle = Instance("Frame",{
						Name = "DarknessCircle",
						BackgroundColor3 = Color3.new(1,1,1),
						BorderSizePixel = 0,
						Position = UDim2.new(0, 0, 0, 0),
						Size = UDim2.new(0, 33, 0, 5),
						ZIndex = 16
					},Darkness)
					local colorHex = Instance("TextLabel",{
						Name = "colorHex",
						BackgroundColor3 = Color3.fromRGB(9, 8, 13),
						Position = UDim2.new(0.0717131495, 0, 0.850678742, 0),
						Size = UDim2.new(0, 94, 0, 24),
						Font = Enum.Font.GothamSemibold,
						Text = "#FFFFFF",
						TextColor3 = Color3.fromRGB(234, 239, 245),
						TextSize = 14,
						ZIndex = 16
					},colorpickerFrame)
					local Copy = Instance("TextButton",{
						BackgroundColor3 = Color3.fromRGB(9, 8, 13),
						Position = UDim2.new(0.72111553, 0, 0.850678742, 0),
						Size = UDim2.new(0, 60, 0, 24),
						AutoButtonColor = false,
						Font = Enum.Font.GothamSemibold,
						Text = "Copy",
						TextColor3 = Color3.fromRGB(234, 239, 245),
						TextSize = 14,
						ZIndex = 16
					},colorpickerFrame)
					buttoneffect({frame = colorpickerLabel, entered = Colorpicker})

					local vis = false
					colorpickerButton.MouseButton1Click:Connect(function()
						colorpickerFrame.Visible = not colorpickerFrame.Visible
						vis = not vis
						Services.TweenService:Create(colorpickerLabel, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
							TextColor3 = vis and Color3.fromRGB(234, 239, 246) or Color3.fromRGB(157, 171, 182)
						}):Play()
					end)
					
					Dragify(colorpickerFrame, Colorpicker)
					
					Resize(25)
					Copy.MouseButton1Click:Connect(function()
						if setclipboard then
							setclipboard(tostring(colorHex.Text))
							Library:Notify(bozoname, tostring(colorHex.Text))
							Library:Notify(bozoname, "Done!")
						else
							print(tostring(colorHex.Text))
							Library:Notify(bozoname, tostring(colorHex.Text))
							Library:Notify(bozoname, "Your exploit doesn't support the function 'setclipboard', so we've printed it out.")
						end
					end)

					local ceil,clamp,atan2,pi = math.ceil,math.clamp,math.atan2,math.pi
					--local tostr,sub             = tostring,string.sub
					--local fromHSV               = Color3.fromHSV
					--local v2,udim2              = Vector2.new,UDim2.new

					local WheelDown = false
					local SlideDown = false

					local function toPolar(v)
						return atan2(v.y, v.x), v.magnitude;
					end

					local function radToDeg(x)
						return ((x + pi) / (2 * pi)) * 360;
					end
					local hue, saturation, value = 0, 0, 1;
					local color = {1,1,1}

					local function to_hex(color)
						return string.format("#%02X%02X%02X", color.R * 255, color.G * 255, color.B * 255)
					end
					local function update()
						local r = color[1];
						local g = color[2];
						local b = color[3];

						local c = Color3.fromHSV(r, g, b);
						colorHex.Text = tostring(to_hex(c))
					end
					local function mouseLocation()
						return LostMouse
					end
					local function UpdateSlide(iX,iY)   
						local ml = mouseLocation()
						local y = ml.Y - Darkness.AbsolutePosition.Y
						local maxY = Darkness.AbsoluteSize.Y
						if y<0 then y=0 end
						if y>maxY then y=maxY end
						y = y/maxY
						local cy = DarknessCircle.AbsoluteSize.Y/2
						color = {color[1],color[2],1-y}
						local realcolor = Color3.fromHSV(color[1],color[2],color[3])
						DarknessCircle.BackgroundColor3 = realcolor
						DarknessCircle.Position = UDim2.new(0,0,y,-cy)
						options.callback(Colorpicker,realcolor)
						defupdate({Color3.toHSV(realcolor)})

						update();
					end
					local function UpdateRing(iX,iY)
						local ml = mouseLocation()
						local x,y = ml.X - RGB.AbsolutePosition.X,ml.Y - RGB.AbsolutePosition.Y
						local maxX,maxY = RGB.AbsoluteSize.X,RGB.AbsoluteSize.Y
						if x<0 then 
							x=0 
						end
						if x>maxX then 
							x=maxX 
						end
						if y<0 then 
							y=0 
						end
						if y>maxY then 
							y=maxY
						end
						x = x/maxX
						y = y/maxY

						local cx = RGBCircle.AbsoluteSize.X/2
						local cy = RGBCircle.AbsoluteSize.Y/2

						RGBCircle.Position = UDim2.new(x,-cx,y,-cy)

						color = {1-x,1-y,color[3]}
						local realcolor = Color3.fromHSV(color[1],color[2],color[3])
						Darkness.BackgroundColor3 = realcolor
						DarknessCircle.BackgroundColor3 = realcolor
						options.callback(Colorpicker,realcolor)
						defupdate({Color3.toHSV(realcolor)})
						update();
					end


					RGB.MouseButton1Down:Connect(function()
						WheelDown = true
						UpdateRing(LostMouse.X,LostMouse.Y)
					end)
					Darkness.MouseButton1Down:Connect(function()
						SlideDown = true
						UpdateSlide(LostMouse.X,LostMouse.Y)
					end)

					
					LibraryMaid:GiveTask(
						Services.UserInputService.InputEnded:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								WheelDown = false
								SlideDown = false
							end
						end)
					)

					RGB.MouseMoved:Connect(function()
						if WheelDown then
							UpdateRing(LostMouse.X,LostMouse.Y)
						end
					end)
					Darkness.MouseMoved:Connect(function()
						if SlideDown then
							UpdateSlide(LostMouse.X,LostMouse.Y)
						end
					end)

					local function setcolor(tbl)
						local realcolor = Color3.fromHSV(tbl[1],tbl[2],tbl[3])
						colorHex.Text = tostring(to_hex(realcolor))
						DarknessCircle.BackgroundColor3 = realcolor
					end
					setcolor({hue,sat,val})
				end

				function elements:Keybind(options)
					if not options.text  or not options.id then return Library:Notify("Keybind", "Missing arguments") end
					if not options.default then
						options.default = 'NONE'
					end
					local oldKey = type(options.default) == 'string' and options.default or options.default.Name
					local defupdate = updateInGlob(options.id)
					if MINERVA.globset[options.id] then
						oldKey = MINERVA.globset[options.id]
					else
						defupdate(oldKey)
					end

					Resize(25)
					local Keybind = Instance("Frame",{
						Name = "Keybind",
						BackgroundColor3 = Color3.new(1,1,1),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new(0.0348837227, 0, 0.945454538, 0),
						Size = UDim2.new(0, 200, 0, 22),
						ZIndex = 2
					},sectionFrame)
					local keybindButton = Instance("TextButton",{
						Name = "keybindButton",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.new(1,1,1),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(0, 200, 0, 22),
						AutoButtonColor = false,
						Font = Enum.Font.Gotham,
						Text = " " .. options.text,
						TextColor3 = Color3.fromRGB(157, 171, 182),
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left
					},Keybind)
					local keybindLabel = Instance("TextLabel",{
						Name = "keybindLabel",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(157, 171, 182),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.910000026, 0, 0.5, 0),
						Size = UDim2.new(0, 36, 0, 22),
						Font = Enum.Font.Gotham,
						Text = oldKey .. " ",
						TextColor3 = Color3.fromRGB(157, 171, 182),
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Right
					},keybindButton)
					local isWait = false
					
					buttoneffect({frame = keybindButton, entered = Keybind})

					keybindButton.MouseButton1Click:Connect(function()
						isWait = true
						keybindLabel.Text = "... "
						Services.TweenService:Create(keybindButton, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
							TextColor3 = Color3.fromRGB(234, 239, 246)
						}):Play()
						Services.TweenService:Create(keybindLabel, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
							TextColor3 = Color3.fromRGB(234, 239, 246)
						}):Play()
						local inputbegan = Services.UserInputService.InputBegan:Wait()
						Services.TweenService:Create(keybindButton, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
							TextColor3 = Color3.fromRGB(157, 171, 182)
						}):Play()
						Services.TweenService:Create(keybindLabel, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
							TextColor3 = Color3.fromRGB(157, 171, 182)
						}):Play()
						if not blacklisted_keys[inputbegan.KeyCode.Name] then
							if inputbegan.KeyCode == Enum.KeyCode.Escape then
								keybindLabel.Text = 'NONE'
								oldKey = 'NONE'
							else
								keybindLabel.Text = short_keys[inputbegan.KeyCode.Name] or inputbegan.KeyCode.Name
								oldKey = inputbegan.KeyCode.Name
							end
						else
							keybindLabel.Text = short_keys[oldKey] or oldKey
						end
						wait()
						isWait = false
						defupdate(oldKey)
					end)
					
					LibraryMaid:GiveTask(
						Services.UserInputService.InputBegan:connect(function(key, focused)
							if not focused then
								if key.KeyCode.Name == oldKey and not isWait then
									options.callback(Keybind,oldKey)
								end
							end
						end)
					)
				end
				
				return options.children(elements)
			end
			return options.children(sections)
		end
		return options.children(tabs)
	end
	return options.children(tabsections)
	--return tabsections
end
return Library
