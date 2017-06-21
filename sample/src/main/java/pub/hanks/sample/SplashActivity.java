package pub.hanks.sample;

import android.content.Intent;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.view.animation.LinearInterpolator;

import androlua.LuaActivity;
import androlua.LuaManager;
import androlua.base.BaseActivity;
import androlua.common.LuaConstants;
import androlua.common.LuaFileUtils;
import androlua.common.LuaSp;

public class SplashActivity extends BaseActivity {
//    @Override
//    public void onWindowFocusChanged(boolean hasFocus) {
//        super.onWindowFocusChanged(hasFocus);
//        if (hasFocus) {
//            getWindow().getDecorView().setSystemUiVisibility(
//                    View.SYSTEM_UI_FLAG_LAYOUT_STABLE
//                            | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
//                            | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
//                            | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
//                            | View.SYSTEM_UI_FLAG_FULLSCREEN
//                            | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
//        }
//    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setLightStatusBar();
        setContentView(R.layout.activity_splash);
        final View icon = findViewById(R.id.icon);
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                launchMain();
            }
        }, 4000);
        initFiles();
        icon.postDelayed(new Runnable() {
            @Override
            public void run() {
                icon.animate().translationY(0).setDuration(3550).setInterpolator(new LinearInterpolator()).start();
            }
        },200);

    }

    public static final String FILE_SP = "pub_hanks_sample";

    private void initFiles() {
        if (LuaSp.getInstance(FILE_SP).get(LuaConstants.KEY_VERSION, 0) >= BuildConfig.VERSION_CODE) {
//            return;
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
        overridePendingTransition(0,android.R.anim.fade_out);
        finish();
    }
}
