package androlua;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.support.v7.app.AppCompatActivity;
import android.view.ContextMenu;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.luajava.JavaFunction;
import com.luajava.LuaException;
import com.luajava.LuaObject;
import com.luajava.LuaState;
import com.luajava.LuaStateFactory;

import java.io.File;
import java.io.Serializable;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.HashMap;

import common.FileUtils;
import common.Logs;
import dalvik.system.DexClassLoader;

public class LuaActivity extends AppCompatActivity implements LuaBroadcastReceiver.OnReceiveListener, LuaContext {

    public String luaDir;
    public Handler handler;
    public TextView status;
    public String luaCpath;
    private LuaState L;
    private String luaPath;
    private ScrollView errorLayout;
    private boolean isSetViewed;
    private long lastShow;
    private Menu optionsMenu;
    private LuaObject mOnKeyDown;
    private LuaObject mOnKeyUp;
    private LuaObject mOnKeyLongPress;
    private LuaObject mOnTouchEvent;
    private ArrayList<LuaThread> threadList = new ArrayList<LuaThread>();
    private String localDir;
    private String odexDir;
    private String libDir;
    private String luaExtDir;
    private LuaBroadcastReceiver mReceiver;
    private String luaLpath;
    private String luaMdDir;
    private LuaDexLoader luaDexLoader;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        handler = new MainHandler(this);

        // 用于出错时显示
        initErrorLayout();

