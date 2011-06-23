//TODO vector rendering
//TODO Redraw areas
package org.rixel.Core.main
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import flashx.textLayout.events.UpdateCompleteEvent;
	
	import org.rixel.Core.Geometry.RxRectangle;
	import org.rixel.Core.displayObjects.Abstract_RxDisplayObject;
	import org.rixel.Core.displayObjects.bitmap.Abstract_RxBitmap_DisplayObject;
	import org.rixel.Core.displayObjects.bitmap.RxComponent_BitmapSprite;
	import org.rixel.Core.quadtree.RxQuadTree;

	/**
	 * Main class that handles all rendering and mouse events. This class also create the quadTree which is at the center of rendering, collision detection, and mouse functionality
	 * Eventually there will be other rendering options to choose from 
	 * @author adamrensel
	 * 
	 */	
	public class RxStage extends Sprite
	{
		private var _width:int;
		private var _height:int; 
		private var _padding:int
		private var _transparent:Boolean;
		private var _bgColor:uint;
		private var _smoothing:Boolean;
		 
		private var _renderMode:String;
		private var _displayList:Vector.<Abstract_RxDisplayObject>;
		private var _bmpCanvas:Bitmap;
		private var _bitmapBuffer:BitmapData;
		private var _renderRect:Rectangle;
		
		private var _tree:RxQuadTree;
		private var _mouse:RxMouse;
		
		//blit renderer vars
		private var rectXOffset:Number;
		private var rectYOffset:Number
		
		private var rectWidthOffset:Number = 0;
		private var rectHeightOffset:Number = 0;
		
		private var sX:int = 0
		private var sY:int = 0
		private var sWidth:int = 0;
		private var sHeight:int = 0;
		
		private var point:Point = new Point();
		private var rect:Rectangle = new Rectangle();
		
		private static var _initialized:Boolean;
 
		public static const GRAPHIC_RENDERER:String = "graphicRenderer";
		public static const BLIT_RENDERER:String = "blitRenderer";
		/**
		 * Creates a new instance of the stage. Multiple stages can be created but it's not recommended. Creating multiple stages will dramatically increase memory usage.
		 * The public static method init on the Rixel class must called before the stage can be used
		 * 
		 * @see #init()
		 * 
		 * @param width int
		 * @param height int
		 * @param padding int Padding is the amount of area off the stage that objects will be kept track of. An error will be thrown if an Object passes beyond
		 * dimensions of the stage.
		 * @param bgColor uint default BG color
		 * @param smoothing Boolean
		 * @param renderMode String
		 * 
		 */		
		public function RxStage(width:Number,height:Number,padding:int = 200,transparent:Boolean = true, bgColor:uint = 0x00000000, smoothing:Boolean = false, renderMode:String = RxStage.BLIT_RENDERER)
		{
			super();
			
			if(!_initialized)
			{
				throw new Error("Please initialize Rixel before instantiating the RxStage --> Rixel.init()");
			}
			
			_width = width;
			_height = height;
			_transparent = false;
			_bgColor = bgColor; 
			_smoothing = smoothing;
			_transparent = transparent;
			_renderMode = renderMode;
			
			_padding = padding;
			
			init(); 
		}
		
		private function init():void
		{	
			
			//create a new quadtree
			_tree = new RxQuadTree(5,RxQuadTree.MAX_1024_OBJECTS);
		 	_tree.setWorldBounds(new RxRectangle(-_padding,-_padding,_width + (_padding*2),_height + (_padding*2)) );
			
			//create a new mouseObject
			_mouse = new RxMouse(_tree,this);
			
			//set defaults
			_renderRect = new Rectangle(0,0,_width,_height);
			_displayList = new Vector.<Abstract_RxDisplayObject>;
			
			//GPU rendering mode setup
			if(_renderMode == RxStage.BLIT_RENDERER)
			{
				_bitmapBuffer = new BitmapData(_width,_height,_transparent,_bgColor);
				
				_bmpCanvas = new Bitmap(_bitmapBuffer,"auto",_smoothing);
				
				this.addChild(_bmpCanvas);
			}
		}
		
		public function doLogic():void
		{	
			for each(var s2D:Abstract_RxDisplayObject in _displayList)
			{
				_tree.moveProxy(s2D.componentProxy.proxyId);
				
				s2D.update();
			}
		}
		
		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS/////////////////
		/**
		 * render loop, this method must be called in an enterFrame or timed loop to render anything. 
		 * 
		 */		
		public function render():void
		{	
			switch(_renderMode)
			{
				case RxStage.BLIT_RENDERER:
					blitRenderer();
					break;
				case RxStage.GRAPHIC_RENDERER:
					graphicRenderer();
					break;
			}
			//update the mouse
			_mouse.update();
		}
		
		//this is the render loop for the blit render engine, it looks a bit cluttered instead of abstracting parts out and splitting it up
		//because it's more efficient to keep everything directly in the loop and make as few function calls as possible. I rarely do this because i like
		//more organized code, but i figured the render loop needs to be as efficient as possible.
		/**
		 * @private 
		 * 
		 */		
		private function blitRenderer():void
		{	
			_bitmapBuffer.lock();
			
			rect.x = 0; 
			rect.y = 0;
			rect.width = _width;
			rect.height = _height; 
			point.x = 0;
			point.y = 0;
			
			//clear bitmap
			_bitmapBuffer.fillRect(rect,_bgColor);
			
			//loop through each object in the displayList vector
			for each(var s2D:Abstract_RxDisplayObject in _displayList)
			{
				_tree.moveProxy(s2D.componentProxy.proxyId);
				
				sX = s2D.componentDisplayable.boundsX;
				sY = s2D.componentDisplayable.boundsY;
				sWidth = s2D.width;
				sHeight = s2D.height;
				
				point.x = sX;
				point.y = sY;
		
				//these conditionals perform screen clipping. So if an object has part that is off the stage, those pixels aren't drawn.
				//It's more efficient to keep this code in the loop rather then abstract it to a static class, even though it makes this code
				//a bit more cluttered.
				if(sX < 0)
				{
					rectXOffset = -sX;
				}else{
					rectXOffset = 0;
				}
				
				if(sY < 0)
				{
					rectYOffset = -sY;
				}else{
					rectYOffset = 0;
				}
				
				if(sX + sWidth > _width)
				{
					rectWidthOffset = (sX + sWidth) - _width;
				}else{
					rectWidthOffset = 0;
				}
				
				if(sY + sHeight > _height)
				{
					rectHeightOffset = (sY + sHeight) - _height;
				}else{
					rectHeightOffset = 0; 
				}
				
				rect.x = rectXOffset;
				rect.y = rectYOffset;
				rect.width = sWidth + rectXOffset - rectWidthOffset;
				rect.height = sHeight + rectYOffset - rectHeightOffset;
				
				point.x = sX + rectXOffset;
				point.y = sY + rectYOffset;
				
				//copy pixels to the canvas bitmap
				_bitmapBuffer.copyPixels((s2D.componentDisplayable as Abstract_RxBitmap_DisplayObject).incrementFrame,rect, point,null,null,true);
			}
			
			_bitmapBuffer.unlock();
		}
		
		//this is an alternative rendermode that renders bitmaps using the graphics api graphics.beginBitmapFill()
		//The rendering mode is not finished and is in a very basic form.
		/**
		 * @private 
		 * 
		 */	
		private function graphicRenderer():void
		{
			this.graphics.clear();
			for each(var s2D:RxComponent_BitmapSprite in _displayList)
			{
				this.graphics.beginBitmapFill(s2D.incrementFrame,new Matrix(1,0,0,1,s2D.x,s2D.y),false,false);
				this.graphics.drawRect(s2D.x,s2D.y,s2D.width,s2D.height);
				this.graphics.endFill();
			}
		}
		
		/**
		 * adds a new abstract_RxDisplayObject to the RxStage 
		 * @param child
		 * @return 
		 * 
		 */		
		public function AddRixelChild(child:Abstract_RxDisplayObject):Abstract_RxDisplayObject
		{
			child.componentProxy.proxyId = _tree.createProxy(child.componentProxy);
			child.index = _displayList.push(child);
			
			return child;
		}
		
		/**
		 * Adds a child to RxStage at the index given 
		 * @param child Abstract_RxDisplayObject
		 * @param index int
		 * @return 
		 * 
		 */		
		public function AddRixelChildAt(child:Abstract_RxDisplayObject, index:int):Abstract_RxDisplayObject
		{
			child.componentProxy.proxyId = _tree.createProxy(child.componentProxy);
			child.index = index;
			_displayList.splice(index-1,0,child);
			return child;
		}
		
		/**
		 * removes a child from the RxStage 
		 * @param child Abstract_RxDisplayObject
		 * @return Abstract_RxDisplayObject
		 * 
		 */		
		public function removeRixelChild(child:Abstract_RxDisplayObject):Abstract_RxDisplayObject
		{
			if(_displayList.indexOf(child) == -1)
			{
				throw new Error("There is no Abstract_RxDisplayObject in the displayList of this RxStage: " + this);
			}
			
			_displayList.splice(child.index,1);
			_tree.destroyProxy(child.componentProxy.proxyId);
			return child;
		}
		
		/**
		 * removes a child from the RxStage at the given index 
		 * @param index int
		 * @return Abstract_RxDisplayObject 
		 * 
		 */		
		public function removeRixelChildAt(index:int):Abstract_RxDisplayObject
		{
			var child:Abstract_RxDisplayObject = _displayList.splice(index,1)[0]
			
			if(!child)
			{
				throw new Error("There is no Abstract_RxDisplayObject at index: " + index);
			}
				
			_tree.destroyProxy( child.componentProxy.proxyId );
			
			return child;
		}
		
		
		////////////////////GETTERS SETTERS////////////////
	
		
		////////////////////STATICS////////////////////////
		/**
		 * initialize RxStage
		 * 
		 */		
		public static function init():void
		{
			_initialized = true;
		}
		
	}
}