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
import "android.support.v7.widget.GridLayoutManager"
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



local item_header = {
    LinearLayout,
    layout_width = "match",
    orientation = "vertical",
    {
        ImageView,
        id = "iv_cover",
        layout_width = "fill",
        layout_height = "360dp",
        scaleType = "centerCrop",
    },
    {
        TextView,
        id = "tv_title",
        textSize = "20sp",
        textColor = "#444444",
    },
    {
        TextView,
        id = "tv_type",
        textSize = "14sp",
        textColor = "#767676",
    },
    {
        TextView,
        id = "tv_author",
        textSize = "14sp",
        textColor = "#767676",
    },
    {
        TextView,
        id = "tv_updateinfo",
        textSize = "16sp",
        textColor = "#444444",
    },
    {
        TextView,
        id = "tv_score",
        textSize = "16sp",
        textColor = "#444444",
    },
    {
        TextView,
        id = "tv_desc",
        textSize = "14sp",
        textColor = "#444444",
    },
}

-- create view table
local layout = {
    LinearLayout,
    orientation = "vertical",
    layout_width = "fill",
    layout_height = "fill",
    item_header,
    {
        RecyclerView,
        id = "recyclerView",
        layout_width = "fill",
        layout_height = "fill",
    },
}

local item_capter = {
    LinearLayout,
    orientation = "vertical",
    layout_width = screenWidth / 4,
    layout_height = "60dp",
    gravity = "center",
    {
       Button,
       id = "tv_chapter",
    },
}

local baseInfo = {}
local data = {}


local adapter

local function  updateHeader()
  -- header
    LuaImageLoader.load(iv_cover, baseInfo.coverImg or '')
    tv_title.setText(baseInfo.title or '')
    tv_type.setText(baseInfo.type or '')
    tv_author.setText(baseInfo.author or '')
    tv_score.setText(baseInfo.score or '')
    tv_desc.setText(baseInfo.desc or '')
end


local function getData(url)
    LuaHttp.request({ url = url }, function(error, code, body)
        if error or code ~= 200 then
            print('fetch dm5 data error')
            return
        end
        uihelper = runOnUiThread(activity, function()
            -- TOP10
            local coverImg =  string.match(body,'<div class="coverForm".-<img src="(.-)"')
            local info = string.match(body,'<div class="info d[-]item[-]content">(.-)</div>')
            local title =  string.match(info,'<p class="title d[-]nowrap">(.-)</p>')
            local updateInfo =  string.match(info,'<p class="bottom d[-]nowrap">(.-)</p>')
            local author, type
            for sub in string.gmatch(info,'<p class="subtitle d[-]nowrap">(.-)</p>') do
            if type == nil then
             type = sub
            else
             author = sub
            end
            end
            local score =  string.match(body,'<div class="sorce">(.-)</div>'):gsub('<.->','')
            local desc =  string.match(body,'<div class="detailContent">(.-)</div>'):gsub('<.->',''):gsub('%s+','')
            baseInfo.coverImg = coverImg
            baseInfo.title = title
            baseInfo.type = type
            baseInfo.author = author
            baseInfo.score = score
            updateHeader()
            local capters = string.match(body,'<div .-id="chapterList_1".->(.-)</div>')
            for li in string.gmatch(capters,'<li>(.-)</li>') do
              local url = string.match(li,'<a href="(.-)"')
              local name = li:gsub('<.->',''):gsub('%s+','')
              data[#data + 1] = {url=url,name=name}
            end
            adapter.notifyDataSetChanged()
        end)
    end)
end

function launchDetail(item)
end

function onCreate(savedInstanceState)
    activity.setContentView(loadlayout(layout))

    adapter = LuaRecyclerAdapter(luajava.createProxy('androlua.adapter.LuaRecyclerAdapter$AdapterCreator', {
        getItemCount = function()
            return #data
        end,
        getItemViewType = function(position)
            return 0
        end,
        onCreateViewHolder = function(parent, viewType)
            viewType = viewType + 1
            local views = {}
            local holder = LuaRecyclerHolder(loadlayout(item_capter, views, RecyclerView))
            holder.itemView.setTag(views)
            holder.itemView.getLayoutParams().width = parent.getWidth()
            return holder
        end,
        onBindViewHolder = function(holder, position)
            position = position + 1
            local views = holder.itemView.getTag()
            if views == nil then return end

            local item = data[position]
            views.tv_desc.setText(item.name or '')

        end,
    }))


    recyclerView.setLayoutManager(LinearLayoutManager(activity))
    recyclerView.setAdapter(adapter)

    local url = activity.getIntent().getStringExtra('url')
    getData(url or 'http://m.dm5.com/manhua-yongzheheluku/')
end
