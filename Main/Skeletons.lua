--// Services

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

--// Tables

local Functions = {}
local Storage = {
    Drawing = {},
}

--// Functions

function Functions.Line()
    --// change properties if you want (upon execution)

    local Line = Drawing.new("Line")
    Line.Thickness = 1
    Line.Color = Color3.fromRGB(255, 255, 255)

    return Line
end

function Functions.Cache(Player)
    if Player and Player.Character and not Storage.Drawing[Player] then
        Storage.Drawing[Player] = {
            Lines = {
                Head = Functions.Line(),
                TorsoLeftUpperArm = Functions.Line(),
                TorsoRightUpperArm = Functions.Line(),
                LeftUpperArmLowerArm = Functions.Line(),
                RightUpperArmLowerArm = Functions.Line(),
                LeftLowerArmHand = Functions.Line(),
                RightLowerArmHand = Functions.Line(),
                TorsoLeftUpperLeg = Functions.Line(),
                TorsoRightUpperLeg = Functions.Line(),
                LeftUpperLegLowerLeg = Functions.Line(),
                RightUpperLegLowerLeg = Functions.Line(),
            }            
        }
    end
end

function Functions.CacheRemove(Player)
    if Storage.Drawing[Player] then
        local Lines = Storage.Drawing[Player].Lines

        for i, Line in Lines do
            Line.Visible = false
            Line:Remove()
        end

        Storage.Drawing[Player] = nil
    end
end

--// Rest

do --// Logic

    RunService.RenderStepped:Connect(function()

        for i, Player in Players:GetPlayers() do
            Functions.Cache(Player)
        end
    
        do --// Loops
    
            for Player, PlayerStorage in Storage.Drawing do
                if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChildOfClass("Humanoid") then
        
                    local Character = Player.Character
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                    local RigType = Humanoid.RigType == Enum.HumanoidRigType.R15 and "R15" or "R6"
                    local PlayerLines = PlayerStorage.Lines
        
                    local Bodyparts = {
                        R15 = {
                            Head = Character:FindFirstChild("Head"),
                            Torso = Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso"),
                            LeftUpperArm = Character:FindFirstChild("LeftUpperArm"),
                            RightUpperArm = Character:FindFirstChild("RightUpperArm"),
                            LeftLowerArm = Character:FindFirstChild("LeftLowerArm"),
                            RightLowerArm = Character:FindFirstChild("RightLowerArm"),
                            LeftUpperLeg = Character:FindFirstChild("LeftUpperLeg"),
                            RightUpperLeg = Character:FindFirstChild("RightUpperLeg"),
                            LeftLowerLeg = Character:FindFirstChild("LeftLowerLeg"),
                            RightLowerLeg = Character:FindFirstChild("RightLowerLeg"),
                            LeftHand = Character:FindFirstChild("LeftHand"),
                            RightHand = Character:FindFirstChild("RightHand"),
                        },
                        R6 = {
                            Head = Character:FindFirstChild("Head"),
                            Torso = Character:FindFirstChild("Torso"),
                            LeftArm = Character:FindFirstChild("Left Arm"),
                            RightArm = Character:FindFirstChild("Right Arm"),
                            LeftLeg = Character:FindFirstChild("Left Leg"),
                            RightLeg = Character:FindFirstChild("Right Leg"),
                        }
                    }
                    
                    local Lines = {
                        R15 = {
                            {Drawing = PlayerLines.Head, From = Bodyparts.R15.Head, To = Bodyparts.R15.Torso},
                            {Drawing = PlayerLines.TorsoLeftUpperArm, From = Bodyparts.R15.Torso, To = Bodyparts.R15.LeftUpperArm},
                            {Drawing = PlayerLines.TorsoRightUpperArm, From = Bodyparts.R15.Torso, To = Bodyparts.R15.RightUpperArm},
                            {Drawing = PlayerLines.LeftUpperArmLowerArm, From = Bodyparts.R15.LeftUpperArm, To = Bodyparts.R15.LeftLowerArm},
                            {Drawing = PlayerLines.RightUpperArmLowerArm, From = Bodyparts.R15.RightUpperArm, To = Bodyparts.R15.RightLowerArm},
                            {Drawing = PlayerLines.LeftLowerArmHand, From = Bodyparts.R15.LeftLowerArm, To = Bodyparts.R15.LeftHand},
                            {Drawing = PlayerLines.RightLowerArmHand, From = Bodyparts.R15.RightLowerArm, To = Bodyparts.R15.RightHand},
                            {Drawing = PlayerLines.TorsoLeftUpperLeg, From = Bodyparts.R15.Torso, To = Bodyparts.R15.LeftUpperLeg},
                            {Drawing = PlayerLines.TorsoRightUpperLeg, From = Bodyparts.R15.Torso, To = Bodyparts.R15.RightUpperLeg},
                            {Drawing = PlayerLines.LeftUpperLegLowerLeg, From = Bodyparts.R15.LeftUpperLeg, To = Bodyparts.R15.LeftLowerLeg},
                            {Drawing = PlayerLines.RightUpperLegLowerLeg, From = Bodyparts.R15.RightUpperLeg, To = Bodyparts.R15.RightLowerLeg},
                        },
                        R6 = {
                            {Drawing = PlayerLines.Head, From = Bodyparts.R6.Head, To = Bodyparts.R6.Torso},
                            {Drawing = PlayerLines.TorsoLeftUpperArm, From = Bodyparts.R6.Torso, To = Bodyparts.R6.LeftArm},
                            {Drawing = PlayerLines.TorsoRightUpperArm, From = Bodyparts.R6.Torso, To = Bodyparts.R6.RightArm},
                            {Drawing = PlayerLines.TorsoLeftUpperLeg, From = Bodyparts.R6.Torso, To = Bodyparts.R6.LeftLeg},
                            {Drawing = PlayerLines.TorsoRightUpperLeg, From = Bodyparts.R6.Torso, To = Bodyparts.R6.RightLeg},
                        }
                    }
        
                    if Lines[RigType] then
                        for i, DrawArrays in Lines[RigType] do
                            if DrawArrays.From and DrawArrays.To then
        
                                local FromW2S, FromVis = Camera:WorldToViewportPoint(DrawArrays.From.Position)
                                local ToW2S, ToVis = Camera:WorldToViewportPoint(DrawArrays.To.Position)
                                local Line = DrawArrays.Drawing
        
                                if FromVis and ToVis then
                                    Line.From = Vector2.new(FromW2S.X, FromW2S.Y)
                                    Line.To = Vector2.new(ToW2S.X, ToW2S.Y)
                                    Line.Visible = true
                                else
                                    Line.Visible = false
                                end
        
                            else
        
                                DrawArrays.Drawing.Visible = false
        
                            end
                        end
                    end
        
                end
            end
            
        end
    
        do --// Connections
    
            Players.PlayerRemoving:Connect(function(Player)
                Functions.CacheRemove(Player)
            end)
            
        end
    
    
    end)
    
end
