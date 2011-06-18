package org.rixel.Core.main
{
	public class Abstract_RxDisplayObject extends Abstract_internalDisplayObject
	{
		protected var _x:int;
		protected var _y:int;
		protected var _width:int;
		protected var _height:int;
		
		protected var _component_collision:RxComponent_Collision;
		protected var _component_displayable:IDisplayable;
		protected var _component_quadtreeProxy:IRxProxy;
		protected var _component_mouse:RxComponent_Mouse;
		
		public function Abstract_RxDisplayObject()
		{
			init();
		}
		
		private function init():void
		{
			setupDisplayable();
			setupComponents();
		}
		
		protected function setupDisplayable():void
		{
			throw new Error("The setupDisplayable() method must be overridden where _component_displayable is defined, must be an instance of IDisplayable.");
		}
		
		private function setupComponents():void
		{
			_component_quadtreeProxy = new RxComponent_QuadtreeProxyObject(this);
			_component_collision = new RxComponent_Collision(_component_displayable,_component_quadtreeProxy);
			_component_mouse = new RxComponent_Mouse();
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
			_component_displayable.height = value;	
		}
		
		public function get width():int
		{
			return _component_displayable.width;
		}
		
		public function set width(value:int):void
		{
			_component_displayable.width = value
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
		
		public function get collision():RxComponent_Collision 
		{
			return _component_collision;
		}

		/////////////////////INTERNAL///////////////////
		internal function get componentMouse():IMouseTriggerable
		{
			return _component_mouse;
		}
		
		override internal function get componentProxy():IRxProxy
		{
			return _component_quadtreeProxy;
		}
		
		override internal function get componentDisplayable():IDisplayable
		{
			return _component_displayable;
		}
		
		override internal function update():void
		{
			_component_collision.update();
		}
	}
}