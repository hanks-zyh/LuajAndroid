// 功能： 编辑 lua

var fs = require('fs');
var path = require('path');
var shelljs = require('shelljs/global');

var root = "D:\\work\\opensource\\LuaJAndroid\\lua";
var pluginRoot = "D:\\work\\opensource\\api_luanroid\\lua";

rm('-rf', '../../../../api_luanroid/lua');
cp('-R', '../../../lua', '../../../../api_luanroid/lua');

var plugins = fs.readdirSync(pluginRoot);

for (var j = 0; j < plugins.length; j++) {

    var pluginDir = path.join(pluginRoot,plugins[j]);
    cd(pluginDir)
    var files = fs.readdirSync(pluginDir);
    for (var i = 0; i < files.length; i++) {
       var file = files[i];
       if(!file.endsWith('.lua')) continue;
       var filePath = path.join(pluginDir,file);
       console.log(filePath);
       var cmd = 'luac '+ file ;
       console.log(cmd);
       exec(cmd);
       rm(file)
       mv('luac.out', file)
       console.log('-----');
    }
}
