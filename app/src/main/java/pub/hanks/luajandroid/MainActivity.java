package pub.hanks.luajandroid;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;

import org.luaj.vm2.LuaValue;
import org.luaj.vm2.lib.jse.CoerceJavaToLua;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        LuajView view = new LuajView(this);
        setContentView(view);
        try {
            LuaValue activity = CoerceJavaToLua.coerce(this);
            LuaValue viewobj = CoerceJavaToLua.coerce(view);
            view.globals.loadfile("test.lua").call(activity, viewobj);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
