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
import "androlua.LuaImageLoader"
import "android.support.graphics.drawable.VectorDrawableCompat"

local uihelper = require("common.uihelper")
local JSON = require("common.json")
local log = require('common.log')
local weather = require("weather.weather")

local item_hour = {
    LinearLayout,
    layout_weight = 1,
    orientation = "vertical",
    gravity = "center",
    paddingTop = "16dp",
    paddingBottom = "16dp",
    {
        TextView,
        textSize = "13sp",
        textColor = "#444444",
        text = "00:00",
    },
    {
        ImageView,
        layout_width = "match",
        layout_height = "30dp",
        layout_marginBottom = "4dp",
        layout_marginTop = "12dp",
    },
    {
        TextView,
        textSize = "12sp",
        textColor = "#444444",
        text = "0°",
    },
}
local item_week ={
    LinearLayout,
    layout_weight = 1,
    orientation = "vertical",
    gravity = "center",
    paddingTop = "16dp",
    paddingBottom = "16dp",
    {
        TextView,
        textSize = "13sp",
        textColor = "#444444",
        text = "今天",
    },
    {
        ImageView,
        layout_width = "match",
        layout_height = "50dp",
        layout_marginBottom = "4dp",
        layout_marginTop = "12dp",
    },
    {
        TextView,
        textSize = "12sp",
        textColor = "#444444",
        text = "多云",
    },
}

-- create view table
local layout = {
    -- FrameLayout,
    -- layout_width = "match",
    -- layout_height = "match",
    -- {
    --     ImageView,
    --     id = "iv_bg",
    --     layout_width = "match",
    --     layout_height = "match",
    --     scaleType = "centerCrop",
    -- },
    -- {
    --     ImageView,
    --     background = "#11000000",
    --     layout_width = "match",
    --     layout_height = "match",
    -- },
    ScrollView,
    {
        LinearLayout,
        orientation = "vertical",
        {
            LinearLayout,
            background = "#009688",
            layout_width = "fill",
            layout_height = "wrap",
            orientation = "vertical",
            gravity = "center_horizontal",
            {
                RelativeLayout,
                layout_width = "fill",
                layout_height = "wrap",
                layout_marginTop = "25dp",
                padding="16dp",
                {
                    TextView,
                    id = "tv_city",
                    layout_centerVertical = true,
                    textSize = "16sp",
                    textColor = "#ffffff",
                },
                {
                    TextView,
                    id = "tv_update",
                    layout_alignParentRight = true,
                    layout_centerVertical = true,
                    textSize = "12sp",
                    textColor = "#aaffffff",
                },
            },
            {
                LinearLayout,
                layout_width = "fill",
                orientation = "vertical",
                gravity = "center_horizontal",
                paddingBottom = "80dp",
                paddingTop = "32dp",
                {
                    TextView,
                    id = "tv_weather",
                    textSize = "18sp",
                    textColor = "#eeffffff",
                },
                {
                    TextView,
                    id = "tv_temp",
                    layout_marginTop="8dp",
                    layout_marginBottom="12dp",
                    textSize = "82sp",
                    textColor = "#f1ffffff",
                },
                {
                    TextView,
                    id = "tv_wind",
                    textSize = "13sp",
                    textColor = "#aaffffff",
                },
            },
        },
        {
            LinearLayout,
            id = "layout_week",
            layout_width = "fill",
            orientation = "horizontal",
            item_week,
            item_week,
            item_week,
            item_week,
            item_week,
            item_week,
        },
        {
            LinearLayout,
            id = "layout_24h",
            layout_width = "fill",
            orientation = "horizontal",
            item_hour,
            item_hour,
            item_hour,
            item_hour,
            item_hour,
            item_hour,
        },
    },
}

-- bg http://i.tq121.com.cn/i/wap2016/news/d11.jpg

function fillBaseInfo( body )
    local json = JSON.decode(string.match( body,'{.*}' ))
    tv_city.setText(json.cityname)
    tv_temp.setText(json.temp .. '°')
    tv_update.setText(json.time .. ' 更新')
    tv_weather.setText(json.weather)
    tv_wind.setText(string.format('空气指数 %s  •  %s  •  湿度 %s', json.aqi_pm25, json.WD .. ' ' .. json.WS, json.SD) )
    -- local bgUrl = string.format( "http://i.tq121.com.cn/i/wap2016/news/%s.jpg", json.weathercode )
    -- print(bgUrl)
    -- LuaImageLoader.load(iv_bg, bgUrl)
end

function fillWeekInfo( body )
    local json = JSON.decode(string.match( body,'{.*}' ))
    for i=1,#json.f do
         local child = layout_week.getChildAt(i-1)
         child.getChildAt(0).setText(json.f[i].fj)
         local xmlPath = string.format('%s/weather/img/ic_%s.xml', luajava.luaextdir , json.f[i].fa)
         print(xmlPath)
         child.getChildAt(1).setImageDrawable(VectorDrawableCompat.createFromPath(xmlPath))
         child.getChildAt(2).setText(weather['_' .. json.f[i].fa])
    end
end

function fill24HInfo( body )
    local json = JSON.decode(string.match(body,'fc1h_24 =(.*)' ))
    local j = 0
    for i=1, #json.jh, 3 do
        local child = layout_24h.getChildAt(j)
        if child then
            child.getChildAt(0).setText(json.jh[i].jf:sub(9,10) .. ':00')
            child.getChildAt(2).setText(json.jh[i].jb .. '°')
        end
        j = j + 1
    end
end

function getData(url, successFunc)
    local options = {
        url = url,
        headers = {
            "Referer:http://e.weather.com.cn"
        }
    }
    LuaHttp.request(options, function(error, code, body)
        if error or code ~= 200 then
            print('fetch data error')
            return
        end
        uihelper.runOnUiThread(activity, function()
            successFunc(body)
        end)
    end)
end


function onCreate(savedInstanceState)
    activity.setStatusBarColor(0x00000000)
    activity.setContentView(loadlayout(layout))
    getData('http://d1.weather.com.cn/sk_2d/101010300.html', fillBaseInfo)
    getData('http://d1.weather.com.cn/weixinfc/101010300.html', fillWeekInfo)
    getData('http://d1.weather.com.cn/wap_40d/101010300.html', fill24HInfo)
end


