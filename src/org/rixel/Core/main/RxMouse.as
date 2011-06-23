//TODO tweak the mouse so the mouseOver event only gets fired to the top most element and not all elements colliding with the mouse
//TODO find a more elegent way to provide mouse functionality. This works but it feels a tad hacky.
package org.rixel.Core.main
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import org.rixel.Core.collision.CollisionType;
	import org.rixel.Core.displayObjects.Abstract_RxDisplayObject;
	import org.rixel.Core.displayObjects.IDisplayable;
	import org.rixel.Core.mouse.IMouseTriggerable;
	import org.rixel.Core.quadtree.IRxProxy;
	import org.rixel.Core.quadtree.RxQuadTree;
	
	/**
	 * translates mouse actions to the bitmap displayObjects. This class calls functions in the RxComponent_mouse component. 
	 * @author adamrensel
	 * 
	 */	
	public class RxMouse extends Abstract_internalDisplayObject implements IDisplayable
	{
		private var _x:int;
		private var _y:int; 
		private var _bmd:BitmapData;
		
		private var _width:int;
		private var _height:int;
		
		private var _quadTree:RxQuadTree;
		private var _rolloverCollision:RxComponent_Collision;
		private var _clickCollision:RxComponent_Collision;
		
		private var _mouseItem:IMouseTriggerable;
		private var _mouseAction:String;
		
		private var _stage:RxStage;
		
		private var _hasCollideded:Boolean;
		private var _collideTarget:Abstract_RxDisplayObject;
		
		private const MOUSE_DOWN:String = "mouseDown";
		private const MOUSE_UP:String = "mouseUp";
		private const MOUSE_CLICK:String = "mouseClick";
		
		/**
		 * 
		 * @param quadTree RxQuadTree
		 * @param rxStage
		 * @private
		 */		
		public function RxMouse(quadTree:RxQuadTree,rxStage:RxStage)
		{
			_quadTree = quadTree;
			_stage = rxStage;
			init();
		}
		
		private function init():void
		{
			_hasCollideded = false;
			
			_width = 8;
			_height = 8;
			
			_x = 1;
			_y = 1;
			
			_bmd = new BitmapData(_width,_height,false,0x000000);
			
			_component_quadtreeProxy = new RxComponent_QuadtreeProxyObject(this);
			
			initListeners()
			insertIntoTree();
		}
		
		override protected function setupDisplayable():void
		{
			
		}
		
		private function initListeners():void
		{
			_rolloverCollision = new RxComponent_Collision(this,_component_quadtreeProxy,CollisionType.TYPE_PIXEL_PERFECT);
			_rolloverCollision.Event_mouseCollision.add(onCollide);
			
			_clickCollision = new RxComponent_Collision(this,_component_quadtreeProxy,CollisionType.TYPE_PIXEL_PERFECT);
			_clickCollision.Event_mouseCollision.add(onClick);
			
			_stage.addEventListener(MouseEvent.CLICK,stageClick);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, stageDown);
			_stage.addEventListener(MouseEvent.MOUSE_UP, stageUp);
		}
		
		private function stageClick(e:MouseEvent):void
		{
			_mouseAction = MOUSE_CLICK;
			_clickCollision.update();
		}
		
		private function stageDown(e:MouseEvent):void
		{
			_mouseAction = MOUSE_DOWN;
			_clickCollision.update();
		}
		
		private function stageUp(e:MouseEvent):void
		{
			_mouseAction = MOUSE_UP;
			_clickCollision.update();
		}
		
		
		private function insertIntoTree():void
		{
			_quadTree.createProxy(_component_quadtreeProxy);
		}
		
		private function onCollide(rxMouse:Abstract_internalDisplayObject, item:Abstract_RxDisplayObject):void
		{
			if(item.componentMouse is IMouseTriggerable && !_hasCollideded)
			{
				_mouseItem = (item.componentMouse as IMouseTriggerable);
				_mouseItem.RxMouseOver(_x,_y);
				
				_collideTarget = item;
				_hasCollideded = true;
			}
		}
		
		private function onClick(rxMouse:Abstract_internalDisplayObject, item:Abstract_RxDisplayObject):void
		{			
			if(item.componentMouse is IMouseTriggerable)
			{
				_mouseItem = (item.componentMouse as IMouseTriggerable);
				switch(_mouseAction)
				{
					case MOUSE_CLICK:
						_mouseItem.RxMouseClick(_x,_y);
						break;
					case MOUSE_DOWN:
						_mouseItem.RxMouseDown(_x,_y);
						break;
					case MOUSE_UP:
						_mouseItem.RxMouseUp(_x,_y);
						break;
				}
				
			}
		}
		
		////////////////GETTERS/SETTERS////////////////
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
		
		public function get width():int
		{
			return _width;
		}
		
		public function get xOffset():int
		{
			return 0;
		}
		
		public function get yOffset():int
		{
			return 0;
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
		
		public function get staticFrame():BitmapData
		{
			return _bmd;
		}
		
		public function get boundsX():int
		{
			return _x;
		}
		
		public function get boundsY():int
		{
			return _y;
		}
		
		/////////////////////////static/////////////////////
		override internal function get componentProxy():IRxProxy
		{
			return _component_quadtreeProxy;
		}
		
		override internal function get componentDisplayable():IDisplayable
		{
			return this;
		}
		
		override internal function update():void
		{
			_x = _stage.mouseX;
			_y = _stage.mouseY;
			_component_quadtreeProxy.x = _x;
			_component_quadtreeProxy.y = _y;
			
			
			_quadTree.moveProxy(_component_quadtreeProxy.proxyId);
			
			if(_hasCollideded)
			{
				if(!_rolloverCollision.hitTest(_x,_y,_collideTarget,_collideTarget.x,_collideTarget.y))
				{
					_hasCollideded = false;
					_collideTarget.componentMouse.RxMouseOut(_x,_y);
				}
			}else{
				_rolloverCollision.update();
			}
		}
		
	}
}