package backend;

class Paths
{
	public static final fonts:{ui:String, game:String} = {ui: 'LeagueSpartan-Bold.otf', game: 'Panton-BlackCaps.otf'};  
	static final musicSuffix = #if !web ".ogg" #else ".mp3" #end;

	static public function image(key:String) return 'assets/images/$key.png';
	static public function font(key:String) return 'assets/fonts/$key';
	static public function json(key:String, directory:String = "word-mode")
	{
		#if sys
		return sys.io.File.getContent('assets/data/$directory/$key.json');
		#else
		return sys.io.File.getContent('assets/data/$directory/$key.json');
		#end
	}
	static public function music(key:String) return 'assets/music/$key' + musicSuffix;
	static public function sound(key:String) return 'assets/sounds/$key' + musicSuffix;
}