package androlua;

import android.content.Context;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.support.v4.content.ContextCompat;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.model.GlideUrl;
import com.bumptech.glide.load.model.LazyHeaders;

import pub.hanks.luajandroid.R;

/**
 * user image loader
 * Created by hanks on 2017/5/12. Copyright (C) 2017 Hanks
 */

public class LuaImageLoader {

    public static void load(ImageView imageView, String uri) {
        load(imageView.getContext(), imageView, uri);
    }


    public static void load(Context context, ImageView imageView, String uri) {
        load(context, imageView, uri,
                ContextCompat.getDrawable(context, R.drawable.ic_loading),
                ContextCompat.getDrawable(context, R.drawable.ic_loading));
    }

    public static void load(Context context, ImageView imageView, String uri,
                            Drawable placeholderDrawable, Drawable errorDrawable) {
        if (imageView == null || uri == null) {
            return;
        }
        boolean loadLocal = false;
        if (uri.startsWith("#")) { // load local file
            uri = uri.substring(1);
            loadLocal = true;
        }

        if (!uri.startsWith("http://") && !uri.startsWith("https://")) {
            String path = uri;
            if (!uri.startsWith("/")) {
                path = LuaManager.getInstance().getLuaExtDir() + "/" + uri;
            }
            if (loadLocal) {
                imageView.setImageBitmap(BitmapFactory.decodeFile(path));
                return;
            }
            uri = "file://" + path;
        }
        Glide.with(context)
                .load(uri)
                .placeholder(placeholderDrawable)
                .error(errorDrawable)
                .crossFade()
                .into(imageView);
    }


    public static void load(ImageView imageView, String uri, String referer) {
        if (imageView == null || uri == null) {
            return;
        }
        LazyHeaders headers = new LazyHeaders.Builder()
                .addHeader("Referer", referer)
                .build();
        GlideUrl glideUrl = new GlideUrl(uri, headers);
        Glide.with(imageView.getContext())
                .load(glideUrl)
                .placeholder(R.drawable.ic_loading)
                .error(R.drawable.ic_loading)
                .crossFade()
                .into(imageView);
    }
}
