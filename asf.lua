local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/c1vx/myupd/main/bib.lua"))()

local mainWin = library:new({ name = "My Script Menu", color = Color3.fromRGB(225, 58, 81) })
local mainPage = mainWin:page({ name = "Главная" })
local mainSec = mainPage:section({ name = "Функции" })

mainSec:button({
    name = "Приветственное сообщение",
    callback = function()
        print("Скрипт успешно работает!")
    end
})

mainSec:toggle({
    name = "Тестовый Toggle",
    def = false,
    callback = function(state)
        print("Состояние переключено:", state)
    end
})
