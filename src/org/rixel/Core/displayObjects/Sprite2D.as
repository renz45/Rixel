package org.rixel.Core.displayObjects
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import org.rixel.Core.displayObjects.VO.Sprite_VO;
	import org.rixel.Core.nameSpaces.rixel;

	public class Sprite2D extends DisplayObject2D
	{	
		protected var _className:String;
		protected var _displayObjectClass:Class;
		
		protected static var _displayObjectList:Object;
		
		public function Sprite2D(sprite:Class, params:Object = null)
		{
			super(params);
			
			_displayObjectClass = sprite;
			_className = (sprite as Class).toString();
			
			init();
		}
		
		protected function init():void
		{	
			var objectExists:Boolean = _displayObjectList.hasOwnProperty(_className);
			
			if( !objectExists )
			{	
				var vo:Sprite_VO = new Sprite_VO();
				vo.name = _className;
				
				_displayObjectList[_className] = vo;
			}
			
			if(!objectExists && _displayObjectClass is Sprite )
			{
				//create sprite assets
			}

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
		

		///////////////////STATICS////////////////////////
		rixel static function init():void
		{
			_displayObjectList = {};
		}

		

		
	}
}