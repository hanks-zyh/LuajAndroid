require "import"

import "android.widget.*"
import "android.content.*"
import "android.support.v4.view.ViewPager"

local layout = {
  ViewPager,
  id = "pageview",
  layout_width="match",
  layout_height="match",
}
local childLayout1 = loadlayout("text.layout_text")
local childLayout2 = loadlayout("image.layout_image")
local data = {
  childLayout1,
  childLayout2,
  loadlayout({
    TextView,
    textSize="33sp",
    textColor="#ff0000",
    gravity="center",
    text="page3",
  }),
  loadlayout({
    TextView,
    textSize="33sp",
    textColor="#00ff00",
    gravity="center",
    text="page4",
  }),
}


local Adapter = luajava.bindClass("androlua.LuaPagerAdapter")
local adapter = Adapter(luajava.createProxy("androlua.LuaPagerAdapter$AdapterCreator", {
     getCount = function() return #data end,
     instantiateItem = function(container,position)
        position = position + 1
        return data[position]
     end
}))


function onCreate(savedInstanceState)
    activity.setTitle('Test Pager')
    activity.setContentView(loadlayout(layout))
    pageview.setAdapter(adapter)
end


