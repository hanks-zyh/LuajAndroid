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
import "androlua.LuaHttp"
local uihelper = require "common.uihelper"

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

local css = [[
    article,aside,details,figcaption,figure,footer,header,hgroup,main,nav,section,summary{display:block}audio,canvas,video{display:inline-block}audio:not([controls]){display:none;height:0}html{font-family:sans-serif;-webkit-text-size-adjust:100%}body{font-family:'Helvetica Neue',Helvetica,Arial,Sans-serif;background:#fff;padding-top:0;margin:0}a:focus{outline:thin dotted}a:active,a:hover{outline:0}h1{margin:.67em 0}h1,h2,h3,h4,h5,h6{font-size:16px}abbr[title]{border-bottom:1px dotted}hr{box-sizing:content-box;height:0}mark{background:#ff0;color:#000}code,kbd,pre,samp{font-family:monospace,serif;font-size:1em}pre{white-space:pre-wrap}q{quotes:\201C\201D\2018\2019}small{font-size:80%}sub,sup{font-size:75%;line-height:0;position:relative;vertical-align:baseline}sup{top:-0.5em}sub{bottom:-0.25em}img{border:0;vertical-align:middle;color:transparent;font-size:0}svg:not(:root){overflow:hidden}figure{margin:0}fieldset{border:1px solid silver;margin:0 2px;padding:.35em .625em .75em}legend{border:0;padding:0}table{border-collapse:collapse;border-spacing:0;overflow:hidden}a{text-decoration:none}blockquote{border-left:3px solid #d0e5f2;font-style:normal;display:block;vertical-align:baseline;font-size:100%;margin:.5em 0;padding:0 0 0 1em}ul,ol{padding-left:20px}.content{color:#444;line-height:1.6em;font-size:16px;margin:16px}.content img{max-width:100%;display:block;margin:30px auto}.content img+img{margin-top:15px}.content img[src*="zhihu.com/equation"]{display:inline-block;margin:0 3px}.content a{color:#259}.content a:hover{text-decoration:underline}
]]
local htmlTemplate = [[
<!DOCTYPE html>
<html>
<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta name="viewport" content="width=device-width; initial-scale=1; minimum-scale=1; maximum-scale=2">
	<meta content="width=device-width,user-scalable=no" name="viewport">
	<style type="text/css">	%s </style>
</head>
<body>
<div class="content"> %s </div>
</body>
</html>
]]

function html_unescape(s)
    return s:gsub("&lt;","<")
    :gsub("&gt;",">")
    :gsub("&amp;","&")
    :gsub("&quot;",'"')
    :gsub("&#39;","'")
    :gsub("&#47;","/")
end

function onCreate(savedInstanceState)
    activity.setStatusBarColor(0xffd22222)
    activity.setContentView(loadlayout(layout))
    back.onClick = function()
        activity.finish()
    end
    local newsid = activity.getIntent().getStringExtra('newsid')
    local originalUrl = string.format('http://wap.ithome.com/html/%s.htm', newsid)
    tv_title.setText(originalUrl)
    webview.setVisibility(0)
    progressBar.setVisibility(8)
    local url = string.format( "http://api.ithome.com/xml/newscontent/%s/%s.xml", newsid:sub(1,3),newsid:sub(4,6) )
    LuaHttp.request({url= url}, function ( error, code, body )
        local content = string.match( body,'<detail.->(.-)</detail>')
        local data = string.format(htmlTemplate,css, html_unescape(content))
        uihelper.runOnUiThread(activity,function()
                print(data)
                webview.loadData(data, "text/html; charset=UTF-8", nil)
        end)
    end)
end


function onDestroy()
    if webview then
        webview.getParent().removeView(webview)
        webview.destroy()
        webview = nil
    end
end