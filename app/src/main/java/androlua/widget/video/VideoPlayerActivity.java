package androlua.widget.video;

import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.WindowManager;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import org.json.JSONException;
import org.json.JSONObject;

import androlua.base.BaseActivity;

/**
 * Created by hanks on 2017/6/2. Copyright (C) 2017 Hanks
 */

public class VideoPlayerActivity extends BaseActivity {

    private WebView mWebView;
    private static String data = "<!DOCTYPE html>\n" +
            "<html>\n" +
            "<head>\n" +
            "\t<title></title>\n" +
            "\t<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\n" +
            "\t<meta name=\"viewport\" content=\"width=device-width; initial-scale=1; minimum-scale=1; maximum-scale=2\">\n" +
            "\t<meta content=\"width=device-width,user-scalable=no\" name=\"viewport\">\n" +
            "</head>\n" +
            "<body>\n" +
            "\t <video id=\"lua_video\" webkit-playsinline=\"true\" playsinline=\"true\" style=\"width: 100%; height: 100%; display: block; position: relative;\" poster=\"{poster}\" src=\"{url}\"></video>\n" +
            "</body>\n" +
            "</html>";

    public static void start(Context context, String json) {
        Intent starter = new Intent(context, VideoPlayerActivity.class);
        starter.putExtra("json", json);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mWebView = new WebView(this);
        setContentView(mWebView);
        initWebView();
        try {
            String extra = getIntent().getStringExtra("json");
            JSONObject json = new JSONObject(extra);
            String url = json.getString("url");
            String poster = json.getString("poster");
            data = data.replace("{poster}",poster).replace("{url}", url);
            mWebView.loadData(data,"text/html","utf-8");
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
        settings.setCacheMode(WebSettings.LOAD_DEFAULT);
        InsideWebViewClient mInsideWebViewClient = new InsideWebViewClient();
        mWebView.setWebChromeClient(new WebChromeClient());
        mWebView.setWebViewClient(mInsideWebViewClient);
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

}
