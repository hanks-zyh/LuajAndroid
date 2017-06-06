
require("import")
import "android.widget.*"
import "android.content.*"
import "android.view.View"
import "androlua.LuaAdapter"

local layout = {
    LinearLayout,
    layout_width = "match",
    layout_height = "match",
    orientation = 'vertical',
    fitsSystemWindows = true,
     {
        TextView,
        layout_height = "56dp",
        layout_width = "match",
        gravity = "center",
        text = "添加城市",
        textSize = "18sp",
        textColor = "#666666",
    },
    {
        EditText,
        id = 'key',
        paddingLeft = "16dp",
        layout_width = "match",
        layout_height = "56dp",
        hint = "搜索城市",
    },
    {
        ListView,
        id = 'listview',
        layout_width = "match",
        layout_height = "match",
    }
}


local China  = require("weather.city")

local item_view = {
    TextView,
    id = "text",
    gravity = "center_vertical",
    layout_widht = "fill",
    layout_height = "56dp",
    paddingLeft = "16dp",
    textColor = "#666666",
}

local data = {}

function onCreate(savedInstanceState)
    activity.setLightStatusBar()
    activity.setContentView(loadlayout(layout))
    
    for k,_ in pairs(China) do
        data[#data + 1] = k
    end

    local adapter = LuaAdapter(luajava.createProxy("androlua.LuaAdapter$AdapterCreator", {
        getCount = function() return #data end,
        getItem = function(position) return nil end,
        getItemId = function(position) return position end,
        getView = function(position, convertView, parent)
            position = position + 1 -- lua 索引从 1开始
            if convertView == nil then
                local views = {} -- store views
                convertView = loadlayout(item_view, views, ListView)
                convertView.getLayoutParams().width = parent.getWidth()
                convertView.setTag(views)
            end
            local views = convertView.getTag()
            local item = data[position]
            print(position,item)
            views.text.setText(item)
            return convertView
        end
    }))
    listview.setAdapter(adapter)
    listview.setOnItemClickListener(luajava.createProxy("android.widget.AdapterView$OnItemClickListener",{
        onItemClick = function(adapter,view,position,id)
            activity.toast('click item:' .. position)
        end,
    }))
end
