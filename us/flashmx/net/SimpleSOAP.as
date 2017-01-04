package us.flashmx.net 
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestDefaults;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SimpleSOAP extends EventDispatcher 
	{
		private var _url:String;
		private var _loarder:URLLoader	= new URLLoader;
		private var _result:String		= "";
		private var _headers:Array		= [];
		
		public function SimpleSOAP(target:flash.events.IEventDispatcher=null) 
		{
			super(target);
			//
			_loarder.addEventListener(Event.COMPLETE, _onLoaderTaskComplete, false, int.MIN_VALUE, true);
			_loarder.addEventListener(IOErrorEvent.IO_ERROR, _onIOError, false, int.MIN_VALUE, true);
			_loarder.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError, false, int.MIN_VALUE, true);
		}
		
		private function _onSecurityError(e:SecurityErrorEvent):void 
		{
			dispatchEvent(e.clone());
		}
		
		private function _onIOError(e:IOErrorEvent):void 
		{
			dispatchEvent(e.clone() );
		}
		
		private function _onLoaderTaskComplete(e:Event):void 
		{
			//
			_result	= _loarder.data as String;
			
			//
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function callService(serviceName:String, postParams:* = null):void
		{
			_result	= "";
			
			//
			if (url == null || url.length < 1)
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "SOAP URL is missing!"));
				return;
			}
			
			//
			close();
			
			//
			var _serviceURL:String	= url + serviceName;
			var _rq:URLRequest		= new URLRequest(_serviceURL);
			_rq.method				= URLRequestMethod.POST;
			_rq.data				= postParams;
			_rq.contentType			= FormContentTypes.TYPE_DEFAULT;
			
			//custom headers
			if(headers.length > 0)
				_rq.requestHeaders	= headers;
			
			trace("====");
			trace("HEADERS:	" + _rq.requestHeaders);
			trace("VARS:	" +  _rq.data);
			for (var s:String in _rq.data)
				trace("		-> var : " + s + ": " + _rq.data[s]);
			trace("====");
			//
			_loarder.load(_rq);
			_loarder.dataFormat	= URLLoaderDataFormat.TEXT;
		}
		
		public function close():void
		{
			try{
				_loarder.close();
			}catch(err:Error){
				
			}
		}
		
		public function get url():String 
		{
			return _url;
		}
		
		public function set url(value:String):void 
		{
			_url = value;
		}
		
		public function get result():String 
		{
			return _result;
		}
		
		public function get xml():XML
		{
			return new XML(result);
		}
		
		public function get headers():Array 
		{
			return _headers;
		}
		
		public function set headers(value:Array):void 
		{
			_headers = value;
		}
		
	}

}