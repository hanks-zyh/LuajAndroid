var fs = require "fs"

var fileDirectory = "D:\\work\\opensource\\LuaJAndroid\\lua";
if(fs.existsSync(fileDirectory)){
  fs.readdir(fileDirectory, function (err, files) {
  if (err) {
    console.log(err);
    return;
  }

  var count = files.length;
  var results = {};
  var res = ""
  files.forEach(function (filename) {
    // plugin dir
    
      if (filename = "info.json") {
        
        fs.readFile(filename,'utf-8',function(err,data){
   			if(err){
		        console.log("error");
		    }else{
		        console.log(data);
                var json = JSON.parse(data)
                result.push(json)
		    }
		});
        

      }

 
  });
});
}
