--
-- Created by IntelliJ IDEA.  Copyright (C) 2017 Hanks
-- User: hanks
-- Date: 2017/5/3
-- Time: 16:29
--

local activity = ...
local TextView = luajava.bindClass('android.widget.TextView')
local Toast = luajava.bindClass('android.widget.Toast')
activity:setTitle('LuaAndroid')

function onCreate(savedInstanceState)
    print('lua onCreate', savedInstanceState)
    local view = TextView.new(activity)
    view:setText('hhhhhhh')
    view:setTextSize(100)
    activity:setContentView(view)

    local button_cb = {}
    button_cb.onClick = function (ev)
        Toast:makeText(activity, ev:toString(), Toast.LENGTH_SHORT):show()
    end

    local buttonProxy = luajava.createProxy("android.view.View$OnClickListener", button_cb)
    view:setOnClickListener(buttonProxy)
end

function onStart()
    print('lua onStart')
end

function onResume()
    print('lua onResume')
end

function onStop()
    print('lua onStop')
end

function onDestroy()
    print('lua onDestroy')
end
