package androlua.widget.video;

import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.WindowManager;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import org.json.JSONException;
import org.json.JSONObject;

import androlua.base.BaseActivity;
import pub.hanks.luajandroid.R;

/**
 * Created by hanks on 2017/6/2. Copyright (C) 2017 Hanks
 */

public class VideoPlayerActivity extends BaseActivity {

    private String data = "<html><head><title></title><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><meta content=\"width=device-width,user-scalable=no\" name=\"viewport\"><style>      *{margin:0;padding:0;}      body { background-color: #000000; display: flex; align-items: center;}video { width: 100%; display: block; background: transparent url('{poster}') 50% 50% / cover no-repeat ; }</style></head><body><video controls=\"controls\"  preload=\"none\"  id=\"lua_video\" webkit-playsinline=\"true\" playsinline=\"true\"  poster=\"1.jpg\" src=\"{url}\"></video></body></html>";
    private WebView mWebView;

    public static void start(Context context, String json) {
        Intent starter = new Intent(context, VideoPlayerActivity.class);
        starter.putExtra("json", json);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_video);
        mWebView = (WebView) findViewById(R.id.webview);
        initWebView();
        try {
            String extra = getIntent().getStringExtra("json");
            JSONObject json = new JSONObject(extra);
            String url = json.getString("url");
            String poster = json.getString("poster");
            data = data.replace("{poster}", poster).replace("{url}", url);
            Log.e("xxxxxxxx", "onCreate: " + data);
            mWebView.loadData(data, "text/html", "utf-8");
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private void initWebView() {
        WebSettings settings = mWebView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setJavaScriptCanOpenWindowsAutomatically(true);
        settings.setPluginState(WebSettings.PluginState.ON);
        settings.setAllowFileAccess(true);
        settings.setLoadWithOverviewMode(true);
        settings.setUseWideViewPort(true);
        settings.setCacheMode(WebSettings.LOAD_NO_CACHE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            mWebView.setWebContentsDebuggingEnabled(true);
        }
        InsideWebViewClient mInsideWebViewClient = new InsideWebViewClient();
        mWebView.setWebChromeClient(new WebChromeClient());
        mWebView.setWebViewClient(mInsideWebViewClient);
    }

    @Override
    public void onConfigurationChanged(Configuration config) {
        super.onConfigurationChanged(config);
        switch (config.orientation) {
            case Configuration.ORIENTATION_LANDSCAPE:
                getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN);
                getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
                break;
            case Configuration.ORIENTATION_PORTRAIT:
                getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
                getWindow().addFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN);
                break;
        }
    }

    @Override
    public void onPause() {
        super.onPause();
        mWebView.onPause();
    }

    @Override
    public void onResume() {
        super.onResume();
        mWebView.onResume();
    }

    @Override
    public void onBackPressed() {
        if (mWebView.canGoBack()) {
            mWebView.goBack();
            return;
        }
        super.onBackPressed();
    }

    @Override
    public void onDestroy() {
        mWebView.destroy();
        super.onDestroy();
    }

    private class InsideWebViewClient extends WebViewClient {

        public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
            return true;
        }

        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
        }

    }

}
