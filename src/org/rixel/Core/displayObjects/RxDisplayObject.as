package org.rixel.Core.displayObjects
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import org.osflash.signals.Signal;
	import org.rixel.Core.main.QuadTree;
	import org.rixel.Core.main.QuadTreeNode;
	import org.rixel.Core.nameSpaces.rixel;

	use namespace rixel;
	
	public class RxDisplayObject
	{ 
		protected var _x:Number;
		protected var _y:Number;
		protected var _width:Number;
		protected var _height:Number;
		protected var _alpha:Number;
		protected var _transparent:Boolean;
		protected var _fillColor:uint;
		protected var _dirty:Boolean;
		
		protected var _imageData:BitmapData;
		protected var _dataLoaded:Boolean;
		protected var _params:Object;
		
		public var _parentNode:QuadTreeNode;
		
		public var Event_MovieclipLoaded:Signal;
		
		
		
		public function RxDisplayObject(params:Object = null)
		{
			if(params == null)
			{
				_params = {};
			}else{
				_params = params;
			}
			
			init();
		}
		
		private function init():void
		{
			//signals event code
			Event_MovieclipLoaded = new Signal(RxDisplayObject);
			
			_width = 0;
			_height = 0;
			_x = 0;
			_y = 0;
			_dataLoaded = false;
			
			
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
			
			if( _params.hasOwnProperty("alpha") )
			{
				_alpha = _params['alpha'];
			}else{
				_alpha = 1;
			}
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
			_dirty = true;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
			_dirty = true;
		}
		
		public function get width():Number
		{
			return _width;
		}
		
		public function set width(value:Number):void
		{
			_width = value;
			_dirty = true;
		}
		
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(value:Number):void
		{
			_height = value;
			_dirty = true;
		}
		
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void
		{
			_alpha = value;
			_dirty = true;
		}
		
		
		/////////////////////INTERNAL RIXEL METHODS//////////////////
		rixel function get frame():BitmapData
		{
			if(_imageData)
			{
				return _imageData;
			}else{
				return new BitmapData(1,1,true,0xffffff);
			}
		}
		
		rixel function get parentNode():QuadTreeNode
		{
			return _parentNode;
		}
		
		rixel function set parentNode(node:QuadTreeNode):void
		{
			_parentNode = node;
		}
		
	}
}