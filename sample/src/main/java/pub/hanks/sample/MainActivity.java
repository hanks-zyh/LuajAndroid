package pub.hanks.sample;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;

import androlua.LuaActivity;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        startActivity(new Intent(this, LuaActivity.class));
        finish();
//        setContentView(R.layout.activity_main);
    }

    public void loadLua(View view){
        startActivity(new Intent(this, LuaActivity.class));
    }
}
