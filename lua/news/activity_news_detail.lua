--
-- Created by IntelliJ IDEA.  Copyright (C) 2017 Hanks
-- User: hanks
-- Date: 2017/5/26
-- A news app
--
require "import"
import "android.widget.*"
import "android.content.*"
import("android.webkit.WebView")
import("android.webkit.WebViewClient")
import("android.webkit.WebSettings")

-- create view table
local layout = {
    LinearLayout,
    layout_width = "fill",
    layout_height = "fill",
    orientation = "vertical",
    fitsSystemWindows = true,
    {
        LinearLayout,
        orientation = "horizontal",
        layout_width = "fill",
        layout_height = "56dp",
        background = "#D22222",
        gravity = "center_vertical",
        {
            ImageView,
            id = "back",
            layout_width = "40dp",
            layout_height = "40dp",
            layout_marginLeft = "12dp",
            scaleType="centerInside",
            src = "@drawable/ic_menu_back",
        },
        {
            TextView,
            layout_height = "56dp",
            layout_width = "fill",
            id = "tv_title",
            gravity = "center_vertical",
            paddingLeft = "8dp",
            textColor = "#ffffff",
            textSize = "16sp",
        },
    },
    {
        WebView,
        id = "webview",
        layout_width = "fill",
        layout_height = "fill",
    },
}


function onCreate(savedInstanceState)
    activity.setContentView(loadlayout(layout))
    back.onClick = function()
        activity.finish()
    end
    local url = activity.getIntent().getStringExtra('url')
    if url == nil then url = "http:-- hanks.pub" end
    print('.....................' .. url)
    webview.loadUrl(url)
    webview.setWebViewClient(WebViewClient())
    -- 设置是否支持缩放，我这里为false，默认为true。
    local setting = webview.getSettings()
    setting.setSupportZoom(false)

    -- 设置是否显示缩放工具，默认为false
    setting.setBuiltInZoomControls(false)

    -- 设置默认的字体大小，默认为16，有效值区间在1-72之间
    setting.setDefaultFontSize(18)

    -- 首先阻塞图片，让图片不显示
    setting.setBlockNetworkImage(true)

    -- 页面加载好以后，在放开图片
    setting.setBlockNetworkImage(false)

    -- 设置自适应屏幕
    setting.setUseWideViewPort(true)
    --  缩放至屏幕的大小
    setting.setLoadWithOverviewMode(true)

    -- 支持插件
    setting.setPluginsEnabled(true)

    -- 提高渲染等级
    setting.setRenderPriority(WebSettings.RenderPriority.HIGH)

    -- 禁止webview上面控件获取焦点(黄色边框)
    setting.setNeedInitialFocus(false)

    -- 关闭webview中缓存
    setting.setCacheMode(WebSettings.LOAD_CACHE_ELSE_NETWORK)

    -- 设置可以访问文件
    setting.setAllowFileAccess(true)

    -- 支持自动加载图片
    setting.setLoadsImagesAutomatically(true)
    setting.setJavaScriptEnabled(true)

    webview.setWebChromeClient(luajava.createProxy('android.webkit.WebChromeClient',{
        onReceivedTitle = function(webview, title)
            tv_title.setText(title)
        end
    }))
end


