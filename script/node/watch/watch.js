var chokidar = require('chokidar');
var shelljs = require('shelljs');


chokidar.watch('/Users/zhanks/work/opensource/LuajAndroid/lua').on('change', function(){

  console.log('filse changed');

  shelljs.exec('adb push /Users/zhanks/work/opensource/LuajAndroid/lua/* sdcard/Android/data/pub.hanks.sample/files/LLLLLua');

});
