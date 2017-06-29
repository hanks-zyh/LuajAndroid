require "import"
import "android.widget.*"
import "android.content.*"
import "android.support.v4.view.ViewPager"
import "android.support.v7.widget.Toolbar"
import "androlua.LuaActivity"
import "androlua.LuaAdapter"
import "androlua.LuaImageLoader"
import "androlua.common.LuaFileUtils"

local uihelper = require "uihelper"
local log = require "log"
local JSON = require "cjson"

local layout = {
    FrameLayout,
    layout_width = "fill",
    layout_height = "fill",
    focusable = true,
    focusableInTouchMode = true,
    {
        ImageView,
        id = "iv_home_bg",
        layout_width = "fill",
        layout_height = "fill",
    },
    {

    LinearLayout,
    layout_width = "fill",
    layout_height = "fill",
    gravity = "center_horizontal",
    background = "#55FFFFFF",
    orientation = 1,
    paddingLeft = "16dp",
    paddingRight = "16dp",
    {
        ImageView,
        id = "iv_logo",
        layout_height = "72dp",
        layout_width = "72dp",
        layout_marginTop= "120dp",
        src = "@mipmap/ic_launcher",
        scaleType = "centerCrop",
    },
    {
        TextView,
        id = "tv_add_plugin",
        layout_height = "48dp",
        layout_width = "fill",
        layout_marginLeft = "24dp",
        layout_marginTop = "48dp",
        layout_marginBottom = "40dp",
        layout_marginRight = "24dp",
        gravity = "center",
        text = "URL | AGC | NEWS | CODE",
        textColor = "#9DAEBF",
        textSize = "12sp",
        background = "#E0EBF0F2",
    },
    {
        GridView,
        id = "gridView",
        layout_width = "fill",
        layout_marginLeft = "14dp",
        layout_marginRight = "14dp",
        numColumns = 5,
    },
    }
}

local item_view = {
    LinearLayout,
    layout_width = "50dp",
    layout_height = "68dp",
    orientation = "vertical",
    gravity = "center",
    {
        ImageView,
        id = "icon",
        layout_width = "40dp",
        layout_height = "40dp",
    },
    {
        TextView,
        id = "text",
        textSize = "10sp",
        gravity = "center",
        layout_width = "fill",
        layout_height = "20dp",
    }
}

local data = {}
local adapter

local config_file = "luandroid"
local sp = activity.getSharedPreferences(config_file, Context.MODE_PRIVATE)
local home_loadicon = false
local home_bg

local function newActivity(luaPath)
    local intent = Intent(activity, LuaActivity)
    intent.putExtra("luaPath", luaPath)
    activity.startActivity(intent)
end

local function getData()
  local localList = LuaFileUtils.getPluginList()
  for i = 1, #localList do
      local p = localList[i - 1]
      data[#data + 1] = {
        text = p.getName(),
        launchPage = p.getMainPath(),
        icon = p.getIconPath(),
      }
      adapter.notifyDataSetChanged()
  end
end

local config
function onResume()
  config = JSON.decode( sp.getString('config','{}'))
  log.print_r(config)
  for k,v in pairs(data) do
    data[k] = nil
  end
  getData()
  -- bg
  if config.home_bg and config.home_bg ~= '' then
    activity.setStatusBarColor(0x00FFFFFF)
    LuaImageLoader.load(iv_home_bg, config.home_bg)
  end

  -- logo
  if config.home_logo and config.home_logo ~= '' then
    LuaImageLoader.loadWithRadius(iv_logo, 36 , config.home_logo)
  end
end


function onCreate(savedInstanceState)
    activity.setLightStatusBar()
    activity.setContentView(loadlayout(layout))

    iv_logo.onClick = function (args)
      newActivity(luajava.luaextdir .. '/activity_setting.lua')
    end

    tv_add_plugin.onClick = function (args)
      newActivity(luajava.luadir .. '/activity_plugins.lua')
    end
    adapter = LuaAdapter(luajava.createProxy("androlua.LuaAdapter$AdapterCreator", {
        getCount = function() return #data end,
        getView = function(position, convertView, parent)
            position = position + 1 -- lua 索引从 1开始
            if convertView == nil then
                local views = {} -- store views
                convertView = loadlayout(item_view, views, GridView)
                convertView.getLayoutParams().width = gridView.getWidth() / 5 - 1
                convertView.setTag(views)
            end
            local views = convertView.getTag()
            local item = data[position]
            if item then
                local icon = ''
                if config.home_loadicon then icon = item.icon end
                LuaImageLoader.loadWithRadius(views.icon, 40, icon)
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
