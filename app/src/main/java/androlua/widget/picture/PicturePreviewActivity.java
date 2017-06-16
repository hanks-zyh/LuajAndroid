package androlua.widget.picture;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

import androlua.adapter.LuaFragmentPageAdapter;
import androlua.base.BaseActivity;
import androlua.base.BaseFragment;
import pub.hanks.luajandroid.R;

/**
 * Created by hanks on 2017/6/2. Copyright (C) 2017 Hanks
 */

public class PicturePreviewActivity extends BaseActivity {

    private LuaFragmentPageAdapter adapter;
    private ArrayList<String> uris = new ArrayList<>();
    private ArrayList<Fragment> fragments = new ArrayList<>();
    private int currentIndex;
    private ViewPager viewPager;
    private TextView tv_count;

    public static void start(Context context, String json) {
        Intent starter = new Intent(context, PicturePreviewActivity.class);
        starter.putExtra("json", json);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_picture);
        tv_count = (TextView) findViewById(R.id.tv_count);
        setStatusBarColor(Color.TRANSPARENT);
        getWindow().getDecorView().setBackgroundColor(Color.TRANSPARENT);
        viewPager = (ViewPager) findViewById(R.id.viewpager);
        adapter = new LuaFragmentPageAdapter(getSupportFragmentManager(), new LuaFragmentPageAdapter.AdapterCreator() {
            @Override
            public long getCount() {
                return fragments.size();
            }

            @Override
            public Fragment getItem(int position) {
                return fragments.get(position);
            }

            @Override
            public String getPageTitle(int position) {
                return (position + 1) + "/" + fragments.size();
            }
        });
        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                tv_count.setText(adapter.getPageTitle(position));
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
        viewPager.setAdapter(adapter);
        getData();
    }

    private void getData() {
        // { "uris":[], "currentIndex":0 }
        String str = getIntent().getStringExtra("json");
        try {
            JSONObject json = new JSONObject(str);
            JSONArray list = json.getJSONArray("uris");
            for (int i = 0; i < list.length(); i++) {
                uris.add(list.getString(i));
            }
            currentIndex = json.getInt("currentIndex");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        tv_count.setText(String.format("%s/%s",1,uris.size()));
        for (String uri : uris) {
            fragments.add(PicturePreviewFragment.newInstance(uri));
        }
        adapter.notifyDataSetChanged();
        viewPager.setCurrentItem(currentIndex, false);
    }

    public static class PicturePreviewFragment extends BaseFragment {
        public static PicturePreviewFragment newInstance(String uri) {
            Bundle args = new Bundle();
            args.putString("uri", uri);
            PicturePreviewFragment fragment = new PicturePreviewFragment();
            fragment.setArguments(args);
            return fragment;
        }

        @Nullable
        @Override
        public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
            View view = new ImageView(getContext());
            return view;

        }

        @Override
        public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
            super.onViewCreated(view, savedInstanceState);
            String uri = getArguments().getString("uri", "");
            ImageView imageView = (ImageView) view;
            Glide.with(imageView.getContext())
                    .load(uri)
                    .diskCacheStrategy(DiskCacheStrategy.SOURCE)
                    .placeholder(R.drawable.bg_circle)
                    .error(R.drawable.bg_circle)
                    .crossFade()
                    .into(imageView);
        }
    }


}
