-- Загружаем библиотеку из bib.lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/c1vx/myupd/main/bib.lua"))()

-- Создаем окно
local mainWin = library:new({ name = "My Script Menu", color = Color3.fromRGB(225, 58, 81) })

-- Создаем вкладку
local mainPage = mainWin:page({ name = "Главная" })

-- Создаем секцию
local mainSec = mainPage:section({ name = "Функции" })

-- Добавляем кнопку
mainSec:button({
    name = "Приветственное сообщение",
    callback = function()
        print("Скрипт успешно работает!")
    end
})

-- Добавляем тумблер (Toggle)
mainSec:toggle({
    name = "Тестовый Toggle",
    def = false,
    callback = function(state)
        print("Состояние переключено:", state)
    end
})
