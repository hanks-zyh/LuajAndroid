package androlua;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.support.v4.content.ContextCompat;
import android.widget.ImageView;

import com.bumptech.glide.Glide;

import pub.hanks.luajandroid.R;

/**
 * user image loader
 * Created by hanks on 2017/5/12. Copyright (C) 2017 Hanks
 */

public class LuaImageLoader {

    public static void load(ImageView imageView, String uri) {
        load(LuaApplication.instance, imageView, uri);
    }

    public static void load(Context context, ImageView imageView, String uri) {
        load(context, imageView, uri,
                ContextCompat.getDrawable(context, R.drawable.loading),
                ContextCompat.getDrawable(context, R.drawable.loading));
    }

    public static void load(Context context, ImageView imageView, String uri,
                            Drawable placeholderDrawable, Drawable errorDrawable) {
        if (imageView == null || uri == null) {
            return;
        }
       if (!uri.startsWith("http://") && !uri.startsWith("https://")){
            if (uri.startsWith("/")) {
                uri = "file://" + uri;
            }else {
                uri = "file://" + LuaApplication.instance.getLuaExtDir() + "/" + uri;
            }
        }
        Glide.with(context)
                .load(uri)
                .placeholder(placeholderDrawable)
                .error(errorDrawable)
                .into(imageView);
    }
}
