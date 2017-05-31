require "import"
import "android.widget.*"
import "android.content.*"
import "android.support.design.widget.BottomNavigationView"
import "android.support.v4.view.ViewPager"
import "androlua.utils.ColorStateListFactory"
import "androlua.LuaDrawable"
local uihelper = require("common.uihelper")
local fragment = require("jike.fragment_recoment")

local layout = {
    LinearLayout,
    orientation = "vertical",
    {
        ViewPager,
        id = "viewPager",
        layout_width = "fill",
        layout_weight = 1,
        background = "#ffffff",
    },
    {
        BottomNavigationView,
        id = "bottomView",
        layout_width = "fill",
        layout_height = "56dp",
        background = "#f1f1f1",
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

    table.insert(data.fragments, fragment.newInstance())
    table.insert(data.fragments, fragment.newInstance())
    table.insert(data.fragments, fragment.newInstance())
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
