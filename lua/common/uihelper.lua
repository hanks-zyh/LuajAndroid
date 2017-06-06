local uihelper  = {}

function runOnUiThread(activity, f)
    activity.runOnUiThread(luajava.createProxy('java.lang.Runnable', {
        run = f
    }))
end

uihelper.runOnUiThread = runOnUiThread

local density

local function dp2px (dp)
    if density == nil then
        import "androlua.LuaUtil"
        density = LuaUtil.getDensity()
    end
    return 0.5 + dp * density
end
uihelper.dp2px = dp2px

return uihelper

