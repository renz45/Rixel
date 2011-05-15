package org.rixel.Core.main
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
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
		private var _canvasData:BitmapData;
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
				_canvasData = new BitmapData(_width,_height,_transparent,_bgColor);
				
				_bmpCanvas = new Bitmap(_canvasData,"auto",_smoothing);
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
			_canvasData.lock();
			
			_canvasData.fillRect( _renderRect,0xFFFFFF);
			
			var rectXOffset:Number;
			var rectYOffset:Number
			
			var rectWidthOffset:Number = 0;
			var rectHeightOffset:Number = 0;
			
			var sX:Number = 0
			var sY:Number = 0
			var sWidth:Number = 0;
			var sHeight:Number = 0;
			
			for each(var s2D:Animation2D in _displayList)
			{
				sX = s2D.rixel::renderX;
				sY = s2D.rixel::renderY;
				sWidth = s2D.width;
				sHeight = s2D.height;
				
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
				
					_canvasData.copyPixels(s2D.rixel::frame,new Rectangle(rectXOffset,rectYOffset,sWidth + rectXOffset - rectWidthOffset,sHeight + rectYOffset - rectHeightOffset),new Point(sX,sY) );
			
				
			}
			
			_canvasData.unlock(); 
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