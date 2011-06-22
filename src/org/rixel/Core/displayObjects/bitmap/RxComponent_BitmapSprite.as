package org.rixel.Core.displayObjects.bitmap
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import org.rixel.Core.displayObjects.VO.Sprite_VO;

	/**
	 * Bitmap version of the Flash sprite class. There isn't any transformation or displayObjectContainer functionality, this class is just for static images.
	 * 
	 * @author adamrensel
	 * 
	 */	
	public class RxComponent_BitmapSprite extends Abstract_RxBitmap_DisplayObject
	{	
		
		private var _className:String;
		private var _displayObjectClass:Class;
		private var _frameData:BitmapData;
		private var _xOffset:int;
		private var _yOffset:int;

		private static var _displayObjectList:Object;
		private static var _placeHolderData:BitmapData;
		
		/**
		 * constructor for creating a RxSprite. 
		 * @param spriteClass : Class This is not an instance of the sprite, it is the classname of the sprite. The RxSprite class will decide if it can reuse
		 * data previously converted, or if it needs to create and convert a new instance of the sprite Class passed in.
		 * @param params : Object settings object for the RxSprite class. The current settings are {fillColor:0x00000000, transparent:true}
		 * 
		 */			
		public function RxComponent_BitmapSprite(spriteClass:Class, params:Object = null)
		{
			super(params);
			
			if(_displayObjectList == null)
			{
				throw new Error("Please initialize Rixel before instantiating the RxSprite --> Rixel.init()");
			}
			
			_displayObjectClass = spriteClass;
			_className = (spriteClass as Class).toString();
			
			init(); 
		}
		
		protected function init():void
		{
			_x = 0;
			_y = 0;
			
			var vo:Sprite_VO;
			
			//check to see if data for this class exists in memory
			if( !_displayObjectList.hasOwnProperty(_className) )
			{	
				var newClass:Sprite = new _displayObjectClass();
				
				//throw an error if the class isnt a sprite
				if( !(newClass is Sprite) )
				{
					throw new Error("The class argument must be of type Sprite");
				}
				
				vo = new Sprite_VO();
				vo.name = _className;
				
				//create a new slot in the static storage vector
				_displayObjectList[_className] = vo;
				
				//convert the sprite class to bitmapData
				convertSprite(newClass); 
			}else{//if the class exists in memory, than pull out the data and plug it into this RxSprite object
				vo = (_displayObjectList[_className] as Sprite_VO);
				_frameData = vo.frame;
				_xOffset = vo.xOffset;
				_yOffset = vo.yOffset;
				_height = vo.height;
				_width = vo.width;
			}
		}
		//FIXME might need to fix a bug where borders are getting cut off in the bitmap conversion process
		
		/**
		 * Convert a Sprite to bitmapData, the offset of the x and y are found if the registration point isn't in the top left and accounted for in creation.
		 * @private
		 * @param sprite Sprite
		 * 
		 */		
		private function convertSprite(sprite:Sprite):void
		{
			var vo:Sprite_VO = _displayObjectList[_className] as Sprite_VO;
			var bounds:Rectangle = sprite.getBounds(sprite);
			
			//set vo properties
			vo.width = _width = sprite.width;
			vo.height= _height = sprite.height;
			vo.xOffset = _xOffset = bounds.x;
			vo.yOffset = _yOffset = bounds.y;
			
			//use a matrix to counter a registration point that isn't top left, this fixes the issue where the drawn bitmapData is cut off
			var m:Matrix = new Matrix();
			m.tx = -bounds.x;
			m.ty = -bounds.y;
			
			//draw the bitmapData
			_frameData = new BitmapData(sprite.width,sprite.height,_transparent,_fillColor);
			_frameData.draw(sprite,m);
			
			vo.frame = _frameData;
			
			sprite = null;
			bounds = null;
			
			//dispatch loaded event
			Event_Loaded.dispatch(this);
		}

		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS/////////////////
		
		
		////////////////////GETTERS SETTERS////////////////
		
		
		//////////////////engine specific/////////////
		
		//these render values will account for the offset of the movieclip. So if a registration point was in the center the position will be the same
		//the function is a engine specific function since users don't need to see these values.
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */	
		override public function get boundsX():int
		{
			return _x + _xOffset;
		}
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */	
		override public function get boundsY():int
		{
			return _y + _yOffset;
		}
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */	
		override public function get xOffset():int
		{
			return _xOffset;
		}
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */	
		override public function get yOffset():int
		{
			return _yOffset;
		}
		
		//engine specific function used by the Stage2D to render the image.
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */	
		override public function get incrementFrame():BitmapData 
		{
			if(_frameData)
			{
				return _frameData; 
			}else{
				return _placeHolderData;
			}
		}
		
		//used for bitmap data collision so the frame doesn't get advanced to the next frame
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */	
		override public function get staticFrame():BitmapData
		{
			if(_frameData)
			{
				return _frameData; 
			}else{
				return _placeHolderData;
			}
		}
		
		///////////////////STATICS////////////////////////
		/**
		 * @private 
		 * 
		 */		
		public static function init():void
		{
			_displayObjectList = {};
			_placeHolderData = new BitmapData(1,1,false);
		}

		
	}
}