package us.flashmx.tools 
{
	import flash.system.Capabilities;
	/**
	 * ...
	 * @author Nikolay Shishenkov
	 */
	public class OSDetect 
	{
		public static const ANDROID:String	= "android";
		public static const IOS:String		= "ios";
		public static const LIN:String		= "linux";
		public static const MAC:String		= "macintosh";
		public static const WIN:String		= "windows";
		public static const UNKNOWN:String	= "unknown";
		
		public function OSDetect() {}
		
		//
		public static function get os():String
		{
			switch(Capabilities.manufacturer)
			{
				case "Android Linux":
					return ANDROID;
				case "Adobe iOS":
					return IOS;
				case "Adobe Macintosh":
					return MAC;
				case "Adobe Windows":
					return WIN;
			}
			//
			return UNKNOWN;
		}
		
		//
		public static function get is_Android():Boolean
		{
			return os == ANDROID;
		}
		//
		public static function get is_iOS():Boolean
		{
			return os == IOS;
		}
		//
		public static function get is_old_iOS():Boolean
		{
			return os == IOS && Math.min(Capabilities.screenResolutionX, Capabilities.screenResolutionY) < 768;
		}
		//
		public static function get is_Linux():Boolean
		{
			return os == LIN;
		}
		//
		public static function get is_Mac():Boolean
		{
			return os == MAC;
		}
		//
		public static function get is_Windows():Boolean
		{
			return os == WIN;
		}

		//
		public static function get is_Mobile():Boolean
		{
			return os == IOS || os == ANDROID;
		}
	}

}