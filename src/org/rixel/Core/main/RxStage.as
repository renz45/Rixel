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
	
	import org.rixel.Core.Geometry.RxRectangle;
	import org.rixel.Core.displayObjects.RxAnimation;
	import org.rixel.Core.displayObjects.RxSprite;
	import org.rixel.Core.nameSpaces.rixel;
	import org.rixel.Core.quadTree.RxProxyBase;
	import org.rixel.Core.quadTree.RxQuadTree;
	import org.rixel.Core.quadTree.RxQuadTreeNode;
	import org.rixel.Core.quadTree.RxQuadTreeProxy;
	
	import spark.components.mediaClasses.VolumeBar;
	import org.rixel.oldUnusedForReference.RxStage_Old;
	
	use namespace rixel;
	
	public class RxStage extends Sprite
	{
		private var _width:int;
		private var _height:int; 
		private var _padding:int
		private var _transparent:Boolean;
		private var _bgColor:uint;
		private var _smoothing:Boolean;
		 
		private var _renderMode:String;
		private var _displayList:Vector.<RxSprite>;
		private var _bmpCanvas:Bitmap;
		private var _bitmapBuffer:BitmapData;
		private var _renderRect:Rectangle;
		
		private var _tree:RxQuadTree;
		private var _debugCanvas:Sprite = new Sprite();
		private var _debugRect:RxRectangle = new RxRectangle();
		private var _debugNode:RxQuadTreeNode;
		
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
 
		public static const GRAPHIC_RENDERER:String = "graphicRenderer";
		public static const BLIT_RENDERER:String = "blitRenderer";
		
		public function RxStage(width:Number,height:Number,padding:int = 200, bgColor:uint = 0xFFFFFF, smoothing:Boolean = false, renderMode:String = RxStage.BLIT_RENDERER)
		{
			super();
			
			_width = width;
			_height = height;
			_transparent = false;
			_bgColor = bgColor; 
			_smoothing = smoothing;
			
			_renderMode = renderMode;
			
			_padding = padding;
			
			init(); 
		}
		
		private function init():void
		{	
			_tree = new RxQuadTree(5,RxQuadTree.MAX_1024_OBJECTS);
		 	_tree.setWorldBounds(new RxRectangle(-_padding,-_padding,_width + (_padding*2),_height + (_padding*2)) );
			
			_renderRect = new Rectangle(0,0,_width,_height);
			
			_displayList = new Vector.<RxSprite>;
			
			//GPU rendering mode setup
			if(_renderMode == RxStage_Old.BLIT_RENDERER)
			{
				_bitmapBuffer = new BitmapData(_width,_height,true,_bgColor);
				
				_bmpCanvas = new Bitmap(_bitmapBuffer,"auto",_smoothing);
				
				this.addChild(_bmpCanvas);
			}
			
			this.addChild(_debugCanvas);
		}
		
		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS/////////////////
		public function render():void
		{
			switch(_renderMode)
			{
				case RxStage_Old.BLIT_RENDERER:
					blitRenderer();
					break;
				case RxStage_Old.GRAPHIC_RENDERER:
					graphicRenderer();
					break;
			}
			
		}
		
		//this is the render loop for the blit render engine, it looks a bit cluttered instead of abstracting parts out and splitting it up
		//because it's more efficient to keep everything directly in the loop and make as few function calls as possible. I rarely do this because i like
		//more organized code, but i figured the render loop needs to be as efficient as possible.
		private function blitRenderer():void
		{
			//_debugCanvas.graphics.clear();
			//_debugCanvas.graphics.lineStyle(1,0xFFaaaa);
			
			_bitmapBuffer.lock();
			
			rect.x = 0;
			rect.y = 0;
			rect.width = _width;
			rect.height = _height; 
			point.x = 0;
			point.y = 0;
			
			//clear bitmap
			_bitmapBuffer.fillRect(rect,0);
			
			for each(var s2D:RxSprite in _displayList)
			{
				_tree.moveProxy(s2D.proxyId);
				 
				
				//_debugNode = _tree.getNodeContaining(s2D.proxyId);
				//_debugNode = s2D.proxy.node;
			//	_debugCanvas.graphics.drawRect(_debugNode.xmin,_debugNode.ymin,_debugNode.xmax - _debugNode.xmin, _debugNode.ymax - _debugNode.ymin);
				
				sX = s2D.rixel::renderX;
				sY = s2D.rixel::renderY;
				sWidth = s2D.width;
				sHeight = s2D.height;
				point.x = sX;
				point.y = sY;
		
				//these conditionals perform screen clipping. So if an object has part that is off the stage, those pixels aren't drawn internally
				//it's more efficient to keep this code in the loop rather then abstract it to a static class, even though it makes this code
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
				
				_bitmapBuffer.copyPixels(s2D.rixel::frame,rect, point,null,null,true);
			}
			
			_bitmapBuffer.unlock();
		}
		
		private function graphicRenderer():void
		{
			this.graphics.clear();
			for each(var s2D:RxSprite in _displayList)
			{
				this.graphics.beginBitmapFill(s2D.rixel::frame,new Matrix(1,0,0,1,s2D.x,s2D.y),false,false);
				this.graphics.drawRect(s2D.x,s2D.y,s2D.width,s2D.height);
				this.graphics.endFill();
			}
		}
		
		public function rxAddChild(child:RxSprite):RxSprite
		{
			child.proxyId = _tree.createProxy(child);
			_displayList.push(child);
			
			return child;
		}
		
		/*public function rxAddChildAt(child:RxSprite, index:int):RxSprite
		{
			return child;
		}*/
		
		////////////////////GETTERS SETTERS////////////////

		
		////////////////////STATICS////////////////////////
		public static function init():void
		{
			RxSprite.rixel::init();
		}
		
	}
}