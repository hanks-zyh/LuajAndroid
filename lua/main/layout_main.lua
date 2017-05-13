return {
    ScrollView,
    layout_width = "fill",
    {
        LinearLayout,
        orientation = 1,
        layout_width = "fill",
        padding = 20,
        focusable=true,
        focusableInTouchMode=true,
        {
            TextView,
            text = "用户名"
        },
        {
            EditText,
            id = "luaPath",
            textSize="12sp",
            hint = "手机号/邮箱",
            layout_width = "fill",
            singleLine = true
        },
        {
            TextView,
            text = "密码"
        },
        {
            EditText,
            id = "packageName",
            hint="6-20位数字或字母",
            layout_width = "fill",
            singleLine = true,
            textSize="12sp",
            inputType="textPassword"
        },
        {
            TextView,
            text = "程序名称"
        },
        {
            EditText,
            id = "appName",
            textSize="12sp",
            layout_width = "fill",
            singleLine = true
        },


        {
            Button,
            layout_width = "fill",
            text = "Text",
            id = "btn_text"
        },
        {
            Button,
            layout_width = "fill",
            text = "Image",
            id = "btn_image"
        },
        {
            Button,
            layout_width = "fill",
            text = "List",
            id = "btn_list"
        },
        {
            Button,
            layout_width = "fill",
            text = "pager",
            id = "btn_pager"
        },
    }
}
