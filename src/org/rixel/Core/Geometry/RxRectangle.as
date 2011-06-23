package org.rixel.Core.Geometry
{
	
	/**
	 * custom rectangle class. This class is used over the flash rectangle class because it's smaller and more efficiant, and runs faster.
	 *  
	 * @author adamrensel
	 * 
	 */
	public class RxRectangle
	{
		private var _width:int;
		private var _height:int;
		private var _x:int;
		private var _y:int;
		
		private var _topLeft:RxPoint;
		private var _topRight:RxPoint;
		private var _bottomLeft:RxPoint;
		private var _bottomRight:RxPoint;
		private var _middle:RxPoint;
		
		private var _x2:int;
		private var _y2:int;
		private var _width2:int;
		private var _height2:int;
		
		//////////Merge vars
		private var _xMax:int;
		private var _xMin:int;
		private var _yMax:int;
		private var _yMin:int;
		
		private var _thisLowerX:int;
		private var _thisLowerY:int;
		private var _thatLowerX:int;
		private var _thatLowerY:int;
		
		////////////////contains vars
		private var width1:int;
		private var height1:int;
		
		private var x2:int;
		private var y2:int;
		private var width2:int;
		private var height2:int;
		
		private var x1:int;
		private var y1:int;
		/**
		 * create a new RxRectangle 
		 * @param x int x coodinate
		 * @param y int y coodinate
		 * @param width int width value
		 * @param height int height value
		 * 
		 */		
		public function RxRectangle(x:int = 0,y:int = 0,width:int = 0,height:int = 0)
		{
			_width = width;
			_height = height;
			_x = x; 
			_y = y;
		
			init();
		}
		
		/**
		 * initialize points 
		 * 
		 */		
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
		/**
		 * checks to see if another RxRectangle intersects this one. A boolean is returned true if there is an intersection 
		 * @param rxRectangle
		 * @return Boolean
		 * 
		 */		
		public function intersects(rxRectangle:RxRectangle):Boolean
		{	
			_x2 = rxRectangle.x;
			_y2 = rxRectangle.y;
			_width2 = rxRectangle.width;
			_height2 = rxRectangle.height;
			
			return	!(_x > _x2 + _width2 || _y > _y2 + _height2 || _x + _width < _x2 || _y + _height < _y2);
		}
		
		/**
		 * Merges this RxRectangle with another RxRectangle and returns this rectangle with the modified properties. I didn't to return a new rectangle
		 * because I'm using this for a dirty rectangles system which is in the render loop. The new operator is too slow to use in this situation. 
		 * 
		 * @param rxRectangle RxRectangle
		 * @return RxRectangle
		 * 
		 */		
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
		
		/**
		 * tests if the given RxPoint is contained within this RxRectangle 
		 * @param point RxPoint
		 * @return Boolean
		 * 
		 */		
		public function containsPoint(point:RxPoint):Boolean
		{
			return !(point.x < _x || point.x > _x + _width || point.y < _y || point.y > _y + _height)
		}
		
		/**
		 * Checks to see if the given RxRectangle is fully contained within this RxRectangle 
		 * @param rxRectangle RxRectangle
		 * @return Boolean
		 * 
		 */		
		public function containsRect(rxRectangle:RxRectangle):Boolean
		{
			width1 = _width;
			height1 = _height;
			
			x2 = rxRectangle.x;
			y2 = rxRectangle.y;
			width2 = rxRectangle.width;
			height2 = rxRectangle.height;
			
			if ((width1 | _height | width2 | height2) < 0) {
				return false;
			}

			x1 = _x;
			y1 = _y;
			
			if (x2 < x1 || y2 < y1) {
				return false;
			}
			
			width1 += x1;
			width2 += x2;
			
			if (width2 <= x2) {
				if (width1 >= x1 || width2 > width1) 
				{
					return false;
				}
			} else {
				if (width1 >= x1 && width2 > width1)
				{
					return false;
				}
			}
			
			height1 += y1;
			height2 += y2;
			
			if (height2 <= y2) {
				if (height1 >= y1 || height2 > height1)
				{
					return false;
				}
			} else {
				if (height1 >= y1 && height2 > height1)
				{
					return false;
				}
			}
			return true;
		}

		////////////////////GETTERS SETTERS////////////////
		/**
		 * returns width of this RxRectangle 
		 * @return int
		 * 
		 */		
		public function get width():int
		{
			return _width;
		}
		
		/**
		 * sets the width of this RxRectangle 
		 * @param value int
		 * 
		 */		
		public function set width(value:int):void
		{
			_width = value;
		}
		
		/**
		 * returns the height if this RxRectangle 
		 * @return int
		 * 
		 */		
		public function get height():int
		{
			return _height;
		}
		
		/**
		 * sets the height of this RxRectangle 
		 * @param value int
		 * 
		 */		
		public function set height(value:int):void
		{
			_height = value;
		}
		
		/**
		 * returns x coordinate of this RxRectangle 
		 * @return int
		 * 
		 */		
		public function get x():int
		{
			return _x;
		}
		/**
		 * sets the x value of this RxRectangle  
		 * @param value int
		 * 
		 */		
		public function set x(value:int):void
		{
			_x = value;
		}
		
		/**
		 * returns the y value of this RxRectangle  
		 * @return int
		 * 
		 */		
		public function get y():int
		{
			return _y;
		}
		
		/**
		 * sets the y value of this RxRectangle  
		 * @param value int
		 * 
		 */		
		public function set y(value:int):void
		{
			_y = value;
		}
		/**
		 * returns the topLeft RxPoint of this RxRectangle  
		 * @return RxPoint
		 * 
		 */
		public function get topLeft():RxPoint
		{
			_topLeft.x = _x;
			_topLeft.y = _y;
			
			return _topLeft;
		}

		/**
		 * returns the topRight RxPoint of this RxRectangle  
		 * @return RxPoint
		 * 
		 */		
		public function get topRight():RxPoint
		{
			_topRight.x = _x + _width;
			_topRight.y = _y;
			
			return _topRight;
		}
		
		/**
		 * returns the bottomLeft RxPoint of this RxRectangle 
		 * @return RxPoint
		 * 
		 */
		public function get bottomLeft():RxPoint
		{
			_bottomLeft.x = _x;
			_bottomLeft.y = _y + _height;
			
			return _bottomLeft;
		}

		/**
		 * returns the bottomRight RxPoint of this RxRectangle  
		 * @return RxPoint
		 * 
		 */		
		public function get bottomRight():RxPoint
		{
			_bottomRight.x = _x + _width;
			_bottomRight.y = _y + _height;
			
			return _bottomRight;
		}

		/**
		 * returns the center RxPoint of this RxRectangle  
		 * @return RxPoint
		 * 
		 */		
		public function get center():RxPoint
		{	
			_middle.x = (_x + _width) / 2;
			_middle.y = (_y + _height) / 2;
			
			return _middle;
		}

		/**
		 * sets the center RxPoint of this RxRectangle  
		 * @param value RxPoint
		 * 
		 */		
		public function set center(value:RxPoint):void
		{	
			_middle = value;
			
			_x = _middle.x - (_width / 2);
			_y = _middle.y - (_height / 2);
		}
		
		/**
		 * returns the minimum x value of this RxRectangle 
		 * @return int
		 * 
		 */		
		public function get xmin():int
		{
			return _x;
		}
		
		/**
		 * returns the maximum x value of this RxRectangle  
		 * @return int
		 * 
		 */		
		public function get xmax():int
		{
			return _x + _width;
		}
		
		/**
		 * returns the minimum y value of this RxRectangle  
		 * @return int
		 * 
		 */		
		public function get ymin():int
		{
			return _y;
		}
		
		/**
		 * returns the maximum y value of this RxRectangle  
		 * @return int
		 * 
		 */		
		public function get ymax():int
		{
			return _y + _height;
		}
	}
}