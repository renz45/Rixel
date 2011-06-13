package org.rixel.Core.collision
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import org.osflash.signals.Signal;
	import org.rixel.Core.Geometry.RxPoint;
	import org.rixel.Core.Geometry.RxRectangle;
	import org.rixel.Core.displayObjects.RxSprite;
	import org.rixel.Core.nameSpaces.rixel;
	import org.rixel.Core.quadTree.RxQuadTreeProxy;

	use namespace rixel;
	
	public class RxCollision
	{
		private var _sprite:RxSprite;
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
		
		private var _collisionType:String;
		
		private var _xOffset:int;
		private var _yOffset:int;
		
		public var Event_collision:CollisionSignal;
		
		public static const TYPE_PIXEL_PERFECT:String = "pixelPerfect";
		public static const TYPE_DISTANCE_RADIUS:String = "distanceRadius";
		public static const TYPE_BOUNDING_BOX:String = "boundingBox";
		public static const TYPE_BOUNDING_CIRCLE:String = "boundingCircle";
		
		public function RxCollision(rxSprite:RxSprite,type:String = RxCollision.TYPE_PIXEL_PERFECT)
		{
			_sprite = rxSprite;
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
		
		private function initEvents():void
		{
			Event_collision = new CollisionSignal(RxSprite,RxSprite);
		}
		
		private function pixelPerfect(rxSprite:RxSprite):void
		{
			_p1.x = _sprite.rixel::renderX;
			_p1.y = _sprite.rixel::renderY;
			
			_p2.x = rxSprite.rixel::renderX;
			_p2.y = rxSprite.rixel::renderY;
			
			if(_sprite.rixel::collisionFrame.hitTest(_p1,255,rxSprite.rixel::collisionFrame,_p2) )
			{
				Event_collision.dispatch(_sprite,rxSprite);
			}
		}
		
		private function distanceRadiusBased(rxSprite:RxSprite):void
		{	
			_x1 = (_sprite.width*.5) + _sprite.rixel::renderX;
			_y1 = (_sprite.height*.5) + _sprite.rixel::renderY;
			
			_width1 = _sprite.width*.5;
			_width2 = rxSprite.width*.5;
			
			_x2 = _width2 + rxSprite.rixel::renderX;
			_y2 = (rxSprite.height * .5) + rxSprite.rixel::renderY;
			
			_x3 = _x1 - _x2;
			_y3 = _y1 - _y2;
			_width3 = _width1 + _width2;
			
			if((_x3) * (_x3) + (_y3) * (_y3) < _width3 * _width3)
			{
				Event_collision.dispatch(_sprite,rxSprite);
			}
		}
		
		private function boundingBoxBased(rxSprite:RxSprite):void
		{	
			_x1 = _sprite.rixel::renderX;
			_y1  = _sprite.rixel::renderY;
			_width1 = _sprite.width;
			_height1 = _sprite.height;
			
			_x2 = rxSprite.rixel::renderX;
			_y2 = rxSprite.rixel::renderY;
			_width2 = rxSprite.width;
			_height2 = rxSprite.height;
			
			if( !(_x1 > _x2 + _width2 || _y1 > _y2 + _height2 || _x1 + _width1 < _x2 || _y1 + _height1 < _y2) )
			{
				Event_collision.dispatch(_sprite,rxSprite);
			}
		}
		
		private function boundingCircleBased(rxSprite:RxSprite):void
		{
			_p1.x = _sprite.rixel::renderX;
			_p1.y = _sprite.rixel::renderY;
			
			_x1 = (_sprite.width*.5) + _p1.x;
			_y1 = (_sprite.height*.5) + _p1.y;
			
			_x3 = _x1 - _p1.x;
			_y3 = _y1 - _p1.y;
			
			_boundingCircleRadius = _x3 * _x3 + _y3 * _y3 ;
			
			_rect2.x = rxSprite.rixel::renderX;
			_rect2.y = rxSprite.rixel::renderY;
			
			_x2 = rxSprite.width*.5 + _rect2.x;
			_y2 = rxSprite.height*.5 + _rect2.y;
			
			_x3 = _x2 - _rect2.x;
			_y3 = _y2 - _rect2.y;
			
			_x2 = _x1 - _x2;
			_y2 = _y1 - _y2;
			
			if( (_x2) * (_x2) + (_y2) * (_y2) < _boundingCircleRadius + ( ((_x3) * (_x3)) + ((_y3) * (_y3)) ) )
			{
				Event_collision.dispatch(_sprite,rxSprite);
			}
		}
		
		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS/////////////////
		
		public function update(point:RxPoint = null):void
		{
			if(Event_collision.numberOfListeners > 0)
			{	
				_testproxy = _sprite.proxy.node.proxyList;
				
				while(_testproxy != null)
				{
					if(_testproxy != _sprite.proxy)
					{
						switch(_collisionType)
						{
							case "pixelPerfect":
								this.pixelPerfect(_testproxy.sprite);
								break
							case "distanceRadius":
								this.distanceRadiusBased(_testproxy.sprite);
								break;
							case "boundingBox":
								this.boundingBoxBased(_testproxy.sprite);
								break;
							case "boundingCircle":
								this.boundingCircleBased(_testproxy.sprite);
								break;
						}
					}
					_testproxy = _testproxy.nextInNode;
				}
			}
		}
		
		////////////////////GETTERS SETTERS////////////////
		public function get collisionType():String
		{
			return _collisionType;
		}
		
		public function set collisionType(type:String):void
		{
			_collisionType = type;
		}
		
		////////////////RIXEL INTERNAL///////////
		
		
	}
}