return {
    LinearLayout,
    layout_widht = "fill",
    paddingTop = "16dp",
    orientation = "vertical",
    background="@drawable/layout_se",
    -- head
    {
        FrameLayout,
        layout_width = "match",
        layout_height = "36dp",
        paddingLeft = "16dp",
        paddingRight = "16dp",
        {
            ImageView,
            id = "iv_image",
            layout_width = "36dp",
            layout_height = "36dp",
            scaleType="centerCrop"
        },
        {
            TextView,
            id = "tv_title",
            layout_marginLeft = "44dp",
            layout_widht = "fill",
            paddingRight = "16dp",
            maxLines = "1",
            ellipsize="end",
            textSize = "13sp",
            textColor = "#234156",
        },
        {
            TextView,
            id = "tv_date",
            layout_gravity="bottom",
            layout_marginLeft = "44dp",
            layout_widht = "fill",
            maxLines = "1",
            textSize = "11sp",
            textColor = "#999999",
        },
    },
    -- content
    {
        TextView,
        id = "tv_content",
        layout_widht = "fill",
        layout_marginLeft = "16dp",
        layout_marginRight = "16dp",
        layout_marginTop = "12dp",
        lineSpacingMultiplier = '1.3',
        textSize = "14sp",
        textColor = "#222222",
    },
    -- pictures
    {
        LuaNineGridView,
        id = "iv_nine_grid",
        layout_width = "match",
        layout_height = "wrap",
        gap = "2dp",
        maxSize = 9,
        showStyle = 1,
        layout_marginTop = "12dp",
        layout_marginLeft = "16dp",
        layout_marginRight = "16dp",
    },

    -- video
    {
        FrameLayout,
        id= "layout_video",
        layout_width = "match",
        layout_height = "240dp",
        layout_marginTop = "12dp",
        {
            ImageView,
            id = "iv_video",
            layout_widht = "fill",
            scaleType="centerCrop"
        },
        {
            View,
            layout_height = "fill",
            layout_width = "fill",
            background = "#88000000",
        },
        {
            ImageView,
            layout_gravity="center",
            layout_widht = "40dp",
            layout_height = "40dp",
            src="jike/img/ic_video_play.png",
        },
    },
    -- foot
    {
        LinearLayout,
        layout_width = "match",
        layout_height = "56dp",
        paddingLeft="16dp",
        paddingRight="16dp",
        gravity="center_vertical",
        orientation = "horizontal",
        {
            ImageView,
            layout_width = "20dp",
            layout_height = "20dp",
            src="jike/img/ic_like_border.png",
        },
        {
            TextView,
            id = "tv_collect",
            layout_width = "70dp",
            paddingLeft="4dp",
            textSize = "12sp",
            textColor = "#A6A6A6",
        },
        {
            ImageView,
            layout_width = "20dp",
            layout_height = "20dp",
            src="jike/img/ic_comment.png"
        },
        {
            TextView,
            id = "tv_comment",
            paddingLeft="4dp",
            layout_width = "70dp",
            textSize = "12sp",
            textColor = "#A6A6A6",
        },
        {
            ImageView,
            layout_width = "20dp",
            layout_height = "20dp",
            src="jike/img/ic_share.png"
        },

    },
    {
        View,
        layout_height = "8dp",
        layout_width = "fill",
        background = "#e1e1e1",
    }
}