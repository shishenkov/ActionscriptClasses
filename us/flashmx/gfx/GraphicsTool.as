package us.flashmx.gfx 
{
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author Nikolay Shishenkov
	 */
	public class GraphicsTool 
	{
		public static function drawRect(_target:MovieClip = null, _width:Number = 1, _height:Number = 1, _color:int = 0, _alpha:Number = 1, _centered:Boolean = false):MovieClip
		{
			_target	= _target == null ? new MovieClip() : _target;
			//
			_target.graphics.beginFill(_color, _alpha);
			_target.graphics.drawRect(_centered ? - _width / 2 : 0, _centered ? - _height / 2 : 0, _width, _height);
			_target.graphics.endFill();
			//
			return _target;
		}
		
		public static function drawCircle(_target:MovieClip = null, _radius:Number = 1, _color:int = 0, _alpha:Number = 1, _centered:Boolean = false):MovieClip
		{
			_target	= _target == null ? new MovieClip() : _target;
			//
			_target.graphics.beginFill(_color, _alpha);
			_target.graphics.drawCircle(_centered ? 0 : _radius, _centered ? 0 : _radius, _radius);
			_target.graphics.endFill();
			//
			return _target;
		}
		
		public static function colorTransform(_target:MovieClip, _color:int = 0):void
		{
			var _ct:ColorTransform	= _target.transform.colorTransform;
			_ct.color				= _color;
			//
			_target.transform.colorTransform	= _ct;
		}
		/////////////////////////////////
		public function GraphicsTool() {}
		
	}

}