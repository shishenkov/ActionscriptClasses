package us.flashmx.tools 
{
	import away3d.animators.nodes.SpriteSheetClipNode;
	import away3d.animators.SpriteSheetAnimationSet;
	import away3d.animators.SpriteSheetAnimator;
	import away3d.materials.SpriteSheetMaterial;
	import away3d.textures.Texture2DBase;
	import away3d.tools.helpers.SpriteSheetHelper;
	import away3d.tools.utils.TextureUtils;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author Nikolay Shishenkov
	 */
	public class AW3D_Tools 
	{
		
		public function AW3D_Tools() 
		{
			
		}
		
		public static function autoResizeBitmapData(bmData:BitmapData,smoothing:Boolean = true):BitmapData 
		{
			if (TextureUtils.isBitmapDataValid(bmData))
			return bmData;
			 
			var max:Number = Math.max(bmData.width, bmData.height);
			max = TextureUtils.getBestPowerOf2(max);
			var mat:Matrix = new Matrix();
			mat.scale(max/bmData.width, max/bmData.height);
			var bmd:BitmapData = new BitmapData(max, max, true, 0);
			bmd.draw(bmData, mat, null, null, null, smoothing);
			return bmd;
		}
		
		
		//
		public static function prepareSpritesheetAnimationFromMovieClip(_sourceMC:MovieClip, _cols:int, _animationId:String = 'texture_animation', _ratio:Number = .5, _transparent:Boolean = false, _bgColor:int = 0xFFFFFF, _maxSheetSize:int = 2048):Object
		{
			var _result:Object		= { };
			//
			var _spriteSheetHelper:SpriteSheetHelper	= new SpriteSheetHelper();
			var _rows:int, _width:int, _height:int, _sheetsCount:int;
			//
			_width			= int(_maxSheetSize / _cols);
			_height			= _width * _ratio;
			_rows			= int(_maxSheetSize / _height);
			_sheetsCount	= Math.ceil(_sourceMC.totalFrames / (_rows * _cols));
			//
			var _spriteSheet:Vector.<Texture2DBase> 	= _spriteSheetHelper.generateFromMovieClip(_sourceMC, _cols, _rows, _width, _height, _transparent, _bgColor);
			var _mat:SpriteSheetMaterial					= new SpriteSheetMaterial(_spriteSheet);
			var _animationSet:SpriteSheetAnimationSet	= new SpriteSheetAnimationSet();
			var _animationNode:SpriteSheetClipNode		= _spriteSheetHelper.generateSpriteSheetClipNode(_animationId, _cols, _rows, _sheetsCount);
			_animationSet.addAnimation(_animationNode);
			var _animator:SpriteSheetAnimator			= new SpriteSheetAnimator(_animationSet);
			//
			_result['SpriteSheet']	= _spriteSheet;
			_result['Material']		= _mat;
			_result['Animator']		= _animator;
			return _result;
		}
		
	}

}