        initLua(savedInstanceState);
    }

    private void initLua(Bundle savedInstanceState) {
        LuaApplication app = LuaApplication.instance;
        localDir = app.getLocalDir();
        odexDir = app.getOdexDir();
        libDir = app.getLibDir();
        luaMdDir = app.getMdDir();
        luaCpath = app.getLuaCpath();
        luaDir = localDir;
        luaLpath = app.getLuaLpath();
        luaExtDir = app.getLuaExtDir();
        try {
            Object[] arg = LuaUtil.IntentHelper.getArgs(getIntent());
            luaPath = LuaUtil.IntentHelper.getLuaPath(getIntent());
            initLuaEnv();
            luaDexLoader = new LuaDexLoader(this);
            luaDexLoader.loadLibs();
            doFile(luaPath, arg);
            runFunc("onCreate", savedInstanceState);
        } catch (Exception e) {
            sendMsg(e.getMessage());
            setContentView(this.errorLayout);
        }
    }

    private void initErrorLayout() {
        errorLayout = new ScrollView(this);
        errorLayout.setFillViewport(true);
        errorLayout.setBackgroundColor(Color.WHITE);

        status = new TextView(this);
        status.setTextColor(Color.BLACK);
        status.setText("");
        status.setTextIsSelectable(true);

        errorLayout.addView(status, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
    }

    @Override
    public ArrayList<ClassLoader> getClassLoaders() {
        return luaDexLoader.getClassLoaders();
    }

    public HashMap<String, String> getLibrarys() {
        return luaDexLoader.getLibrarys();
    }

    public void loadResources(String path) {
        luaDexLoader.loadResources(path);
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
        return L;
    }

    public View getDecorView() {
        return getWindow().getDecorView();
    }

    public String getLocalDir() {
        return localDir;
    }

    @Override
    public String getLuaExtDir() {
        return luaExtDir;
    }

    public String getLuaExtDir(String name) {
        File dir = new File(luaExtDir + "/" + name);
        if (!dir.exists())
            if (!dir.mkdirs())
                return null;
        return dir.getAbsolutePath();
    }

    @Override
    public String getLuaDir() {
        return luaDir;
    }

    public String getLuaDir(String name) {
        File dir = new File(luaDir + "/" + name);
        if (!dir.exists())
            if (!dir.mkdirs())
                return null;
        return dir.getAbsolutePath();
    }

    public DexClassLoader loadDex(String path) throws LuaException {
        if (path.charAt(0) != '/')
            path = luaDir + "/" + path;
        if (!new File(path).exists())
            if (new File(path + ".dex").exists())
                path += ".dex";
            else if (new File(path + ".jar").exists())
                path += ".jar";
            else
                throw new LuaException(path + " not found");
        return new DexClassLoader(path, odexDir, getApplicationInfo().nativeLibraryDir, getClassLoader());
    }

    public Object loadLib(String name) throws LuaException {
        int i = name.indexOf(".");
        String fn = name;
        if (i > 0)
            fn = name.substring(0, i);
        File f = new File(libDir + "/lib" + fn + ".so");
        if (!f.exists()) {
            f = new File(luaDir + "/lib" + fn + ".so");
            if (!f.exists())
                throw new LuaException("can not find lib " + name);
            LuaUtil.copyFile(luaDir + "/lib" + fn + ".so", libDir + "/lib" + fn + ".so");
        }
        LuaObject require = L.getLuaObject("require");
        return require.call(name);
    }

    public Intent registerReceiver(LuaBroadcastReceiver receiver, IntentFilter filter) {
        return super.registerReceiver(receiver, filter);
    }

    public Intent registerReceiver(LuaBroadcastReceiver.OnReceiveListener ltr, IntentFilter filter) {
        LuaBroadcastReceiver receiver = new LuaBroadcastReceiver(ltr);
        return super.registerReceiver(receiver, filter);
    }

    public Intent registerReceiver(IntentFilter filter) {
        if (mReceiver != null)
            unregisterReceiver(mReceiver);
        mReceiver = new LuaBroadcastReceiver(this);
        return super.registerReceiver(mReceiver, filter);
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        runFunc("onReceive", context, intent);
    }

    @Override
    public void onContentChanged() {
        super.onContentChanged();
        isSetViewed = true;
    }

    @Override
    protected void onStart() {
        super.onStart();
        runFunc("onStart");
    }

    @Override
    protected void onResume() {
        super.onResume();
        runFunc("onResume");
    }

    @Override
    protected void onPause() {
        super.onPause();
        runFunc("onPause");
    }

    @Override
    protected void onStop() {
        super.onStop();
        runFunc("onStop");
    }

    @Override
    protected void onNewIntent(Intent intent) {
        runFunc("onNewIntent", intent);
        super.onNewIntent(intent);
    }

    @Override
    protected void onDestroy() {
        if (mReceiver != null)
            unregisterReceiver(mReceiver);

        for (LuaThread t : threadList) {
            if (t.isRun)
                t.quit();
        }
        runFunc("onDestroy");
        super.onDestroy();
        System.gc();
        L.gc(LuaState.LUA_GCCOLLECT, 1);
        //L.close();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        runFunc("onActivityResult", requestCode, resultCode, data);
        super.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (mOnKeyDown != null) {
            try {
                Object ret = mOnKeyDown.call(keyCode, event);
                if (ret != null && ret.getClass() == Boolean.class && (Boolean) ret)
                    return true;
            } catch (LuaException e) {
                sendMsg("onKeyDown " + e.getMessage());
            }
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        if (mOnKeyUp != null) {
            try {
                Object ret = mOnKeyUp.call(keyCode, event);
                if (ret != null && ret.getClass() == Boolean.class && (Boolean) ret)
                    return true;
            } catch (LuaException e) {
                sendMsg("onKeyUp " + e.getMessage());
            }
        }
        return super.onKeyUp(keyCode, event);
    }

    @Override
    public boolean onKeyLongPress(int keyCode, KeyEvent event) {
        if (mOnKeyLongPress != null) {
            try {
                Object ret = mOnKeyLongPress.call(keyCode, event);
                if (ret != null && ret.getClass() == Boolean.class && (Boolean) ret)
                    return true;
            } catch (LuaException e) {
                sendMsg("onKeyLongPress " + e.getMessage());
            }
        }
        return super.onKeyLongPress(keyCode, event);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (mOnTouchEvent != null) {
            try {
                Object ret = mOnTouchEvent.call(event);
                if (ret != null && ret.getClass() == Boolean.class && (Boolean) ret)
                    return true;
            } catch (LuaException e) {
                sendMsg("onTouchEvent " + e.getMessage());
            }
        }
        return super.onTouchEvent(event);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        optionsMenu = menu;
        runFunc("onCreateOptionsMenu", menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        Object ret = null;
        if (!item.hasSubMenu())
            ret = runFunc("onOptionsItemSelected", item);
        if (ret != null && ret.getClass() == Boolean.class && (Boolean) ret)
            return true;
        return super.onOptionsItemSelected(item);
    }

    public Menu getOptionsMenu() {
        return optionsMenu;
    }

    @Override
    public void onOptionsMenuClosed(Menu menu) {
        super.onOptionsMenuClosed(menu);
    }

    @Override
    public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo) {
        runFunc("onCreateContextMenu", menu, v, menuInfo);
        super.onCreateContextMenu(menu, v, menuInfo);
    }

    @Override
    public boolean onContextItemSelected(MenuItem item) {
        runFunc("onContextItemSelected", item);
        return super.onContextItemSelected(item);
    }

    public int getWidth() {
        return getResources().getDisplayMetrics().widthPixels;
    }

    public int getHeight() {
        return getResources().getDisplayMetrics().heightPixels;
    }

    public boolean bindService(int flag) {
        ServiceConnection conn = new ServiceConnection() {

            @Override
            public void onServiceConnected(ComponentName comp, IBinder binder) {
                runFunc("onServiceConnected", comp, ((LuaService.LuaBinder) binder).getService());
            }

            @Override
            public void onServiceDisconnected(ComponentName comp) {
                runFunc("onServiceDisconnected", comp);
            }
        };
        return bindService(conn, flag);
    }

    public boolean bindService(ServiceConnection conn, int flag) {
        Intent service = new Intent(this, LuaService.class);
        service.putExtra("luaDir", luaDir);
        service.putExtra("luaPath", luaPath);
        return super.bindService(service, conn, flag);
    }

    public ComponentName startService() {
        return startService(null, null);
    }

    public ComponentName startService(Object[] arg) {
        return startService(null, arg);
    }

    public ComponentName startService(String path) {
        return startService(path, null);
    }

    public ComponentName startService(String path, Object[] arg) {
        Intent intent = new Intent(this, LuaService.class);
        intent.putExtra("luaDir", luaDir);
        intent.putExtra("luaPath", luaPath);
        if (path != null) {
            if (path.charAt(0) != '/')
                intent.setData(Uri.parse("file://" + luaDir + "/" + path + ".lua"));
            else
                intent.setData(Uri.parse("file://" + path));
        }
        if (arg != null)
            intent.putExtra("arg", arg);

        return super.startService(intent);
    }

    public void newActivity(String path) {
        newActivity(1, path, null);
    }

    public void newActivity(String path, Object[] arg) {
        newActivity(1, path, arg);
    }

    public void newActivity(int req, String path) {
        newActivity(req, path, null);
    }

    public void newActivity(int req, String path, Object[] arg) {
        Intent intent = new Intent(this, LuaActivity.class);
        if (path.charAt(0) != '/')
            intent.setData(Uri.parse("file://" + luaDir + "/" + path + ".lua"));
        else
            intent.setData(Uri.parse("file://" + path));

        if (arg != null)
            intent.putExtra("arg", arg);
        startActivityForResult(intent, req);
        overridePendingTransition(android.R.anim.slide_in_left, android.R.anim.slide_out_right);
    }

    public void newActivity(String path, int in, int out) {
        newActivity(1, path, in, out, null);
    }

    public void newActivity(String path, int in, int out, Object[] arg) {
        newActivity(1, path, in, out, arg);
    }

    public void newActivity(int req, String path, int in, int out) {
        newActivity(req, path, in, out, null);
    }

    public void newActivity(int req, String path, int in, int out, Object[] arg) {
        Intent intent = new Intent(this, LuaActivity.class);
        if (path.charAt(0) != '/')
            intent.setData(Uri.parse("file://" + luaDir + "/" + path + ".lua"));
        else
            intent.setData(Uri.parse("file://" + path));

        if (arg != null)
            intent.putExtra("arg", arg);
        startActivityForResult(intent, req);
        overridePendingTransition(in, out);
    }
    //
    //    public LuaAsyncTask newTask(LuaObject func) throws LuaException {
    //        return newTask(func, null, null);
    //    }
    //
    //    public LuaAsyncTask newTask(LuaObject func, LuaObject callback) throws LuaException {
    //        return newTask(func, null, callback);
    //    }
    //
    //    public LuaAsyncTask newTask(LuaObject func, LuaObject update, LuaObject callback) throws LuaException {
    //        return new LuaAsyncTask(this, func, update, callback);
    //    }

    public LuaThread newThread(LuaObject func) throws LuaException {
        return newThread(func, null);
    }

    public LuaThread newThread(LuaObject func, Object[] arg) throws LuaException {
        LuaThread thread = new LuaThread(this, func, true, arg);
        threadList.add(thread);
        return thread;
    }
    //
    //    public LuaTimer newTimer(LuaObject func) throws LuaException {
    //        return newTimer(func, null);
    //    }
    //
    //    public LuaTimer newTimer(LuaObject func, Object[] arg) throws LuaException {
    //        return new LuaTimer(this, func, arg);
    //    }
    //
    //    public Bitmap loadBitmap(String path) throws IOException {
    //        return LuaBitmap.getBitmap(this, path);
    //    }

    public void setContentView(LuaObject layout) throws LuaException {
        setContentView(layout, null);
    }

    public void setContentView(LuaObject layout, LuaObject env) throws LuaException {
        LuaObject loadlayout = L.getLuaObject("loadlayout");
        View view = (View) loadlayout.call(layout, env);
        super.setContentView(view);
    }

    //初始化lua使用的Java函数
    private void initLuaEnv() throws Exception {
        L = LuaStateFactory.newLuaState();
        L.openLibs();

        L.pushJavaObject(this);
        L.setGlobal("activity");

        L.getGlobal("activity");
        L.setGlobal("this");

        L.pushContext(this);
        L.getGlobal("luajava");

        L.pushString(luaExtDir);
        L.setField(-2, "luaextdir");

        L.pushString(luaDir);
        L.setField(-2, "luadir");

        L.pushString(luaPath);
        L.setField(-2, "luapath");

        L.pop(1);

        JavaFunction print = new LuaPrint(this, L);
        print.register("print");

        L.getGlobal("package");
        L.pushString(luaLpath);
        L.setField(-2, "path");
        L.pushString(luaCpath);
        L.setField(-2, "cpath");
        L.pop(1);

        new JavaFunction(L) {
            @Override
            public int execute() throws LuaException {
                LuaThread thread = (LuaThread) L.toJavaObject(2);

                thread.set(L.toString(3), L.toJavaObject(4));
                return 0;
            }
        }.register("set");

        new JavaFunction(L) {
            @Override
            public int execute() throws LuaException {
                LuaThread thread = (LuaThread) L.toJavaObject(2);
                int top = L.getTop();
                if (top > 3) {
                    Object[] args = new Object[top - 3];
                    for (int i = 4; i <= top; i++) {
                        args[i - 4] = L.toJavaObject(i);
                    }
                    thread.call(L.toString(3), args);
                } else if (top == 3) {
                    thread.call(L.toString(3));
                }
                return 0;
            }
        }.register("call");

        mOnKeyDown = L.getLuaObject("onKeyDown");
        if (mOnKeyDown.isNil())
            mOnKeyDown = null;
        mOnKeyUp = L.getLuaObject("onKeyUp");
        if (mOnKeyUp.isNil())
            mOnKeyUp = null;
        mOnKeyLongPress = L.getLuaObject("onKeyLongPress");
        if (mOnKeyLongPress.isNil())
            mOnKeyLongPress = null;
        mOnTouchEvent = L.getLuaObject("onTouchEvent");
        if (mOnTouchEvent.isNil())
            mOnTouchEvent = null;
    }


    //运行lua脚本
    public Object doFile(String filePath) {
        return doFile(filePath, new Object[0]);
    }

    public Object doFile(String filePath, Object[] args) {
        int ok = 0;
        try {
            if (filePath.charAt(0) != '/')
                filePath = luaExtDir + "/" + filePath;

            L.setTop(0);
            ok = L.LloadFile(filePath);

            if (ok == 0) {
                L.getGlobal("debug");
                L.getField(-1, "traceback");
                L.remove(-2);
                L.insert(-2);
                int l = args.length;
                for (int i = 0; i < l; i++) {
                    L.pushObjectValue(args[i]);
                }
                ok = L.pcall(l, 1, -2 - l);
                if (ok == 0) {
                    return L.toJavaObject(-1);
                }
            }
            Intent res = new Intent();
            res.putExtra("data", L.toString(-1));
            setResult(ok, res);
            throw new LuaException(errorReason(ok) + ": " + L.toString(-1));
        } catch (LuaException e) {
            setTitle(errorReason(ok));
            setContentView(errorLayout);
            sendMsg(e.getMessage());
            String s = e.getMessage();
            String p = "android.permission.";
            int i = s.indexOf(p);
            if (i > 0) {
                i = i + p.length();
                int n = s.indexOf(".", i);
                if (n > i) {
                    String m = s.substring(i, n);
                    L.getGlobal("require");
                    L.pushString("permission");
                    L.pcall(1, 0, 0);
                    L.getGlobal("permission_info");
                    L.getField(-1, m);
                    if (L.isString(-1))
                        m = m + " (" + L.toString(-1) + ")";
                    sendMsg("权限错误: " + m);
                    return null;
                }
            }
        }
        return null;
    }

    @Override
    public void toast(String msg) {
        Toast.makeText(this, msg, Toast.LENGTH_SHORT).show();
    }

    public Object doAsset(String name, Object... args) {
        int ok = 0;
        try {
            byte[] bytes = FileUtils.readAsset(name);
            L.setTop(0);
            ok = L.LloadBuffer(bytes, name);

            if (ok == 0) {
                L.getGlobal("debug");
                L.getField(-1, "traceback");
                L.remove(-2);
                L.insert(-2);
                int l = args.length;
                for (int i = 0; i < l; i++) {
                    L.pushObjectValue(args[i]);
                }
                ok = L.pcall(l, 0, -2 - l);
                if (ok == 0) {
                    return L.toJavaObject(-1);
                }
            }
            throw new LuaException(errorReason(ok) + ": " + L.toString(-1));
        } catch (Exception e) {
            setTitle(errorReason(ok));
            setContentView(errorLayout);
            sendMsg(e.getMessage());
        }

        return null;
    }

    //运行lua函数
    public Object runFunc(String funcName, Object... args) {
        if (L != null) {
            try {
                L.setTop(0);
                L.getGlobal(funcName);
                if (L.isFunction(-1)) {
                    L.getGlobal("debug");
                    L.getField(-1, "traceback");
                    L.remove(-2);
                    L.insert(-2);

                    int argsLength = args.length;
                    for (int i = 0; i < argsLength; i++) {
                        L.pushObjectValue(args[i]);
                    }

                    int ok = L.pcall(argsLength, 1, -2 - argsLength);
                    if (ok == 0) {
                        return L.toJavaObject(-1);
                    }
                    throw new LuaException(errorReason(ok) + ": " + L.toString(-1));
                }
            } catch (LuaException e) {
                sendMsg(funcName + " " + e.getMessage());
            }
        }
        return null;
    }

    //运行lua代码
    public Object doString(String funcSrc, Object... args) {
        try {
            L.setTop(0);
            int ok = L.LloadString(funcSrc);

            if (ok == 0) {
                L.getGlobal("debug");
                L.getField(-1, "traceback");
                L.remove(-2);
                L.insert(-2);

                int l = args.length;
                for (int i = 0; i < l; i++) {
                    L.pushObjectValue(args[i]);
                }

                ok = L.pcall(l, 1, -2 - l);
                if (ok == 0) {
                    return L.toJavaObject(-1);
                }
            }
            throw new LuaException(errorReason(ok) + ": " + L.toString(-1));
        } catch (LuaException e) {
            sendMsg(e.getMessage());
        }
        return null;
    }

    //生成错误信息
    private String errorReason(int error) {
        switch (error) {
            case 6:
                return "error error";
            case 5:
                return "GC error";
            case 4:
                return "Out of memory";
            case 3:
                return "Syntax error";
            case 2:
                return "Runtime error";
            case 1:
                return "Yield error";
        }
        return "Unknown error " + error;
    }

    //显示信息
    public void sendMsg(String msg) {
        Message message = new Message();
        Bundle bundle = new Bundle();
        bundle.putString("data", msg);
        message.setData(bundle);
        message.what = 0;
        handler.sendMessage(message);
        Logs.d(msg);
    }

    private void setField(String key, Object value) {
        try {
            L.pushObjectValue(value);
            L.setGlobal(key);
        } catch (LuaException e) {
            sendMsg(e.getMessage());
        }
    }

    public void call(String func) {
        push(2, func);
    }

    public void call(String func, Object[] args) {
        if (args.length == 0)
            push(2, func);
        else
            push(3, func, args);
    }

    public void set(String key, Object value) {
        push(1, key, new Object[]{value});
    }

    public Object get(String key) throws LuaException {
        L.getGlobal(key);
        return L.toJavaObject(-1);
    }

    public void push(int what, String s) {
        Message message = new Message();
        Bundle bundle = new Bundle();
        bundle.putString("data", s);
        message.setData(bundle);
        message.what = what;

        handler.sendMessage(message);

    }

    public void push(int what, String s, Object[] args) {
        Message message = new Message();
        Bundle bundle = new Bundle();
        bundle.putString("data", s);
        bundle.putSerializable("args", args);
        message.setData(bundle);
        message.what = what;

        handler.sendMessage(message);

    }

    // avoid handler leak memory
    private static class MainHandler extends Handler {
        WeakReference<Activity> activityWeakReference;

        private MainHandler(Activity activity) {
            activityWeakReference = new WeakReference<>(activity);
        }

        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            Activity activity = activityWeakReference.get();
            if (activity == null || !(activity instanceof LuaActivity)) {
                return;
            }
            LuaActivity luaActivity = (LuaActivity) activity;
            switch (msg.what) {
                case 0: {
                    String data = msg.getData().getString("data");
                    luaActivity.toast(data);
                    luaActivity.status.append(data + "\n");
                }
                break;
                case 1: {
                    Bundle data = msg.getData();
                    luaActivity.setField(data.getString("data"), ((Object[]) data.getSerializable("args"))[0]);
                }
                break;
                case 2: {
                    String src = msg.getData().getString("data");
                    luaActivity.runFunc(src);
                }
                break;
                case 3: {
                    String src = msg.getData().getString("data");
                    Serializable args = msg.getData().getSerializable("args");
                    luaActivity.runFunc(src, (Object[]) args);
                }
            }
        }
    }
}
