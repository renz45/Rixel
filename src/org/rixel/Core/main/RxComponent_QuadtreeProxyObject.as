package org.rixel.Core.main
{
	import org.rixel.Core.displayObjects.IDisplayable;
	import org.rixel.Core.quadtree.IRxProxy;
	import org.rixel.Core.quadtree.RxQuadTreeNode;
	import org.rixel.Core.quadtree.RxQuadTreeProxy;

	public class RxComponent_QuadtreeProxyObject implements IRxProxy
	{
		private var _x:int;
		private var _y:int;
		private var _width:int;
		private var _height:int;
		private var _proxy:RxQuadTreeProxy; 
		private var _proxyId:int;
		private var _displayable:IDisplayable;
		private var _displayObject:Abstract_internalDisplayObject;
		
		public function RxComponent_QuadtreeProxyObject(displayObject:Abstract_internalDisplayObject)
		{
			_displayable = displayObject.componentDisplayable;
			_displayObject = displayObject;
		}
		
		public function set x(value:int):void
		{
			_x = value;
		}
		
		public function set y(value:int):void
		{
			_y = value;
		}
		
		public function set width(value:int):void
		{
			_width = value;
		}
		
		public function set height(value:int):void
		{
			_height = value;
		}
		
		public function get xmin():int
		{
			return _x;
		}
		
		public function get xmax():int
		{
			return _x + _width;
		}
		
		public function get ymin():int
		{
			return _y;
		}
		
		public function get ymax():int
		{
			return _y + _height;
		}
		
		public function get proxy():RxQuadTreeProxy
		{
			return _proxy;
		}
		
		public function set proxy(value:RxQuadTreeProxy):void
		{
			_proxy = value;	
		}
		
		public function get proxyId():int
		{
			return _proxyId;
		}
		
		public function set proxyId(value:int):void
		{
			_proxyId = value;
		}
		
		public function get node():RxQuadTreeNode
		{
			return _proxy.node;
		}
		
		public function get displayable():IDisplayable
		{
			return _displayable;
		}
		
		public function set displayable(value:IDisplayable):void
		{
			_displayable = value;
		}
		
		public function get displayObject():Abstract_internalDisplayObject
		{
			return _displayObject;
		}
		
		public function set displayObject(value:Abstract_internalDisplayObject):void
		{
			_displayObject = value;
		}
		
		///////////////CALLBACKS///////////////
		///////////PUBLIC FUNCTIONS////////////
		////////////GETTERS SETTERS////////////
	}
}