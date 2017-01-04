package us.flashmx.display 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Nick Shishenkov <n@vc.am>
	 */
	public class SimpleImageLoader extends Sprite 
	{
		private var _hasBitmapData:Boolean	= false;
		private var _bitmap:Bitmap;
		private var _url:String			= "";
		private var _smoothing:Boolean	= true;
		private var _l:Loader			= new Loader;
		private var _originalSize:Point	= new Point;
		//
		public function SimpleImageLoader(imageURL:String = "") 
		{
			super();
			//
			if (imageURL.length > 0)
			{
				load(imageURL);
			}
		}
		
		public function load(imageURL:String):void
		{
			removeChildren();
			//
			_hasBitmapData	= false;
			
			//
			_url = imageURL;
			
			//
			_l.load(new URLRequest(_url));
			
			//
			if (!_l.contentLoaderInfo.hasEventListener(Event.COMPLETE))
			{
				_l.contentLoaderInfo.addEventListener(Event.COMPLETE, _onLoadComplete);
				_l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onLoadError);
			}
		}
		
		private function _onLoadError(e:IOErrorEvent):void 
		{
			trace(" -> ERROR: " + e.toString())
			trace("	-> URL: " + url);
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		
		private function _onLoadComplete(e:Event):void 
		{
			_hasBitmapData	= _l.content is Bitmap;
			//
			if ( hasBitmapData ){
				
				_bitmap	= _l.content as Bitmap;
				
				//
				bitmap.smoothing	= smoothing;
				
				//
				addChild(bitmap);
				
				//
				_originalSize	= new Point(bitmap.width, bitmap.height);
				
				//
				dispatchEvent(new Event(Event.COMPLETE));
				
			}else {
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			}
		}
		
		public function get url():String 
		{
			return _url;
		}
		
		public function get smoothing():Boolean 
		{
			return _smoothing;
		}
		
		public function set smoothing(value:Boolean):void 
		{
			_smoothing = value;
			
			//update smoothing state
			if(bitmap != null)
				bitmap.smoothing	= smoothing;
		}
		
		public function get bitmap():Bitmap 
		{
			return _bitmap;
		}
		
		public function get originalSize():Point 
		{
			return _originalSize;
		}
		
		public function get ratio():Number 
		{
			return originalSize.x == 0 || originalSize.y == 0 ? 1 : originalSize.x / originalSize.y;
		}
		
		public function get hasBitmapData():Boolean 
		{
			return _hasBitmapData;
		}
		
	}

}