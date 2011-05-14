package org.rixel.Core.displayObjects
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import mx.charts.chartClasses.InstanceCache;
	
	import org.rixel.Core.displayObjects.VO.DisplayObject_VO;
	import org.rixel.Core.nameSpaces.rixel;
	import org.rixel.Core.utils.ClipFrameManager;

	public class Animation2D extends Sprite2D
	{
		private var _imageDataFrames:Vector.<BitmapData>;
		private var _currentFrame:int;
		private var _totalFrames:int;
		private var _isPlaying:Boolean;
		private var _reverse:Boolean;
		
		private var _xOffsetMin:Number;
		private var _yOffsetMin:Number;
		
		private var _xOffsetMax:Number;
		private var _yOffsetMax:Number;
		
		private var _id:int;
		
		private var _frameManager:ClipFrameManager;
		
		
		private static var _clipList:Vector.<Vector.<BitmapData>>;
		private static var _clipInfoList:Object;
		
		public function Animation2D()
		{	
			super();
		}
		
		override protected function init():void
		{
			super.init();
			
			_reverse = false;
			_isPlaying = true;
			
			_frameManager = ClipFrameManager.getInstance();
		}
		
		private function convertMovieClip(mc:MovieClip):void
		{
			_imageDataFrames = new Vector.<BitmapData>;
			
			var container:Sprite = new Sprite();
			
			findMaxDimensions(mc);
			
			mc.x = _xOffsetMin;
			mc.y = _yOffsetMin;
			container.addChild(mc);
			
			_width += _xOffsetMax;
			_height += _yOffsetMax;
			
			for(var i:int = 0; i < mc.totalFrames; i++ )
			{
				mc.gotoAndStop(i);
				
				var bmd:BitmapData = new BitmapData(_width,_height,_transparent,_fillColor);
				bmd.draw(container);
				_imageDataFrames.push(bmd);
			}
			
			_currentFrame = 0;
			_imageData = _imageDataFrames[0];
			
			_totalFrames = _imageDataFrames.length;
			
			_dataLoaded = true;
			
			_clipList.push(_imageDataFrames);
			
			_id = _clipList.indexOf(_imageDataFrames);
			
			mc = null;
			container = null;
			mc = null;
			
			
			createVO();
		}
		
		private function findMaxDimensions(mc:MovieClip):void
		{
			var maxWidth:Number = 0;
			var maxHeight:Number = 0;
			_xOffsetMin = 0;
			_yOffsetMin = 0;
			_xOffsetMax = 0;
			_yOffsetMax = 0;
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
				
				
				if(rect.x < _xOffsetMin)
				{
					_xOffsetMin = rect.x;
				}
				
				if(rect.y < _yOffsetMin)
				{
					_yOffsetMin = rect.y;
				}
				
				if(rect.x > _xOffsetMax)
				{
					_xOffsetMax = rect.x;
				}
				
				if(rect.y > _yOffsetMax)
				{
					_yOffsetMax = rect.y;
				}
			}
			
			
			_xOffsetMin =	_xOffsetMin * -1;
			_yOffsetMin = _yOffsetMin * -1;
			
			_xOffsetMax = Math.ceil(_xOffsetMax);
			_yOffsetMax = Math.ceil(_yOffsetMax);
			
			_width = maxWidth;
			_height = maxHeight;
		}
		
		private function createVO():void
		{
			var vo:DisplayObject_VO = new DisplayObject_VO();
			
			vo.x = _x;
			vo.y = _y;
			
			vo.xOffsetMin = _xOffsetMin;
			vo.yOffsetMin = _yOffsetMin;
			
			vo.xOffsetMax = _xOffsetMax;
			vo.yOffsetMax = _yOffsetMax;
			
			vo.width = _width;
			vo.height = _height;
			
			vo.id = _id;
			
			_alpha =1;
			_transparent = true;
			_fillColor = 4.295;
			
			_reverse = false;
			_isPlaying = true;
			
			_currentFrame = 0;
			_imageData = _imageDataFrames[0];
			
			
			vo.totalFrames = _totalFrames;
		}


		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS////////////////
		
		
		public function gotoAndStop(frameNumber:int):void
		{
			if(frameNumber >= _totalFrames)
			{//if number is greater than total go to the last frame
				_currentFrame = _totalFrames - 1;
				_imageData = _imageDataFrames[_totalFrames - 1];
			}else if(frameNumber < 0){//if number is less than 0 go to 0
				_currentFrame = 0;
				_imageData = _imageDataFrames[0];
			}else{//just go to the frame
				_currentFrame = frameNumber;
				_imageData = _imageDataFrames[frameNumber];
			}
		}
		
		public function gotoAndPlay(reverse:Boolean = false):void
		{
			
		}
		
		public function setMovieClipReference(movieClip:MovieClip, name:String):void
		{
			
			convertMovieClip(movieClip);
		}
		
		
		////////////////////GETTERS SETTERS////////////////
		
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		
		public function get totalFrames():int
		{
			return _totalFrames;
		}
		
		
		//////////////////ending specific/////////////
		rixel function get renderX():Number
		{
			return _x - _xOffsetMin;
		}
		
		rixel function get renderY():Number
		{
			return _y - _yOffsetMin;
		}
		
		rixel function get frame():BitmapData
		{
			if(_dataLoaded)
			{
				_imageData = _imageDataFrames[_currentFrame];
				
				if(_isPlaying)
				{
					if(_reverse)
					{
						if(_currentFrame == 0)
						{
							_currentFrame = _totalFrames - 1;
						}else{
							_currentFrame --;
						}
					}else{
						if(_currentFrame == _totalFrames - 1)
						{
							_currentFrame = 0;
						}else{
							_currentFrame ++;
						}
					}
				}
				
				return _imageData;
			}else{
				return new BitmapData(1,1,false,0xffffff);
			}
			
		}
		
		/////////////////////statics///////////////////
		
		public static function init():void
		{
			_clipList = new Vector.<Vector.<BitmapData>>;
			_clipInfoList = {};
		}
		
	}
}