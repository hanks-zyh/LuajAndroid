package androlua;

import android.content.Context;

import luajava.LuaState;


public interface LuaContext {

    void call(String func, Object... args);

    void set(String name, Object value);

    String getLuaDir();

    String getLuaExtDir();

    String getLuaLpath();

    String getLuaCpath();

    Context getContext();

    LuaState getLuaState();

    Object doFile(String path, Object... arg);

    void toast(String msg);
}
