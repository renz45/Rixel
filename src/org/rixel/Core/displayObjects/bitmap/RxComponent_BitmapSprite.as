package org.rixel.Core.displayObjects.bitmap
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import org.rixel.Core.displayObjects.VO.Sprite_VO;

	public class RxComponent_BitmapSprite extends Abstract_RxBitmap_DisplayObject
	{	
		
		private var _className:String;
		private var _displayObjectClass:Class;
		private var _frameData:BitmapData;
		private var _xOffset:int;
		private var _yOffset:int;

		private static var _displayObjectList:Object;
		private static var _placeHolderData:BitmapData;
		
		public function RxComponent_BitmapSprite(sprite:Class, params:Object = null)
		{
			super(params);
			
			_displayObjectClass = sprite;
			_className = (sprite as Class).toString();
			
			init(); 
		}
		
		protected function init():void
		{
			_x = 0;
			_y = 0;
			
			var vo:Sprite_VO;
			
			if( !_displayObjectList.hasOwnProperty(_className) )
			{	
				var newClass:Sprite = new _displayObjectClass();
				
				if( !(newClass is Sprite) )
				{
					throw new Error("The class argument must be of type Sprite");
				}
				
				vo = new Sprite_VO();
				vo.name = _className;
				
				_displayObjectList[_className] = vo;
				
				convertSprite(newClass); 
			}else{
				vo = (_displayObjectList[_className] as Sprite_VO);
				_frameData = vo.frame;
				_xOffset = vo.xOffset;
				_yOffset = vo.yOffset;
				_height = vo.height;
				_width = vo.width;
			}
		}
		//FIXME might need to fix a bug where borders are getting cut off in the bitmap conversion process
		private function convertSprite(sprite:Sprite):void
		{
			var vo:Sprite_VO = _displayObjectList[_className] as Sprite_VO;
			var sp:Sprite = new Sprite();
			var bounds:Rectangle = sprite.getBounds(sprite);
			vo.width = _width = sprite.width;
			vo.height= _height = sprite.height;
			vo.xOffset = _xOffset = bounds.x;
			vo.yOffset = _yOffset = bounds.y;
			
			sp.addChild(sprite);
			sprite.x = -_xOffset;
			sprite.y = -_yOffset;
			
			_frameData = new BitmapData(sp.width,sp.height,_transparent,_fillColor);
			_frameData.draw(sp);
			
			vo.frame = _frameData;
			
			sprite = null;
			sp = null;
			Event_Loaded.dispatch(this);
		}

		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS/////////////////
		
		
		////////////////////GETTERS SETTERS////////////////
		
		
		//////////////////engine specific/////////////
		
		//these render values will account for the offset of the movieclip. So if a registration point was in the center the position will be the same
		//the function is a engine specific function since users don't need to see these values.
		override public function get boundsX():int
		{
			return _x + _xOffset;
		}
		
		override public function get boundsY():int
		{
			return _y + _yOffset;
		}
		
		override public function get xOffset():int
		{
			return _xOffset;
		}
		
		override public function get yOffset():int
		{
			return _yOffset;
		}
		
		//engine specific function used by the Stage2D to render the image.
		override public function get frame():BitmapData 
		{
			if(_frameData)
			{
				return _frameData; 
			}else{
				return _placeHolderData;
			}
		}
		
		//used for bitmap data collision so the frame doesn't get advanced to the next frame
		override public function get collisionFrame():BitmapData
		{
			if(_frameData)
			{
				return _frameData; 
			}else{
				return _placeHolderData;
			}
		}
		
		///////////////////STATICS////////////////////////
		public static function init():void
		{
			_displayObjectList = {};
			_placeHolderData = new BitmapData(1,1,false);
		}

		
	}
}