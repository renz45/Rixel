package org.rixel.Core.displayObjects
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.flash_proxy;
	
	import org.osflash.signals.Signal;
	import org.rixel.Core.collision.RxCollision;
	import org.rixel.Core.displayObjects.VO.Sprite_VO;
	import org.rixel.Core.nameSpaces.rixel;
	
	use namespace rixel;
	
	public class RxAnimation extends RxSprite
	{ 
		private var _currentFrame:int;
		private var _totalFrames:int;
		private var _isPlaying:Boolean;
		private var _playDirection:int;
		
		private var _xOffsetMin:int;
		private var _yOffsetMin:int;
		
		private var _xOffsetMax:int;
		private var _yOffsetMax:int;
		
		private var _imageDataFrames:Vector.<BitmapData>;
		
		
		public function RxAnimation(movieclip:Class, params:Object = null)
		{	
			super(movieclip,params);
		}
		
		override protected function init():void
		{	
			//set defaults, -1 for reverse play
			_playDirection = 1;
			_isPlaying = true;
			_dirty = true;
			
			_collisionManager = new RxCollision(this);
			
			//create a boolean which tests of our static object has a name in its list that matches the given class
			var objectExists:Boolean = _displayObjectList.hasOwnProperty(_className);
			var vo:Sprite_VO;
			
			//if the class doesnt exist than make a new slot in the object and create a sprite_VO to go in the slot
			if( !objectExists )
			{//name doesn't exist so go ahead and create new frame data and add the name to the  static _displayObjectList array
				
				var newClass:MovieClip = new _displayObjectClass();
				
				if(!(newClass is MovieClip))
				{
					throw new Error("a movieclip param is required when creating a new type of animation2D");
				}
				
				vo  = new Sprite_VO();
				vo.name = _className;
				
				_displayObjectList[_className] = vo;
				
				convertMovieClip(newClass as MovieClip);
				
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
				
				//dispatch loaded event
				Event_MovieclipLoaded.dispatch(this);
			}
			
			newClass = null;
		}
		
		//takes a movieclip and converts the frames into a vector of bitmap data
		private function convertMovieClip(mc:MovieClip):void
		{
			var container:Sprite = new Sprite();
			
			var frameList:Vector.<BitmapData> = new Vector.<BitmapData>;
			
			//finds max dimensions and offsets.
			findMaxDimensions(mc);
			
			mc.x = _xOffsetMin;
			mc.y = _yOffsetMin; 
			container.addChild(mc);
			
			_width += _xOffsetMax;
			_height += _yOffsetMax;
			
			//loop through the frames and draw bitmap data to a vector array
			for(var i:int = 0; i < mc.totalFrames; i++ )
			{
				mc.gotoAndStop(i);
				
				var bmd:BitmapData = new BitmapData(_width,_height,_transparent,_fillColor);
				bmd.draw(container);
				frameList.push(bmd);
			}
			
			//set defaults
			_currentFrame = 0;
			_dataLoaded = true;
			_totalFrames = frameList.length;
			
			//create a new VO for the static object which holds the vector of frames and other information needed to create a new animation of this type
			var vo:Sprite_VO = (_displayObjectList[_className] as Sprite_VO);
			
			vo.frames = frameList;
			vo.xOffset = _xOffsetMin;
			vo.yOffset = _yOffsetMin;
			vo.width = _width;
			vo.height = _height;
			
			_imageDataFrames = vo.frames;
			
			//dispatch loaded event
			this.Event_MovieclipLoaded.dispatch(this);
		}
		
		//this method loops through all the frames of a movieclip and finds max width and max heights. It also finds offsets so we can account
		//for registration points that aren't in the top left.
		//This solves the problem of a rotating object getting it's corners cut off during the rotation cycle, and movieclips that contain sliding animation
		private function findMaxDimensions(mc:MovieClip):void
		{
			var maxWidth:int = 0;
			var maxHeight:int = 0;
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
			
			
			_xOffsetMin =_xOffsetMin * -1;
			_yOffsetMin = _yOffsetMin * -1;
			
			_xOffsetMax = Math.ceil(_xOffsetMax);
			_yOffsetMax = Math.ceil(_yOffsetMax);
			
			_width = maxWidth;
			_height = maxHeight;
			
		}
		
		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS////////////////
		
		/**
		 * Moves the playhead to the specified frame number. Will default to 0 if the frame is a negative number and default to the last frame
		 * if a value out of bounds is chosen. 
		 * @param frameNumber
		 * 
		 */		
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
			
			_isPlaying = false;
		}
		
		public function gotoAndPlay(frameNumber:int, reverse:Boolean = false):void
		{
			gotoAndStop(frameNumber);
			_isPlaying = true;
		}
		
		public function play():void
		{
			_isPlaying = true;
		}
		
		public function stop():void
		{
			_isPlaying = false;
			
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
		
		public function set reverse(value:Boolean):void
		{
			if(value)
			{
				_playDirection = -1;
			}else{
				_playDirection = 1;
			}
		}
		
		public function get reverse():Boolean
		{
			if(_playDirection == -1)
			{
				return true;
			}else{
				return false;
			}
		}
		
		//////////////////engine specific/////////////
		
		//these render values will account for the offset of the movieclip. So if a registration point was in the center the position will be the same
		//the function is a engine specific function since users don't need to see these values.
		override public function get boundsX():int
		{
			return _x - _xOffsetMin;
		}
		
		override public function get boundsY():int
		{
			return _y - _yOffsetMin; 
		}
		
		//engine specific function used by the Stage2D to render the image.
		override public function get frame():BitmapData 
		{
			_collisionManager.update();
			
			if(_dataLoaded)
			{
				
				if(_isPlaying)
				{
					_currentFrame += _playDirection;
					
					if(_currentFrame > _totalFrames - 1)
					{
						_currentFrame = 0;
					}else if(_currentFrame < 0)
					{
						_currentFrame = _totalFrames - 1;
					}
					
					_dirty = true; 
					Event_IsDirty.dispatch(this);
				}else{
					_dirty = false;
				}
				return _imageDataFrames[_currentFrame];
			}else{
				return _placeHolderData;
			}
		}
		
		override public function get collisionFrame():BitmapData
		{
			if(_dataLoaded)
			{
				return _imageDataFrames[_currentFrame];
			}else{
				return _placeHolderData;
			}
		}
		/////////////////////statics///////////////////
		
	}
}