package androlua;

import com.luajava.JavaFunction;
import com.luajava.LuaException;
import com.luajava.LuaObject;
import com.luajava.LuaState;
import com.luajava.LuaStateFactory;
import java.io.IOException;
import java.util.regex.Pattern;

public class LuaTimerTask extends TimerTaskX {
    private LuaState L;
    private Object[] mArg;
    private byte[] mBuffer;
    private boolean mEnabled;
    private LuaContext mLuaContext;
    private String mSrc;

    public LuaTimerTask(LuaContext luaContext, String src) throws LuaException {
        this(luaContext, src, null);
    }

    public LuaTimerTask(LuaContext luaContext, String src, Object[] arg) throws LuaException {
        this.mArg = new Object[0];
        this.mEnabled = true;
        this.mLuaContext = luaContext;
        this.mSrc = src;
        if (arg != null) {
            this.mArg = arg;
        }
    }

    public LuaTimerTask(LuaContext luaContext, LuaObject func) throws LuaException {
        this(luaContext, func, null);
    }

    public LuaTimerTask(LuaContext luaContext, LuaObject func, Object[] arg) throws LuaException {
        this.mArg = new Object[0];
        this.mEnabled = true;
        this.mLuaContext = luaContext;
        if (arg != null) {
            this.mArg = arg;
        }
        this.mBuffer = func.dump();
    }

    public void run() {
        if (this.mEnabled) {
            try {
                if (this.L == null) {
                    initLua();
                    if (this.mBuffer != null) {
                        newLuaThread(this.mBuffer, this.mArg);
                    } else {
                        newLuaThread(this.mSrc, this.mArg);
                    }
                    this.L.gc(2, 1);
                    System.gc();
                }
                this.L.getGlobal("run");
                if (!this.L.isNil(-1)) {
                    runFunc("run", new Object[0]);
                } else if (this.mBuffer != null) {
                    newLuaThread(this.mBuffer, this.mArg);
                } else {
                    newLuaThread(this.mSrc, this.mArg);
                }
                this.L.gc(2, 1);
                System.gc();
            } catch (LuaException e) {
                this.mLuaContext.toast(e.getMessage());
            }
        }
    }

    public boolean cancel() {
        return super.cancel();
    }

    public void setArg(Object[] arg) {
        this.mArg = arg;
    }

    public void setArg(LuaObject arg) throws ArrayIndexOutOfBoundsException, LuaException, IllegalArgumentException {
        this.mArg = arg.asArray();
    }

    public void setEnabled(boolean enabled) {
        this.mEnabled = enabled;
    }

    public boolean isEnabled() {
        return this.mEnabled;
    }

    public void set(String key, Object value) throws LuaException {
        this.L.pushObjectValue(value);
        this.L.setGlobal(key);
    }

    public Object get(String key) throws LuaException {
        this.L.getGlobal(key);
        return this.L.toJavaObject(-1);
    }

    private String errorReason(int error) {
        switch (error) {
            case 1:
                return "Yield error";
            case 2:
                return "Runtime error";
            case 3:
                return "Syntax error";
            case 4:
                return "Out of memory";
            case 5:
                return "GC error";
            case 6:
                return "error error";
            default:
                return "Unknown error " + error;
        }
    }

    private void initLua() throws LuaException {
        this.L = LuaStateFactory.newLuaState();
        this.L.openLibs();
        this.L.pushJavaObject(this.mLuaContext);
        if (this.mLuaContext instanceof LuaActivity) {
            this.L.setGlobal("activity");
        } else if (this.mLuaContext instanceof LuaService) {
            this.L.setGlobal("service");
        }
        this.L.pushJavaObject(this);
        this.L.setGlobal("this");
        this.L.pushContext(this.mLuaContext);
        new LuaPrint(this.mLuaContext, this.L).register("print");
        this.L.getGlobal("package");
        this.L.pushString(this.mLuaContext.getLuaLpath());
        this.L.setField(-2, "path");
        this.L.pushString(this.mLuaContext.getLuaCpath());
        this.L.setField(-2, "cpath");
        this.L.pop(1);
        new JavaFunction(this.L) {
            public int execute() throws LuaException {
                LuaTimerTask.this.mLuaContext.set(this.L.toString(2), this.L.toJavaObject(3));
                return 0;
            }
        }.register("set");
        new JavaFunction(this.L) {
            public int execute() throws LuaException {
                int top = this.L.getTop();
                if (top > 2) {
                    Object[] args = new Object[(top - 2)];
                    for (int i = 3; i <= top; i++) {
                        args[i - 3] = this.L.toJavaObject(i);
                    }
                    LuaTimerTask.this.mLuaContext.call(this.L.toString(2), args);
                } else if (top == 2) {
                    LuaTimerTask.this.mLuaContext.call(this.L.toString(2), new Object[0]);
                }
                return 0;
            }
        }.register("call");
    }

