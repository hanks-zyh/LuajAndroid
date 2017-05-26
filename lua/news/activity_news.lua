--
-- Created by IntelliJ IDEA.  Copyright (C) 2017 Hanks
-- User: hanks
-- Date: 2017/5/26
-- A news app
--
require "import"
import "android.widget.*"
import "android.content.*"

local ImageLoader = luajava.bindClass("androlua.LuaImageLoader")
import "android.support.v4.view.ViewPager"
import "android.support.design.widget.TabLayout"
local LuaFragmentPageAdapter = luajava.bindClass("androlua.LuaFragmentPageAdapter")

local fragmentNews= require "news/fragment_news"

-- create view table
local layout = {
    LinearLayout,
    layout_width = "fill",
    layout_height = "fill",
    orientation = "vertical",
    fitsSystemWindows = true,
    {
        TabLayout,
        id = "tab",
        layout_width = "fill",
        layout_height = "48dp",
        background = "#2979FB",
        elevation = "2dp",
    },
    {
        ViewPager,
        id = "viewPager",
        layout_width = "fill",
        layout_height = "fill",
    },
}

local page = {
    TextView,
    id = "listView",
    text = "pagekkkkkk",
    textSize = "50sp",
}

local data = {
    titles = {},
    fragments = {},
}

table.insert(data.fragments, fragmentNews.newInstance())
table.insert(data.titles, '科技')

table.insert(data.fragments, fragmentNews.newInstance())
table.insert(data.titles, '互联网')

table.insert(data.fragments, fragmentNews.newInstance())
table.insert(data.titles, '娱乐')

table.insert(data.fragments, fragmentNews.newInstance())
table.insert(data.titles, '程序员')


local adapter = LuaFragmentPageAdapter(activity.getSupportFragmentManager(),
    luajava.createProxy("androlua.LuaFragmentPageAdapter$AdapterCreator", {
        getCount = function() return #data.fragments end,
        getItem = function(position)
            position = position + 1
            return data.fragments[position]
        end,
        getPageTitle = function(position)
            position = position + 1
            return  data.titles[position]
        end
}))

function onCreate(savedInstanceState)
    activity.setContentView(loadlayout(layout))
    viewPager.setAdapter(adapter)
    tab.setSelectedTabIndicatorColor(0xffffffff)
    tab.setTabTextColors(0xffffffff, 0xffeeeeee)
    tab.setupWithViewPager(viewPager)
end


