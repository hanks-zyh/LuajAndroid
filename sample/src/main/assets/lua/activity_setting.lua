require "import"
import "android.widget.*"
import "android.content.*"
import "android.view.View"
import "android.support.v7.widget.AppCompatCheckBox"
import "android.net.Uri"

local config_file = "luandroid"
local sp = activity.getSharedPreferences(config_file, Context.MODE_PRIVATE)

local update_inwifi = sp.getBoolean("update_inwifi",true)
local home_loadicon = sp.getBoolean("home_loadicon",false)

local divider = {
  View,
  layout_width = "match",
  layout_height = "0.5dp",
  background = "#f1f1f1",
}

local layout_content = {
  LinearLayout,
  layout_width = "fill",
  layout_height = "fill",
  orientation = "vertical",
  {
    TextView,
    layout_height = "40dp",
    text = "界面",
    textColor = "#666666",
    textSize = "13sp",
    gravity = "center_vertical",
    paddingLeft = "16dp",
  },
  {
    RelativeLayout,
    layout_width = "match",
    layout_height = "56dp",
    paddingLeft = "16dp",
    {
      TextView,
      text = "首页加载图标",
      textColor = "#444444",
      textSize = "14sp",
      layout_centerVertical = true,
    },
    {
        AppCompatCheckBox,
        id = "cb_loadicon",
        layout_width = "50dp",
        layout_height = "50dp",
        layout_centerVertical = true,
        layout_alignParentRight = true,
        checked = home_loadicon,
    }
  },
  divider,
  {
    RelativeLayout,
    layout_width = "match",
    layout_height = "56dp",
    paddingLeft = "16dp",
    {
      TextView,
      text = "WiFi 情况下自动更新",
      textColor = "#444444",
      textSize = "14sp",
      layout_centerVertical = true,
    },
    {
        AppCompatCheckBox,
        id = "cb_update_inwifi",
        layout_width = "50dp",
        layout_height = "50dp",
        layout_centerVertical = true,
        layout_alignParentRight = true,
        checked = update_inwifi,
    }
  },
  {
    TextView,
    layout_height = "40dp",
    text = "其他",
    textColor = "#666666",
    textSize = "13sp",
    gravity = "center_vertical",
    paddingLeft = "16dp",
  },
  {
    RelativeLayout,
    id = "layout_market",
    layout_width = "match",
    layout_height = "56dp",
    paddingLeft = "16dp",
    {
      TextView,
      text = "应用评分",
      textColor = "#444444",
      textSize = "14sp",
      layout_centerVertical = true,
    },
  },
  divider,
  {
    RelativeLayout,
    id = "layout_shareapp",
    layout_width = "match",
    layout_height = "56dp",
    paddingLeft = "16dp",
    {
      TextView,
      text = "推荐给朋友",
      textColor = "#444444",
      textSize = "14sp",
      layout_centerVertical = true,
    },
  },
  divider,
  {
    RelativeLayout,
    id = "layout_about",
    layout_width = "match",
    layout_height = "56dp",
    paddingLeft = "16dp",
    {
      TextView,
      text = "关于应用",
      textColor = "#444444",
      textSize = "14sp",
      layout_centerVertical = true,
    },
  },
  divider,
  {
    RelativeLayout,
    id = "layout_support",
    layout_width = "match",
    layout_height = "56dp",
    paddingLeft = "16dp",
    background = "@drawable/layout_selector_tran",
    {
      TextView,
      text = "《《捐赠》》",
      textColor = "#444444",
      textSize = "16sp",
      layout_centerVertical = true,
    },
  },
}

local layout = {
  LinearLayout,
  layout_width = "match",
  layout_height = "match",
  orientation = "vertical",
  background = "#ffffff",
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
          background = "@drawable/layout_selector_tran",
          scaleType="centerInside",
      },
      {
          TextView,
          layout_height = "56dp",
          layout_width = "fill",
          id = "tv_title",
          gravity = "center_vertical",
          paddingLeft="8dp",
          textColor = "#FFFFFF",
          textSize = "16sp",
          text = "设置",
      },
  },
  {
      FrameLayout,
      layout_width = "fill",
      layout_height = "fill",
      layout_content,
      {
          View,
          layout_width = "fill",
          layout_height = "3dp",
          background = "@drawable/shadow_line_top",
      }
  },
}


function onCreate(savedInstanceState)
  activity.setContentView(loadlayout(layout))

  back.onClick = function()
      activity.finish()
  end


  cb_update_inwifi.onClick = function()
    if update_inwifi == true then
      update_inwifi = false
    else
      update_inwifi = true
    end
   sp.edit().putBoolean("update_inwifi", update_inwifi).apply()
  end

  cb_loadicon.onClick = function()
    if home_loadicon == true then
      home_loadicon = false
    else
      home_loadicon = true
    end
    sp.edit().putBoolean("home_loadicon",home_loadicon).apply()
  end

  layout_market.onClick = function()

      local intent = Intent(Intent.ACTION_VIEW)
      intent.setData(Uri.parse('market://details?id=xyz.hanks.note'))
      activity.startActivity(intent)

  end

  layout_about.onClick = function()

    pcall(function()
      local intent = Intent(Intent.ACTION_VIEW)
      intent.setData(Uri.parse('market://details?id=xyz.hanks.note'))
      activity.startActivity(intent)
    end)

  end

  layout_shareapp.onClick = function()
    pcall(function()
      local intent = Intent(Intent.ACTION_SEND)
      intent.putExtra(Intent.EXTRA_TEXT, '震惊，所有用了这个 APP 的人都再也离不开了 😀 http://coolapk.com/apk/xyz.hanks.note');
      intent.setType("text/plain");
      activity.startActivity(Intent.createChooser(intent, '分享'))
    end)
  end

  layout_support.onClick =  function()
    xpcall(function()
      local intentFullUrl ="intent://platformapi/startapp?saId=10000007&clientVersion=3.7.0.0718&qrcode=https%3A%2F%2Fqr.alipay.com%2Faex09002nkvmcsullzrwg2b%3F_s%3Dweb-other&_t=1472443966571#Intent;scheme=alipayqr;package=com.eg.android.AlipayGphone;end"
      activity.startActivity(Intent.parseUri(intentFullUrl, 1));
    end,
    function()
      local url = "https://qr.alipay.com/aex09002nkvmcsullzrwg2b";
      activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)));
    end)
  end

end
