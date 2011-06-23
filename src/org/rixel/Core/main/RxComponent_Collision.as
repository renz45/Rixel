//TODO investigate if a hitlist is needed for the collision event
package org.rixel.Core.main
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import org.rixel.Core.Geometry.RxRectangle;
	import org.rixel.Core.collision.CollisionSignal;
	import org.rixel.Core.collision.CollisionType;
	import org.rixel.Core.displayObjects.Abstract_RxDisplayObject;
	import org.rixel.Core.displayObjects.IDisplayable;
	import org.rixel.Core.quadtree.IRxProxy;
	import org.rixel.Core.quadtree.RxQuadTreeProxy;
	/**
	 * collision component for displayObjects. This class handles all collision related functionality. 
	 * @author adamrensel
	 * 
	 */	
	public class RxComponent_Collision
	{
		private var _displayObject:IDisplayable;
		private var _displayObject2:IDisplayable;
		private var _p1:Point;
		private var _p2:Point;
		private var _bmd:BitmapData;
		
		private var _x1:int;
		private var _x2:int;
		private var _y1:int;
		private var _y2:int;
		private var _x3:int;
		private var _y3:int;
		private var _width1:int;
		private var _width2:int;
		private var _width3:int;
		private var _height1:int;
		private var _height2:int;
		private var _originalWidth1:int;
		private var _originalWidth2:int;
		private var _originalX1:int;
		private var _originalX2:int;
		private var _originalY1:int;
		private var _originalY2:int;
		private var _boundingCircleRadius:Number;
		private var _rect1:RxRectangle;
		private var _rect2:RxRectangle;
		private var _testproxy:RxQuadTreeProxy;
		private var _proxyObject:IRxProxy;
		
		private var _xOffset:int;
		private var _yOffset:int;
		
		private var _collisionType:String;
		
		/**
		 * This signal is used to dispatch a signal when this object collides with another object on the RxStage. The resulting callback expects 2
		 * Abstract_internalDisplayObject's - all displayObjects are of this type.
		 * <p>
		 * var sp:RxSprite = new RxSprite(MySprite);
		 * 
		 * sp.collision.Event_collision.add(onCollide_Handler)
		 * 
		 * private function onCollide_Handler(target:Abstract_internalDisplayObject,collidedWith:Abstract_internalDisplayObject)
		 * {
		 * 	//do stuff
		 * }
		 * </p>
		 */		
		public var Event_collision:CollisionSignal;
		/**
		 * @private 
		 */		
		public var Event_mouseCollision:CollisionSignal;
		
		/**
		 * create a new instance of the collision class. 
		 * @param displayable IDisplayable renderer
		 * @param proxyObject IRxProxy Object used to search the internal quadtree for neighbors to check collision, this prevents the need to search every object on the screen
		 * @param type String constant used to set which collision type to use, the CollisionType class holds these constants.
		 * 
		 */		
		public function RxComponent_Collision(displayable:IDisplayable,proxyObject:IRxProxy,type:String = CollisionType.TYPE_PIXEL_PERFECT)
		{
			_displayObject = displayable;
			_proxyObject = proxyObject;
			_collisionType = type;
			
			init();
		}
		
		private function init():void
		{	
			
			_p1 = new Point();
			_p2 = new Point();
			
			_rect1 = new RxRectangle();
			_rect2 = new RxRectangle();
			
			initEvents();
		}
		
		/**
		 * initialize event signals 
		 * 
		 */		
		private function initEvents():void
		{
			Event_collision = new CollisionSignal(Abstract_internalDisplayObject,Abstract_internalDisplayObject);
			Event_mouseCollision = new CollisionSignal(Abstract_internalDisplayObject,Abstract_internalDisplayObject);
		}
		
		/**
		 * pixel perfect collison detection. Uses flashes built in bitmapData.hitTest. Fairly fast, especially with small objects 
		 * @param x1 int x coordinate of the displayObject that owns this component
		 * @param y1 int y coordinate of the displayObject that owns this component
		 * @param rxDisplayObject IDisplayable DisplayObject to check collision with
		 * @param x2 int x coordinate of given rxDisplayObject
		 * @param y2 int y coordinate of given rxDisplayObject
		 * @return Boolean true if there was a collision, false if not.
		 * 
		 */		
		private function pixelPerfect(x1:int,y1:int,rxDisplayObject:IDisplayable,x2:int,y2:int):Boolean
		{
			_p1.x = x1;
			_p1.y = y1;
			
			_p2.x = x2;
			_p2.y = y2;
			
			if(_displayObject.staticFrame.hitTest(_p1,255,rxDisplayObject.staticFrame,_p2) )
			{
				return true;
			}else{
				return false;
			}
		}
		//FIXME fix these two distance based collision to work with the offset reference point
		/**
		 * distance based collision class, the distance is based on the width of the 2 objects 
		 * @param x1 int x coordinate of the displayObject that owns this component
		 * @param y1 int y coordinate of the displayObject that owns this component
		 * @param rxDisplayObject IDisplayable DisplayObject to check collision with
		 * @param x2 int x coordinate of given rxDisplayObject
		 * @param y2 int y coordinate of given rxDisplayObject
		 * @return Boolean true if there was a collision, false if not.
		 * 
		 */		
		private function distanceRadiusBasedWidth(x1:int,y1:int,rxDisplayObject:IDisplayable,x2:int,y2:int):Boolean
		{	
			_x1 = (_displayObject.width*.5) + x1;
			_y1 = (_displayObject.height*.5) + x2;
			
			_width1 = _displayObject.width*.5;
			_width2 = rxDisplayObject.width*.5;
			
			_x2 = _width2 + x2;
			_y2 = (rxDisplayObject.height * .5) + y2;
			
			_x3 = _x1 - _x2;
			_y3 = _y1 - _y2;
			_width3 = _width1 + _width2;
		
			if((_x3) * (_x3) + (_y3) * (_y3) < _width3 * _width3)
			{
				return true;
			}else{
				return false
			}
		}
		
		/**
		 * distance based collision class, the distance is based on the height of the 2 objects 
		 * @param x1 int x coordinate of the displayObject that owns this component
		 * @param y1 int y coordinate of the displayObject that owns this component
		 * @param rxDisplayObject IDisplayable DisplayObject to check collision with
		 * @param x2 int x coordinate of given rxDisplayObject
		 * @param y2 int y coordinate of given rxDisplayObject
		 * @return Boolean true if there was a collision, false if not.
		 * 
		 */	
		private function distanceRadiusBasedHeight(x1:int,y1:int,rxDisplayObject:IDisplayable,x2:int,y2:int):Boolean
		{	
			_x1 = (_displayObject.width*.5) + x1;
			_y1 = (_displayObject.height*.5) + y1;
			
			_width1 = _displayObject.height*.5;
			_width2 = rxDisplayObject.height*.5;
			
			_x2 = _width2 + x2;
			_y2 = (rxDisplayObject.height * .5) + y2;
			
			_x3 = _x1 - _x2;
			_y3 = _y1 - _y2;
			_width3 = _width1 + _width2;
			
			if((_x3) * (_x3) + (_y3) * (_y3) < _width3 * _width3)
			{
				return true;
			}else{
				return false
			}
		}
		
		/**
		 * bounding box based collision. Similar to Flashes built in hitTestObject, uses bounding box intersections to determine hits
		 * @param x1 int x coordinate of the displayObject that owns this component
		 * @param y1 int y coordinate of the displayObject that owns this component
		 * @param rxDisplayObject IDisplayable DisplayObject to check collision with
		 * @param x2 int x coordinate of given rxDisplayObject
		 * @param y2 int y coordinate of given rxDisplayObject
		 * @return Boolean true if there was a collision, false if not.
		 * 
		 */		
		private function boundingBoxBased(x1:int,y1:int,rxDisplayObject:IDisplayable,x2:int,y2:int):Boolean
		{	
			_x1 = x1;
			_y1  = y1;
			_width1 = _displayObject.width;
			_height1 = _displayObject.height;
			
			_x2 = x2;
			_y2 = y2;
			_width2 = rxDisplayObject.width;
			_height2 = rxDisplayObject.height;
			
			if( !(_x1 > _x2 + _width2 || _y1 > _y2 + _height2 || _x1 + _width1 < _x2 || _y1 + _height1 < _y2) )
			{
				return true;
			}else{
				return false;
			}
		}
		
		/**
		 * bounding circle based collision. Uses a circle that contains the entire object to check for hits
		 * @param x1 int x coordinate of the displayObject that owns this component
		 * @param y1 int y coordinate of the displayObject that owns this component
		 * @param rxDisplayObject IDisplayable DisplayObject to check collision with
		 * @param x2 int x coordinate of given rxDisplayObject
		 * @param y2 int y coordinate of given rxDisplayObject
		 * @return Boolean true if there was a collision, false if not.
		 * 
		 */	
		private function boundingCircleBased(x1:int,y1:int,rxDisplayObject:IDisplayable,x2:int,y2:int):Boolean
		{
			_p1.x = x1;
			_p1.y = y1;
			
			_x1 = (_displayObject.width*.5) + _p1.x;
			_y1 = (_displayObject.height*.5) + _p1.y;
			
			_x3 = _x1 - _p1.x;
			_y3 = _y1 - _p1.y;
			
			_boundingCircleRadius = _x3 * _x3 + _y3 * _y3 ;
			
			_rect2.x = x2;
			_rect2.y = y2;
			
			_x2 = rxDisplayObject.width*.5 + _rect2.x;
			_y2 = rxDisplayObject.height*.5 + _rect2.y;
			
			_x3 = _x2 - _rect2.x;
			_y3 = _y2 - _rect2.y;
			
			_x2 = _x1 - _x2;
			_y2 = _y1 - _y2;
			
			if( (_x2) * (_x2) + (_y2) * (_y2) < _boundingCircleRadius + ( ((_x3) * (_x3)) + ((_y3) * (_y3)) ) )
			{
				return true;
			}else{
				return false;
			}
		}
		
		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS/////////////////
		/**
		 * used for checking for collisons using the Event_Collision 
		 * 
		 */		
		public function update():void
		{
			if(Event_collision.numberOfListeners > 0 || Event_mouseCollision.numberOfListeners > 0)
			{	
				_testproxy = _proxyObject.node.proxyList;
				
				while(_testproxy != null)
				{
					_displayObject2 = _testproxy.proxyObject.displayable;
					if(_testproxy != _proxyObject.proxy)
					{
						switch(_collisionType)
						{
							case "pixelPerfect":
								if(pixelPerfect(_displayObject.boundsX,_displayObject.boundsY,_displayObject2,_displayObject2.boundsX,_displayObject2.boundsY))
								{
									if(_displayObject is RxMouse || _displayObject2 is RxMouse)
									{
										Event_mouseCollision.dispatch(_proxyObject.displayObject,_testproxy.proxyObject.displayObject);
									}else{
										Event_collision.dispatch(_proxyObject.displayObject,_testproxy.proxyObject.displayObject);
									}
								}
								break
							case "distanceRadiusWidth":
								if(distanceRadiusBasedWidth(_displayObject.boundsX,_displayObject.boundsY,_displayObject2,_displayObject2.boundsX,_displayObject2.boundsY))
								{
									if(_displayObject is RxMouse || _displayObject2 is RxMouse)
									{
										Event_mouseCollision.dispatch(_proxyObject.displayObject,_testproxy.proxyObject.displayObject);
									}else{
										Event_collision.dispatch(_proxyObject.displayObject,_testproxy.proxyObject.displayObject);
									}
								}
								break;
							case "distanceRadiusHeight":
								if(distanceRadiusBasedHeight(_displayObject.boundsX,_displayObject.boundsY,_displayObject2,_displayObject2.boundsX,_displayObject2.boundsY))
								{
									if(_displayObject is RxMouse || _displayObject2 is RxMouse)
									{
										Event_mouseCollision.dispatch(_proxyObject.displayObject,_testproxy.proxyObject.displayObject);
									}else{
										Event_collision.dispatch(_proxyObject.displayObject,_testproxy.proxyObject.displayObject);
									}
								}
								break;
							case "boundingBox":
								if(boundingBoxBased(_displayObject.boundsX,_displayObject.boundsY,_displayObject2,_displayObject2.boundsX,_displayObject2.boundsY))
								{
									if(_displayObject is RxMouse || _displayObject2 is RxMouse)
									{
										Event_mouseCollision.dispatch(_proxyObject.displayObject,_testproxy.proxyObject.displayObject);
									}else{
										Event_collision.dispatch(_proxyObject.displayObject,_testproxy.proxyObject.displayObject);
									}
								}
								break;
							case "boundingCircle":
								if(boundingCircleBased(_displayObject.boundsX,_displayObject.boundsY,_displayObject2,_displayObject2.boundsX,_displayObject2.boundsY))
								{
									if(_displayObject is RxMouse || _displayObject2 is RxMouse)
									{
										Event_mouseCollision.dispatch(_proxyObject.displayObject,_testproxy.proxyObject.displayObject);
									}else{
										Event_collision.dispatch(_proxyObject.displayObject,_testproxy.proxyObject.displayObject);
									}
								}
								break;
						}
					}
					
					_testproxy = _testproxy.nextInNode;
				}
			}
		}
		
		/**
		 * manual hitTest method. It has more complexe methods than the Flash version of hitTest so the developer has more flexibility
		 * with checking ahead for points to make for smoother actions with objects.
		 * 
		 * @param x1 int x coordinate of the displayObject that owns this component
		 * @param y1 int y coordinate of the displayObject that owns this component
		 * @param rxDisplayObject IDisplayable DisplayObject to check collision with
		 * @param x2 int x coordinate of given rxDisplayObject
		 * @param y2 int y coordinate of given rxDisplayObject
		 * @return Boolean true if there was a collision, false if not.
		 * 
		 */		
		public function hitTest(x1:int,y1:int,rxDisplayObject:Abstract_RxDisplayObject,x2:int,y2:int,type:String = CollisionType.TYPE_PIXEL_PERFECT):Boolean
		{	
			switch(type)
			{
				case "pixelPerfect":
					return pixelPerfect(x1,y1,rxDisplayObject.componentDisplayable,x2,y2);
					break
				case "distanceRadiusWidth":
					return distanceRadiusBasedWidth(x1,y1,rxDisplayObject.componentDisplayable,x2,y2);
					break;
				case "distanceRadiusHeight":
					return distanceRadiusBasedHeight(x1,y1,rxDisplayObject.componentDisplayable,x2,y2)
					break;
				case "boundingBox":
					return boundingBoxBased(x1,y1,rxDisplayObject.componentDisplayable,x2,y2);
					break;
				case "boundingCircle":
					return boundingCircleBased(x1,y1,rxDisplayObject.componentDisplayable,x2,y2); 
					break;
				default:
					throw new Error("Invalid type, use the static type constants on the RxCollision class");
					return false;
					break;
			}
					
		}
		
		////////////////////GETTERS SETTERS////////////////
		/**
		 * returns the currently set collision type used for the Event_Collision; 
		 * @return String
		 * 
		 */		
		public function get collisionType():String
		{
			return _collisionType;
		}
		
		/**
		 * sets the collision type to be used with Event_Collision. Use the static constants in the CollisionType class 
		 * @param type String
		 * 
		 */		
		public function set collisionType(type:String):void
		{
			_collisionType = type;
		}
		
		////////////////RIXEL INTERNAL///////////
		
		
	}
}