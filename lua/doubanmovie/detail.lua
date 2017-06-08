require "import"
import "android.widget.*"
import "android.content.*"
import "android.view.View"
import "androlua.LuaHttp"

local JSON = require "common.json"
local uihelper = require "common.uihelper"

local layout = {
  ScrollView,
  layout_width = "fill",
  layout_height = "wrap",
  {


  LinearLayout,
  layout_width = "fill",
  layout_height = "wrap",
  orientation = "vertical",
  background = "#FFFFFF",
  {
    FrameLayout,
    layout_width = "fill",
    layout_height = "308dp",
    {
      ImageView,
      id = "iv_bg",
      layout_width = "fill",
      scaleType = "centerCrop",
      layout_height = "220dp",
    },
    {
      View,
      layout_width = "fill",
      layout_height = "220dp",
      background = "#88000000",
    },
    {
      ImageView,
      id = "iv_cover",
      layout_gravity = "bottom",
      layout_marginLeft = "16dp",
      layout_marginBottom = "8dp",
      layout_width = "104dp",
      layout_height = "160dp",
      elevation = "4dp",
    },
    {
      LinearLayout,
      layout_width = "fill",
      layout_height = "160dp",
      orientation = "vertical",
      layout_gravity = "bottom",
      layout_marginRight = "16dp",
      layout_marginLeft = "136dp",
      layout_marginBottom = "4dp",
      {
        TextView,
        id = "tv_title",
        layout_width = "fill",
        textColor = "#faffffff",
        textSize = "20sp",
      },
      {
        TextView,
        id = "tv_rate",
        layout_width = "fill",
        textColor = "#faffffff",
        textSize = "18sp",
        layout_marginTop = "8dp",
      },
      {
        TextView,
        id = "tv_duration",
        layout_width = "fill",
        textColor = "#00ffffff",
        textSize = "14sp",
        layout_marginTop = "8dp",
      },
      {
        TextView,
        id = "tv_genres",
        layout_width = "fill",
        layout_marginTop = "6dp",
        textSize = "14sp",
        textColor = "#8a8a8a"
      },
      {
        TextView,
        id = "tv_directors",
        layout_marginTop = "8dp",
        layout_width = "fill",
        textSize = "14sp",
        textColor = "#8a8a8a"
      },
      {
        TextView,
        id = "tv_year",
        layout_marginTop = "8dp",
        layout_width = "fill",
        textSize = "14sp",
        textColor = "#8a8a8a"
      },
    },
  },
  {
    TextView,
    textSize="20sp",
    text = "剧情简介",
    textColor = "#444444",
    layout_margin = "16dp",
  },
  {
    TextView,
    id = "tv_summary",
    textSize="12sp",
    layout_marginLeft = "16dp",
    layout_marginRight = "16dp",
    lineSpacingMultiplier = 1.5,
    textColor = "#777777",
  },
  {
    View,
    layout_margin = "16dp",
    layout_height = 2,
    background = "#f1f1f1",
  },
  {
    TextView,
    layout_margin = "16dp",
    textSize="20sp",
    text = "演员表",
    textColor = "#444444",
  },
  {
    HorizontalScrollView,
    layout_marginBottom = "16dp",
    {
      LinearLayout,
      id = "layout_casts",
      layout_width = "fill",
      layout_height = "200dp",
      paddingLeft = "16dp",
      clipToPadding = false,
    }
  },
},

}

local item_cast = {
  LinearLayout,
  layout_width = "80dp",
  orientation = "vertical",
  gravity = "center",
  paddingRight = "8dp",
  {
    ImageView,
    layout_width = "fill",
    layout_height = "120dp",
    scaleType = "centerCrop",
  },
  {
    TextView,
    layout_margin = "4dp",
    textSize="12sp",
    textColor = "#444444",
  }
}

function getData(id)
  local url = string.format('http://api.douban.com/v2/movie/subject/%s',id)
  LuaHttp.request({url=url},function(error, code, body)
    if error or code ~= 200 then
      print('get data error ' .. error)
    end
    local json = JSON.decode(body)
    uihelper.runOnUiThread(activity, function()
        LuaImageLoader.load(iv_bg,json.images.small)
        LuaImageLoader.load(iv_cover,json.images.large)
        local rate = json.rating.average
        if rate == '0' or rate == 0 then rate = '暂无' end
        tv_title.setText(json.title)
        tv_rate.setText('评分:  ' ..  rate)
        tv_summary.setText(json.summary or '暂无简介')
        tv_year.setText('年份:  ' .. json.year or '')
        tv_genres.setText('分类:  ' .. table.concat( json.genres or {'无'},',') )
        tv_duration.setText( string.format('%s/%s', table.concat( json.countries or {'未知'} ,',') ,
              table.concat( json.durations or {'0'},',') ) )

        local directors = {}
        if json.directors then
          for i = 1, #json.directors do directors[i] = json.directors[i].name end
        end
        tv_directors.setText('导演:  '.. table.concat(directors,','))
        if json.casts then
          layout_casts.removeAllViews()
          for i = 1, #json.casts do
              local cast = json.casts[i]
              local child = loadlayout(item_cast)
              LuaImageLoader.load(child.getChildAt(0), cast.avatars.medium)
              child.getChildAt(1).setText(cast.name)
              layout_casts.addView(child)
          end
        end
    end)
  end)

end

function onCreate(savedInstanceState)
  activity.setStatusBarColor(0x00000000)
  activity.setContentView(loadlayout(layout))
  local id = activity.getIntent().getStringExtra('id')
  getData(id)
end
