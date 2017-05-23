--
-- Created by IntelliJ IDEA.
-- User: hanks
-- Date: 2017/5/13
-- Time: 00:01
-- To change this template use File | Settings | File Templates.
--
require "import"

import "android.widget.*"
import "android.content.*"

local ImageLoader = luajava.bindClass("androlua.LuaImageLoader")

-- create view table
local layout = {
    ListView,
    id = "listview",
    layout_width = "fill",
    layout_height = "fill",
}

local item_view = {
    LinearLayout,
    layout_widht = "fill",
    layout_height = "wrap",
    orientation = "horizontal",
    gravity = "center_vertical",
    padding = "8dp",
    {
        ImageView,
        id = "icon",
        layout_width = "80dp",
        layout_height = "150dp",
    },
    {
        TextView,
        id = "text",
        layout_widht = "fill",
        layout_margin = "8dp",
    }
}


local data = {}

for i = 1, 59 do
    data[i] = {
        url = string.format("http://i.meizitu.net/2017/05/07a%02d.jpg",i),
        text = "this is item : " .. (i-1)
    }
end

local Adapter = luajava.bindClass("androlua.LuaAdapter")


function onCreate(savedInstanceState)
    activity.setTitle('Test List')
    activity.setContentView(loadlayout(layout))

    local adapter = Adapter(luajava.createProxy("androlua.LuaAdapter$AdapterCreator", {
        getCount = function() return #data end,
        getItem = function(position) return nil end,
        getItemId = function(position) return position end,
        getView = function(position, convertView, parent)
            position = position + 1 -- lua 索引从 1开始
            if convertView == nil then
                local views = {} -- store views
                convertView = loadlayout(item_view, views, ListView)
                if parent then
                    local params = convertView.getLayoutParams()
                    params.width = parent.getWidth()
                end
                convertView.setTag(views)
            end
            local views = convertView.getTag()
            local item = data[position]
            if item then
                ImageLoader.load(views.icon, item.url)
                views.text.setText(item.text)
            end
            return convertView
        end
    }))

    listview.setAdapter(adapter)
    listview.setOnItemClickListener(luajava.createProxy("android.widget.AdapterView$OnItemClickListener",{
        onItemClick = function(adapter,view,position,id)
            activity.toast('click item:' .. position)
        end,
    }))
    listview.setOnItemLongClickListener(luajava.createProxy("android.widget.AdapterView$OnItemLongClickListener",{
        onItemLongClick = function(adapter,view,position,id)
            activity.toast('long click item:' .. position)
        end,
    }))
end


