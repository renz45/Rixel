package org.rixel.Core.displayObjects
{
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class DisplayObject2D
	{
		protected var _x:Number;
		protected var _y:Number;
		protected var _width:Number;
		protected var _height:Number;
		protected var _alpha:Number;
		protected var _transparent:Boolean;
		protected var _fillColor:uint;
		
		protected var _imageData:BitmapData;
		protected var _dataLoaded:Boolean;
		
		public function DisplayObject2D()
		{
			init();
		}
		
		protected function init():void
		{
			_width = 0;
			_height = 0;
			_x = 0;
			_y = 0;
			_alpha = 1;
			_transparent = true;
			_fillColor = 0xFFFFFF;
			_dataLoaded = false;
		}
		
		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS/////////////////
	
		
		
		////////////////////GETTERS SETTERS////////////////
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
		}
		
		public function get width():Number
		{
			return _width;
		}
		
		public function set width(value:Number):void
		{
			_width = value;
		}
		
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(value:Number):void
		{
			_height = value;
		}
		
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void
		{
			_alpha = value;
		}
		
		public function get frame():BitmapData
		{
			if(_imageData)
			{
				return _imageData;
			}else{
				return new BitmapData(1,1,true,0xffffff);
			}
		}
		
		public function get transparent():Boolean
		{
			return _transparent;
		}
		
		public function set transparent(value:Boolean):void
		{
			_transparent = value;
		}
		
		public function get fillColor():uint
		{
			return _fillColor;
		}
		
		public function set fillColor(value:uint):void
		{
			_fillColor = value;
		}
		
		
	}
}