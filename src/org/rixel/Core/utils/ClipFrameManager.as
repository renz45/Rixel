package org.rixel.Core.utils
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import org.rixel.Core.displayObjects.VO.DisplayObject_VO;
	import org.rixel.Core.nameSpaces.rixel;
	import org.rixel.Core.utils.VO.ClipFrameManager_VO;

	public class ClipFrameManager
	{
		
		private static var _clipList:Vector.<BitmapData>;
		private static var _clipInfoList:Object;
		
		private static var _instance:ClipFrameManager;
		
		public function ClipFrameManager()
		{
			if(_instance)
			{
				throw new Error("The ClipFrameManager class is a singleton, please use the static getInstance() method");
			}else{
				_instance = this;
			}
		}
		
		private function init():void
		{
			
		}
		
		
		
		private function findMaxDimensions(mc:MovieClip):ClipFrameManager_VO
		{
			var maxWidth:Number = 0;
			var maxHeight:Number = 0;
			var xOffsetMin:Number = 0;
			var yOffsetMin:Number = 0;
			var xOffsetMax:Number = 0;
			var yOffsetMax:Number = 0;
			var rect:Rectangle;
			
			for(var i:int = 0; i < mc.totalFrames; i++ )
			{
				mc.gotoAndStop(i);
				
				rect = mc.getBounds(mc);
				
				if(rect.width > maxWidth)
				{
					maxWidth = rect.width;
				}
				
				if(rect.height > maxHeight)
				{
					maxHeight = rect.height;
				}
				
				
				if(rect.x < xOffsetMin)
				{
					xOffsetMin = rect.x;
				}
				
				if(rect.y < yOffsetMin)
				{
					yOffsetMin = rect.y;
				}
				
				if(rect.x > xOffsetMax)
				{
					xOffsetMax = rect.x;
				}
				
				if(rect.y > yOffsetMax)
				{
					yOffsetMax = rect.y;
				}
			}
			
			
			var vo:ClipFrameManager_VO = new ClipFrameManager_VO();
			
			vo.maxWidth = maxWidth;
			vo.maxHeight = maxHeight;
			vo.xOffsetMin = xOffsetMin * -1;
			vo.xOffsetMax = Math.ceil(xOffsetMax);
			vo.yOffsetMin = yOffsetMin * -1;
			vo.yOffsetMax = Math.ceil(yOffsetMax);
			vo.width = maxWidth;
			vo.height = maxHeight;
			
			return vo;
		}
		
		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS/////////////////
		rixel function convertMovieClip(mc:MovieClip,name:String, transparent:Boolean = true, fillColor:uint = 0xFFFFFF):void
		{
			var imageDataFrames:Vector.<BitmapData> = new Vector.<BitmapData>;
			
			var container:Sprite = new Sprite();
			
			var dimensionInfo:ClipFrameManager_VO = findMaxDimensions(mc);
			
			var width:Number = dimensionInfo.width;
			var height:Number = dimensionInfo.height;
			
			mc.x = dimensionInfo.xOffsetMin;
			mc.y = dimensionInfo.yOffsetMin;
			container.addChild(mc);
			
			width += dimensionInfo.xOffsetMax;
			height += dimensionInfo.yOffsetMax;
			
			for(var i:int = 0; i < mc.totalFrames; i++ )
			{
				mc.gotoAndStop(i);
				
				var bmd:BitmapData = new BitmapData(width,height,transparent,fillColor);
				bmd.draw(container);
				imageDataFrames.push(bmd);
			}
			
			//_currentFrame = 0;
			//_imageData = _imageDataFrames[0];
			
			var totalFrames:int = imageDataFrames.length;
			
			//_dataLoaded = true;
			
			_clipList.push(imageDataFrames);
			
			var id:int = _clipList.indexOf(imageDataFrames);
			
			mc = null;
			container = null;
			
			//_eventManager.trigger(Event2D.ASSET_LOADED,this);
			
			var vo:DisplayObject_VO = new DisplayObject_VO();
			
			vo.xOffsetMin = dimensionInfo.xOffsetMin;
			vo.yOffsetMin = dimensionInfo.yOffsetMin;
			
			vo.xOffsetMax = dimensionInfo.xOffsetMax;
			vo.yOffsetMax = dimensionInfo.yOffsetMax;
			
			vo.width = width;
			vo.height = height;
			
			vo.id = id;
			
			/*_alpha =1;
			_transparent = true;
			_fillColor = 4.295;
			
			_reverse = false;
			_isPlaying = true;
			
			_currentFrame = 0;
			_imageData = _imageDataFrames[0];*/
			
			
			vo.totalFrames = totalFrames;
			
			_clipInfoList[name] = vo;
		}
		
		rixel function getFramesForName(name:String):Vector.<BitmapData>
		{
			return _clipList[(_clipInfoList[name] as DisplayObject_VO).id] as Vector.<BitmapData>;
		}
		
		rixel function getFrameInfoForName(name:String):DisplayObject_VO
		{
			return _clipInfoList[name] as DisplayObject_VO;
		}
		
		////////////////////GETTERS SETTERS////////////////
		
		
		//////////////////STATICS//////////////////
		public static function getInstance():ClipFrameManager
		{
			if(_instance == null)
			{
				_clipList = new Vector.<BitmapData>;
				_clipInfoList = {};
				_instance = new ClipFrameManager();
				
				return _instance;
			}else{
				return _instance;
			}
		}
	}

}