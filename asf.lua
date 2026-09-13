local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/c1vx/myupd/main/bib.lua"))()

-- Уведомление при запуске
library:notify({
    title = "KitsuneWare",
    text = "Script Loaded | Pitch: 3 | Speed: 1",
    duration = 5
})

local mainWin = library:new({ name = "KitsuneWare 1.0.1b", color = Color3.fromRGB(85, 170, 255) })

-- ВКЛАДКИ
local combatPage = mainWin:page({ name = "Combat" })
local macrosPage = mainWin:page({ name = "Macros" })
local visualsPage = mainWin:page({ name = "Visuals" })
local ragePage = mainWin:page({ name = "Rage" })
local miscPage = mainWin:page({ name = "Misc" })

---------------------------------------------------------
-- ВКЛАДКА RAGE (как на таймкоде 00:22)
---------------------------------------------------------

-- Левая колонка
local frontDashSec = ragePage:section({ name = "Front Dash", side = "left" })
frontDashSec:toggle({ name = "Enabled", def = false })
frontDashSec:toggle({ name = "Only On Keybind", def = false })
frontDashSec:slider({ name = "Dash Distance", min = 0, max = 100, def = 16 })
frontDashSec:keybind({ name = "Keybind", def = Enum.KeyCode.Q })

local sideDashSec = ragePage:section({ name = "Side Dash", side = "left" })
sideDashSec:toggle({ name = "Enabled", def = false })
sideDashSec:toggle({ name = "Only On Keybind", def = false })
sideDashSec:slider({ name = "Dash Distance", min = 0, max = 100, def = 16 })
sideDashSec:slider({ name = "Dash Size", min = 0, max = 100, def = 10 })
sideDashSec:keybind({ name = "Keybind", def = Enum.KeyCode.E })
sideDashSec:slider({ name = "Delay", min = 0, max = 1, def = 0 })
sideDashSec:toggle({ name = "Omni-Directional", def = false })
sideDashSec:slider({ name = "Desktop Delay", min = 0, max = 1, def = 0 })

-- Правая колонка
local togglesSec = ragePage:section({ name = "Toggles", side = "right" })
togglesSec:toggle({ name = "No Stun", def = false })
togglesSec:toggle({ name = "No Slow", def = false })
togglesSec:toggle({ name = "No Fatigue", def = false })
togglesSec:toggle({ name = "No Upper Limit", def = false })
togglesSec:toggle({ name = "Auto Dodge", def = false })

local flingSec = ragePage:section({ name = "Fling", side = "right" })
flingSec:textbox({ name = "Fling Target", placeholder = "Player Name..." })
flingSec:toggle({ name = "Loop Fling", def = false })
flingSec:button({ name = "Fling", callback = function() print("Fling executed") end })

local antiFlingSec = ragePage:section({ name = "Anti Fling", side = "right" })
antiFlingSec:toggle({ name = "Enabled", def = false })

---------------------------------------------------------
-- БАЗОВЫЕ НАЧИНКИ ДЛЯ ДРУГИХ ВКЛАДОК
---------------------------------------------------------

local combatSec = combatPage:section({ name = "Auto Combat", side = "left" })
combatSec:toggle({ name = "Auto Block", def = false })
combatSec:toggle({ name = "Auto 4in1 Punch", def = false })
combatSec:toggle({ name = "Auto Counter", def = false })

local visualsSec = visualsPage:section({ name = "World", side = "left" })
visualsSec:toggle({ name = "Remove Fog", def = false })
visualsSec:toggle({ name = "No Lighting", def = false })
