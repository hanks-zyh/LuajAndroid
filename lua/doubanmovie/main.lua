--
-- Created by IntelliJ IDEA.  Copyright (C) 2017 Hanks
-- User: hanks
-- Date: 2017/5/26
-- douban - hot movie
--
require "import"
import "android.widget.*"
import "android.content.*"
import "android.view.View"
import "androlua.LuaHttp"
import "androlua.LuaAdapter"
import "androlua.widget.video.VideoPlayerActivity"
import "androlua.LuaImageLoader"
import "android.support.v7.widget.RecyclerView"
import "androlua.adapter.LuaRecyclerAdapter"
import "androlua.adapter.LuaRecyclerHolder"
import "android.support.v7.widget.GridLayoutManager"

local uihelper = require("common.uihelper")
local JSON = require("common.json")

-- create view table
local layout = {
    LinearLayout,
    orientation = "vertical",
    layout_width = "fill",
    layout_height = "fill",
    fitsSystemWindows = true,
    {
        TextView,
        layout_width = "fill",
        layout_height = "48dp",
        background = "#FFFFFF",
        gravity = "center",
        text = "豆瓣-热映电影",
        textColor = "#42BD52",
        textSize = "18sp",
    },
    {
        RecyclerView,
        id = "recyclerView",
        layout_width = "fill",
        layout_height = "fill",
    },
}

local item_view = {
    LinearLayout,
    layout_widht = "match",
    layout_height = "wrap",
    orientation = "vertical",
    gravity = "center",
    {
        ImageView,
        id = "iv_image",
        layout_width = "104dp",
        layout_height = "160dp",
        scaleType = "centerCrop",
    },
    {
        TextView,
        id = "tv_title",
        layout_marginTop = "4dp",
        layout_marginBottom = "12dp",
        padding = "4dp",
        layout_widht = "fill",
        gravity = "center",
        textSize = "12sp",
        maxLines = 1,
        ellipsize = "end",
        textColor = "#444444",
    },
}


local data = {}
local adapter
local page = 0
local pageCount = 15
local total = 99999

function getData()
    if #data >= total then return end
    local url = string.format('http://api.douban.com/v2/movie/in_theaters?apikey=0df993c66c0c636e29ecbb5344252a4a&count=%d&start=%d', pageCount, page * pageCount)
    LuaHttp.request({ url = url }, function(error, code, body)
        if error or code ~= 200 then
            print('fetch data error')
            return
        end
        local str = JSON.decode(body)
        total = str.total
        page = page + 1
        uihelper = runOnUiThread(activity, function()
            local arr = str.subjects
            for i = 1, #arr do
                data[#data + 1] = arr[i]
            end
            adapter.notifyDataSetChanged()
        end)
    end)
end

function launchDetail(item)
  local intent = Intent(activity, LuaActivity)
  intent.putExtra("luaPath", 'doubanmovie/detail.lua')
  intent.putExtra("id", item.id)
  activity.startActivity(intent)
end


function onCreate(savedInstanceState)
    activity.setLightStatusBar()
    activity.setContentView(loadlayout(layout))
    local screenWidth = uihelper.getScreenWidth()
     adapter = LuaRecyclerAdapter(luajava.createProxy('androlua.adapter.LuaRecyclerAdapter$AdapterCreator', {
          getItemCount = function()
              return #data
          end,

          getItemViewType = function(position)
              return 0
          end,

          onCreateViewHolder = function(parent, viewType)
              local views = {}
              local holder
              holder = LuaRecyclerHolder(loadlayout(item_view, views, RecyclerView))
              holder.itemView.setTag(views)
              holder.itemView.onClick = function(view)
                  local position = holder.getAdapterPosition() + 1
              end
              holder.itemView.getLayoutParams().width = screenWidth/3
              holder.itemView.onClick = function()
                local p = holder.getAdapterPosition() + 1
                launchDetail(data[p])
              end
              return holder
          end,

          onBindViewHolder = function(holder, position)
              position = position + 1
              local views = holder.itemView.getTag()
              if views == nil then return end
              local item = data[position]
              if item then
                  LuaImageLoader.load(views.iv_image, item.images.large)
                  views.tv_title.setText(item.title)
              end
              if (position == #data) then
                  getData() -- getdata may call ther lua files
              end
          end,
      }))

      recyclerView.setLayoutManager(GridLayoutManager(activity,3))
      recyclerView.setAdapter(adapter)
      getData()
end
