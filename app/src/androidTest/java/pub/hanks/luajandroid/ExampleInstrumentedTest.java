package pub.hanks.luajandroid;

import android.content.Context;
import android.content.res.ColorStateList;
import android.os.Build;
import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.design.widget.TabLayout;
import android.support.graphics.drawable.VectorDrawableCompat;
import android.support.test.InstrumentationRegistry;
import android.support.test.runner.AndroidJUnit4;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.GridLayout;
import android.widget.GridView;
import android.widget.HorizontalScrollView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import org.junit.Test;
import org.junit.runner.RunWith;

import androlua.LuaBitmap;
import androlua.LuaDrawable;

import static org.junit.Assert.assertEquals;

/**
 * Instrumentation test, which will execute on an Android device.
 *
 * @see <a href="http://d.android.com/tools/testing">Testing documentation</a>
 */
@RunWith(AndroidJUnit4.class)
public class ExampleInstrumentedTest {
    @Test
    public void useAppContext() throws Exception {
        // Context of the app under test.
        Context appContext = InstrumentationRegistry.getTargetContext();
        LinearLayout linearLayout = new LinearLayout(appContext);
        linearLayout.setOrientation(LinearLayout.VERTICAL);
        assertEquals("pub.hanks.luajandroid", appContext.getPackageName());
        linearLayout.animate().scaleX(2).scaleY(2).translationX(100).setDuration(3000).start();
        VectorDrawableCompat.createFromPath("");

        GridView gridLayout = new GridView(appContext);
        gridLayout.setNumColumns(5);
        gridLayout.setStretchMode(1);
        gridLayout.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

            }
        });
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            gridLayout.setElevation(20);
        }

        HorizontalScrollView horizontalScrollView = new HorizontalScrollView(appContext);
        horizontalScrollView.setHorizontalScrollBarEnabled(false);
        ListView listView = new ListView(appContext);
        listView.setDividerHeight(0);
        TextView textView = new TextView(appContext);
        textView.setMaxLines(1);
        textView.setSingleLine(true);
        TabLayout tabLayout = new TabLayout(appContext);
        tabLayout.setVisibility(View.VISIBLE);
        WebView webView = new WebView(appContext);
        webView.setWebChromeClient(new WebChromeClient());

        final BottomNavigationView bottomView = new BottomNavigationView(appContext);
        ColorStateList textColor = ColorStateList.valueOf(0xFFFF0000);
        bottomView.setItemTextColor(textColor);
        bottomView.getMenu().add("");
        bottomView.getMenu().add("");
        bottomView.getMenu().add("");
        bottomView.setOnNavigationItemSelectedListener(new BottomNavigationView.OnNavigationItemSelectedListener() {
            @Override
            public boolean onNavigationItemSelected(@NonNull MenuItem item) {
                item.getTitle();
                item.setChecked(true);
                return true;
            }
        });

    }

    class MyAdapter extends BaseAdapter {

        @Override
        public int getCount() {
            return 0;
        }

        @Override
        public Object getItem(int position) {
            return null;
        }

        @Override
        public long getItemId(int position) {
            return 0;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            return null;
        }
    }
}
