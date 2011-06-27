//TODO create a RxVector class or some sort of graphics API use so the bitmaps can be scaled and rotated
//TODO bitmap Graphics API for drawing boxes, lines circles
//FIXME work out how to store x y width height in this main class and have the Idisplayable and quadtreeProxy reference it without needing their own variables.
package org.rixel.Core.displayObjects
{
	import flash.display.BitmapData;
	
	import org.rixel.Core.Geometry.RxPoint;
	import org.rixel.Core.Geometry.RxRectangle;
	import org.rixel.Core.main.Abstract_internalDisplayObject;
	import org.rixel.Core.quadtree.RxQuadTreeProxy;

	public class Abstract_RxDisplayObject extends Abstract_internalDisplayObject
	{
		protected var _x:int;
		protected var _y:int;
		protected var _width:int;
		protected var _height:int;
		protected var _index:int;
		
		private var _rect:RxRectangle;
		
		public function Abstract_RxDisplayObject()
		{
			_rect = new RxRectangle();
			
			_width = _component_displayable.width;
			_height = _component_displayable.height;
		}
		
		///////////////CALLBACKS///////////////
		///////////PUBLIC FUNCTIONS////////////
		////////////GETTERS SETTERS////////////
		public function get height():int
		{
			return _component_displayable.height;
		}
		
		public function set height(value:int):void
		{
			//_component_displayable.height = value;	
			_height = value;
		}
		
		public function get width():int
		{
			return _component_displayable.width;
		}
		
		public function set width(value:int):void
		{
			//_component_displayable.width = value
			_width = value;
		}
		
		public function get x():int
		{
			return _component_displayable.x;
		}
		
		public function set x(value:int):void
		{
			_x = value;
			_component_displayable.x = value;
			_component_quadtreeProxy.x = value + _component_displayable.xOffset;
		}
		
		public function get y():int
		{
			return _component_displayable.y;
		}
		
		public function set y(value:int):void
		{
			_y = value;
			_component_displayable.y = value;
			_component_quadtreeProxy.y = value + _component_displayable.yOffset;
		}
		
		public function get frameData():BitmapData
		{
			return _component_displayable.staticFrame;
		}
		
		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}


		public function get testRect():RxRectangle
		{
			if(_component_quadtreeProxy.proxy)
			{
				/*_rect.x =  _component_quadtreeProxy.proxy.xl1;
				_rect.y =  _component_quadtreeProxy.proxy.yl1;
				_rect.width = _component_quadtreeProxy.proxy.xl2 - _component_quadtreeProxy.proxy.xl1;
				_rect.height = _component_quadtreeProxy.proxy.yl2 - _component_quadtreeProxy.proxy.yl1;*/
				
			}
			
			_rect.x = _x;
			_rect.y = _y;
			_rect.width = _width;
			_rect.height = _height;
			
			return _rect;
		}
		
		public function get bounds():RxPoint
		{
			return new RxPoint(_component_displayable.boundsX, _component_displayable.boundsY);
		}
		
		public function get prox():RxQuadTreeProxy
		{
			return _component_quadtreeProxy.proxy;
		}
		/////////////////////INTERNAL///////////////////
		
	}
}