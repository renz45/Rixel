package org.rixel.Core.Geometry
{
	
	/**
	 * custom point class that is lighter and more efficiant than the flash Point class.  
	 * @author adamrensel
	 * 
	 */
	public class RxPoint
	{
		private var _x:int;
		private var _y:int;
		
		/**
		 * constructor 
		 * @param x int x coordinate
		 * @param y int y coordinate
		 * 
		 */		
		public function RxPoint(x:int = 0,y:int = 0)
		{
			_x = x;
			_y = y;
		}
		
		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS/////////////////
		/**
		 * returns the distance as a Number between this RxPoint and the RxPoint given 
		 * @param rxPoint RxPoint
		 * @return Number
		 * 
		 */		
		public function distanceTo(rxPoint:RxPoint):Number
		{
			return (rxPoint.x - _x) * (rxPoint.x - _x) + (rxPoint.y - _y) * (rxPoint.y - _y);	
		}
		
		/**
		 * returns a RxPoint that is the midpoint between this RxPoint and the given RxPoint 
		 * @param rxPoint
		 * @return RxPoint
		 * 
		 */		
		public function midpointTo(rxPoint:RxPoint):RxPoint
		{
			return new RxPoint((_x + rxPoint.x)/2, (_y + rxPoint.y)/2);
		}
		
		
		////////////////////GETTERS SETTERS////////////////
		/**
		 * returns the x coordinate of this RxPoint 
		 * @return int
		 * 
		 */		
		public function get x():int 
		{
			return _x;
		}
		
		/**
		 * sets the x coordinate of this RxPoint 
		 * @param value int
		 * 
		 */		
		public function set x(value:int):void
		{
			_x = value;
		}
		
		/**
		 * returns the y coordinate of this RxPoint 
		 * @return int
		 * 
		 */	
		public function get y():int
		{
			return _y;
		}
		
		/**
		 * sets the y coordinate of this RxPoint 
		 * @param value int
		 * 
		 */	
		public function set y(value:int):void
		{
			_y = value;
		}
	}
}