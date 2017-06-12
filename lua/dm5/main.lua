--
-- Created by IntelliJ IDEA.  Copyright (C) 2017 Hanks
-- User: hanks
-- Date: 2017/5/26
-- 漫本联盟 dm5.com
--
require "import"
import "android.widget.*"
import "android.content.*"
import "android.view.View"
import "androlua.LuaHttp"
import "androlua.LuaAdapter"
import "androlua.widget.video.VideoPlayerActivity"
import "androlua.LuaImageLoader"

import "androlua.LuaImageLoader"
import "androlua.LuaFragment"
import "android.support.v7.widget.RecyclerView"
import "android.support.v4.widget.SwipeRefreshLayout"
import "androlua.adapter.LuaRecyclerAdapter"
import "androlua.adapter.LuaRecyclerHolder"
import "android.support.v7.widget.LinearLayoutManager"
import "android.view.View"
import "android.support.v4.widget.Space"
import "androlua.widget.ninegride.LuaNineGridView"
import "androlua.widget.ninegride.LuaNineGridViewAdapter"
import "androlua.widget.picture.PicturePreviewActivity"
import "androlua.widget.webview.WebViewActivity"


local uihelper = require("common.uihelper")
local JSON = require("common.json")
local log = require('common.log')
local screenWidth = uihelper.getScreenWidth()

local category = {
  "",
  "原创精品",
  "最新更新",
  "热门连载",
  "少年热血",
  "少女爱情",
  "最新上架",
}
-- create view table
local layout = {
    LinearLayout,
    orientation = "vertical",
    layout_width = "fill",
    layout_height = "fill",
    statusBarColor = "#FDE04C",
    {
        TextView,
        layout_width = "fill",
        layout_height = "48dp",
        background = "#FDE04C",
        gravity = "center",
        text = "漫画",
        textColor = "#43250C",
        textSize = "18sp",
    },
    {
        RecyclerView,
        id = "recyclerView",
        layout_width = "fill",
        layout_height = "fill",
    },
}

local item_banner = {
    FrameLayout,
    layout_height = "192dp",
    layout_width = "match",
    {
      ImageView,
      layout_height = "match",
      layout_width = "match",
      id = "iv_banner",
      scaleType = "centerCrop",
    }
}

local ceil_category = {
    LinearLayout,
    layout_width = (screenWidth- uihelper.dp2px(8))/3 ,
    layout_height = "200dp",
    paddingLeft = "4dp",
    paddingRight = "4dp",
    orientation = "vertical",
    {
        ImageView,
        layout_width = "fill",
        layout_height = "160dp",
        scaleType = "centerCrop",
    },
    {
        TextView,
        layout_height = "match",
        layout_width = "match",
        gravity = "center",
    },
}

local ceil_topList = {
    FrameLayout,
    layout_height = "96dp",
    padding = "8dp",
    {
        ImageView,
        layout_width = "120dp",
        layout_height = "80dp",
        scaleType = "centerCrop",
    },
    {
        TextView,
        layout_marginLeft = "128dp",
        textColor = "#444444",
        textSize = "14sp",
    },
    {
        TextView,
        layout_marginLeft = "128dp",
        maxLines = 1,
        textSize = "12sp",
        textColor = "#767676",
        layout_gravity = "center_vertical",
    },
    {
        TextView,
        layout_marginLeft = "128dp",
        textSize = "12sp",
        textColor = "#ec4646",
        layout_gravity = "bottom",
    },
    {
        TextView,
        layout_gravity = "right",
        textSize = "10sp",
    },
}

local item_category = {
    LinearLayout,
    orientation = "vertical",
    {
        RelativeLayout,
        layout_height = "48dp",
        paddingLeft = "8dp",
        paddingRight = "8dp",
        {
            TextView,
            id = "tv_category",
            textSize = "16sp",
            text = "原创精品",
            textColor = "#222222",
            layout_centerVertical = true,
        },
        {
            TextView,
            text = '更多 >',
            layout_alignParentRight = true,
            layout_centerVertical = true,
        },
    },
    {
        LinearLayout,
        id = "row_1",
        orientation = "horizontal",
        paddingLeft = "4dp",
        paddingRight = "4dp",

        ceil_category,
        ceil_category,
        ceil_category,
    },
    {
        LinearLayout,
        id = "row_2",
        orientation = "horizontal",
        paddingLeft = "4dp",
        paddingRight = "4dp",

        ceil_category,
        ceil_category,
        ceil_category,
    }
}

local item_topList = {
    LinearLayout,
    id = "layout_toplist",
    layout_width = "match",
    orientation = "vertical",
    {
        RelativeLayout,
        layout_height = "48dp",
        paddingLeft = "8dp",
        paddingRight = "8dp",
        {
            TextView,
            id = "tv_category",
            textSize = "16sp",
            text = "Top 10",
            textColor = "#222222",
            layout_centerVertical = true,
        },
        {
            TextView,
            text = '更多 >',
            layout_alignParentRight = true,
            layout_centerVertical = true,
        },
    },
    ceil_topList,
    ceil_topList,
    ceil_topList,
    ceil_topList,
    ceil_topList,
    ceil_topList,
    ceil_topList,
    ceil_topList,
    ceil_topList,
    ceil_topList,
}

