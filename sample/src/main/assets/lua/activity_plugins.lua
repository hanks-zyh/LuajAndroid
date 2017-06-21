--
-- Created by IntelliJ IDEA.
-- User: hanks
-- Date: 2017/5/13
-- Time: 00:01
-- Load plugin from api
--
require "import"

import "android.widget.*"
import "android.content.*"
import "android.view.View"
import "android.support.v7.widget.Toolbar"
import "androlua.LuaImageLoader"
import "androlua.LuaHttp"
import "android.os.Build"
import "androlua.LuaAdapter"
import "android.graphics.drawable.GradientDrawable"
import "androlua.widget.marqueetext.MarqueeTextView"

local FileUtils = import "androlua.common.LuaFileUtils"
local JSON = require "json"
local uihelper = require "uihelper"
-- create view table
local layout = {
    LinearLayout,
    orientation = "vertical",
    layout_width = "fill",
    statusBarColor = "#222222",
    {
        LinearLayout,
        orientation = "horizontal",
        layout_width = "fill",
        layout_height = "56dp",
        background = "#222222",
        gravity="center_vertical",
        {
            ImageView,
            id = "back",
            layout_width = "40dp",
            layout_height = "40dp",
            layout_marginLeft="12dp",
            src="@drawable/ic_menu_back",
            scaleType="centerInside",
        },
        {
            TextView,
            layout_height = "56dp",
            layout_width = "fill",
            id = "tv_title",
            gravity = "center_vertical",
            paddingLeft="8dp",
            textColor = "#ffffff",
            textSize = "16sp",
            text = "插件列表",
        },
    },
    {
        ListView,
        id = "listview",
        layout_width = "fill",
        layout_height = "fill",
    }
}

local item_view = {
    FrameLayout,
    layout_widht = "fill",
    layout_height = "72dp",
    padding = "16dp",
    {
        ImageView,
        id = "icon",
        layout_gravity = "center_vertical",
        layout_width = "40dp",
        layout_height = "40dp",
        scaleType="centerInside",
    },
    {
        TextView,
        id = "text",
        layout_widht = "fill",
        layout_marginTop = "2dp",
        layout_marginLeft = "48dp",
        textSize = "12sp",
        textColor = "#222222",
        layout_gravity = "top",
    },
    {
        MarqueeTextView,
        id = "desc",
        textSize = "10sp",
        textColor = "#666666",
        layout_widht = "fill",
        layout_marginLeft = "48dp",
        layout_marginRight = "96dp",
        layout_marginBottom = "4dp",
        layout_gravity = "bottom",
    },
    {
        TextView,
        layout_width = "68dp",
        layout_height = "32dp",
        background = "#666666",
        gravity = "center",
        id = "download",
        text = "下载",
        textSize = "12sp",
        layout_gravity = "right",
    },
}


local strokeWidth = 2;
local roundRadius = 8;
local strokeColor = 0xFF2E3135

local gd = GradientDrawable()
gd.setCornerRadius(roundRadius)
gd.setStroke(strokeWidth, strokeColor)

local function flatType(type)
    if type == 'uninstall' then return '卸载'
    elseif type == 'update' then return '更新'
    elseif type == 'downloading' then return '下载中'
    else return '安装'
    end
end

local function flatTypeColor(type)
    local color = 0xff111111
    if type == 'uninstall' then color  = 0xff888888
    elseif type == 'update' then color =  0xff222222
    elseif type == 'downloading' then color =  0xffc22525
    end
    return color
end

local data = {} -- plugin list

local adapter

local function notifyAdapterData()
    uihelper.runOnUiThread(activity,function() adapter.notifyDataSetChanged() end)
end

local function compareWithLocal(localList, plugin)
    plugin.type = 'install'
    for i = 1, #localList do
        local p = localList[i - 1]
        if p.getId() == plugin.id then
            if p.getVersionCode() < plugin.versionCode then plugin.type = 'update'
            else plugin.type = 'uninstall'
            end
        end
    end
end

local function getData()
  local options = {
      url = 'https://coding.net/u/zhangyuhan/p/api_luanroid/git/raw/master/api/plugins'
  }
  LuaHttp.request(options, function(error, code, body)
      local localList = FileUtils.getPluginList()
      local json = JSON.decode(body)
      local list = json.data
      for i = 1, #list do
          local plugin = list[i]
          compareWithLocal(localList, plugin)
          data[#data + 1] =  plugin;
      end
      notifyAdapterData()
  end)
end


local function downloadPlugin(plugin)
    FileUtils.downloadPlugin(plugin.download, plugin.id, function(pluginDir)
        plugin.type = 'uninstall'
        notifyAdapterData()
    end)
end


function onCreate(savedInstanceState)
    activity.setContentView(loadlayout(layout))
    back.onClick = function()
        activity.finish()
    end

    adapter = LuaAdapter(luajava.createProxy("androlua.LuaAdapter$AdapterCreator", {
        getCount = function() return #data end,
        getView = function(position, convertView, parent)
            position = position + 1 -- lua 索引从 1开始
            if convertView == nil then
                local views = {} -- store views
                convertView = loadlayout(item_view, views, ListView)
                if Build.VERSION.SDK_INT < 16 then
                    views.download.setBackgroundDrawable(gd);
                else
                    views.download.setBackground(gd);
                end
                convertView.getLayoutParams().width = parent.getWidth()
                convertView.setTag(views)
            end
            local views = convertView.getTag()
            local plugin = data[position]
            if plugin then
                LuaImageLoader.loadWithRadius(views.icon, 40, plugin.icon)
                views.text.setText(plugin.name)
                views.desc.setText(plugin.desc)
                views.download.setText(flatType(plugin.type))
                views.download.setTextColor(flatTypeColor(plugin.type))
                views.download.onClick = function(view)
                    if plugin.type == 'downloading' then
                        return
                    elseif plugin.type == 'update' or plugin.type == 'install' then
                        plugin.type = 'downloading'
                        downloadPlugin(plugin)
                    else
                        FileUtils.removePlugin(plugin.id)
                        plugin.type = 'install'
                        notifyAdapterData()
                    end
                end
            end
            return convertView
        end
    }))
    listview.setAdapter(adapter)
    getData()
end
