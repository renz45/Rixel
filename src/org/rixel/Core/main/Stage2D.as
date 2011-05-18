package org.rixel.Core.main
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	
	import mx.managers.SystemManager;
	
	import org.rixel.Core.Geometry.Rectangle2D;
	import org.rixel.Core.displayObjects.Animation2D;
	import org.rixel.Core.displayObjects.Sprite2D;
	import org.rixel.Core.nameSpaces.rixel;
	
	import spark.components.mediaClasses.VolumeBar;
	
	use namespace rixel;
	
	public class Stage2D extends Sprite 
	{
		private var _width:Number;
		private var _height:Number; 
		private var _transparent:Boolean;
		private var _bgColor:uint;
		private var _smoothing:Boolean;
		 
		private var _renderMode:String;
		private var _displayList:Vector.<Sprite2D>;
		private var _bmpCanvas:Bitmap;
		private var _bitmapBuffer:BitmapData;
		private var _renderRect:Rectangle;
		
		private var _debugCanvas:Sprite;
		private var _debugMode:Boolean;
		
		private var _dirtyRect:DirtyRectangles = new DirtyRectangles();
		
		private var _dirtyRectangles:Boolean;
		 
		public static const GRAPHIC_RENDERER:String = "graphicRenderer";
		public static const BLIT_RENDERER:String = "blitRenderer";
		
		public function Stage2D(width:Number,height:Number, bgColor:uint = 0xFFFFFF, smoothing:Boolean = false, renderMode:String = Stage2D.BLIT_RENDERER)
		{
			super();
			
			_width = width;
			_height = height;
			_transparent = false;
			_bgColor = bgColor;
			_smoothing = smoothing;
			
			_renderMode = renderMode;
			
			init();
		}
		
		private function init():void
		{	
			_renderRect = new Rectangle(0,0,_width,_height);
			
			_displayList = new Vector.<Sprite2D>;
			
			_debugMode = false;
			
			_dirtyRectangles = false;
			
			//GPU rendering mode setup
			if(_renderMode == Stage2D.BLIT_RENDERER)
			{
				_bitmapBuffer = new BitmapData(_width,_height,_transparent,_bgColor);
				
				_bmpCanvas = new Bitmap(_bitmapBuffer,"auto",_smoothing);
				
				this.addChild(_bmpCanvas);
			}
		}
		
		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS/////////////////
		public function render():void
		{
			switch(_renderMode)
			{
				case Stage2D.BLIT_RENDERER:
					blitRenderer();
					break;
				case Stage2D.GRAPHIC_RENDERER:
					graphicRenderer();
					break;
			}
			
		}
		
		//this is the render loop for the blit render engine, it looks a bit cluttered instead of abstracting parts out and splitting it up
		//because it's more efficient to keep everything directly in the loop and make as few function calls as possible.
		private function blitRenderer():void
		{
			
			var rectXOffset:Number;
			var rectYOffset:Number
			
			var rectWidthOffset:Number = 0;
			var rectHeightOffset:Number = 0;
			
			var sX:Number = 0
			var sY:Number = 0
			var sWidth:Number = 0;
			var sHeight:Number = 0;
			
			var point:Point = new Point();
			var rect:Rectangle = new Rectangle();
			
			var redrawList:Vector.<Rectangle2D>;
			
			
			var drawThis:Boolean;
			
			//double buffer where bitmap data is alternatly switched out of the bitmap to copy pixels and swapped back in after
		/*	if(_bmpCanvas.bitmapData == _buffer1)
			{
				dataToDraw = _buffer1;
				_bmpCanvas.bitmapData = _buffer2;
			}else{
				dataToDraw = _buffer2;
				_bmpCanvas.bitmapData = _buffer1;
			}*/
			
			_renderRect.x = 0;
			_renderRect.y = 0;
			_renderRect.width = _bitmapBuffer.width;
			_renderRect.height = _bitmapBuffer.height;
			point.x = 0;
			point.y = 0;
			
			//_bitmapBuffer.fillRect( _renderRect,0xeeeeee);
			
			//dirty rectangle system so we only redraw object that change, this should be used when the number of objects on the screen is low,
			//and when those objects are small or medium sized in relation to each other.
			//If there are a lot of objects where the entire screen will get redrawn anyways this technique will actually slow down the 
			//rendering a lot and it will be faster to disable this mode and do brute force fullscreen renders.
			if(_dirtyRectangles)
			{
				redrawList = _dirtyRect.rixel::getRedrawAreas(_displayList);
				
				for each(var dirtyRect2:Rectangle2D in redrawList)
				{
					_renderRect.x = dirtyRect2.x;
					_renderRect.y = dirtyRect2.y;
					_renderRect.width = dirtyRect2.width;
					_renderRect.height = dirtyRect2.height;
					
					_bitmapBuffer.fillRect( _renderRect,0xFFFFFF);
				}
				
				if(_debugMode)
				{
					_debugCanvas.graphics.clear();
					_debugCanvas.graphics.lineStyle(1,0xff0000);
					for each(var dirtyRectDebug:Rectangle2D in redrawList)
					{
						_debugCanvas.graphics.drawRect(dirtyRectDebug.x,dirtyRectDebug.y,dirtyRectDebug.width,dirtyRectDebug.height);
					}
				}
			}else{
				_bitmapBuffer.fillRect( _renderRect,0xFFFFFF);
			}
			
			//the actual pixel output is contained in this loop with the copyPixel method
			drawThis = false;
			
			for each(var s2D:Sprite2D in _displayList)
			{
				sX = s2D.rixel::renderX;
				sY = s2D.rixel::renderY;
				sWidth = s2D.width;
				sHeight = s2D.height;
				point.x = sX;
				point.y = sY;
				
				
				if(s2D.dirty == false && _dirtyRectangles)
				{
					for each(var r2D:Rectangle2D in redrawList)
					{
						//if the dirty rectangle and a non dirty rectangle intersect
						if(!(sX > r2D.x + r2D.width ||
							sY > r2D.y + r2D.height ||
							sX + sWidth < r2D.x ||
							sY + sHeight < r2D.y)
						)
						{

							drawThis = false;
							
							
							if(sX - r2D.x < 0)
							{
								rect.x = (sX - r2D.x) * -1;
								rect.width = sWidth - (sX - r2D.x) * -1;
								point.x = sX + (sX - r2D.x) * -1;
							}else{
								rect.x = 0;
								rect.width = sWidth - (sX - r2D.x);
								point.x = sX;
							}
							
							if(sY - r2D.y < 0)
							{
								rect.y = (sY - r2D.y) * -1;
								rect.height = sHeight - (sY - r2D.y) * -1;
								point.y = sY + (sY - r2D.y) * -1 - 1;
							}else{
								rect.y = 0;
								rect.height = sHeight - (sY - r2D.y);
								point.y = sY +1;
							}
							
							_bitmapBuffer.lock();
							_bitmapBuffer.copyPixels(s2D.rixel::frame,rect, point);
							_bitmapBuffer.unlock(rect);
							
							//break;
						}else{
							//drawThis = false;
						}
					}
					
				}else{

					drawThis = true;
				}

				if(drawThis)
				{
					//these conditionals perform screen clipping. So if an object has part that is off the stage, those pixels aren't drawn internally
					//it's more efficient to keep this code in the loop rather then abstract it to a static class, even though it makes this code
					//a bit more cluttered.
					if(sX < 0)
					{
						rectXOffset = sX * -1;
					}else{
						rectXOffset = 0;
					}
					
					if(sY < 0)
					{
						rectYOffset = sY * -1;
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
					
					//_debugCanvas.graphics.lineStyle(1,0x00ff00);
					//_debugCanvas.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
					
					_bitmapBuffer.lock();
					_bitmapBuffer.copyPixels(s2D.rixel::frame,rect, point);
					_bitmapBuffer.unlock(rect);
					
					
				
				}
				
				
			}
		}
		
		private function graphicRenderer():void
		{
			this.graphics.clear();
			for each(var s2D:Sprite2D in _displayList)
			{
				this.graphics.beginBitmapFill(s2D.rixel::frame,new Matrix(1,0,0,1,s2D.x,s2D.y),false,false);
				this.graphics.drawRect(s2D.x,s2D.y,s2D.width,s2D.height);
				this.graphics.endFill();
			}
		}
		
		public function addChild2D(child:Sprite2D):Sprite2D
		{
			_displayList.push(child);
			
			return child;
		}
		
		public function addChildAt2D(child:Sprite2D, index:int):Sprite2D
		{
			
			return child;
		}
		
		
		
		////////////////////GETTERS SETTERS////////////////
		
		public function set showRedrawFrames(value:Boolean):void
		{
			if(value)
			{
				_debugCanvas = new Sprite();
				this.addChild(_debugCanvas);
			}else{
				this.removeChild(_debugCanvas);
				_debugCanvas = null;
				
			}
			
			_debugMode = value;
		}
		
		public function set useDirtyRectangles(value:Boolean):void
		{
			_dirtyRectangles = value;
		}
		
		
		////////////////////STATICS////////////////////////
		public static function init():void
		{
			Sprite2D.rixel::init();
		}
		
	}
}