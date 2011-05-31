package org.rixel.Core.Geometry
{
	import flash.geom.Point;

	public class RxPoint
	{
		private var _x:int;
		private var _y:int;
		
		public function RxPoint(x:int = 0,y:int = 0)
		{
			_x = x;
			_y = y;
		}
		
		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS/////////////////
		
		private function distanceTo(rxPoint:RxPoint):Number
		{
			return (rxPoint.x - _x) * (rxPoint.x - _x) + (rxPoint.y - _y) * (rxPoint.y - _y);	
		}
		
		private function midpointTo(rxPoint:RxPoint):RxPoint
		{
			return new RxPoint((_x + rxPoint.x)/2, (_y + rxPoint.y)/2);
		}
		
		
		////////////////////GETTERS SETTERS////////////////
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
	}
}