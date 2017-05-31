--
-- Created by IntelliJ IDEA.
-- User: hanks
-- Date: 2017/5/13
-- Time: 00:01
-- To change this template use File | Settings | File Templates.
--
local JSON = require("common.json")
local ImageLoader = import "androlua.LuaImageLoader"
local LuaFragment = import("androlua.LuaFragment")
local Http = import "androlua.LuaHttp"
local uihelper = require("common.uihelper")
import "android.support.v7.widget.RecyclerView"
import "android.support.v4.widget.SwipeRefreshLayout"
import "androlua.adapter.LuaRecyclerAdapter"
import "androlua.adapter.LuaRecyclerHolder"
import "android.support.v7.widget.LinearLayoutManager"
import "android.view.View"
import "android.support.v4.widget.Space"
import "androlua.widget.ninegride.LuaNineGridView"
import "androlua.adapter.LuaNineGridViewAdapter"

local function fetchData(data, adapter, fragment)
    local url = 'http://app.jike.ruguoapp.com/1.0/recommendFeed/list'
    local options = {
        url = url,
        method = 'POST',
        headers = {
            "Cookie:io=0_Djvr_i0yLPqdsuFnzY; jike:sess.sig=d-IvFa3n5DhxWNim_0gVasNfTP0; jike:feed:latestNormalMessageId=592e495c7a27e200117d35b3; jike:recommendfeed:latestRecCreatedAt=2017-05-31T06:16:06.797Z; jike:sess=eyJfdWlkIjoiNTdmYjc2YTJhNzViY2ExMzAwZjYyMzkyIiwiX3Nlc3Npb25Ub2tlbiI6IkdRTUU0RmNkTHZhNTZlcExXR1BaYURDaDQifQ==; jikeSocketSticky=33b938e0c7b12816f8f2e027067ee82d69975eb2; jike:feed:latestFeedItemId=592e495c7a27e200117d35b3; jike:feed:noContentPullCount=0"
        }
    }
    Http.request(options, function(error, code, body)
        if error or code ~= 200 then
            print(' ================== get data error')
            return
        end
        local json = JSON.decode(body).data
        for i = 1, #json do
            if json[i].type == 'MESSAGE_RECOMMENDATION' then
                data[#data + 1] = json[i]
            end
        end
        uihelper.runOnUiThread(fragment.getActivity(), function()
            adapter.notifyDataSetChanged()
        end)
    end)
end

function launchDetail(fragment, newsid)
end

function newInstance()

    -- create view table
    local layout = {
        LinearLayout,
        layout_widht = "match",
        layout_height = "match",
        orientation = "vertical",
        {
            SwipeRefreshLayout,
            id = "refreshLayout",
            {
                RecyclerView,
                id = "recyclerView",
                paddingTop="25dp",
                clipToPadding = false,
                layout_width = "fill",
                layout_height = "fill",
            },
        },
    }

    local item_view = require('jike.item_msg')

    local data = {}
    local ids = {}
    local fragment = LuaFragment.newInstance()
    local adapter
    fragment.setCreator(luajava.createProxy('androlua.LuaFragment$FragmentCreator', {
        onDestroyView = function() end,
        onDestroy = function() end,
        onCreateView = function(inflater, container, savedInstanceState)
            return loadlayout(layout, ids)
        end,
        onViewCreated = function(view, savedInstanceState)
            adapter = LuaRecyclerAdapter(luajava.createProxy('androlua.adapter.LuaRecyclerAdapter$AdapterCreator', {
                getItemCount = function() return #data end,
                getItemViewType = function(position) return 0 end,
                onCreateViewHolder = function(parent, viewType)
                    local views = {}
                    local holder = LuaRecyclerHolder(loadlayout(item_view, views, RecyclerView))
                    holder.itemView.setTag(views)
                    if parent then
                        local params = holder.itemView.getLayoutParams()
                        params.width = parent.getWidth()
                    end
                    return holder
                end,
                onBindViewHolder = function(holder, position)
                    position = position + 1
                    local msg = data[position]
                    local views = holder.itemView.getTag()
                    views.tv_title.setText(msg.item.title or 'error title')
                    views.tv_content.setText(msg.item.content or '')
                    views.tv_date.setText(msg.item.updatedAt:sub(1,10) or '')
                    views.tv_collect.setText(string.format('%s', msg.item.collectCount))
                    views.tv_comment.setText(string.format('%s', msg.item.commentCount))
                    ImageLoader.load(views.iv_icon_url, msg.item.iconUrl)
                    ImageLoader.load(views.iv_image, msg.item.topic.thumbnailUrl)
                    if msg.item.video then
                        ImageLoader.load(views.iv_video, msg.item.video.thumbnailUrl)
                        views.layout_video.setVisibility(0)
                    else
                        views.layout_video.setVisibility(8)
                    end

                    if msg.item.pictureUrls and #msg.item.pictureUrls > 0 then
                        local pictures = msg.item.pictureUrls
                        local urls = {}
                        for i = 1, #pictures do
                            urls[i] = pictures[i].middlePicUrl
                        end
                        views.iv_nine_grid.setVisibility(0)
                        views.iv_nine_grid.setAdapter(LuaNineGridViewAdapter(luajava.createProxy('androlua.adapter.LuaNineGridViewAdapter$AdapterCreator', {
                            onDisplayImage = function(context, imageView, url)
                                ImageLoader.load(imageView, url)
                            end,
                            onItemImageClick = function(context, imageView, index, list)
                            end
                        })))
                        views.iv_nine_grid.setImagesData(urls)
                    else
                        views.iv_nine_grid.setVisibility(8)
                    end
                end,
            }))
            ids.recyclerView.setLayoutManager(LinearLayoutManager(fragment.getActivity()))
            ids.recyclerView.setAdapter(adapter)
            fetchData(data, adapter, fragment) -- getdata may call ther lua files
        end,
    }))
    return fragment
end

return {
    newInstance = newInstance
}