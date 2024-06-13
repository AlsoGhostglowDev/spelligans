package backend;

class Paths
{
	static public function image(key:String)
	{
		return 'assets/images/$key.png';
	}

	static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}
}