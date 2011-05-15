package org.rixel.Core.displayObjects
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.flash_proxy;
	
	import mx.charts.chartClasses.InstanceCache;
	import mx.core.MovieClipAsset;
	import mx.core.mx_internal;
	
	import org.osflash.signals.Signal;
	import org.rixel.Core.displayObjects.VO.Sprite_VO;
	import org.rixel.Core.nameSpaces.rixel;
	
	public class Animation2D extends Sprite2D
	{
		private var _currentFrame:int;
		private var _totalFrames:int;
		private var _isPlaying:Boolean;
		private var _reverse:Boolean;
		
		private var _xOffsetMin:Number;
		private var _yOffsetMin:Number;
		
		private var _xOffsetMax:Number;
		private var _yOffsetMax:Number;
		
		private var _imageDataFrames:Vector.<BitmapData>;
		
		public var Event_MovieclipLoaded:Signal;
		
		public function Animation2D(movieclip:Class, params:Object = null)
		{	
			super(movieclip,params);
		}
		
		override protected function init():void
		{
			Event_MovieclipLoaded = new Signal(Animation2D);
			
			_reverse = false;
			_isPlaying = true;
			
			var objectExists:Boolean = _displayObjectList.hasOwnProperty(_className);
			var vo:Sprite_VO;
			
			var newClass:MovieClip = new _displayObjectClass();
			
			if( !objectExists )
			{//name doesn't exist so go ahead and create new frame data and add the name to the  static _displayObjectList array
				
				if(!(newClass is MovieClip))
				{
					throw new Error("a movieclip param is required when creating a new type of animation2D");
				}
				
				vo  = new Sprite_VO();
				vo.name = _className;
				
				_displayObjectList[_className] = vo;
			}else{//name already exists so create a animation2D and give it the information of the stored frames
				vo = _displayObjectList[_className] as Sprite_VO;
				
				_xOffsetMin = vo.xOffset;
				_yOffsetMin = vo.yOffset;
				_imageDataFrames = vo.frames;
				_width = vo.width;
				_height = vo.height;
				
				_currentFrame = 0;
				_dataLoaded = true;
				_totalFrames = _imageDataFrames.length;
				
				Event_MovieclipLoaded.dispatch(this);
			}
			
			if(!objectExists && newClass is MovieClip )
			{	
				convertMovieClip(newClass as MovieClip);
			}else if(!_displayObjectClass is MovieClip){
				throw new Error("a movieclip param is required when creating a new type of animation2D");
			}
		}
		
		private function convertMovieClip(mc:MovieClip):void
		{
			var container:Sprite = new Sprite();
			
			var frameList:Vector.<BitmapData> = new Vector.<BitmapData>;
			
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
				frameList.push(bmd);
			}
			
			_currentFrame = 0;
			_dataLoaded = true;
			_totalFrames = frameList.length;
			
			var vo:Sprite_VO = (_displayObjectList[_className] as Sprite_VO);
			
			vo.frames = frameList;
			vo.xOffset = _xOffsetMin;
			vo.yOffset = _yOffsetMin;
			vo.width = _width;
			vo.height = _height;
			
			_imageDataFrames = vo.frames;
			
			this.Event_MovieclipLoaded.dispatch(this);
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
				
				return _imageDataFrames[_currentFrame];
			}else{
				return new BitmapData(1,1,false);
			}
			
		}
		
		/////////////////////statics///////////////////
		
	}
}