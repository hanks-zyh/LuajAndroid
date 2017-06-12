require "import"
import "android.widget.*"
import "android.content.*"
import "android.support.v4.view.ViewPager"
import "android.support.v7.widget.Toolbar"
import "androlua.LuaActivity"
local layout = require "main.layout_main"
import ("androlua.LuaAdapter")


local item_view = {
    LinearLayout,
    layout_width = "50dp",
    layout_height = "wrap",
    orientation = "vertical",
    gravity = "center",
    paddingTop="4dp",
    paddingBottom="4dp",
    {
        ImageView,
        id = "icon",
        layout_width = "40dp",
        layout_height = "40dp",
        src = '@mipmap/ic_launcher_round'
    },
    {
        TextView,
        id = "text",
        textSize = "10sp",
        gravity = "center",
        layout_width = "fill",
        layout_marginTop = "2dp",
    }
}
local data = {}


function newActivity(luaPath)
    local intent = Intent(activity, LuaActivity)
    intent.putExtra("luaPath", luaPath)
    activity.startActivity(intent)
end


function onCreate(savedInstanceState)
    activity.setLightStatusBar()

    activity.setContentView(loadlayout(layout))

    data[#data + 1 ] ={
        text = '动漫资讯',
        launchPage = 'tv005/main.lua'
    }

    data[#data + 1 ] = {
        text = '图解电影',
        launchPage = 'graphmovies/main.lua'
    }

    data[#data + 1 ] ={
        text = '奇趣百科',
        launchPage = 'qiqu/main.lua'
    }
    data[#data + 1 ] ={
        text = '漫本联盟',
        launchPage = 'dm5/main.lua'
    }
    data[#data + 1 ] ={
        text = '豆瓣电影',
        launchPage = 'doubanmovie/main.lua'
    }
    data[#data + 1 ] ={
        text = '开眼',
        launchPage = 'eyepetizer/main.lua'
    }
    data[#data + 1 ] ={
        text = 'IT 之家',
        launchPage = 'news/activity_news.lua'
    }

    data[#data + 1 ] ={
        text = '知乎日报',
        launchPage = 'zhihudaliy/activity_zhihu_daliy.lua'
    }

    data[#data + 1 ] ={
        text = '即刻',
        launchPage = 'jike/main.lua'
    }

    data[#data + 1 ] ={
        text = '天气',
        launchPage = 'weather/main.lua'
    }

    local adapter = LuaAdapter(luajava.createProxy("androlua.LuaAdapter$AdapterCreator", {
        getCount = function() return #data end,
        getItem = function(position) return nil end,
        getItemId = function(position) return position end,
        getView = function(position, convertView, parent)
            position = position + 1 -- lua 索引从 1开始
            if convertView == nil then
                local views = {} -- store views
                convertView = loadlayout(item_view, views, GridView)
                convertView.getLayoutParams().width = 171
                convertView.setTag(views)
            end
            local views = convertView.getTag()
            local item = data[position]
            if item then
                --ImageLoader.load(views.icon, item.url)
                views.text.setText(item.text)
            end
            return convertView
        end
    }))
    gridView.setAdapter(adapter)
    gridView.setOnItemClickListener(luajava.createProxy("android.widget.AdapterView$OnItemClickListener", {
        onItemClick = function(parent, view, position, id)
            position = position + 1 -- lua 索引从 1开始
            local item = data[position]
            newActivity(item.launchPage)
        end
    }))
end

function onCreateOptionsMenu(menu)
    menu.addSubMenu("setting")
    menu.addSubMenu("about")
end
