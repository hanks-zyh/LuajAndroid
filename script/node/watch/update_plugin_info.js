var fs = require('fs');
var path = require('path');
var archiver = require('archiver');

var root = "D:\\work\\opensource\\LuaJAndroid\\lua";
var apiFile = "D:\\work\\opensource\\api_luanroid\\api\\plugins";

var res = {data:[]};

var plugins = fs.readdirSync(root);
for (var j = 0; j < plugins.length; j++) {
    var pluginDir = path.join(root,plugins[j]);
    var files = fs.readdirSync(pluginDir);
    for (var i = 0; i < files.length; i++) {
       if(files[i] != 'info.json') continue;
       var text = fs.readFileSync(path.join(pluginDir,files[i]),'utf8');
       var json = JSON.parse(text);
       json.download = 'https://coding.net/u/zhangyuhan/p/api_luanroid/git/raw/master/plugin/' + plugins[j] + '.zip';
       res.data.push(json);
    }
}
// 生成 json
var apiData = JSON.stringify(res);
console.log(apiData);
fs.writeFileSync(apiFile,apiData,'utf8');

