package pub.hanks.luajandroid;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.drawable.RippleDrawable;
import android.os.Build;
import android.support.annotation.NonNull;
import android.support.design.widget.AppBarLayout;
import android.support.design.widget.BottomNavigationView;
import android.support.design.widget.CollapsingToolbarLayout;
import android.support.design.widget.CoordinatorLayout;
import android.support.design.widget.TabLayout;
import android.support.graphics.drawable.VectorDrawableCompat;
import android.support.test.InstrumentationRegistry;
import android.support.test.runner.AndroidJUnit4;
import android.support.v7.widget.AppCompatCheckBox;
import android.support.v7.widget.GridLayoutManager;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.HorizontalScrollView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import org.junit.Test;
import org.junit.runner.RunWith;

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
        gridLayout.setStretchMode(GridView.STRETCH_SPACING);
        gridLayout.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

            }
        });
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            gridLayout.setElevation(20);
        }
        gridLayout.postDelayed(new Runnable() {
            @Override
            public void run() {

            }
        }, 1000);


        new GridLayoutManager(appContext, 3);

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
        //webView.addJavascriptInterface(this, "");

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


        CollapsingToolbarLayout collapsingToolbarLayout = new CollapsingToolbarLayout(appContext);
        CoordinatorLayout.LayoutParams params = (CoordinatorLayout.LayoutParams) collapsingToolbarLayout.getLayoutParams();
        params.setBehavior(new AppBarLayout.ScrollingViewBehavior());

        // 动态代理




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
