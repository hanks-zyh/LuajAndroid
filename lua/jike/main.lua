require "import"
import "android.widget.*"
import "android.content.*"
import "android.support.design.widget.BottomNavigationView"
import "androlua.widget.viewpager.NoScrollViewPager"
import "androlua.utils.ColorStateListFactory"
import "androlua.LuaDrawable"
local uihelper = require("common.uihelper")
local recommendFragment = require("jike.fragment_recoment")
local feedFragment = require("jike.fragment_feed")

local layout = {
    LinearLayout,
    orientation = "vertical",
    {
        NoScrollViewPager,
        id = "viewPager",
        layout_width = "fill",
        layout_weight = 1,
        background = "#ffffff",
    },
    {
        BottomNavigationView,
        id = "bottomView",
        elevation="3dp",
        layout_width = "fill",
        layout_height = "56dp",
        background = "#ffffff",
    }
}

local data = {
    titles = {},
    fragments = {},
}

local adapter = LuaFragmentPageAdapter(activity.getSupportFragmentManager(),
    luajava.createProxy("androlua.LuaFragmentPageAdapter$AdapterCreator", {
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
    activity.setStatusBarColor(0x33000000)
    activity.setContentView(loadlayout(layout))


local TYPE = {
    -- post
    recommendFeed = '/1.0/recommendFeed/list',
    newsFeed = '/1.0/newsFeed/list',
    -- hot get
    hotFeedAll = '/1.0/users/messages/listPopularByTag?tag=ALL',
    hotFeedAll = '/1.0/users/messages/listPopularByTag?tag=VIDEO',
    hotFeedAll = '/1.0/users/messages/listPopularByTag?tag=GIF',
    hotFeedAll = '/1.0/users/messages/listPopularByTag?tag=MUSIC',
}

    table.insert(data.fragments, recommendFragment.newInstance())
    table.insert(data.fragments, recommendFragment.newInstance())
    table.insert(data.fragments, feedFragment.newInstance())
    table.insert(data.titles, "推荐")
    table.insert(data.titles, "热门")
    table.insert(data.titles, "订阅")
    uihelper.runOnUiThread(activity, function()
        adapter.notifyDataSetChanged()
    end)

    viewPager.setAdapter(adapter)
    bottomView.setItemTextColor(ColorStateListFactory.newInstance(0xFFC7C7C7, 0xFF1E1E1E))
    bottomView.setItemIconTintList(ColorStateListFactory.newInstance(0xFFC7C7C7, 0xFF1E1E1E))
    local recommentDrawable = LuaDrawable.create('jike/img/recoment.png')
    local hotDrawable = LuaDrawable.create('jike/img/hot.png')
    local feedDrawable = LuaDrawable.create('jike/img/feed.png')
    bottomView.getMenu().add("推荐").setIcon(recommentDrawable)
    bottomView.getMenu().add("热门").setIcon(hotDrawable)
    bottomView.getMenu().add("订阅").setIcon(feedDrawable)
    bottomView.setOnNavigationItemSelectedListener(luajava.createProxy('android.support.design.widget.BottomNavigationView$OnNavigationItemSelectedListener', {
        onNavigationItemSelected = function(item)
            local title = item.getTitle()
            if title == "推荐" then viewPager.setCurrentItem(0, false) end
            if title == "热门" then viewPager.setCurrentItem(1, false) end
            if title == "订阅" then viewPager.setCurrentItem(2, false) end
            return true
        end
    }))
end
