--
-- Created by IntelliJ IDEA.
-- User: hanks
-- Date: 2017/5/2
-- Time: 10:18
-- To change this template use File | Settings | File Templates.
--

-- Simple lua script that is executed when the activity start.
--
-- Arguments are the activity and the view.

-- require "import"

local activity, view = ...
print('activity', activity, 'view', view)

activity:setTitle('HHHHH')

-- AlertDialog
local AlertDialog_Builder = luajava.bindClass('android.app.AlertDialog$Builder')
local dl = AlertDialog_Builder.new(activity)
dl:setTitle('标题待定')
dl:setMessage('呢哦人')
dl:show()

-- 打开网页
local Uri = luajava.bindClass('android.net.Uri')
local Intent = luajava.bindClass('android.content.Intent')
local intent = Intent.new()
intent:setData(Uri:parse("http://baidu.com"))
intent:setAction(Intent.ACTION_VIEW)
activity:startActivity(intent)
