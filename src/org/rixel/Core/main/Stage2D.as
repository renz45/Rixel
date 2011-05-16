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
	
	import org.rixel.Core.displayObjects.Animation2D;
	import org.rixel.Core.displayObjects.Sprite2D;
	import org.rixel.Core.nameSpaces.rixel;
	
	import spark.components.mediaClasses.VolumeBar;
	
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
		private var _buffer1:BitmapData;
		private var _buffer2:BitmapData;
		private var _renderRect:Rectangle;
		 
		
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
			
			//GPU rendering mode setup
			if(_renderMode == Stage2D.BLIT_RENDERER)
			{
				_buffer1 = new BitmapData(_width,_height,_transparent,_bgColor);
				_buffer2 = new BitmapData(_width,_height,_transparent,_bgColor);
				
				_bmpCanvas = new Bitmap(_buffer1,"auto",_smoothing);
				//_bmpCanvas = new Bitmap(null,"auto",_smoothing);
				
				this.addChild(_bmpCanvas);
			}
			
			
		}
		
		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS/////////////////
		public function render():void
		{
			if(_renderMode == Stage2D.BLIT_RENDERER)
			{
				blitRenderer();
			}else if(_renderMode == Stage2D.GRAPHIC_RENDERER){
				graphicRenderer();
			}
			
		}
		
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

			//_buffer1.lock();
			
			var redrawAreas:Vector.<Rectangle> = Stage2DUtils.rixel::getRedrawAreas(_displayList);
			
			//double buffer
			if(_bmpCanvas.bitmapData == _buffer1)
			{
				_buffer1.fillRect( _renderRect,0xFFFFFF);
				_bmpCanvas.bitmapData = _buffer2;
			}else{
				_buffer1.fillRect( _renderRect,0xFFFFFF);
				_bmpCanvas.bitmapData = _buffer1;
			}
			
			///_bmpCanvas.bitmapData = _drawnLast;
			
			
			for each(var s2D:Sprite2D in _displayList)
			{
				sX = s2D.rixel::renderX;
				sY = s2D.rixel::renderY;
				sWidth = s2D.width;
				sHeight = s2D.height;
				point.x = sX;
				point.y = sY;
				
				//these conditionals perform screen clipping. So if an object has part that is off the stage, those pixels aren't drawn internally
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
				
				if(_bmpCanvas.bitmapData == _buffer1)
				{
					_buffer2.copyPixels(s2D.rixel::frame,rect, point);
				}else{
					_buffer1.copyPixels(s2D.rixel::frame,rect, point);
				}
			}
			
		//	_buffer1.unlock(); 
		}
		
		
		
		private function graphicRenderer():void
		{
			this.graphics.clear();
			for each(var s2D:Sprite2D in _displayList)
			{
				this.graphics.beginBitmapFill(s2D.frame,new Matrix(1,0,0,1,s2D.x,s2D.y),false,false);
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
		
		
		////////////////////STATICS////////////////////////
		public static function init():void
		{
			Sprite2D.rixel::init();
		}
		
	}
}