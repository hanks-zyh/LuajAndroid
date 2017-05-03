package pub.hanks.luaj_android;

import org.luaj.vm2.Globals;
import org.luaj.vm2.LuaValue;
import org.luaj.vm2.lib.ResourceFinder;
import org.luaj.vm2.lib.jse.CoerceJavaToLua;
import org.luaj.vm2.lib.jse.JsePlatform;

/**
 * Created by hanks on 2017/5/3. Copyright (C) 2017 Hanks
 */

public class Luaj {

    private static Luaj instance;
    private final Globals globals;

    private Luaj(ResourceFinder resourceFinder) {
        this.globals = JsePlatform.standardGlobals();
        this.globals.finder = resourceFinder;
    }

    public static Luaj getInstance(ResourceFinder resourceFinder) {
        if (instance == null) {
            synchronized (Luaj.class) {
                if (instance == null) {
                    instance = new Luaj(resourceFinder);
                }
            }
        }
        return instance;
    }

    public Globals getGlobals() {
        return globals;
    }

    public LuaValue loadfile(String luaFile){
      return  getGlobals().loadfile(luaFile);
    }

    public void callLua(String functionName, Object... args) {
        LuaValue f = getGlobals().get(functionName);
        if (!f.isnil()) {
            try {
                if (args.length == 0) {
                    f.call();
                } else {
                    f.call(CoerceJavaToLua.coerce(args));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
