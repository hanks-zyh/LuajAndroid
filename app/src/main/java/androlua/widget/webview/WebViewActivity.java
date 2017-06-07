package androlua.widget.webview;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.net.http.SslError;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.View;
import android.webkit.SslErrorHandler;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.EditText;

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
    private View iv_finish;
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
        iv_finish = findViewById(R.id.iv_finish);
        layout_toolbar = findViewById(R.id.layout_toolbar);
        mWebView = (WebView) findViewById(R.id.webview);
        ivRefresh = findViewById(R.id.iv_refresh);

        WebSettings settings = mWebView.getSettings();
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
        loading.setVisibility(View.VISIBLE);
        iv_finish.setVisibility(View.GONE);
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
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                loading.setVisibility(View.GONE);
                iv_finish.setVisibility(View.VISIBLE);
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

    @Override
    public void onBackPressed() {
        if (mWebView.canGoBack()){
            return;
        }
        super.onBackPressed();

    }
}
