--
-- Created by IntelliJ IDEA.  Copyright (C) 2017 Hanks
-- User: hanks
-- Date: 2017/5/26
-- A news app
--
require "import"
import "android.widget.*"
import "android.content.*"
import("androlua.LuaWebView")

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
        elevation = "2dp",
        {
            ImageView,
            id = "back",
            layout_width = "40dp",
            layout_height = "40dp",
            layout_marginLeft = "8dp",
            scaleType = "centerInside",
            src = "@drawable/ic_menu_back",
        },
        {
            TextView,
            layout_height = "56dp",
            layout_width = "fill",
            paddingRight = "16dp",
            singleLine = true,
            textIsSelectable = true,
            ellipsize = "end",
            id = "tv_title",
            gravity = "center_vertical",
            paddingLeft = "8dp",
            textColor = "#ffffff",
            textSize = "16sp",
        },
    },
    {
        FrameLayout,
        layout_width = "fill",
        layout_height = "fill",
        {
            LuaWebView,
            id = "webview",
            layout_width = "fill",
            layout_height = "fill",
        },
        {
            ProgressBar,
            layout_gravity="center",
            id = "progressBar",
            layout_width = "40dp",
            layout_height = "40dp",
        },
    }
}


function onCreate(savedInstanceState)
    activity.setStatusBarColor(0xffd22222)
    activity.setContentView(loadlayout(layout))
    back.onClick = function()
        activity.finish()
    end
    local url = activity.getIntent().getStringExtra('url')
    if url == nil then url = "http://hanks.pub" end
    tv_title.setText(url)
    webview.setVisibility(8)
    progressBar.setVisibility(0)
    webview.loadUrl(url)
    webview.setWebViewClientListener(luajava.createProxy('androlua.LuaWebView$WebViewClientListener', {
        onPageFinished = function(view, url)
            view.loadUrl([[
                    javascript:(function(){
                        var rec = document.getElementsByClassName('rc2');
                        for(var i=0;i<rec.length;i++) rec[i].style.display = 'none';
                        document.getElementById('hd_float').style.display = 'none';
                        document.getElementById("ft").style.display = 'none';
                        document.getElementById('ruanmei-apps').style.display = 'none';
                        document.getElementById('downapp').style.display = 'none';
                        document.getElementsByClassName('newsgrade')[0].style.display = 'none';
                        document.getElementsByClassName('nav')[0].style.display = 'none';
                        document.getElementsByClassName('shareto')[0].style.display = 'none';
                        document.getElementsByClassName('current_nav')[0].style.display = 'none';
                    })()
              ]]);
            webview.setVisibility(0)
            progressBar.setVisibility(8)
        end
    }))
end


function onDestroy()
    if webview then
        webview.getParent().removeView(webview)
        webview.destroy()
        webview = nil
    end
end