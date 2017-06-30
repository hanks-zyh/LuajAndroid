require "import"
import "android.widget.*"
import "android.content.*"
import "android.view.View"
import "android.support.v7.widget.AppCompatCheckBox"
import "android.net.Uri"
import "java.io.File"
import "androlua.utils.DialogUtils"
import "android.support.v7.widget.AppCompatSeekBar"
local DialogBuilder = import "android.app.AlertDialog$Builder"

local JSON = require "cjson"
local config = {}

local config_file = "luandroid"
local sp = activity.getSharedPreferences(config_file, Context.MODE_PRIVATE)

local config = JSON.decode(sp.getString('config', '{}'))

local divider = {
    View,
    layout_width = "match",
    layout_height = "0.5dp",
    background = "#f1f1f1",
}

local dialog_progress = {
    RelativeLayout,
    padding = "16dp",
    {
        TextView,
        id = 'tv_progress',
        layout_alignParentRight = true,
        layout_centerVertical = true,
        textSize = "14sp",
        textColor = "#444444",
    },
    {
        AppCompatSeekBar,
        id = 'progress',
        layout_width = "fill",
        layout_toLeftOf = "tv_progress"
    }
}

local function layoutTitle(text)
    return {
        TextView,
        layout_width = "fill",
        layout_height = "16dp",
        textColor = "#666666",
        background = "#fafafa",
        textSize = "13sp",
        gravity = "center_vertical",
        paddingLeft = "16dp",
    }
end

local function layoutText(text, id)
    return {
        TextView,
        id = id,
        layout_width = "fill",
        layout_height = "48dp",
        paddingLeft = "16dp",
        background = "@drawable/layout_selector_tran",
        gravity = 'center_vertical',
        text = text,
        textColor = "#444444",
        textSize = "14sp",
    }
end

local function layoutCheckBox(text, id, checked)
    return {
        RelativeLayout,
        layout_width = "match",
        layout_height = "48dp",
        paddingLeft = "16dp",
        {
            TextView,
            text = text,
            textColor = "#444444",
            textSize = "14sp",
            layout_centerVertical = true,
        },
        {
            AppCompatCheckBox,
            id = id,
            layout_width = "50dp",
            layout_height = "50dp",
            layout_centerVertical = true,
            layout_alignParentRight = true,
            checked = checked,
        }
    }
end

local layout_content = {
    LinearLayout,
    layout_width = "fill",
    layout_height = "fill",
    orientation = "vertical",

    layoutTitle('界面'),
    layoutText('首页背景', 'layout_home_bg'),
    divider,
    layoutText('首页Logo', 'layout_home_logo'),
    divider,
    layoutText('调整图标圆角', 'layout_home_radius'),
    divider,
    layoutCheckBox('首页加载图标', 'cb_loadicon', config.home_loadicon or false),
    divider,
    layoutCheckBox('WiFi 下自动更新插件', 'cb_update_inwifi', config.update_inwifi or true),

    layoutTitle('其他'),
    layoutText('应用评分', 'layout_market'),
    divider,
    layoutText('推荐给好基友', 'layout_shareapp'),
    divider,
    layoutText('关于应用', 'layout_about'),
    divider,
    layoutText('捐赠(๑￫ܫ￩)', 'layout_support')
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
        gravity = "center_vertical",
        {
            ImageView,
            id = "back",
            layout_width = "56dp",
            layout_height = "56dp",
            src = "@drawable/ic_menu_back",
            background = "@drawable/layout_selector_tran",
            scaleType = "centerInside",
        },
        {
            TextView,
            layout_height = "56dp",
            layout_width = "fill",
            id = "tv_title",
            gravity = "center_vertical",
            paddingLeft = "8dp",
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

local CODE_PICK_BG, CODE_PICK_LOGO = 0x1, 0x2

local function saveConfig(config)
    sp.edit().putString("config", JSON.encode(config)).apply()
end

function onCreate(savedInstanceState)
    activity.setContentView(loadlayout(layout))

    back.onClick = function()
        activity.finish()
    end


    cb_update_inwifi.onClick = function()
        if config.update_inwifi == true then
            config.update_inwifi = false
        else
            config.update_inwifi = true
        end
        saveConfig(config)
    end

    cb_loadicon.onClick = function()
        if config.home_loadicon == true then
            config.home_loadicon = false
        else
            config.home_loadicon = true
        end
        saveConfig(config)
    end

    layout_market.onClick = function()
        local intent = Intent(Intent.ACTION_VIEW)
        intent.setData(Uri.parse('market://details?id=xyz.hanks.note'))
        activity.startActivity(intent)
    end


    layout_home_bg.onClick = function()
        pcall(function()
            local intent = Intent(Intent.ACTION_GET_CONTENT)
            intent.setType("image/*")
            activity.startActivityForResult(intent, CODE_PICK_BG)
        end)
    end

    layout_home_logo.onClick = function()
        pcall(function()
            local intent = Intent(Intent.ACTION_GET_CONTENT)
            intent.setType("image/*")
            activity.startActivityForResult(intent, CODE_PICK_LOGO)
        end)
    end

    layout_home_radius.onClick = function()
        local ids = {}
        DialogBuilder(activity).setView(loadlayout(dialog_progress, ids, ViewGroup)).show()
        ids.progress.setMax(50)
        ids.progress.setProgress(tonumber(config.home_icon_radius) or 40)
        ids.tv_progress.setText(config.home_icon_radius or '40')
        ids.progress.setOnSeekBarChangeListener(luajava.createProxy('android.widget.SeekBar$OnSeekBarChangeListener', {
            onProgressChanged = function(bar, progress, fromUser)
                config.home_icon_radius = '' .. progress
                ids.tv_progress.setText(config.home_icon_radius)
                saveConfig(config)
            end
        }))
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
            intent.putExtra(Intent.EXTRA_TEXT, '震惊，所有用了这个 APP 的人都再也离不开了! http://coolapk.com/apk/xyz.hanks.note');
            intent.setType("text/plain");
            activity.startActivity(Intent.createChooser(intent, '分享'))
        end)
    end

    layout_support.onClick = function()
        xpcall(function()
            local intentFullUrl = "intent://platformapi/startapp?saId=10000007&clientVersion=3.7.0.0718&qrcode=https%3A%2F%2Fqr.alipay.com%2Faex09002nkvmcsullzrwg2b%3F_s%3Dweb-other&_t=1472443966571#Intent;scheme=alipayqr;package=com.eg.android.AlipayGphone;end"
            activity.startActivity(Intent.parseUri(intentFullUrl, 1));
        end,
            function()
                local url = "https://qr.alipay.com/aex09002nkvmcsullzrwg2b";
                activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)));
            end)
    end
end

function onActivityResult(requestCode, resultCode, data)
    if resultCode ~= -1 or data == nil then
        return
    end
    local uri = data.getData()
    if requestCode == CODE_PICK_BG and uri then
        config.home_bg = uri.toString()
        saveConfig(config)
        return
    end

    if requestCode == CODE_PICK_LOGO and uri then
        config.home_logo = uri.toString()
        saveConfig(config)
        return
    end
end