//TODO create a RxVector class or some sort of graphics API use so the bitmaps can be scaled and rotated
//TODO bitmap Graphics API for drawing boxes, lines circles
//FIXME work out how to store x y width height in this main class and have the Idisplayable and quadtreeProxy reference it without needing their own variables.
package org.rixel.Core.displayObjects
{
	import flash.display.BitmapData;
	
	import org.rixel.Core.main.Abstract_internalDisplayObject;
	import org.rixel.Core.main.RxComponent_Collision;
	import org.rixel.Core.main.RxComponent_QuadtreeProxyObject;
	import org.rixel.Core.mouse.IMouseTriggerable;
	import org.rixel.Core.mouse.RxComponent_Mouse;
	import org.rixel.Core.quadtree.IRxProxy;

	public class Abstract_RxDisplayObject extends Abstract_internalDisplayObject
	{
		protected var _x:int;
		protected var _y:int;
		protected var _width:int;
		protected var _height:int;
		
		public function Abstract_RxDisplayObject()
		{

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
			_component_displayable.x = value;
			_component_quadtreeProxy.x = value;
		}
		
		public function get y():int
		{
			return _component_displayable.y;
		}
		
		public function set y(value:int):void
		{
			_component_displayable.y = value;
			_component_quadtreeProxy.y = value;
		}
		
		public function get frameData():BitmapData
		{
			return _component_displayable.staticFrame;
		}


		/////////////////////INTERNAL///////////////////
		
		
	}
}