local data = {
    {}, --banner
    {}, --list1
    {}, --list2
    {}, --list3
    {}, -- list4 =
    {}, -- list5 =
    {}, -- list6 =
    {}, -- topList
}
local adapter

function getData()
    LuaHttp.request({ url = 'http://m.dm5.com/' }, function(error, code, body)
        if error or code ~= 200 then
            print('fetch dm5 data error')
            return
        end
        uihelper = runOnUiThread(activity, function()
            -- banner
            local banner = data[1]
            local ul =  string.match(body, '<ul class="am[-]slides">(.-)</ul>')
            for img in string.gmatch(ul, '<img src="(.-)"') do
                if img:find('cdndm5.com') then
                    banner[#banner + 1] = img
                end
            end

            -- 原创精品 最新更新 热门连载 少年热血 少女爱情 最新上架 TOP10
            local count = 1
            for li in string.gmatch(body, '<li class="am[-]thumbnail">(.-)</li>') do
                local url, title = string.match(li, '<a href="(.-)".-title="(.-)">')
                local img = string.match(li, '<img src="(.-)"')
                if url and title and img then
                    local item = { url = url, title = title, img = img }
                    local index = 2
                    if count <= 6 then
                        index = 2
                    elseif count <= 12 then
                        index = 3
                    elseif count <= 18 then
                        index = 4
                    elseif count <= 24 then
                        index = 5
                    elseif count <= 30 then
                        index = 6
                    else
                        index = 7
                    end
                    data[index][#data[index] + 1] = item
                    count = count + 1
                end
            end

            -- TOP10
            local topList = data[8]
            local rankList = string.match(body, '<div class="rankList">.-<ul class="list">(.-)</ul>')
            for li in string.gmatch(rankList, '<a .-</a>') do
                local url, title = string.match(li, '<a href="(.-)".-title="(.-)">')
                local img = string.match(li, '<img class="cover" src="(.-)"')
                local subtitle = string.match(li, '<p class="subtitle d[-]nowrap">(.-)</p>')
                local updateInfo = string.match(li, '<span class="d[-]nowrap">(.-)</span>')
                local score = string.match(li, '<span class="score">(.-)</span>')
                if title and url and img then
                    local item = { title = title, score = score, updateInfo = updateInfo, url = url, img = img, subtitle = subtitle }
                    topList[#topList + 1] = item
                end
            end
            adapter.notifyDataSetChanged()
        end)
    end)
end

function launchDetail(url)
  if url:find('^http://') == nil then
    url = 'http://m.dm5.com' .. url
  end
  local intent = Intent(activity, LuaActivity)
  intent.putExtra("luaPath", 'dm5/detail.lua')
  intent.putExtra("url", url)
  activity.startActivity(intent)
end

function onCreate(savedInstanceState)
    activity.setContentView(loadlayout(layout))

    adapter = LuaRecyclerAdapter(luajava.createProxy('androlua.adapter.LuaRecyclerAdapter$AdapterCreator', {
        getItemCount = function()
            return #data
        end,
        getItemViewType = function(position)
            return position
        end,
        onCreateViewHolder = function(parent, viewType)
            viewType = viewType + 1
            local views = {}
            local holder
            if viewType == 1 then
                -- banner
                holder = LuaRecyclerHolder(loadlayout(item_banner, views, RecyclerView))
            elseif viewType >= 2 and viewType <= 7 then
                holder = LuaRecyclerHolder(loadlayout(item_category, views, RecyclerView))
            else
                -- toplist
                holder = LuaRecyclerHolder(loadlayout(item_topList, views, RecyclerView))
            end
            holder.itemView.setTag(views)
            holder.itemView.getLayoutParams().width = screenWidth
            return holder
        end,
        onBindViewHolder = function(holder, position)
            position = position + 1
            local item = data[position]
            local views = holder.itemView.getTag()
            if item == nil or views == nil then return end
            if position == 1 then
                -- banner
                LuaImageLoader.load(views.iv_banner, item[1] or '')
            elseif position >= 2 and position <= 7 then
                views.tv_category.setText(category[position])
                for i = 1, #item do
                    local child
                    if i <= 3 then
                        child = views.row_1.getChildAt(i - 1)
                    else
                        child = views.row_2.getChildAt(i - 4)
                    end

                    LuaImageLoader.load(child.getChildAt(0), item[i].img)
                    child.getChildAt(1).setText(item[i].title)
                    child.onClick = function()
                      launchDetail(item[i].url)
                    end
                end
            else
                -- toplist
                for i = 1, #item do
                    local child = views.layout_toplist.getChildAt(i)
                    LuaImageLoader.load(child.getChildAt(0), item[i].img)
                    child.getChildAt(1).setText(item[i].title)
                    child.getChildAt(2).setText(item[i].subtitle)
                    child.getChildAt(3).setText(item[i].updateInfo)
                    child.getChildAt(4).setText(item[i].score)
                    child.onClick = function()
                      launchDetail(item[i].url)
                    end
                end
            end
        end,
    }))
    recyclerView.setLayoutManager(LinearLayoutManager(activity))
    recyclerView.setAdapter(adapter)
    getData()
end
