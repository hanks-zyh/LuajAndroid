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
import "androlua.LuaHttp"
import "androlua.LuaAdapter"
import "androlua.widget.video.VideoPlayerActivity"
import "androlua.LuaImageLoader"
import "androlua.LuaWebView"


local uihelper = require("common.uihelper")
local JSON = require("common.json")

-- create view table
local layout = {
    LinearLayout,
    orientation = "vertical",
    layout_width = "fill",
    layout_height = "fill",
    {
        ListView,
        id = "listview",
        dividerHeight = 0,
        layout_width = "fill",
        layout_height = "fill",
    },
    {
      LuaWebView,
      id = "webview",
      layout_height = 1,
      layout_width = 1,
    }
}

local item_view = {
    FrameLayout,
    layout_width = "fill",
    layout_height = "240dp",
    {
        ImageView,
        id = "iv_image",
        layout_width = "fill",
        layout_height = "fill",
        scaleType = "centerCrop",
    },
}


local data = {}
local adapter

local htmlTemplate = [[
<script type="text/javascript">
%s
window.luaapp.setImg(newImgs[0])
</script>
]]

function getData(url)

  LuaHttp.request({ url = url }, function(error, code, body)
    local script = string.match(body,'<script type="text/javascript">(.-)</script>')
    local data = string.format(htmlTemplate, script)
    uihelper.runOnUiThread(activity, function (  )
        print(data)
        webview.loadData(data, "text/html; charset=UTF-8", nil)
    end)
  end)


end

local log = require('common.log')
function launchDetail(item)
end


function onCreate(savedInstanceState)
    activity.setStatusBarColor(0x00000000)
    activity.setContentView(loadlayout(layout))
    webview.addJavascriptInterface(luajava.createProxy('',{
        setImg = function( url )
            print(url)
        end
    }), "luaapp")

    adapter = LuaAdapter(luajava.createProxy("androlua.LuaAdapter$AdapterCreator", {
        getCount = function() return #data.dailyList end,
        getView = function(position, convertView, parent)
            position = position + 1 -- lua 索引从 1开始
            if position == #data.dailyList then
                getData()
            end
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
            local item = data.dailyList[position]
            if item then
                LuaImageLoader.load(views.iv_image, item.coverForFeed)
                views.tv_title.setText(item.title)
            end
            return convertView
        end
    }))
    listview.setAdapter(adapter)
    listview.setOnItemClickListener(luajava.createProxy("android.widget.AdapterView$OnItemClickListener", {
        onItemClick = function(adapter, view, position, id)
            launchDetail()
        end,
    }))

    local url = activity.getIntent().getStringExtra('url')
    getData(url)
end
