--
-- Created by IntelliJ IDEA.  Copyright (C) 2017 Hanks
-- User: hanks
-- Date: 2017/5/12
-- Time: 13:59
--

return {
    RelativeLayout,
    layout_width="fill",
    {
        TextView,
        id="tv_left",
        layout_width=100,
        textSize="20sp",
        textColor="#0000ff",
        text="left",
        background="#22ff0000"
    },
    {
        TextView,
        id="tv_right",
        layout_width=100,
        text="right",
        background="#2200ff00",
        layout_alignParentRight=true
    },
    {
        LinearLayout,
        layout_width="fill",
        layout_height="wrap",
        orientation="vertical",
        layout_toRightOf="tv_left",
        layout_toLeftOf="tv_right",
        {
            Button,
            id="btn_1",
            layout_width="fill",
            text="按钮1",
        },
        {
            Button,
            layout_width="fill",
            text="按钮2",
            background="#220000ff",
        },
        {
            ProgressBar,
        },


    }
}

