package org.rixel.Core.Geometry
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class RxRectangle
	{
		private var _width:Number;
		private var _height:Number;
		private var _x:int;
		private var _y:int;
		
		private var _topLeft:RxPoint;
		private var _topRight:RxPoint;
		private var _bottomLeft:RxPoint;
		private var _bottomRight:RxPoint;
		private var _middle:RxPoint;
		
		//////////Merge vars
		private var _xMax:Number;
		private var _xMin:Number;
		private var _yMax:Number;
		private var _yMin:Number;
		
		private var _thisLowerX:Number;
		private var _thisLowerY:Number;
		private var _thatLowerX:Number;
		private var _thatLowerY:Number;
		
		public function RxRectangle(x:int = 0,y:int = 0,width:Number = 0,height:Number = 0)
		{
			_width = width;
			_height = height;
			_x = x; 
			_y = y;
		
			init();
		}
		
		private function init():void
		{
			_topLeft = new RxPoint();
			_topRight = new RxPoint();
			_bottomLeft = new RxPoint();
			_bottomRight = new RxPoint();
			_middle = new RxPoint();
		}
		
		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS/////////////////
		public function intersects(rxRectangle:RxRectangle):Boolean
		{	
			return	!(_x > rxRectangle.x + rxRectangle.width || _y > rxRectangle.y + rxRectangle.height || _x + _width < rxRectangle.x || _y + _height < rxRectangle.y);
		}
		
		public function merge(rxRectangle:RxRectangle):RxRectangle
		{
			
			_xMax = 0;
			_xMin = 0;
			_yMax = 0;
			_yMin = 0;
			
			_thisLowerX = this.x + this.width;
			_thisLowerY = this.y + this.height;
			_thatLowerX = rxRectangle.x + rxRectangle.width;
			_thatLowerY = rxRectangle.y + rxRectangle.height;
			
			if(this.x < rxRectangle.x)
			{
				_xMin = this.x;
			}else{
				_xMin = rxRectangle.x;
			}
			
			if(this.y < rxRectangle.y)
			{
				_yMin = this.y;
			}else{
				_yMin = rxRectangle.y;
			}
			
			if(_thisLowerX > _thatLowerX)
			{
				_xMax = _thisLowerX; 
			}else{
				_xMax = _thatLowerX;
			}
			
			if(_thisLowerY > _thatLowerY)
			{
				_yMax = _thisLowerY; 
			}else{
				_yMax = _thatLowerY;
			}
			
			//return new RxRectangle(_xMin,_yMin, _xMax - _xMin,_yMax - _yMin);
			
			_x = _xMin;
			_y = _yMin;
			
			_width = _xMax - _xMin;
			_height = _yMax - _yMin;
			
			return this;
		}
		
		public function containsPoint(point:RxPoint):Boolean
		{
			return !(point.x < _x || point.x > _x + _width || point.y < _y || point.y > _y + _height)
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

		public function get topLeft():RxPoint
		{
			_topLeft.x = _x;
			_topLeft.y = _y;
			
			return _topLeft;
		}

		public function get topRight():RxPoint
		{
			_topRight.x = _x + _width;
			_topRight.y = _y;
			
			return _topRight;
		}

		public function get bottomLeft():RxPoint
		{
			_bottomLeft.x = _x;
			_bottomLeft.y = _y + _height;
			
			return _bottomLeft;
		}

		public function get bottomRight():RxPoint
		{
			_bottomRight.x = _x + _width;
			_bottomRight.y = _y + _height;
			
			return _bottomRight;
		}

		public function get middle():RxPoint
		{	
			_middle.x = (_x + _width) / 2;
			_middle.y = (_y + _height) / 2;
			
			return _middle;
		}

		public function set middle(value:RxPoint):void
		{	
			_middle = value;
			
			_x = _middle.x - (_width / 2);
			_y = _middle.y - (_height / 2);
		}


	}
}