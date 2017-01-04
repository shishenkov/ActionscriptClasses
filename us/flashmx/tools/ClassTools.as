package us.flashmx.tools 
{
	/**
	 * ...
	 * @author Nikolay Shishenkov
	 */
	
	 import flash.utils.getQualifiedClassName;
	 
	public class ClassTools 
	{
		
		public static function className(_instance:*):String
		{
			return classTrailclassName(_instance).split(':').pop();
		}
		
		public static function classTrailclassName(_instance:*):String
		{
			return getQualifiedClassName(_instance);
		}
		
		///////////////////////////////
		public function ClassTools() {}		
	}

}