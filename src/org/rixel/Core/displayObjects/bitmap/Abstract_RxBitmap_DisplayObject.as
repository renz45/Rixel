package org.rixel.Core.displayObjects.bitmap
{
	import flash.display.BitmapData;
	
	import org.osflash.signals.Signal;
	import org.rixel.Core.displayObjects.IDisplayable;
	/**
	 * Abstract class used for creating a bitmapRender, IDisplable object. This is the base class for creating a class that works with the blit renderer of
	 * RxStage. This must be extended of some sort of custom bitmap object is to be created
	 *  
	 * @author adamrensel
	 * 
	 */
	public class Abstract_RxBitmap_DisplayObject implements IDisplayable
	{
		protected var _x:int;
		protected var _y:int;
		protected var _width:int;
		protected var _height:int;
		protected var _transparent:Boolean;
		protected var _fillColor:uint;
		
		protected var _imageData:BitmapData;
		protected var _dataLoaded:Boolean;
		protected var _params:Object;
		
		/**
		 * Event_Loaded signal gets dispatched when the bitmapDisplayObject is finished loading. returns the Abstract_RxBitmap_DisplayObject that was loaded
		 * <p>
		 * Event_Loaded.add(onLoad_Handler);
		 * 
		 * private function onLoad_Handler(obj:Abstract_RxBitmap_DisplayObject)
		 * {
		 * 	//Do Stuff
		 * }
		 * </p>
		 */		
		public var Event_Loaded:Signal; 
		
		public function Abstract_RxBitmap_DisplayObject(params:Object = null)
		{
			if(params == null)
			{
				_params = {};
			}else{
				_params = params;
			}
			parseParams();
			init();
		}
		//set defaults
		private function init():void
		{
			_width = 0;
			_height = 0;
			_dataLoaded = false;
			
			initEvents();
		}
		
		//parse params from the param object passed in as an argument
		private function parseParams():void
		{
			if( _params.hasOwnProperty("transparent") )
			{
				_transparent = _params['transparent'];
			}else{
				_transparent = true;
			}
			
			if( _params.hasOwnProperty("fillColor") )
			{
				_fillColor = _params['fillColor'];
			}else{
				_fillColor = 0;
			}
		}
		
		//initialize the event signals
		private function initEvents():void
		{
			Event_Loaded = new Signal(Abstract_RxBitmap_DisplayObject);
		}
		
		/////////////////////CALLBACKS////////////////////
	
		////////////////////PUBLIC METHODS/////////////////
		
		////////////////////GETTERS SETTERS////////////////
		/**
		 * returns the x coordinate of the bigmap IDisplayable 
		 * @return int
		 * 
		 */		
		public function get x():int
		{
			return _x;
		}
		
		/**
		 * sets the x coordinate of the bigmap IDisplayable 
		 * @return void
		 * 
		 */	
		public function set x(value:int):void
		{
			_x = value;
		}
		
		/**
		 * returns the y coordinate of the bigmap IDisplayable 
		 * @return int
		 * 
		 */
		public function get y():int
		{ 
			return _y;
		}
		
		/**
		 * sets the y coordinate of the bigmap IDisplayable 
		 * @return int
		 * 
		 */	
		public function set y(value:int):void
		{
			_y = value;
		}
		
		/**
		 * gets the bounds x coordinate of the bitmap IDisplayable. This is an offset x value which will preserve any registration point that isn't top left.
		 * If the object has a top left registration, this value will be the same as the normal x.
		 * @return int
		 * 
		 */		
		public function get boundsX():int
		{
			throw new Error("The method get boundsX must be overridden when extending the abstract class RxBitmap_DisplayObject");
		}
		/**
		 * gets the bounds y coordinate of the bitmap IDisplayable. This is an offset y value which will preserve any registration point that isn't top left.
		 * If the object has a top left registration, this value will be the same as the normal y.
		 * @return int
		 * 
		 */	
		public function get boundsY():int
		{
			throw new Error("The method get boundsX must be overridden when extending the abstract class RxBitmap_DisplayObject");
		}
		
		/**
		 * This is the actual offset value that is added to the x coordinate to produce the boundsX. 
		 * @return int xOffset
		 * 
		 */		
		public function get xOffset():int
		{
			throw new Error("The method get xOffset must be overridden when extending the abstract class RxBitmap_DisplayObject");
		}
		
		/**
		 * This is the actual offset value that is added to the y coordinate to produce the boundsY. 
		 * @return int yOffset
		 * 
		 */	
		public function get yOffset():int
		{
			throw new Error("The method get yOffset must be overridden when extending the abstract class RxBitmap_DisplayObject");
		}
		
		/**
		 * returns the width of the object. This is a read only property, bitmap objects cannot be resized.
		 * @return int width
		 * 
		 */		
		public function get width():int
		{
			return _width;
		}
			
		/*public function set width(value:int):void
		{
			//_width = value;
		}*/
		/**
		 * returns the height of the object. This is a read only property, bitmap objects cannot be resized.
		 * @return int height
		 * 
		 */			
		public function get height():int
		{
			return _height;
		}
		
		/*public function set height(value:int):void
		{
			//_height = value;
		}*/
		/**
		 * returns a bitmapData object which is the current frame. This method is similar to get collisionFrame, but when this method is called the currentFrame pointer
		 * of an animation is incremented to the next frame. 
		 * @return bitmapData of current frame
		 * 
		 */
		public function get incrementFrame():BitmapData
		{
			throw new Error("The method get incrementFrame must be overridden when extending the abstract class RxBitmap_DisplayObject");
		}
		
		/**
		 * returns a bitmapData object which is the current frame. This method is similar to incrementFrame, but it does not go to the next frame after returning the current frame 
		 * @return bitmapData of current frame
		 * 
		 */		
		public function get staticFrame():BitmapData
		{
			throw new Error("The method get staticFrame must be overridden when extending the abstract class RxBitmap_DisplayObject");
		}	
		
	}
}