package androlua.widget.webview;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.KeyEvent;
import android.view.View;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.widget.EditText;

import androlua.LuaWebView;
import androlua.base.BaseActivity;
import pub.hanks.luajandroid.R;

/**
 * Created by hanks on 2017/6/2. Copyright (C) 2017 Hanks
 */

public class WebViewActivity extends BaseActivity {

    private EditText etUrl;
    private String url;
    private int color;
    private LuaWebView mWebView;
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
        mWebView = (LuaWebView) findViewById(R.id.webview);
        ivRefresh = findViewById(R.id.iv_refresh);


        url = getIntent().getStringExtra("url");
        color = getIntent().getIntExtra("color", 0);
        if (color == Color.TRANSPARENT) {
            setLightStatusBar();
        }else {
            setStatusBarColor(color);
            layout_toolbar.setBackgroundColor(color);
        }
        etUrl.setText(url);
        loading.setVisibility(View.VISIBLE);
        mWebView.loadUrl(url);
        mWebView.setWebViewClientListener(new LuaWebView.WebViewClientListener() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                return true;
            }

            @Override
            public boolean shouldOverrideKeyEvent(WebView view, KeyEvent event) {
                return false;
            }

            @Override
            public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {
                return null;
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                loading.setVisibility(View.GONE);
            }

            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {

            }

            @Override
            public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
                loading.setVisibility(View.GONE);
            }
        });

        ivRefresh.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mWebView.loadUrl(url);
            }
        });
    }
}
