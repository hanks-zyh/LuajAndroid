--
-- Created by IntelliJ IDEA.  Copyright (C) 2017 Hanks
-- User: hanks
-- Date: 2017/5/26
-- A news app
--
require "import"
import "android.widget.*"
import "android.content.*"
import "android.view.View"

import "android.support.v4.view.ViewPager"
import "android.support.design.widget.TabLayout"
import "androlua.adapter.LuaFragmentPageAdapter"

local fragmentNews = require "360news/fragment_news"


-- create view table
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
        background = "#fb7299",
    },
    {
        FrameLayout,
        layout_width = "fill",
        layout_height = "fill",
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
    }
}

local data = {
    titles = {},
    fragments = {},
}

   -- mnews:   http://tran.news.so.com/news/youlike?air=1&f=jsonp&n=",
-- mnewsCat:   http://tran.news.so.com/news/clsnews?f=jsonp&n="

-- table.insert(data.fragments, fragmentNews.newInstance())
-- table.insert(data.titles, '头条')

-- table.insert(data.fragments, fragmentNews.newInstance('social'))
-- table.insert(data.titles, '社会')

-- table.insert(data.fragments, fragmentNews.newInstance('science'))
-- table.insert(data.titles, '科技')

-- table.insert(data.fragments, fragmentNews.newInstance('internet'))
-- table.insert(data.titles, '互联网')

-- table.insert(data.fragments, fragmentNews.newInstance('fun'))
-- table.insert(data.titles, '娱乐')

-- table.insert(data.fragments, fragmentNews.newInstance('funny'))
-- table.insert(data.titles, '搞笑')

-- table.insert(data.fragments, fragmentNews.newInstance('international'))
-- table.insert(data.titles, '国际')

-- table.insert(data.fragments, fragmentNews.newInstance('militery'))
-- table.insert(data.titles, '军事')

-- table.insert(data.fragments, fragmentNews.newInstance('economy'))
-- table.insert(data.titles, '财经')

-- table.insert(data.fragments, fragmentNews.newInstance('car'))
-- table.insert(data.titles, '汽车')

-- table.insert(data.fragments, fragmentNews.newInstance('sport'))
-- table.insert(data.titles, '体育')

-- table.insert(data.fragments, fragmentNews.newInstance('health'))
-- table.insert(data.titles, '健康')

-- table.insert(data.fragments, fragmentNews.newInstance('education'))
-- table.insert(data.titles, '教育')

-- table.insert(data.fragments, fragmentNews.newInstance('newhot'))
-- table.insert(data.titles, '热点')

-- table.insert(data.fragments, fragmentNews.newInstance('domestic'))
-- table.insert(data.titles, '国内')

-- table.insert(data.fragments, fragmentNews.newInstance('gossip'))
-- table.insert(data.titles, '明星八卦')

-- table.insert(data.fragments, fragmentNews.newInstance('variety'))
-- table.insert(data.titles, '综艺')

-- table.insert(data.fragments, fragmentNews.newInstance('fashion'))
-- table.insert(data.titles, '时尚')

-- table.insert(data.fragments, fragmentNews.newInstance('travel'))
-- table.insert(data.titles, '旅游')

-- table.insert(data.fragments, fragmentNews.newInstance('child'))
-- table.insert(data.titles, '育儿')

-- table.insert(data.fragments, fragmentNews.newInstance('food'))
-- table.insert(data.titles, '养生')

-- table.insert(data.fragments, fragmentNews.newInstance('history'))
-- table.insert(data.titles, '美食')

-- table.insert(data.fragments, fragmentNews.newInstance('emotion'))
-- table.insert(data.titles, '历史')

-- table.insert(data.fragments, fragmentNews.newInstance('emotion'))
-- table.insert(data.titles, '情感')

-- table.insert(data.fragments, fragmentNews.newInstance('stock'))
-- table.insert(data.titles, '星座')

-- table.insert(data.fragments, fragmentNews.newInstance('probe'))
-- table.insert(data.titles, '科学探索')

-- table.insert(data.fragments, fragmentNews.newInstance('preg'))
-- table.insert(data.titles, '股票')

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

local function unicode_to_utf8(convertStr)
    local t = {}
    for a in string.gmatch(convertStr, '\\u([0-9a-z][0-9a-z][0-9a-z][0-9a-z])') do
        if #a == 4 then
            local n = tonumber(a, 16)
            assert(n, "String decoding failed: bad Unicode escape " .. a)
            local x
            if n < 0x80 then
                x = string.char(n % 0x80)
            elseif n < 0x800 then
                -- [110x xxxx] [10xx xxxx]
                x = string.char(0xC0 + (math.floor(n / 64) % 0x20), 0x80 + (n % 0x40))
            else
                -- [1110 xxxx] [10xx xxxx] [10xx xxxx]
                x = string.char(0xE0 + (math.floor(n / 4096) % 0x10), 0x80 + (math.floor(n / 64) % 0x40), 0x80 + (n % 0x40))
            end
            convertStr = string.gsub(convertStr, '\\u' .. a, x)
        end
    end
    return convertStr
end

function onCreate(savedInstanceState)

    activity.setContentView(loadlayout(layout))
    viewPager.setAdapter(adapter)
    viewPager.setOffscreenPageLimit(#data.fragments)
    viewPager.setCurrentItem(0)
    tab.setSelectedTabIndicatorColor(0xffffffff)
    tab.setTabTextColors(0x88ffffff, 0xffffffff)
    tab.setTabMode(TabLayout.MODE_SCROLLABLE)
    tab.setTabGravity(TabLayout.GRAVITY_CENTER)
    tab.setupWithViewPager(viewPager)

    LuaHttp.request({url='http://img2.cache.netease.com/f2e/wap/touch_index_2016/trunk/js/newaplib.DSCqS6aALkim.3.js',function (e,code,body )
        uihelper.runOnUiThread(activity, function ( )
            for name,id in string.gmatch(body, '{name:"(\\u.-)".-articleList:{topicid:"(.-)"') do
              if name and id and #id == 16 then
                print(unicode_to_utf8(name),unicode_to_utf8(id))
                data.fragments[#data.fragments + 1]  = unicode_to_utf8(id)
                adapter.notifyDataSetChanged()
              end
            end    
        end)
    end})

end
