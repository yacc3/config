local AutoReload = require "lib.auto-reload"
local Clock = require "lib.analogclock"
local Input = require "lib.input-manager"

AutoReload:init()
Clock:init()

-- create menubar
-- 具有 http://www.hammerspoon.org/docs/hs.menubar.html#setMenu中的属性
-- title checked state disabled menue image tooltip shortcut indent 
-- mixedStateImage onStateImage offStateImage
-- 具有一个 onClicked() 成员方法

local menutab = {
    Caffeine,
    Record,
    {title = "-"},
    Post,
}

local menu = hs.menubar.new()
function  getmenutab()
    print("set menutab")
    for i = 1, #menutab do -- menutab[i] is a iterm
        menutab[i].fn = function ()
            if menutab[i].onClicked then
                menutab[i]:onClicked()
                menu:setMenu(getmenutab())
            end
        end
    end
    return menutab
end

-- menu:setIcon(hs.image.imageFromPath("./assets/statusicon.pdf"))
-- menu:setMenu(getmenutab());
