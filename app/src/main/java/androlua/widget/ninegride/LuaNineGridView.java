package androlua.widget.ninegride;

import android.content.Context;
import android.util.AttributeSet;

import com.luajava.LuaTable;

import java.util.ArrayList;

/**
 * Created by hanks on 2017/5/31. Copyright (C) 2017 Hanks
 */

public class LuaNineGridView extends NineGridImageView {

    public LuaNineGridView(Context context) {
        super(context);
    }

    public LuaNineGridView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public void setImagesData(LuaTable lists) {
        ArrayList<String> data = new ArrayList<>();
        for (Object key : lists.keySet()) {
            String v = (String) lists.get(key);
            data.add(v);
        }
        setImagesData(data);
    }
}
