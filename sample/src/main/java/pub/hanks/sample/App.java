package pub.hanks.sample;

import android.app.Application;

import androlua.LuaManager;

/**
 * Created by hanks on 2017/5/16. Copyright (C) 2017 Hanks
 */

public class App extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        LuaManager.getInstance().init(this);
    }
}
