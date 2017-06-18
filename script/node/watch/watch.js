var chokidar = require('chokidar');
var shelljs = require('shelljs');
const os = require('os');

var watchDir = '/Users/zhanks/work/opensource/LuajAndroid/lua';
var pushDir = '/Users/zhanks/work/opensource/LuajAndroid/lua/*'
if (os.platform() == 'win32') {
  watchDir = 'D:\\work\\opensource\\LuaJAndroid\\lua';
  pushDir = 'D:\\work\\opensource\\LuaJAndroid\\lua\\.';
}
console.log(watchDir);
chokidar.watch(watchDir).on('change', function(){
  console.log('filse changed');
  var cmd = 'adb push ' + pushDir + '  sdcard/Android/data/pub.hanks.sample/files/LLLLLua'
  console.log(cmd)
  shelljs.exec(cmd);
});
