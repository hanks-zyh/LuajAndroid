
local uihelper  = {}

function runOnUiThread(activity, f)
    activity.runOnUiThread(luajava.createProxy('java.lang.Runnable', {
        run = f
    }))
end

uihelper.runOnUiThread = runOnUiThread

return uihelper

