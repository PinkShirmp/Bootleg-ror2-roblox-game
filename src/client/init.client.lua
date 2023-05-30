local Workspace = game:GetService("Workspace")
local Camera = Workspace:WaitForChild"CameraPart"

local CurrentCamera = workspace.CurrentCamera

CurrentCamera.CameraType = Enum.CameraType.Scriptable
CurrentCamera.Focus = Camera.CFrame

CurrentCamera.CFrame = Camera.CFrame
