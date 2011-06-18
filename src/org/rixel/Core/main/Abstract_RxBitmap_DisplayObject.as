package org.rixel.Core.main
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import org.osflash.signals.Signal;

	public class Abstract_RxBitmap_DisplayObject implements IBitmapRender, IDisplayable
	{
		protected var _x:int;
		protected var _y:int;
		protected var _width:int;
		protected var _height:int;
		protected var _transparent:Boolean;
		protected var _fillColor:uint;
		
		protected var _imageData:BitmapData;
		protected var _dataLoaded:Boolean;
		protected var _params:Object;
		
		public var Event_MovieclipLoaded:Signal;
		
		public function Abstract_RxBitmap_DisplayObject(params:Object = null)
		{
			if(params == null)
			{
				_params = {};
			}else{
				_params = params;
			}
			parseParams();
			init();
		}
		
		private function init():void
		{
			
			_width = 0;
			_height = 0;
			_dataLoaded = false;
			
			initEvents();
		}
		
		private function parseParams():void
		{
			if( _params.hasOwnProperty("transparent") )
			{
				_transparent = _params['transparent'];
			}else{
				_transparent = true;
			}
			
			if( _params.hasOwnProperty("fillColor") )
			{
				_fillColor = _params['fillColor'];
			}else{
				_fillColor = 0xFFFFFF;
			}
		}
		
		private function initEvents():void
		{
			Event_MovieclipLoaded = new Signal(Abstract_RxBitmap_DisplayObject);
		}
		
		/////////////////////CALLBACKS////////////////////
	
		////////////////////PUBLIC METHODS/////////////////
		
		////////////////////GETTERS SETTERS////////////////
		
		public function get x():int
		{
			return _x;
		}
		
		public function set x(value:int):void
		{
			_x = value;
		}
		
		public function get y():int
		{
			return _y;
		}
		
		public function set y(value:int):void
		{
			_y = value;
		}
		
		public function get boundsX():int
		{
			throw new Error("The method get boundsX must be overridden when extending the abstract class RxBitmap_DisplayObject");
		}
		
		public function get boundsY():int
		{
			throw new Error("The method get boundsX must be overridden when extending the abstract class RxBitmap_DisplayObject");
		}
		
		public function get xOffset():int
		{
			throw new Error("The method get xOffset must be overridden when extending the abstract class RxBitmap_DisplayObject");
		}
		
		public function get yOffset():int
		{
			throw new Error("The method get yOffset must be overridden when extending the abstract class RxBitmap_DisplayObject");
		}
		
		public function get width():int
		{
			return _width;
		}
		
		public function set width(value:int):void
		{
			_width = value;
		}
		
		public function get height():int
		{
			return _height;
		}
		
		public function set height(value:int):void
		{
			_height = value;
		}

		public function get frame():BitmapData
		{
			throw new Error("The method get frame must be overridden when extending the abstract class RxBitmap_DisplayObject");
		}
		
		public function get collisionFrame():BitmapData
		{
			throw new Error("The method get collisionFrame must be overridden when extending the abstract class RxBitmap_DisplayObject");
		}	
		
	}
}