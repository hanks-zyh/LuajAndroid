--
-- Created by IntelliJ IDEA.  Copyright (C) 2017 Hanks
-- User: hanks
-- Date: 2017/5/15
-- Time: 10:23
-- Test Http for lua


require("import")
import "android.widget.*"
import "android.content.*"
local Http = import("androlua.LuaHttp");

local layout = {
    LinearLayout,
    orientation = 'vertical',
    {
        Button,
        text = "get",
        id = "btn_get",
    },
    {
        Button,
        text = "post",
        id = "btn_post",
    },
    {
        Button,
        text = "upload",
        id = "btn_upload",
    },
    {
        Button,
        text = "download",
        id = "btn_download",
    },
    {
        TextView,
        textColor = '#800',
        id = "tv_request",
    },
    {
        ScrollView,
        {
            TextView,
            textSize = '12sp',
            id = "tv_content",
        },
    }
}

function showResponse(text)
    activity.runOnUiThread(luajava.createProxy('java.lang.Runnable', {
        run = function()
            tv_content.setText(text)
        end
    }))
end

function post()
    local options = {
        url = 'http://route.showapi.com/269-1?showapi_appid=30807&showapi_sign=6a696aa349ca4df2a7b3b3d0e2c5eff7',
        method = 'POST',
        formData = {
            'precise:0',
            'debug:0',
            'text:易源接口是api的可插拔总线'
        },
    }
    tv_request.setText('post:\n' .. options.url .. '\n')

    Http.request(options, function(error, stateCode, body)
        showResponse(error or stateCode .. body)
    end)
end

function get()
    local options = {
        url = 'http://a.apix.cn/apixlife/phone/phone?phone=18810314997',
        method = 'GET',
        headers = {
            'accept:application/json',
            'content-type:application/json',
            'apix-key:4bed15f3d09648d37db92b22195f8d79'
        },
    }
    tv_request.setText('get:\n' .. options.url .. '\n')

    Http.request(options, function(error, stateCode, body)
        showResponse(error or stateCode .. body)
    end)
end

function download()
    print('download')
    local url = 'http://wx4.sinaimg.cn/mw690/475bb144ly1ffl5es0qhxj215o0rskdo.jpg'
    local options = {
        url = url,
        method = 'GET',
        outputFile = '/sdcard/2.jpg',
    }
    tv_request.setText('download:\n' .. options.url .. '\n')

    Http.request(options, function(error, stateCode, body)
        showResponse(error or stateCode .. body)
    end)
end

function upload()
    local options = {
        url = 'https://sm.ms/api/upload',
        method = 'POST',
        multipart = {
            'smfile:/sdcard/1.png',
        },
    }
    tv_request.setText('upload:\n' .. options.multipart[1] .. '\n')

    Http.request(options, function(error, stateCode, body)
        showResponse(error or stateCode .. body)
    end)
end

function onCreate(savedInstanceState)
    activity.setTitle('Test Http')
    activity.setContentView(loadlayout(layout))
    btn_get.onClick = function(v) get() end
    btn_post.onClick = function(v) post() end
    btn_upload.onClick = function(v) upload() end
    btn_download.onClick = function(v) download() end
end
