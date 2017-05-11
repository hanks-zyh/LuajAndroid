package common;

import android.util.Log;

import pub.hanks.luajandroid.BuildConfig;


/**
 * Logs
 * Created by hanks on 2016/11/19.
 */

public class Logs {
    private static final String TAG = "LLogs";
    private static boolean logOpen = BuildConfig.DEBUG;

    public static void i(String s) {
        if (logOpen) {
            Log.i(TAG, s==null?"null":s);
        }
    }

    public static void w(String s) {
        if (logOpen) {
            Log.w(TAG, s==null?"null":s);
        }
    }

    public static void d(String s) {
        if (logOpen) {
            Log.d(TAG, s==null?"null":s);
        }
    }

    public static void e(String s) {
        if (logOpen) {
            Log.e(TAG, s==null?"null":s);
        }
    }

    public static void e(Throwable e) {
        if (logOpen && e != null) {
            e.printStackTrace();
        }
    }
}
