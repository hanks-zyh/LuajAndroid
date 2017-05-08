package pub.hanks.luaj.net;

import org.luaj.vm2.LuaTable;
import org.luaj.vm2.LuaValue;
import org.luaj.vm2.Varargs;

import java.io.IOException;
import java.util.concurrent.TimeUnit;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.FormBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class Http {

    private static Http instance;
    private final OkHttpClient client;

    private Http() {
        client = new OkHttpClient.Builder()
                .connectTimeout(30, TimeUnit.SECONDS)
                .readTimeout(30, TimeUnit.SECONDS)
                .writeTimeout(30, TimeUnit.SECONDS)
                .build();
    }

    public static Http getInstance() {
        if (instance == null) {
            synchronized (Http.class) {
                if (instance == null) {
                    instance = new Http();
                }
            }
        }
        return instance;
    }

    public void post(String url, LuaTable params, final LuaValue luaValue) {
        FormBody.Builder bodyBuilder = new FormBody.Builder();
        if (params != null && !params.isnil()) {
            LuaValue k = LuaValue.NIL;
            while (true) {
                Varargs n = params.next(k);
                if ((k = n.arg1()).isnil())
                    break;
                LuaValue v = n.arg(2);
                bodyBuilder.addEncoded(k.tojstring(),v.tojstring());
            }
        }

        RequestBody body = bodyBuilder.build();
        Request.Builder builder = new Request.Builder().post(body).url(url);
        getInstance().client
                .newCall(builder.build())
                .enqueue(new Callback() {
                    @Override
                    public void onFailure(Call call, IOException e) {
                        luaValue.get("onFailure").call(LuaValue.userdataOf(e));
                    }

                    @Override
                    public void onResponse(Call call, Response response) throws IOException {
                        luaValue.get("onResponse").call(LuaValue.userdataOf(response.body().string()));
                    }
                });
    }

    public void get(String url, final LuaValue luaValue) {
        Request.Builder builder = new Request.Builder().get().url(url);
        getInstance().client
                .newCall(builder.build())
                .enqueue(new Callback() {
                    @Override
                    public void onFailure(Call call, IOException e) {
                        luaValue.get("onFailure").call(LuaValue.userdataOf(e));
                    }

                    @Override
                    public void onResponse(Call call, Response response) throws IOException {
                        luaValue.get("onResponse").call(LuaValue.userdataOf(response.body().string()));
                    }
                });
    }


}
