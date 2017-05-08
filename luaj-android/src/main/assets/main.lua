--
-- Created by IntelliJ IDEA.  Copyright (C) 2017 Hanks
-- User: hanks
-- Date: 2017/5/3
-- Time: 16:29
--

local  activity,http = ...

local json = require "json"
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end
print_r(activity:getClassLoader())
print_r(luajava)
print_r(package)

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
        http:get("http://m.baidu.com",{
            onFailure=function(e)
                print_r(e)
            end,
            onResponse=function(res)
                print_r(res)
            end
        })

        print_r(json.decode('{"name":"hanks","age":123,"isd":false,"c":222.2}'))
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
