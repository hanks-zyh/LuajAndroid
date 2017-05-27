package androlua;

import android.content.Context;
import android.graphics.Bitmap;
import android.util.AttributeSet;
import android.view.KeyEvent;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

/**
 * Created by hanks on 2017/5/27.
 */

public class LuaWebView extends WebView {
    public LuaWebView(Context context) {
        this(context, null);
    }

    public LuaWebView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public LuaWebView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        WebSettings setting = getSettings();
        setting.setSupportZoom(false);
        setting.setBuiltInZoomControls(false);
        setting.setDefaultFontSize(16);
        setting.setUseWideViewPort(true);
        setting.setLoadWithOverviewMode(true);
        setting.setCacheMode(WebSettings.LOAD_CACHE_ELSE_NETWORK);
        setting.setAllowFileAccess(true);
        setting.setLoadsImagesAutomatically(true);
        setting.setJavaScriptEnabled(true);
        setWebChromeClient(new LuaWebChromeClient());
        setWebViewClient(new LuaWebViewClient());
    }

    private WebChromeClientListener webChromeClientListener;
    private WebViewClientListener webViewClientListener;

    public void setWebChromeClientListener(WebChromeClientListener webChromeClientListener) {
        this.webChromeClientListener = webChromeClientListener;
    }

    public void setWebViewClientListener(WebViewClientListener webViewClientListener) {
        this.webViewClientListener = webViewClientListener;
    }

    public interface WebViewClientListener {
        boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request);

        boolean shouldOverrideKeyEvent(WebView view, KeyEvent event);

        WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request);

        void onPageFinished(WebView view, String url);

        void onPageStarted(WebView view, String url, Bitmap favicon);

        void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error);

    }

    public interface WebChromeClientListener {

        void onProgressChanged(WebView view, int newProgress);

        void onReceivedTitle(WebView view, String title);

        void onReceivedIcon(WebView view, Bitmap icon);

        void onReceivedTouchIconUrl(WebView view, String url, boolean precomposed);
    }

    public class LuaWebViewClient extends WebViewClient {
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
            if (webViewClientListener != null) {
                return webViewClientListener.shouldOverrideUrlLoading(view, request);
            }
            return super.shouldOverrideUrlLoading(view, request);
        }

        @Override
        public boolean shouldOverrideKeyEvent(WebView view, KeyEvent event) {
            return super.shouldOverrideKeyEvent(view, event);
        }

        @Override
        public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {
            if (webViewClientListener != null) {
                return webViewClientListener.shouldInterceptRequest(view, request);
            }
            return super.shouldInterceptRequest(view, request);
        }

        @Override
        public void onPageFinished(WebView view, String url) {
            if (webViewClientListener != null) {
               webViewClientListener.onPageFinished(view, url);
            }
            super.onPageFinished(view, url);
        }

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            if (webViewClientListener != null) {
                webViewClientListener.onPageStarted(view, url, favicon);
            }
            super.onPageStarted(view, url, favicon);
        }

        @Override
        public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
            if (webViewClientListener != null) {
                webViewClientListener.onReceivedError(view, request, error);
            }
            super.onReceivedError(view, request, error);
        }
    }

    public class LuaWebChromeClient extends WebChromeClient {

        @Override
        public void onProgressChanged(WebView view, int newProgress) {
            if (webChromeClientListener != null) {
                webChromeClientListener.onProgressChanged(view, newProgress);
            }
            super.onProgressChanged(view, newProgress);
        }

        @Override
        public void onReceivedTitle(WebView view, String title) {
            if (webChromeClientListener != null) {
                webChromeClientListener.onReceivedTitle(view, title);
            }
            super.onReceivedTitle(view, title);
        }

        @Override
        public void onReceivedIcon(WebView view, Bitmap icon) {
            if (webChromeClientListener != null) {
                webChromeClientListener.onReceivedIcon(view, icon);
            }
            super.onReceivedIcon(view, icon);
        }

        @Override
        public void onReceivedTouchIconUrl(WebView view, String url, boolean precomposed) {
            if (webChromeClientListener != null) {
                webChromeClientListener.onReceivedTouchIconUrl(view, url, precomposed);
            }
            super.onReceivedTouchIconUrl(view, url, precomposed);
        }
    }
}
