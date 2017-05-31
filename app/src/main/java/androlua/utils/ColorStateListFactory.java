package androlua.utils;

import android.content.res.ColorStateList;
import android.graphics.Color;

/**
 * Created by hanks on 2017/5/31. Copyright (C) 2017 Hanks
 */

public class ColorStateListFactory {

    public static ColorStateList newInstance(int normalColor) {
        return ColorStateList.valueOf(normalColor);
    }

    public static ColorStateList newInstance(int normalColor, int selectedColor) {
        int[][] states = new int[][]{
                {-android.R.attr.state_checked},
                {android.R.attr.state_checked},
                {android.R.attr.state_pressed},
                {android.R.attr.state_enabled},
                {android.R.attr.state_selected},
        };
        int[] colorList = new int[9];
        colorList[0] = normalColor;
        colorList[1] = selectedColor;
        colorList[2] = selectedColor;
        colorList[3] = selectedColor;
        colorList[4] = selectedColor;
        return new ColorStateList(states, colorList);
    }

}
