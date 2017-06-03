require "import"
import "android.widget.*"
import "android.content.*"
import "android.support.v4.view.ViewPager"
import "android.support.v7.widget.Toolbar"
import "androlua.LuaActivity"
local layout = require "main.layout_main"
local Adapter = luajava.bindClass("androlua.LuaAdapter")


local item_view = {
    LinearLayout,
    layout_widht = "50dp",
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
        layout_widht = "fill",
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

    data[1] = {
        text = 'text',
        launchPage = 'text/activity_text.lua'
    }
    data[2] = {
        text = 'image',
        launchPage = 'image/activity_image.lua'
    }
    data[3] ={
        text = '开眼',
        launchPage = 'eyepetizer/main.lua'
    }
    data[4] ={
        text = 'pager',
        launchPage = 'pager/activity_pager.lua'
    }
    data[5] ={
        text = 'webview',
        launchPage = 'webview/activity_webview.lua'
    }
    data[6] ={
        text = 'animation',
        launchPage = 'animation/activity_animation.lua'
    }
    data[7] ={
        text = 'http',
        launchPage = 'http/activity_http.lua'
    }

    data[8] ={
        text = 'IT 之家',
        launchPage = 'news/activity_news.lua'
    }

    data[9] ={
        text = '知乎日报',
        launchPage = 'zhihudaliy/activity_zhihu_daliy.lua'
    }

    data[10] ={
        text = '即刻',
        launchPage = 'jike/main.lua'
    }

    local adapter = Adapter(luajava.createProxy("androlua.LuaAdapter$AdapterCreator", {
        getCount = function() return #data end,
        getItem = function(position) return nil end,
        getItemId = function(position) return position end,
        getView = function(position, convertView, parent)
            print(position)
            position = position + 1 -- lua 索引从 1开始
            if convertView == nil then
                local views = {} -- store views
                convertView = loadlayout(item_view, views)
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