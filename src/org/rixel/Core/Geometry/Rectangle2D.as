package org.rixel.Core.Geometry
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Rectangle2D
	{
		private var _width:Number;
		private var _height:Number;
		private var _x:int;
		private var _y:int;
		
		public function Rectangle2D(x:int = 0,y:int = 0,width:Number = 0,height:Number = 0)
		{
			_width = width;
			_height = height;
			_x = x;
			_y = y;
		}
		
		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS/////////////////
		public function intersects(rectangle2D:Rectangle2D):Boolean
		{	
			var r1Left:Number = _x;
			var r1Top:Number = _y;
			var r1Right:Number = _x + _width;
			var r1Bottom:Number = _y + _height;
			
			var r2Left:Number = rectangle2D.x;
			var r2Top:Number = rectangle2D.y;
			var r2Right:Number = rectangle2D.x + rectangle2D.width;
			var r2Bottom:Number = rectangle2D.y + rectangle2D.height;
			
			
			
			if(!(r1Left > r2Right ||
				r1Top > r2Bottom ||
				r1Right < r2Left ||
				r1Bottom < r2Top)
			  )
			{
				return true;
			}
			
			return false;
		}
		
		public function merge(rectangle2D:Rectangle2D):Rectangle2D
		{
			
			var xMax:Number = 0;
			var xMin:Number = 0;
			var yMax:Number = 0;
			var yMin:Number = 0;
			
			var thisLowerX:Number = this.x + this.width;
			var thisLowerY:Number = this.y + this.height;
			var thatLowerX:Number = rectangle2D.x + rectangle2D.width;
			var thatLowerY:Number = rectangle2D.y + rectangle2D.height;
			
			if(this.x < rectangle2D.x)
			{
				xMin = this.x;
			}else{
				xMin = rectangle2D.x;
			}
			
			if(this.y < rectangle2D.y)
			{
				yMin = this.y;
			}else{
				yMin = rectangle2D.y;
			}
			
			if(thisLowerX > thatLowerX)
			{
				xMax = thisLowerX; 
			}else{
				xMax = thatLowerX;
			}
			
			if(thisLowerY > thatLowerY)
			{
				yMax = thisLowerY; 
			}else{
				yMax = thatLowerY;
			}
			
			return new Rectangle2D(xMin,yMin, xMax - xMin,yMax - yMin);
		}
		
		
		////////////////////GETTERS SETTERS////////////////
		public function get width():Number
		{
			return _width;
		}
		
		public function set width(value:Number):void
		{
			_width = value;
		}
		
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(value:Number):void
		{
			_height = value;
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
	}
}