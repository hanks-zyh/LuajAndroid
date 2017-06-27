--
-- Created by IntelliJ IDEA.
-- User: hanks
-- Date: 2017/5/13
-- Time: 00:01
-- To change this template use File | Settings | File Templates.
--
require "import"

import "android.widget.*"
import "android.content.*"
import "androlua.LuaAdapter"
import "androlua.LuaImageLoader"
import "androlua.LuaFragment"
import "androlua.LuaHttp"
import "androlua.widget.webview.WebViewActivity"
import "android.support.v4.widget.SwipeRefreshLayout"
local uihelper = require "uihelper"
local JSON = require "cjson"
local log = require "log"

local function getData(params, data, adapter, fragment,swipe_layout)
    local action = 1
    if #data > 0 then
        action = 2
    end

    local path = 'youlike?air=1'
    local category = ''
    if params.rid then 
        path = 'clsnews?'
        category ='&category='..params.rid 
    else
        action = 2
    end
   

    local uid = params.uid
    if uid == nil then
        uid = '' .. os.time()
        params.uid = uid
    end

     local fctime = params.fctime
     local fetime =  params.fetime
     local fst = params.fst
     local lvtime = params.lvtime
     local h = params.h
     local _ = os.time() * 1000

    http://3g.163.com/touch/jsonp/sy/recommend/30-10.html?hasad=1&miss=25&refresh=A&offset=0&size=10&callback=syrec3
    http://3g.163.com/touch/jsonp/sy/recommend/40-10.html?hasad=1&miss=25&refresh=A&offset=0&size=10&callback=syrec4
    http://3g.163.com/touch/reconstruct/article/list/BBM54PGAwangning/10-10.html
    http://3g.163.com/touch/reconstruct/article/list/BBM54PGAwangning/20-10.html
    http://3g.163.com/touch/reconstruct/article/list/BCR1UC1Qwangning/0-10.html
    
    local url = string.format('http://tran.news.so.com/news/%s&f=jsonp&n=10&u=%s&sign=mso_m_home&action=%d&fst=%d&fctime=%d&fetime=%d&lvtime=%d&h=%s&version=1.0.0&device=0%s&_=%d&callback=jsonp1',path,uid,action,fst,fctime,fetime,lvtime,h,category,_)
    params.lvtime = os.time()
    print(url)

    LuaHttp.request({ url = url }, function(error, code, body)
        if error or code ~= 200 then return end
        body = body:sub(9,#body-1)
        print(body)
        local arr = JSON.decode(body)
        uihelper.runOnUiThread(fragment.getActivity(), function()
            for i=1,#arr do
              data[#data + 1] = arr[i]
            end
            adapter.notifyDataSetChanged()
            swipe_layout.setRefreshing(false)
        end)
    end)
end

local function launchDetail(fragment, item)
  local activity = fragment.getActivity()
  if item and item.u then
      WebViewActivity.start(activity,  item.u, 0xFFfb7299)
      return
  end
  activity.toast('没有 url 可以打开')
end

local function dateStr(d)

     local now = os.time()
      local dx = now - d
      if dx < 600 then
        return '刚刚'
      elseif  dx < 3600 then
        return math.floor(dx/60) .. '分钟前'
      elseif  dx < 3600 * 24 then
        return math.floor(dx/3600) .. '小时前'
      else
        return os.date('%y-%m-%d',d)
      end

end


local function newInstance(rid)

    -- create view table
    local layout = {
      SwipeRefreshLayout,
      layout_width = "fill",
      layout_height = "fill",
      id = "swipe_layout",
      {
        ListView,
        id = "listview",
        layout_width = "fill",
        layout_height = "fill",
      }

    }

    local item_view = {
        FrameLayout,
        layout_width = "fill",
        layout_height = "wrap",
        paddingLeft = "16dp",
        paddingRight = "12dp",
        paddingTop = "12dp",
        paddingBottom = "12dp",
        {
            ImageView,
            id = "iv_image",
            layout_gravity = "center_vertical",
            layout_width = "120dp",
            layout_height = "75dp",
            scaleType = "centerCrop",
        },
        {
            TextView,
            id = "tv_title",
            layout_marginLeft = "132dp",
            layout_width = "fill",
            maxLines = "2",
            lineSpacingMultiplier = 1.3,
            layout_gravity = "top",
            textSize = "14sp",
            textColor = "#222222",
        },
        {
            TextView,
            id = "tv_date",
            layout_gravity = "bottom",
            layout_marginLeft = "132dp",
            layout_width = "fill",
            textSize = "12sp",
            textColor = "#aaaaaa",
        }
    }

    local hadLoadData
    local isVisible
    local lastId
    local params = { rid=rid, fctime = 0, fetime = 0, lvtime = 0, fst= 1, h=0, uid= '126174545.2556769649736356000.1498557659047.7295' }
    local data = {}
    local ids = {}
    local adapter
    local fragment = LuaFragment.newInstance()
    local function lazyLoad()
        if not isVisible then return end
        if hadLoadData then return end
        if adapter == nil then return end
        hadLoadData = true
        getData(params, data, adapter, fragment, ids.swipe_layout)
    end
    fragment.setCreator(luajava.createProxy('androlua.LuaFragment$FragmentCreator', {
        onCreateView = function(inflater, container, savedInstanceState)
            return  loadlayout(layout, ids)
        end,
        onViewCreated = function(view, savedInstanceState)
            adapter = LuaAdapter(luajava.createProxy("androlua.LuaAdapter$AdapterCreator", {
                getCount = function() return #data end,
                getView = function(position, convertView, parent)
                    position = position + 1 -- lua 索引从 1开始
                    if convertView == nil then
                        local views = {} -- store views
                        convertView = loadlayout(item_view, views, ListView)
                        convertView.getLayoutParams().width = parent.getWidth()
                        convertView.setTag(views)
                    end
                    local views = convertView.getTag()
                    local item = data[position]
                    if item then
                        LuaImageLoader.load(views.iv_image, item.i)
                        views.tv_date.setText(string.format('%s        %s',item.f ,dateStr(item.p)))
                        views.tv_title.setText(item.t)
                    end
                    
                    if position == #data then getData(params, data, adapter, fragment, ids.swipe_layout) end

                    return convertView
                end
            }))
            ids.listview.setAdapter(adapter)
            ids.listview.setOnItemClickListener(luajava.createProxy("android.widget.AdapterView$OnItemClickListener", {
                onItemClick = function(adapter, view, position, id)
                    launchDetail(fragment, data[position + 1])
                end,
            }))
            ids.swipe_layout.setRefreshing(true)
            lazyLoad()
        end,
        onUserVisible = function(visible)
            isVisible = visible
            lazyLoad()
        end,
    }))
    return fragment
end

return {
    newInstance = newInstance
}
