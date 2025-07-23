-- ATM Autofarm Script
-- Key: 1718171hsks
-- Load with: loadstring(game:HttpGet('YOUR_RAW_URL'))()

local required_key = "1718171hsks"
local user_input = input("Enter script key: ")

if user_input ~= required_key then
    error("Invalid key! Join our Discord for valid keys")
end

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Anti-detection flags
setfflag("HumanoidParallelRemoveNoPhysics", "False")
setfflag("HumanoidParallelRemoveNoPhysicsNoSimulate2", "False")

print("ATM Autofarm initialized!")

-- Improved safe wait with jitter
local function SafeWait(t)
    local jitter = math.random(80, 120)/100
    wait(t * jitter)
    return t * jitter
end

-- Find nearest ATM
local function FindNearestATM()
    local nearestATM = nil
    local minDistance = math.huge
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("atm") or obj.Name:lower():find("machine")) then
            local primaryPart = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
            if primaryPart then
                local distance = (Root.Position - primaryPart.Position).Magnitude
                if distance < minDistance then
                    minDistance = distance
                    nearestATM = obj
                end
            end
        end
    end
    
    if nearestATM then
        print("Found ATM:", nearestATM.Name, "Distance:", minDistance)
    else
        print("No ATMs found! Searching...")
    end
    
    return nearestATM
end

-- Smooth movement to target
local function SmoothMove(target)
    if not Root or not Root.Parent then
        Character = Player.Character or Player.CharacterAdded:Wait()
        Root = Character:WaitForChild("HumanoidRootPart")
    end
    
    local startPos = Root.Position
    local distance = (startPos - target).Magnitude
    local steps = math.floor(distance / 4) + math.random(4, 8)
    
    print("Moving to ATM | Distance:", math.floor(distance), "Steps:", steps)
    
    for i = 1, steps do
        if not Root or not Root.Parent then break end
        
        local t = i / steps
        local offset = Vector3.new(
            math.random(-50, 50)/100,
            0,
            math.random(-50, 50)/100
        )
        
        local newPos = startPos:Lerp(target, t) + offset
        Root.CFrame = CFrame.new(newPos, target)
        SafeWait(0.08)
    end
end

-- Anti-AFK system
local VirtualInput = game:GetService("VirtualInputManager")
local function AntiAFK()
    coroutine.wrap(function()
        while true do
            -- Random WASD movement
            local keys = {Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
            local key = keys[math.random(1, #keys)]
            
            VirtualInput:SendKeyEvent(true, key, false, nil)
            SafeWait(0.1)
            VirtualInput:SendKeyEvent(false, key, false, nil)
            
            SafeWait(math.random(20, 40))
        end
    end)()
end

-- Main farming function
local function FarmATM(atm)
    local atmPart = atm.PrimaryPart or atm:FindFirstChild("HumanoidRootPart") or atm:FindFirstChildWhichIsA("BasePart")
    if not atmPart then return end
    
    local targetPos = atmPart.Position + Vector3.new(0, 0, -3) -- Position in front of ATM
    
    -- Move to ATM
    SmoothMove(targetPos)
    
    -- Face the ATM
    Root.CFrame = CFrame.new(Root.Position, atmPart.Position)
    SafeWait(0.5)
    
    -- Interaction sequence
    print("Starting interaction with ATM")
    
    -- Simulate pressing E key
    VirtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
    SafeWait(0.2)
    VirtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
    
    -- Random interaction pattern
    local interactionTime = math.random(2, 4)
    local startTime = time()
    
    while time() - startTime < interactionTime do
        -- Random mouse movement
        mousemoverel(math.random(-5, 5), math.random(-5, 5))
        
        -- Random key presses
        if math.random(1, 10) > 8 then
            VirtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
            SafeWait(0.1)
            VirtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
        end
        
        SafeWait(0.5)
    end
    
    -- Final interaction
    VirtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
    SafeWait(0.5)
    VirtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
    
    print("ATM interaction complete")
    
    -- Random break after interaction
    if math.random(1, 10) > 7 then
        local breakTime = math.random(1, 3)
        print("Taking break:", breakTime, "seconds")
        SafeWait(breakTime)
    end
end

-- Main farming loop
AntiAFK()

coroutine.wrap(function()
    while true do
        SafeWait(1)
        
        -- Re-acquire character if needed
        if not Character or not Character.Parent then
            Character = Player.Character or Player.CharacterAdded:Wait()
            Humanoid = Character:WaitForChild("Humanoid")
            Root = Character:WaitForChild("HumanoidRootPart")
        end
        
        -- Find nearest ATM
        local targetATM = FindNearestATM()
        
        if targetATM then
            FarmATM(targetATM)
        else
            -- If no ATM found, move randomly
            local randomPos = Root.Position + Vector3.new(
                math.random(-50, 50),
                0,
                math.random(-50, 50)
            )
            print("Moving to random position")
            SmoothMove(randomPos)
        end
        
        -- Random pause pattern
        if math.random(1, 10) == 1 then
            local longBreak = math.random(2, 5)
            print("Taking longer break:", longBreak, "seconds")
            SafeWait(longBreak)
        end
    end
end)()

print("ATM Autofarm activated successfully! Farming in progress...")
