package pub.hanks.luaj_android;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;

import org.luaj.vm2.LuaValue;
import org.luaj.vm2.lib.ResourceFinder;
import org.luaj.vm2.lib.jse.CoerceJavaToLua;

import java.io.InputStream;

/**
 * Created by hanks on 2017/5/3. Copyright (C) 2017 Hanks
 */

public class LuajActivity extends AppCompatActivity implements ResourceFinder {

    private Luaj luaj;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        try {
            luaj = Luaj.getInstance(this);
            LuaValue activity = CoerceJavaToLua.coerce(this);
            luaj.loadfile("main.lua").call(activity);
            luaj.callLua("onCreate", savedInstanceState);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void onStart() {
        super.onStart();
        luaj.callLua("onStart");
    }

    @Override
    protected void onResume() {
        super.onResume();
        luaj.callLua("onResume");
    }

    @Override
    protected void onStop() {
        super.onStop();
        luaj.callLua("onStop");
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        luaj.callLua("onDestroy");
    }

    // Implement a finder that loads from the assets directory.
    public InputStream findResource(String name) {
        try {
            return getAssets().open(name);
        } catch (java.io.IOException ioe) {
            return null;
        }
    }
}
