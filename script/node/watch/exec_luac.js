var fs = require('fs');
var path = require('path');

var root = "D:\\work\\opensource\\LuaJAndroid\\lua";
var apiFile = "D:\\work\\opensource\\api_luanroid\\api\\plugins";
var shelljs = require('shelljs');

var plugins = fs.readdirSync(root);
for (var j = 0; j < plugins.length; j++) {
    var pluginDir = path.join(root,plugins[j]);
    var files = fs.readdirSync(pluginDir);
    for (var i = 0; i < files.length; i++) {
       if(!files[i].endsWith('.lua')) continue;
//       var cmd = 'luac '+ path.join(pluginDir,files[i]) + ' -o ' + path.join(apiFile,plugins[j],files[i]) ;
        var cmd = "lua -v"
       console.log(cmd);
       shelljs.exec(cmd)
    }
}
