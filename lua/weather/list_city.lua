
require("import")
import "android.widget.*"
import "android.content.*"
import "android.view.View"

local layout = {
  TextView,
  id = "content",
  layout_width = "match",
}


local China  = require("weather.city")

function onCreate(savedInstanceState)
    activity.setStatusBarColor(0x00000000)
    activity.setContentView(loadlayout(layout))
    local text = ''
    for k,v in pairs(China) do
        text  = text .. ',' .. k
    end
end
