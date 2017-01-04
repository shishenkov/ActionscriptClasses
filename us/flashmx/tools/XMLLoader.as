package us.flashmx.tools
{
	
	import flash.events.*;
	import flash.net.*;
	
	public class XMLLoader extends EventDispatcher
	{
		public static const XML_LOAD_COMPLETE:String	= "XMLLoader : COMPLETE";
		public static const XML_LOAD_ERROR:String		= "XMLLoader : ERROR";
		
		private var xmlL:URLLoader, _xml:XML;
		
		public function XMLLoader(_xmlPath:String)
		{
			xmlL	= new URLLoader(new URLRequest(_xmlPath));
			//
			xmlL.addEventListener(Event.COMPLETE, _onXMLLoad);
			xmlL.addEventListener(IOErrorEvent.IO_ERROR, _onXMLError);
			xmlL.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onXMLError);
		}
		
		protected function _onXMLLoad(event:Event):void
		{
			_xml	= new XML();
			//
			try{
				_xml	= XML(xmlL.data as String);
				dispatchEvent(new Event(XML_LOAD_COMPLETE));
			}catch(err:Error){
				_onXMLError(err);
			};
		}
		
		protected function _onXMLError(event:* = null):void
		{
			trace("_onXMLError: " + event)
			dispatchEvent(new Event(XML_LOAD_ERROR));		
		}
		
		public function get data():XML
		{
			return _xml;
		}
	}
}