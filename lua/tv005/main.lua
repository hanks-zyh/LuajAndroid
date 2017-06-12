--
-- Created by IntelliJ IDEA.  Copyright (C) 2017 Hanks
-- User: hanks
-- Date: 2017/5/26
-- A agc news app
--
require "import"
import "android.widget.*"
import "android.content.*"
import "android.view.View"

import "android.support.v4.view.ViewPager"
import "android.support.design.widget.TabLayout"
import "androlua.adapter.LuaFragmentPageAdapter"

local fragmentNews = require "tv005/fragment_agc_news"

local layout = {
    LinearLayout,
    layout_width = "fill",
    layout_height = "fill",
    orientation = "vertical",
    statusBarColor = "#fb7299",
    {
        TabLayout,
        id = "tab",
        layout_width = "fill",
        layout_height = "48dp",
        background = "#fffb7299",
    },
    {
      FrameLayout,
      {
          ViewPager,
          id = "viewPager",
          layout_width = "fill",
          layout_height = "fill",
      },
      {
        View,
        layout_width = "fill",
        layout_height = "3dp",
        background = "@drawable/shadow_line_top",
      }
    },
}

local data = {
    titles = {},
    fragments = {},
}

table.insert(data.fragments, fragmentNews.newInstance("http://www.005.tv/xw/dmxw/list_527_%s.html"))
table.insert(data.titles, '动漫新闻')

table.insert(data.fragments, fragmentNews.newInstance("http://www.005.tv/xw/yjdt/list_528_%s.html"))
table.insert(data.titles, '业界动态')

table.insert(data.fragments, fragmentNews.newInstance("http://www.005.tv/xw/qtrd/list_529_%s.html"))
table.insert(data.titles, '其他热点')

table.insert(data.fragments, fragmentNews.newInstance("http://www.005.tv/Cosplay/Cosplay/list_631_%s.html"))
table.insert(data.titles, 'Cosplay')


local adapter = LuaFragmentPageAdapter(activity.getSupportFragmentManager(),
    luajava.createProxy("androlua.adapter.LuaFragmentPageAdapter$AdapterCreator", {
        getCount = function() return #data.fragments end,
        getItem = function(position)
            position = position + 1
            return data.fragments[position]
        end,
        getPageTitle = function(position)
            position = position + 1
            return data.titles[position]
        end
    }))

function onCreate(savedInstanceState)
    activity.setContentView(loadlayout(layout))
    viewPager.setAdapter(adapter)
    tab.setSelectedTabIndicatorColor(0xffffffff)
    tab.setTabTextColors(0x88ffffff, 0xffffffff)
    tab.setTabMode(TabLayout.MODE_SCROLLABLE)
    tab.setTabGravity(TabLayout.GRAVITY_CENTER)
    tab.setupWithViewPager(viewPager)
end
