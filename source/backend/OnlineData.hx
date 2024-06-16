package backend;

using StringTools;
class OnlineData
{
	static public function getDifficultyFromOnline(diff:String = "normal")
	{
		switch(diff.toLowerCase()) {
			case "easy":
				return getOnlineData("https://raw.githubusercontent.com/TBar09/spelligans-onlinedata/main/onlineData/easy.json");
			case "normal":
				return getOnlineData("https://raw.githubusercontent.com/TBar09/spelligans-onlinedata/main/onlineData/normal.json");
			case "hard":
				return getOnlineData("https://raw.githubusercontent.com/TBar09/spelligans-onlinedata/main/onlineData/hard.json");
			case "impossible":
				return getOnlineData("https://raw.githubusercontent.com/TBar09/spelligans-onlinedata/main/onlineData/impossible.json");
		}
		return "";
	}
	
	static public function getOnlineData(url:String)
	{
		var coolSwag = url.toString();
		var http = new haxe.Http(coolSwag);
		http.onData = function(data:String)
		{
			coolSwag = data;
		}
		http.onError = function (error) {
			trace('Error: $error. Is the user offline?');
		}
		http.request();
		
		return coolSwag;
	}
}