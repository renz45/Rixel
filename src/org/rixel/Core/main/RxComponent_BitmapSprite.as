package org.rixel.Core.main
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class RxComponent_BitmapSprite extends Abstract_RxBitmap_DisplayObject
	{	
		
		private var _className:String;
		private var _displayObjectClass:Class;
		private var _frameData:BitmapData;

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
			if( !_displayObjectList.hasOwnProperty(_className) )
			{	
				var newClass:Sprite = new _displayObjectClass();
				
				if( !(newClass is Sprite) )
				{
					throw new Error("The class argument must be of type Sprite");
				}
				
				var vo:Sprite_VO = new Sprite_VO();
				vo.name = _className;
				
				_displayObjectList[_className] = vo;
				
				convertSprite(newClass); 
			}
		}

		private function convertSprite(sprite:Sprite):void
		{
			_frameData = new BitmapData(sprite.width,sprite.height,_transparent,_fillColor);
			
			_frameData.draw(sprite);
			
			Event_MovieclipLoaded.dispatch(this);
		}

		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS/////////////////
		
		
		////////////////////GETTERS SETTERS////////////////
		
		
		//////////////////engine specific/////////////
		
		//these render values will account for the offset of the movieclip. So if a registration point was in the center the position will be the same
		//the function is a engine specific function since users don't need to see these values.
		override public function get xOffset():int
		{
			return 0;
		}
		
		override public function get yOffset():int
		{
			return 0;
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