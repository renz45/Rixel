package org.rixel.Core.displayObjects
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import org.rixel.Core.displayObjects.VO.Sprite_VO;
	import org.rixel.Core.nameSpaces.rixel;
	
	use namespace rixel;

	public class RxSprite extends RxDisplayObject
	{	
		
		protected var _className:String;
		protected var _displayObjectClass:Class;
		
		private var _frameData:BitmapData;
		
		protected static var _displayObjectList:Object;
		protected static var _placeHolderData:BitmapData;
		
		public function RxSprite(sprite:Class, params:Object = null)
		{
			super(params);
			
			_displayObjectClass = sprite;
			_className = (sprite as Class).toString();
			
			init(); 
		}
		
		protected function init():void
		{	
			_dirty = false;
			
			var objectExists:Boolean = _displayObjectList.hasOwnProperty(_className);

			if( !objectExists )
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
		public function get name():String
		{
			return _className;
		}
		
		public function set name(value:String):void
		{
			_className = value;
		}
		
		//////////////////engine specific/////////////
		
		//these render values will account for the offset of the movieclip. So if a registration point was in the center the position will be the same
		//the function is a engine specific function since users don't need to see these values.
		rixel function get renderX():Number
		{
			return _x;
		}
		
		rixel function get renderY():Number
		{
			return _y;
		}
		
		//engine specific function used by the Stage2D to render the image.
		override rixel function get frame():BitmapData 
		{
			if(_frameData)
			{
				return _frameData; 
			}else{
				return new BitmapData(1,1,false);
			}
			
		}

		rixel function get dirty():Boolean
		{
			return _dirty;
		}
		
		rixel function set dirty(value:Boolean):void
		{
			_dirty = value; 
		}
		
		///////////////////STATICS////////////////////////
		rixel static function init():void
		{
			_displayObjectList = {};
			_placeHolderData = new BitmapData(1,1,false);
		}

		
	}
}