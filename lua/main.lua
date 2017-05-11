require "import"
import "android.widget.*"
import "android.content.*"
import "android.support.v4.view.ViewPager"
import "android.support.v7.widget.Toolbar"

local layout = require "layout_main"

activity.setTitle('LuaFileActicity')

function onCreate(savedInstanceState)
--    local layout = LinearLayout(activity)
--    layout.setOrientation(LinearLayout.VERTICAL)
--    local button = Button(activity)
--    local toolbar = Toolbar(activity)
--    button.setText("click me")
--    layout.addView(toolbar)
--    layout.addView(button)
--    toolbar.setBackgroundColor(0xff223344)
--    toolbar.getLayoutParams().width=300
--    toolbar.getLayoutParams().height=100
--
--    activity.setContentView(layout)
--    button.onClick=function(v)
--        print("click"..v.toString())
--    end
    activity.setContentView(loadlayout(layout))
end

function  onCreateOptionsMenu(menu)
    menu.addSubMenu("setting")
    menu.addSubMenu("about")
end