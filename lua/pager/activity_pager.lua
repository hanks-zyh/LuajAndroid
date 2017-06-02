require "import"

import "android.widget.*"
import "android.content.*"
import "android.support.v4.view.ViewPager"
import "androlua.adapter.LuaPagerAdapter"

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

function onCreate(savedInstanceState)
    activity.setTitle('Test Pager')
    activity.setContentView(loadlayout(layout))
    local adapter = LuaPagerAdapter(data)
    pageview.setAdapter(adapter)
end


