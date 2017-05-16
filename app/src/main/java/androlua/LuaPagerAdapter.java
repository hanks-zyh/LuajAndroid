package androlua;

import android.support.v4.view.PagerAdapter;
import android.view.View;
import android.view.ViewGroup;

/**
 * adapter for viewpager
 * Created by hanks on 2017/5/13.
 */

public class LuaPagerAdapter extends PagerAdapter {
    private AdapterCreator adapter;

    public LuaPagerAdapter(AdapterCreator adapter) {
        this.adapter = adapter;
    }

    @Override
    public int getCount() {
        return (int) adapter.getCount();
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == object;
    }

    @Override
    public Object instantiateItem(ViewGroup container, int position) {
        View view = adapter.instantiateItem(container, position);
        container.addView(view);
        return view;
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((View) object);
    }

    public interface AdapterCreator {
        long getCount();

        View instantiateItem(ViewGroup container, int position);
    }

}
