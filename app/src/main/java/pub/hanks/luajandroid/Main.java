package pub.hanks.luajandroid;

import androlua.LuaActivity;

/**
 * Created by hanks on 2017/5/10. Copyright (C) 2017 Hanks
 */

public class Main extends LuaActivity {
    @Override
    public String getLuaDir() {
        return getLocalDir();
    }
}
