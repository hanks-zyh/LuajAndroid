return {
    ScrollView,
    layout_width = "fill",
    {
        LinearLayout,
        orientation = 1,
        layout_width = "fill",
        paddingLeft = 20,
        {
            TextView,
            text = "脚本路径"
        },
        {
            EditText,
            id = "luaPath",
            layout_width = "fill",
            singleLine = true,
        },
        {
            TextView,
            text = "包名称"
        },
        {
            EditText,
            id = "packageName",
            layout_width = "fill",
            singleLine = true,
        },
        {
            TextView,
            text = "程序名称"
        },
        {
            EditText,
            id = "appName",
            layout_width = "fill",
            singleLine = true,
        },
        {
            TextView,
            text = "程序版本"
        },
        {
            EditText,
            id = "appVer",
            layout_width = "fill",
            singleLine = true,
        },
        {
            TextView,
            text = "apk路径"
        },
        {
            EditText,
            id = "apkPath",
            layout_width = "fill",
            singleLine = true,
        },
        {
            TextView,
            text = "打包使用debug签名",
            id = "status"
        },
    }
}
