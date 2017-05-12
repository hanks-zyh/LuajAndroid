--
-- Created by IntelliJ IDEA.  Copyright (C) 2017 Hanks
-- User: hanks
-- Date: 2017/5/12
-- Time: 16:40
-- using imageview in lua
--
require "import"
import "android.widget.*"
import "android.content.*"

local layout = require "image.layout_image"

function onCreate(savedInstanceState)
    activity.setTitle('Test Image')
    activity.setContentView(loadlayout(layout))
end


