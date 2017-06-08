package androlua.widget.webview;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.EditText;

import androlua.LuaUtil;
import androlua.base.BaseActivity;
import pub.hanks.luajandroid.R;

/**
 * Created by hanks on 2017/6/2. Copyright (C) 2017 Hanks
 */

public class WebViewActivity extends BaseActivity {

    private EditText etUrl;
    private String url;
    private int color;
    private WebView mWebView;
    private View loading;
    private View layout_toolbar;
    private View ivRefresh;

    public static void start(Context context, String url) {
        start(context, url, Color.TRANSPARENT);
    }

    public static void start(Context context, String url, int color) {
        Intent starter = new Intent(context, WebViewActivity.class);
        starter.putExtra("url", url);
        starter.putExtra("color", color);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_webview);
        etUrl = (EditText) findViewById(R.id.et_url);
        loading = findViewById(R.id.loading);
        layout_toolbar = findViewById(R.id.layout_toolbar);
        mWebView = (WebView) findViewById(R.id.webview);
        ivRefresh = findViewById(R.id.iv_refresh);

        colorBitmap =  Bitmap.createBitmap(1, 1, Bitmap.Config.RGB_565);
        canvas = new Canvas(colorBitmap);

        WebSettings settings = mWebView.getSettings();
        settings.setUseWideViewPort(true);
        settings.setAppCacheEnabled(true);
        settings.setJavaScriptCanOpenWindowsAutomatically(true);
        settings.setDisplayZoomControls(false);
        settings.setSupportMultipleWindows(true);
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);

        url = getIntent().getStringExtra("url");
        color = getIntent().getIntExtra("color", 0);
        if (color == Color.TRANSPARENT) {
            setLightStatusBar();
        }else {
            setStatusBarColor(color);
            layout_toolbar.setBackgroundColor(color);
        }
        etUrl.setText(url);
        mWebView.setWebChromeClient(new WebChromeClient(){
            @Override
            public void onProgressChanged(WebView view, int newProgress) {
                super.onProgressChanged(view, newProgress);
            }

            @Override
            public void onReceivedTitle(WebView view, String title) {
                super.onReceivedTitle(view, title);
                etUrl.setText(title);
            }

        });
        mWebView.setWebViewClient(new WebViewClient(){
            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                super.onPageStarted(view, url, favicon);
                loading.setVisibility(View.VISIBLE);
                ivRefresh.setVisibility(View.GONE);
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                loading.setVisibility(View.GONE);
                ivRefresh.setVisibility(View.VISIBLE);
                fetchColor();
            }

            @Deprecated
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                return false;
            }
            @Override
            public boolean shouldOverrideUrlLoading(WebView webView, WebResourceRequest webResourceRequest) {
                return false;
            }
        });

        ivRefresh.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mWebView.loadUrl(url);
            }
        });

        mWebView.loadUrl(url);

    }

    private  Bitmap colorBitmap;
    private Canvas canvas;

    private boolean canAsBgColor(int i) {
//        return Color.red(i) < 200 && Color.green(i) < 200 && Color.blue(i) < 200;
        return true;
    }

    private void fetchColor() {
        if (mWebView != null && mWebView.getVisibility() == View.VISIBLE && mWebView.getScrollX() < LuaUtil.dp2px(20)) {
            mWebView.draw(canvas);
            if (colorBitmap != null) {
                int pixel = colorBitmap.getPixel(0, 0);
                if (canAsBgColor(pixel)) {
                    layout_toolbar.setBackgroundColor(pixel);
                    if (pixel == Color.WHITE){
                        setLightStatusBar();
                    }else {
                        setStatusBarColor(pixel);
                    }
                }
            }
        }
    }

    @Override
    public void onBackPressed() {
        if (mWebView.canGoBack()){
            mWebView.goBack();
            return;
        }
        super.onBackPressed();

    }
}
