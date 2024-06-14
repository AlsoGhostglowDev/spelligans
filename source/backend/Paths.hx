package backend;

class Paths
{
	static var musicSuffix = #if !web ".ogg" #else ".mp3" #end;
	
	static public function image(key:String)
	{
		return 'assets/images/$key.png';
	}

	static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}
	
	static public function music(key:String)
	{
		return 'assets/music/$key' + musicSuffix;
	}
}