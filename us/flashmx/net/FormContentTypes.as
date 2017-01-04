package us.flashmx.net 
{
	/**
	 * ...
	 * @author ...
	 */
	public class FormContentTypes 
	{
		//If the value of the data property is a URLVariables object, the value of contentType must be application/x-www-form-urlencoded.
		public static const TYPE_DEFAULT:String	= "application/x-www-form-urlencoded";
		
		//If the value of the data property is any other type, the value of contentType should indicate the type of the POST data that will be sent (which is the binary or string data contained in the value of the data property).
		//public static const TYPE_POST:String	= "application/x-www-form-urlencoded";
		
		//If the value of the data property is any other type, the value of contentType should indicate the type of the POST data that will be sent (which is the binary or string data contained in the value of the data property).
		public static const TYPE_MULTIPART:String	= "multipart/form-data";
		
		//
		public function FormContentTypes() {}
		
	}

}