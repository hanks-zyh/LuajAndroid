package androlua;

import android.app.Application;
import android.content.Context;
import android.widget.Toast;

import com.luajava.LuaState;

import java.util.ArrayList;
import java.util.HashMap;

import common.FileUtils;

public class LuaApplication extends Application implements LuaContext {

    public static LuaApplication instance;
    private static HashMap<String, Object> data = new HashMap<>();
    private String localDir;
    private String odexDir;
    private String libDir;
    private String luaMdDir;
    private String luaCpath;
    private String luaLpath;
    private String luaExtDir;


    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;
        // 注册crashHandler
        CrashHandler crashHandler = CrashHandler.getInstance();
        crashHandler.init(getApplicationContext());

        //初始化AndroLua工作目录
        luaExtDir = FileUtils.getAndroLuaDir();
        //定义文件夹
        localDir = getFilesDir().getAbsolutePath();
        odexDir = getDir("odex", Context.MODE_PRIVATE).getAbsolutePath();
        libDir = getDir("lib", Context.MODE_PRIVATE).getAbsolutePath();
        luaMdDir = getDir("lua", Context.MODE_PRIVATE).getAbsolutePath();
        luaCpath = getApplicationInfo().nativeLibraryDir + "/lib?.so" + ";" + libDir + "/lib?.so";
        luaLpath = luaMdDir + "/?.lua;" + luaMdDir + "/lua/?.lua;" + luaMdDir + "/?/init.lua;" + luaExtDir + "/?.lua;";
    }

    @Override
    public String getLuaDir() {
        return localDir;
    }

    @Override
    public void call(String name, Object[] args) {
    }

    @Override
    public void set(String name, Object object) {
        data.put(name, object);
    }

    public Object get(String name) {
        return data.get(name);
    }

    public String getLibDir() {
        return libDir;
    }

    public String getOdexDir() {
        return odexDir;
    }

    public String getLocalDir() {
        return localDir;
    }

    public String getMdDir() {
        return luaMdDir;
    }

    @Override
    public ArrayList<ClassLoader> getClassLoaders() {
        return null;
    }
    @Override
    public String getLuaExtDir() {
        return luaExtDir;
    }

    @Override
    public String getLuaLpath() {
        return luaLpath;
    }

    @Override
    public String getLuaCpath() {
        return luaCpath;
    }

    @Override
    public Context getContext() {
        return this;
    }

    @Override
    public LuaState getLuaState() {
        return null;
    }

    @Override
    public Object doFile(String path, Object[] arg) {
        return null;
    }

    @Override
    public void toast(String msg) {
        Toast.makeText(this, msg, Toast.LENGTH_SHORT).show();
    }

}