    private void newLuaThread(String str, Object... args) {
        try {
            if (Pattern.matches("^\\w+$", str)) {
                doAsset(str + ".lua", args);
            } else if (Pattern.matches("^[\\w\\.\\_/]+$", str)) {
                this.L.getGlobal("luajava");
                this.L.pushString(this.mLuaContext.getLuaDir());
                this.L.setField(-2, "luadir");
                this.L.pushString(str);
                this.L.setField(-2, "luapath");
                this.L.pop(1);
                doFile(str, args);
            } else {
                doString(str, args);
            }
        } catch (Exception e) {
            this.mLuaContext.toast(e.getMessage());
        }
    }

    private void newLuaThread(byte[] buf, Object... args) throws LuaException {
        this.L.setTop(0);
        int ok = this.L.LloadBuffer(buf, "TimerTask");
        if (ok == 0) {
            this.L.getGlobal("debug");
            this.L.getField(-1, "traceback");
            this.L.remove(-2);
            this.L.insert(-2);
            for (Object pushObjectValue : args) {
                this.L.pushObjectValue(pushObjectValue);
            }
            int l=args.length;
            ok = this.L.pcall(l, 0, -2 - l);
            if (ok == 0) {
                return;
            }
        }
        throw new LuaException(errorReason(ok) + ": " + this.L.toString(-1));
    }

    private void doFile(String filePath, Object... args) throws LuaException {
        this.L.setTop(0);
        int ok = this.L.LloadFile(filePath);
        if (ok == 0) {
            this.L.getGlobal("debug");
            this.L.getField(-1, "traceback");
            this.L.remove(-2);
            this.L.insert(-2);
            for (Object pushObjectValue : args) {
                this.L.pushObjectValue(pushObjectValue);
            }
            int l=args.length;
            ok = this.L.pcall(l, 0, -2 - l);
            if (ok == 0) {
                return;
            }
        }
        throw new LuaException(errorReason(ok) + ": " + this.L.toString(-1));
    }

    public void doAsset(String name, Object... args) throws LuaException, IOException {
        byte[] bytes = LuaUtil.readAsset(this.mLuaContext.getContext(), name);
        this.L.setTop(0);
        int ok = this.L.LloadBuffer(bytes, name);
        if (ok == 0) {
            this.L.getGlobal("debug");
            this.L.getField(-1, "traceback");
            this.L.remove(-2);
            this.L.insert(-2);
            for (Object pushObjectValue : args) {
                this.L.pushObjectValue(pushObjectValue);
            }
            int l=args.length;
            ok = this.L.pcall(l, 0, -2 - l);
            if (ok == 0) {
                return;
            }
        }
        throw new LuaException(errorReason(ok) + ": " + this.L.toString(-1));
    }

    private void doString(String src, Object... args) throws LuaException {
        this.L.setTop(0);
        int ok = this.L.LloadString(src);
        if (ok == 0) {
            this.L.getGlobal("debug");
            this.L.getField(-1, "traceback");
            this.L.remove(-2);
            this.L.insert(-2);
            for (Object pushObjectValue : args) {
                this.L.pushObjectValue(pushObjectValue);
            }
            int l=args.length;
            ok = this.L.pcall(l, 0, -2 - l);
            if (ok == 0) {
                return;
            }
        }
        throw new LuaException(errorReason(ok) + ": " + this.L.toString(-1));
    }

    private void runFunc(String funcName, Object... args) {
        try {
            this.L.setTop(0);
            this.L.getGlobal(funcName);
            if (this.L.isFunction(-1)) {
                this.L.getGlobal("debug");
                this.L.getField(-1, "traceback");
                this.L.remove(-2);
                this.L.insert(-2);
                for (Object pushObjectValue : args) {
                    this.L.pushObjectValue(pushObjectValue);
                }
                int l=args.length;
                int ok = this.L.pcall(l, 1, -2 - l);
                if (ok != 0) {
                    throw new LuaException(errorReason(ok) + ": " + this.L.toString(-1));
                }
            }
        } catch (LuaException e) {
            this.mLuaContext.toast(funcName+":"+e.getMessage());
        }
    }

    private void setField(String key, Object value) {
        try {
            this.L.pushObjectValue(value);
            this.L.setGlobal(key);
        } catch (LuaException e) {
            this.mLuaContext.toast(e.getMessage());
        }
    }
}