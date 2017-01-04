package us.flashmx.net 
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author	Nick Shishenkov <n@vc.am>
	 */
	public class LargeFileLoader extends EventDispatcher 
	{
		private var _url:String				= "";
		private var _filePath:String		= "";
		private var _fileStream:FileStream	= new FileStream;
		private var _urlStream:URLStream	= new URLStream;
		private var _localFile:File;
		private var _bytesLoaded:Number
		public function LargeFileLoader() 
		{
			super(null);
			
			//
			_urlStream.addEventListener(Event.OPEN, _onOpen, false, int.MIN_VALUE, true);
			_urlStream.addEventListener(ProgressEvent.PROGRESS, _onProgress, false, int.MIN_VALUE, true);
			_urlStream.addEventListener(Event.COMPLETE, _onComplete, false, int.MIN_VALUE, true);
			_urlStream.addEventListener(IOErrorEvent.IO_ERROR, _onError, false, int.MIN_VALUE, true);
			_urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError, false, int.MIN_VALUE, true);
			_urlStream.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, _onHTTPStatus, false, int.MIN_VALUE, true);
			_urlStream.addEventListener(HTTPStatusEvent.HTTP_STATUS, _onHTTPStatus, false, int.MIN_VALUE, true);
		}
		
		private function _onHTTPStatus(e:HTTPStatusEvent):void 
		{
			dispatchEvent(e.clone());
		}
		
		public function load(remoteURL:String, localPath:String, overwrite:Boolean = true):void
		{
			_url		= remoteURL;
			_filePath	= localPath;
			//
			_localFile		= new File(_filePath);
			_bytesLoaded	= 0;
			
			//
			if (overwrite && _localFile.exists)
			{
				_localFile.deleteFile();
			}
			//
			_urlStream.load(new URLRequest(url));
			_fileStream.open(_localFile, FileMode.APPEND);
		}
		
		private function _onOpen(e:Event):void 
		{
			dispatchEvent(e.clone());
		}
		
		private function _onSecurityError(e:SecurityErrorEvent):void 
		{
			dispatchEvent(e.clone());
		}
		
		private function _onError(e:IOErrorEvent):void 
		{
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, e.text));
		}
		
		private function _onProgress(e:ProgressEvent):void 
		{
			//
			trace(" -> _onProgress: " + _urlStream.length + " | " + e.bytesLoaded + " / " + e.bytesTotal);
			//
			_writeStreamBytes();
			//
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, e.bytesLoaded, e.bytesTotal));
		}
		
		private function _onComplete(e:Event):void 
		{
			_writeStreamBytes();
			//
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function _writeStreamBytes():void
		{
			var bytes:ByteArray = new ByteArray();
			_urlStream.readBytes( bytes );
			_fileStream.writeBytes( bytes );
			
			//
			_bytesLoaded	+= bytes.length;
			
			//clear buffer (if the array stays non-null it will lead to a memmory leak
			bytes	= null;
			
		}
		
		public function get url():String 
		{
			return _url;
		}
		
		public function get filePath():String 
		{
			return _filePath;
		}
		
		public function get bytesLoaded():Number 
		{
			//_localFile.size;
			return _bytesLoaded;
		}
		
		
		public function dispose():void
		{
			try{ _fileStream.close(); }catch (err:Error){};
			
			//
			try{ _urlStream.close(); }catch (err:Error){};
			
			//
			_urlStream.removeEventListener(Event.OPEN, _onOpen);
			_urlStream.removeEventListener(ProgressEvent.PROGRESS, _onProgress);
			_urlStream.removeEventListener(Event.COMPLETE, _onComplete);
			_urlStream.removeEventListener(IOErrorEvent.IO_ERROR, _onError);
			_urlStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);
			_urlStream.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, _onHTTPStatus);
			_urlStream.removeEventListener(HTTPStatusEvent.HTTP_STATUS, _onHTTPStatus);
			
			//
			_urlStream	= null;
			_fileStream	= null;
			
			//
			System.gc();
		}
	}

}