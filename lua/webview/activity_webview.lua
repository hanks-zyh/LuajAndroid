require("import")
import("android.widget.*")
import("android.content.*")
import("android.webkit.WebView")
import("android.webkit.WebViewClient")

local layout = {
  WebView,
  id='webview',
}

function onCreate (savedInstanceState)
  activity.setContentView(loadlayout(layout))
  webview.loadUrl('http://juejin.im')
  webview.setWebViewClient(WebViewClient())
end