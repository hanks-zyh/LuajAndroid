package androlua;

import android.content.Context;

import com.luajava.LuaException;
import com.luajava.LuaObject;
import com.luajava.LuaState;

import java.io.File;

import common.FileUtils;
import common.Logs;
import dalvik.system.DexClassLoader;

public class LuaManager {

    private static LuaManager instance;
    private Context context;
    private String odexDir;
    private String libDir; // 外部 so 文件路径
    private String luaDir; // 内部 lua 文件路径
    private String luaExtDir; // 外部 lua 文件路径
    private String luaCpath; // 相当于 LUA_CPATH
    private String luaLpath; // 相当于 LUA_PATH

    private LuaManager() {

    }

    public static LuaManager getInstance() {
        if (instance == null) {
            synchronized (LuaManager.class) {
                if (instance == null) {
                    instance = new LuaManager();
                }
            }
        }
        return instance;
    }

    public void init(Context context) {
        this.context = context;
        context = context.getApplicationContext();
        // 注册crashHandler
        CrashHandler crashHandler = CrashHandler.getInstance();
        crashHandler.init(context);

        //初始化AndroLua工作目录
        luaExtDir = FileUtils.getAndroLuaDir();
        //定义文件夹
        odexDir = context.getDir("odex", Context.MODE_PRIVATE).getAbsolutePath();
        libDir = context.getDir("lib", Context.MODE_PRIVATE).getAbsolutePath();
        luaDir = context.getDir("lua", Context.MODE_PRIVATE).getAbsolutePath();
        luaCpath = context.getApplicationInfo().nativeLibraryDir + "/lib?.so" + ";" + libDir + "/lib?.so";
        luaLpath = luaDir + "/?.lua;" + luaDir + "/lua/?.lua;" + luaDir + "/?/initEnv.lua;" + luaExtDir + "/?.lua;";
    }


    //运行lua脚本
    public Object doFile(LuaState L, String filePath) throws LuaException {
        return doFile(L, filePath, new Object[0]);
    }

    public Object doFile(LuaState L, String filePath, Object[] args) throws LuaException {
        int ok = 0;
        L.setTop(0);
        ok = L.LloadFile(filePath);
        if (ok == 0) {
            L.getGlobal("debug");
            L.getField(-1, "traceback");
            L.remove(-2);
            L.insert(-2);
            int l = args.length;
            for (Object arg : args) {
                L.pushObjectValue(arg);
            }
            ok = L.pcall(l, 1, -2 - l);
            if (ok == 0) {
                return L.toJavaObject(-1);
            }
        }
        throw new LuaException(errorReason(ok) + ": " + L.toString(-1));
    }


    //运行lua函数
    public Object runFunc(LuaState L, String funcName, Object... args) {
        try {
            L.setTop(0);
            L.getGlobal(funcName);
            if (L.isFunction(-1)) {
                L.getGlobal("debug");
                L.getField(-1, "traceback");
                L.remove(-2);
                L.insert(-2);
                int argsLength = args.length;
                for (Object arg : args) {
                    L.pushObjectValue(arg);
                }
                int ok = L.pcall(argsLength, 1, -2 - argsLength);
                if (ok == 0) {
                    return L.toJavaObject(-1);
                }
                throw new LuaException(errorReason(ok) + ": " + L.toString(-1));
            }
        } catch (LuaException e) {
            Logs.e(e);
        }
        return null;
    }

    //运行lua代码
    public Object doString(LuaState L, String funcSrc, Object... args) throws LuaException {
        L.setTop(0);
        int ok = L.LloadString(funcSrc);
        if (ok == 0) {
            L.getGlobal("debug");
            L.getField(-1, "traceback");
            L.remove(-2);
            L.insert(-2);
            int l = args.length;
            for (Object arg : args) {
                L.pushObjectValue(arg);
            }
            ok = L.pcall(l, 1, -2 - l);
            if (ok == 0) {
                return L.toJavaObject(-1);
            }
        }
        throw new LuaException(errorReason(ok) + ": " + L.toString(-1));
    }


    public DexClassLoader loadDex(ClassLoader parent, String path) throws LuaException {
        if (path.charAt(0) != '/')
            path = getLuaDir() + "/" + path;
        if (!new File(path).exists())
            if (new File(path + ".dex").exists())
                path += ".dex";
            else if (new File(path + ".jar").exists())
                path += ".jar";
            else
                throw new LuaException(path + " not found");
        return new DexClassLoader(path, odexDir, getContext().getApplicationInfo().nativeLibraryDir, parent);
    }

    public Object loadLib(LuaState L, String soPath) throws LuaException {
        if (!soPath.startsWith("/")) {
            soPath = libDir + "/" + soPath;
        }
        File soFile = new File(soPath);
        if (!soFile.exists()) {
            throw new LuaException("can not find lib " + soFile.getAbsolutePath());
        }
        if (!libDir.equals(soFile.getParent())) {
            LuaUtil.copyFile(soFile.getAbsolutePath(), libDir + "/lib" + soFile.getName() + ".so");
        }
        LuaObject require = L.getLuaObject("require");
        return require.call(soFile.getName());
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

    public void appendSoDir(String dir) {
        if (!dir.startsWith("/")) {
            dir = getLibDir() + "/" + dir;
        }
        if (dir.endsWith(".so")){
            dir = dir.substring(0,dir.lastIndexOf('/'));
        }
        String newPath = String.format(";%s/?.so", dir);
        if (luaCpath.contains(newPath)) {
            return;
        }
        luaCpath += newPath;
    }

    public void appendLuaDir(String dir) {
        if (!dir.startsWith("/")) {
            dir = getLuaExtDir() + "/" + dir;
        }
        if (dir.endsWith(".lua")){
            dir = dir.substring(0,dir.lastIndexOf('/'));
        }
        String newPath = String.format(";%s/?.lua", dir);
        if (luaLpath.contains(newPath)){
            return;
        }
        luaLpath += newPath;
    }

    public Context getContext() {
        return context;
    }

    public String getOdexDir() {
        return odexDir;
    }

    public String getLibDir() {
        return libDir;
    }

    public String getLuaDir() {
        return luaDir;
    }

    public String getLuaExtDir() {
        return luaExtDir;
    }

    public String getLuaCpath() {
        return luaCpath;
    }

    public String getLuaLpath() {
        return luaLpath;
    }


}



