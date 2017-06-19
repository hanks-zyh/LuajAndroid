package pub.hanks.sample;

import android.content.Intent;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import androlua.LuaActivity;
import androlua.LuaManager;
import androlua.common.LuaConstants;
import androlua.common.LuaFileUtils;
import androlua.common.LuaSp;

public class SplashActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                launchMain();
            }
        }, 1000);
        initFiles();
    }

    public static final String FILE_SP = "pub_hanks_sample";

    private void initFiles() {
        if (LuaSp.getInstance(FILE_SP).get(LuaConstants.KEY_VERSION, 0) >= BuildConfig.VERSION_CODE) {
            return;
        }
        new Thread() {
            @Override
            public void run() {
                super.run();
                LuaFileUtils.copyAssetsFlies("lua", LuaManager.getInstance().getLuaDir());
                LuaSp.getInstance(FILE_SP).save(LuaConstants.KEY_VERSION, BuildConfig.VERSION_CODE);
            }
        }.start();
    }

    public void launchMain() {
        Intent intent = new Intent(this, LuaActivity.class);
        intent.putExtra("luaPath",LuaManager.getInstance().getLuaDir() + "/main.lua");
        startActivity(intent);
        finish();
    }
}
