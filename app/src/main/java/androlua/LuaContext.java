package androlua;

import android.content.Context;

import com.luajava.LuaState;

import java.util.ArrayList;


public interface LuaContext {


    String getLuaDir();

    String getLuaExtDir();

    String getLuaLpath();

    String getLuaCpath();

    Context getContext();

    ArrayList<ClassLoader> getClassLoaders();

    LuaState getLuaState();

    Object doFile(String path, Object... arg);

    void call(String func, Object... args);

    void set(String name, Object value);

    void toast(String msg);
}
