package org.rixel.Core.Geometry
{
	import flash.geom.Point;

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
			if(this.x < rectangle2D.x + rectangle2D.width && this.x > rectangle2D.x && this.y < rectangle2D.y + rectangle2D.height && this.y > rectangle2D.y )
			{
				return true;
			}
			
			return false;
		}
		
		public function merge(rectangle2D:Rectangle2D):Rectangle2D
		{
			var rect:Rectangle2D = new Rectangle2D();
			
			var xMax:Number = 0;
			var xMin:Number = 0;
			var yMax:Number = 0;
			var yMin:Number = 0;
			
			if(this.x > rectangle2D.x)
			{
				xMax = this.x;
			}else{
				xMax = rectangle2D.x;
			}
			
			if(this.y > rectangle2D.y)
			{
				yMax = this.y;
			}else{
				yMax = rectangle2D.y;
			}
			
			
			return rect;
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