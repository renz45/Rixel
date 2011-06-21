package org.rixel.Core.main
{
	import org.osflash.signals.Signal;
	import org.rixel.Core.displayObjects.IDisplayable;
	import org.rixel.Core.mouse.IMouseTriggerable;
	import org.rixel.Core.quadtree.IRxProxy;
	import org.rixel.Core.mouse.RxComponent_Mouse;

	public class Abstract_internalDisplayObject
	{
		protected var _component_collision:RxComponent_Collision;
		protected var _component_displayable:IDisplayable;
		protected var _component_quadtreeProxy:IRxProxy;
		protected var _component_mouse:RxComponent_Mouse;
		
		public function Abstract_internalDisplayObject()
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
		
		public function get collision():RxComponent_Collision 
		{
			return _component_collision;
		}
		///////////////INTERNAL///////////////
		internal function get componentMouse():IMouseTriggerable
		{
			return _component_mouse;
		}
		
		internal function get componentProxy():IRxProxy
		{
			return _component_quadtreeProxy;
		}
		
		internal function get componentDisplayable():IDisplayable
		{
			return _component_displayable;
		}
		
		internal function update():void
		{
			_component_collision.update();
		}
	}
}