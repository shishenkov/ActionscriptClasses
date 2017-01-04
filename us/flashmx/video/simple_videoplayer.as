package us.flashmx.video 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.media.*;
	import flash.net.*;
	import flash.system.System;
	import flash.text.*;
	import flash.utils.*;
	
	/**
	 * ...
	 * @author Nick Shishenkov
	 * @email   <admin@flashmx.us>
	 * @version .1
	 */
	public class simple_videoplayer extends MovieClip 
	{
		public static const VIDOE_COMPLETE:String	= "us.flashmx.video.simple_videoplayer :: VIDEO COMPLETE";
		
		private var _ns:NetStream, _nc:NetConnection, _v:Video, _vUrl:String, _bmp:Bitmap, _bd:BitmapData, _container:MovieClip, _metaDataObj:Object, _loop:Boolean;
		private var _sv:StageVideo, _infoTxt:TextField, _delayPlayTimer:Timer;
		private var _StageVideoAvailable:int	= -1;
		
		private var _lastActionCall
		public function simple_videoplayer() 
		{
			_delayPlayTimer	= new Timer(2000, 1);
			_delayPlayTimer.addEventListener(TimerEvent.TIMER, _callDelayedPlayback);
			//
			addEventListener(Event.ADDED_TO_STAGE, _onStage); 
			init();
		}
		
		private function _callDelayedPlayback(e:TimerEvent):void 
		{
			_delayPlayTimer.stop();
			_delayPlayTimer.reset();
			//
			_ns.play(_vUrl);
		}
		
		private function _onStage(e:Event):void 
		{
			//removeEventListener(Event.ADDED_TO_STAGE, _onStage);
			//
			info("simple_videoplayer : _onStage")
		}
		
		private function init(e:* = null):void 
		{
			
			//removeEventListener(Event.ADDED_TO_STAGE, init);
			//
			_infoTxt	= new TextField();
			_v			= new Video();
			_bmp		= new Bitmap();
			_container	= new MovieClip();
			_nc			= new NetConnection();
			//
			_infoTxt.background	= true;
			_infoTxt.width		= 800;
			_infoTxt.selectable	= false;
			_infoTxt.multiline	= true;
			_infoTxt.autoSize	= TextFieldAutoSize.LEFT
			_infoTxt.x			= 400;
			_infoTxt.y			= 100;
			info("simple_videoplayer : init");
			//
			_nc.connect(null);
			//
			_ns			= new NetStream(_nc);
			//
			_ns.addEventListener(NetStatusEvent.NET_STATUS, _ns_status);
			_ns.addEventListener(IOErrorEvent.IO_ERROR, _ns_error);
			_ns.client	= { onMetaData: _ns_onMetaData , onCuePoint: _ns_onCuePoint };
			
			//
			container.addChild(_bmp);
			container.addChild(_v);
			container.addChild(_infoTxt);
			
			//
			addEventListener(VIDOE_COMPLETE, _onVideoComplete);
			
			//
			container.addEventListener(Event.ADDED_TO_STAGE, _onContainerAddedToStage);			
		}
		
		private function _onContainerAddedToStage(e:Event):void 
		{
			//removeEventListener(Event.ADDED_TO_STAGE, _onContainerAddedToStage);
			//trace("simple_videoplayer : _onContainerAddedToStage");
			//if (!container.stage.hasEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY))
				//container.stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, _onStageVideoState);
		}
		
		private function _onStageVideoState(e:StageVideoAvailabilityEvent):void 
		{
			_StageVideoAvailable	= int(e.availability == StageVideoAvailability.AVAILABLE); 
			_StageVideoAvailable	= 0;
			/*
			info('_onStageVideoState : ' + e);
			info('_onStageVideoState : ' + e.availability);
			info('_StageVideoAvailable : ' + _StageVideoAvailable);
			info(('_onStageVideoState : stageVideos : ' + container.stage.stageVideos.length));
			//trace(('_onStageVideoState : stageVideos : ' + container.stage.stageVideos[0]));
			*/
		}
		
		private function _onVideoComplete(e:Event):void 
		{
			if (!loop) return;
			//
			if (_bd == null)
			{
				_bd	= new BitmapData(_v.width, _v.height);
				container.cacheAsBitmap	= true;
				_bd.draw(container);
				container.cacheAsBitmap	= false;
				_bmp.bitmapData	= _bd;
			}
			//
			replay();
		}
		
		private function _ns_onCuePoint(o:Object):void 
		{
			
		}
		
		private function _ns_onMetaData(o:Object):void 
		{
			_metaDataObj	= o;
		}
		
		private function _ns_error(e:IOErrorEvent):void 
		{
			dispatchEvent(e);
		}
		
		private function _ns_status(e:NetStatusEvent):void 
		{
			switch(e.info.code)
			{
				case "NetStream.Play.Start": 
					//trace("Start [" + _ns.time.toFixed(3) + " seconds]"); 
					break; 
				case "NetStream.Play.Stop": 
					//trace("Stop [" + _ns.time.toFixed(3) + " seconds]");
					//
					if (Math.abs(_ns.time - duration) < .5)
					{
						dispatchEvent(new Event(VIDOE_COMPLETE));
					}
					
					break; 
			}
		}
		
		public function pause():void
		{
			if (_ns != null)
				_ns.pause();
		}
		
		public function resume():void
		{
			_ns.resume();
		}
		
		public function _stop():void
		{
			_ns.pause();
			_ns.seek(0);
		}
		
		public function _play(_src:String = ''):void
		{
			if (_src.length > 0)
			{
				source	= _src;
			}else {
				_ns.resume();
			}
		}
		
		public function set source(_s:String):void
		{
			var _delay:Boolean = false;
			
			//
			_vUrl	= _s;
			if (_ns != null)
			{
				_ns.close();
				_v.clear();
			}
			//
			if (_delay)
			{
				_delayPlayTimer.start();
			}else {
				_ns.play(_s);
			}
			
			if (_StageVideoAvailable > 0)
			{
				_sv	= container.stage.stageVideos[0];
				_sv.attachNetStream(_ns);
				_v.attachNetStream(null);
			}else{
				_v.attachNetStream(_ns);
				_v.smoothing	= true;
				_v.getRect(container.stage);
			}
		}
		
		public function get source():String
		{
			return _vUrl;
		}
		
		public function setSize(_w:Number, _h:Number):void
		{
			_v.width	= _w;
			_v.height	= _h;
			//
			if (_StageVideoAvailable > 0)
			{
				_sv.viewPort	= _v.getRect(container.stage);
			}
			//
		}
		
		public function get duration():Number
		{
			return Number(_metaDataObj.duration);
		}
		
		public function get loop():Boolean
		{
			return _loop;
		}
		
		public function set loop(_b:Boolean):void
		{
			_loop	= _b;
		}
		
		public function get container():MovieClip
		{
			return _container;
		}
		
		public function get time():Number 
		{
			return _ns!= null ? _ns.time : 0;
		}
		
		private function info(_inf:String = ''):void
		{
			if (_infoTxt == null)
			{
				trace("info : " + _inf);
				return;
			}
			//
			_infoTxt.text		= _inf + '\n' + _infoTxt.text;
			_infoTxt.visible	= false;
		}
		//
		public function replay():void
		{
			_ns.seek(0);
			_ns.resume();
		}
		//
		public function dispose():void
		{
			trace(" simple_videoplayer : dispose start ...")
			if (_ns != null) {
				trace(" simple_videoplayer : dispose NS")
				_ns.dispose();
			}
			if(_delayPlayTimer!= null){
				_delayPlayTimer.stop();
				trace(" simple_videoplayer : dispose : timer stop")
			}
			//
			_ns	= null;
			_nc	= null;
			//_delayPlayTimer	= null;
			//
			trace(" simple_videoplayer : dispose done")
			//System.gc();
		}
	}
}