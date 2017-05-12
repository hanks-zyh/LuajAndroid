--
-- Created by IntelliJ IDEA.  Copyright (C) 2017 Hanks
-- User: hanks
-- Date: 2017/5/12
-- Time: 13:57
--

require "import"
import "android.widget.*"
import "android.content.*"
local AlertBuilder = import "android.app.AlertDialog$Builder"

local layout = require "text.layout_text"

function onCreate(savedInstanceState)
    activity.setTitle('Test Text')
    activity.setContentView(loadlayout(layout))
    btn_1.onClick = function(v)
        AlertBuilder(activity)
            .setTitle('LuaTitle')
            .setMessage('from lua script')
            .setPositiveButton('OK',luajava.createProxy("android.content.DialogInterface$OnClickListener",{
                onClick = function(dialog,witch)
                    activity.toast("click ok")
                end
            }))
            .setNegativeButton('Cancel', nil)
            .show()
    end
end

