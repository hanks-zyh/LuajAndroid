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
import "androlua.widget.ninegride.LuaNineGridViewAdapter"


local function fetchData(refreshLayout, data, adapter, fragment)
    local url = string.format('http://app.jike.ruguoapp.com/1.0/users/messages/listPopularByTag?tag=ALL')
    Http.request({url=url}, function(error, code, body)
        if error or code ~= 200 then
            print(' ================== get data error')
            return
        end
        local json = JSON.decode(body)
        for i = 1, #json.data do
            data.msg[#data.msg + 1] = json.data[i]
        end
        uihelper.runOnUiThread(fragment.getActivity(), function()
            refreshLayout.setRefreshing(false)
            adapter.notifyDataSetChanged()
        end)
    end)
end

-- local log = require("common.log")

local function launchDetail(fragment, msg)
    local activity = fragment.getActivity()
    local intent = Intent(activity, LuaActivity)
    intent.putExtra("luaPath", 'news/activity_news_detail.lua')
    -- log.print_r(msg)
    intent.putExtra("url", msg.linkUrl)
    activity.startActivity(intent)
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
                paddingTop = "25dp",
                clipToPadding = false,
                layout_width = "fill",
                layout_height = "fill",
            },
        },
    }

    local item_view = require('jike.item_msg')
    local data = { msg = {} }
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

                getItemCount = function()
                    return #data.msg
                end,

                getItemViewType = function(position)
                    return 0
                end,

                onCreateViewHolder = function(parent, viewType)
                    local views = {}
                    local holder = LuaRecyclerHolder(loadlayout(item_view, views, RecyclerView))
                    holder.itemView.getLayoutParams().width = parent.getWidth()
                    holder.itemView.setTag(views)
                    holder.itemView.onClick = function(view)
                        local position = holder.getAdapterPosition() + 1
                        launchDetail(fragment, data.msg[position])
                    end
                    return holder
                end,
                onBindViewHolder = function(holder, position)
                    position = position + 1
                    local msg = data.msg[position]
                    local views = holder.itemView.getTag()
                    views.tv_title.setText(msg.title or 'error title')
                    views.tv_content.setText(msg.content or '')
                    views.tv_date.setText(msg.updatedAt:sub(1, 10) or '')
                    views.tv_collect.setText(string.format('%s', msg.collectCount))
                    views.tv_comment.setText(string.format('%s', msg.commentCount))
                    ImageLoader.load(views.iv_image, msg.topic.thumbnailUrl)
                    if msg.video then
                        ImageLoader.load(views.iv_video, msg.video.thumbnailUrl)
                        views.layout_video.setVisibility(0)
                    else
                        views.layout_video.setVisibility(8)
                    end
                    if msg.pictureUrls and #msg.pictureUrls > 0 then
                        local pictures = msg.pictureUrls
                        local urls = {}
                        local len = #pictures
                        for i = 1, len do
                            if len == 1 then
                                urls[i] = pictures[i].picUrl
                                views.iv_nine_grid.setSingleImgSize(pictures[i].width, pictures[i].height)
                            else urls[i] = pictures[i].thumbnailUrl
                            end
                        end
                        views.iv_nine_grid.setVisibility(0)
                        if views.iv_nine_grid.getAdapter() == nil then
                            views.iv_nine_grid.setAdapter(LuaNineGridViewAdapter(luajava.createProxy('androlua.widget.ninegride.LuaNineGridViewAdapter$AdapterCreator', {
                                onDisplayImage = function(context, imageView, url)
                                    ImageLoader.load(imageView, url)
                                end,
                                onItemImageClick = function(context, imageView, index, list)
                                    print(list.get(index))
                                end
                            })))
                        end
                        views.iv_nine_grid.setImagesData(urls)
                    else
                        views.iv_nine_grid.setVisibility(8)
                    end
                end,
            }))
            ids.recyclerView.setLayoutManager(LinearLayoutManager(fragment.getActivity()))
            ids.recyclerView.setAdapter(adapter)
            ids.refreshLayout.setOnRefreshListener(luajava.createProxy('android.support.v4.widget.SwipeRefreshLayout$OnRefreshListener', {
                onRefresh = function()
                    fetchData(ids.refreshLayout, data, adapter, fragment)
                end
            }))
            ids.refreshLayout.setRefreshing(true)
            fetchData(ids.refreshLayout, data, adapter, fragment) -- getdata may call ther lua files
        end,
    }))
    return fragment
end

return {
    newInstance = newInstance
}