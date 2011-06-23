//TODO add function callbacks to frames
//TODO add gotoAndPlayUntil Method - goes to specified frame and stops/repeats at specified frame
package org.rixel.Core.displayObjects.bitmap
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import org.rixel.Core.displayObjects.VO.Sprite_VO;
	/**
	 * This is a bitmap animation class. It has methods and functionality similar to a Flash Movieclip, although it is not a display object container, and doesn't
	 * have the addchild functionality. This is done for the sake of speed. This class recycles bitmapData vectors, so if a movieclip is used more than once
	 * it is only converted once and frames are shared between all instances of the animation class that use that movieclip.
	 *  
	 * @author adamrensel
	 * 
	 */	
	public class RxComponent_BitmapAnimation extends Abstract_RxBitmap_DisplayObject
	{ 
		private var _className:String;
		private var _displayObjectClass:Class;
		
		private var _currentFrame:int;
		private var _totalFrames:int;
		private var _isPlaying:Boolean;
		private var _playDirection:int;
		
		private var _xOffsetMin:int;
		private var _yOffsetMin:int;
		
		private var _xOffsetMax:int;
		private var _yOffsetMax:int;
		
		private static var _displayObjectList:Object;
		private static var _placeHolderData:BitmapData;
		
		private var _imageDataFrames:Vector.<BitmapData>;
		/**
		 * constructor for creating a RxAnimation. 
		 * @param movieclipClass : Class This is not an instance of the movieclip, it is the classname of the movieclip. The RxAnimation class will decide if it can reuse
		 * data previously converted, or if it needs to create and convert a new instance of the movieclip Class passed in.
		 * @param params : Object settings object for the RxAnimation class. The current settings are {fillColor:0x00000000, transparent:true}
		 * 
		 */		
		public function RxComponent_BitmapAnimation(movieclipClass:Class, params:Object = null)
		{	
			super(params);
			
			if(_displayObjectList == null)
			{
				throw new Error("Please initialize Rixel before instantiating the RxAnimation --> Rixel.init()");
			}
			
			_displayObjectClass = movieclipClass;
			_className = (movieclipClass as Class).toString();
			
			init(); 
		}
		
		private function init():void
		{	
			//set defaults, -1 for reverse play
			_playDirection = 1;
			_isPlaying = true;
			
			
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
				Event_Loaded.dispatch(this);
			}
			
			newClass = null;
		}
		
		//takes a movieclip and converts the frames into a vector of bitmap data
		private function convertMovieClip(mc:MovieClip):void
		{
			
			var frameList:Vector.<BitmapData> = new Vector.<BitmapData>;
			
			//finds max dimensions and offsets.
			findMaxDimensions(mc);
			
			var m:Matrix = new Matrix();
			m.tx = _xOffsetMin * -1;
			m.ty = _yOffsetMin * -1;
			
			_width += _xOffsetMax;
			_height += _yOffsetMax;
			
			//loop through the frames and draw bitmap data to a vector array
			for(var i:int = 0; i < mc.totalFrames; i++ )
			{
				mc.gotoAndStop(i);
				
				var bmd:BitmapData = new BitmapData(_width,_height,_transparent,_fillColor);
				bmd.draw(mc,m);
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
			this.Event_Loaded.dispatch(this);
		}
		
		//this method loops through all the frames of a movieclip and finds max width and max heights. It also finds offsets so we can account
		//for registration points that aren't in the top left.
		//This solves the problem of a rotating object getting it's corners cut off during the rotation cycle, and movieclips that contain sliding animation
		//not displaying properly
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
			
			
			_xOffsetMin =_xOffsetMin;
			_yOffsetMin = _yOffsetMin;
			
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
		
		/**
		 * Similar to the Flash movieclip method. Goes to frame number specified and plays from there, 
		 * if the frame is greater than the total number, than the last frame is used 
		 * @param frameNumber : int frame number to move to and play from.
		 * @param reverse : Boolean indicates if reverse playing is to be set
		 * 
		 */		
		public function gotoAndPlay(frameNumber:int, reverse:Boolean = false):void
		{
			this.reverse = reverse;
			gotoAndStop(frameNumber);
			_isPlaying = true;
		}
		
		/**
		 * starts the RxAnimation playing from where ever the playhead is currently. 
		 * 
		 */		
		public function play():void
		{
			_isPlaying = true;
		}
		
		/**
		 * Stops the play head at whatever the currentFrame value is 
		 * 
		 */		
		public function stop():void
		{
			_isPlaying = false;
			
		}
		////////////////////GETTERS SETTERS////////////////
		
		/**
		 * Returns the number of the current frame being displayed. 
		 * @return  int
		 * 
		 */		
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		
		/**
		 * returns the number of total frames in the animation 
		 * @return int
		 * 
		 */		
		public function get totalFrames():int
		{
			return _totalFrames;
		}
		
		/**
		 * sets the play direction, true being reverse and false being forward 
		 * @param value
		 * 
		 */		
		public function set reverse(value:Boolean):void
		{
			if(value)
			{
				_playDirection = -1;
			}else{
				_playDirection = 1;
			}
		}
		
		/**
		 * returns the value for reverse, true being reverse, false being forward 
		 * @return 
		 * 
		 */		
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
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		override public function get boundsX():int
		{
			return _x + _xOffsetMin;
		}
		
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		override public function get boundsY():int
		{
			return _y + _yOffsetMin;
		}
		
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		override public function get xOffset():int
		{
			return _xOffsetMin;
		}
		
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		override public function get yOffset():int
		{
			return _yOffsetMin; 
		}
		
		//engine specific function used by the Stage2D to render the image.
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		override public function get incrementFrame():BitmapData 
		{	
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
					
				}
				return _imageDataFrames[_currentFrame];
			}else{
				return _placeHolderData;
			}
		}
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		override public function get staticFrame():BitmapData
		{
			if(_dataLoaded)
			{
				return _imageDataFrames[_currentFrame];
			}else{
				return _placeHolderData;
			}
		}
		/////////////////////statics///////////////////
		/**
		 * @private 
		 * 
		 */		
		public static function init():void
		{
			_displayObjectList = {};
			_placeHolderData = new BitmapData(1,1,false);
		}
	}
}