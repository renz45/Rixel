package org.rixel.Core.displayObjects
{
	import org.rixel.Core.displayObjects.bitmap.RxComponent_BitmapAnimation;
	/**
	 * the useable class by the developer for creating a RxAnimation. The RxComponent_BitmapAnimation is used as a renderer and the methods to control the
	 * animation are proxied over to it to cotnrol functionality. This is done to hide internal methods used for rendering from the developer.
	 * @author adamrensel
	 * 
	 */	
	public class RxAnimation extends Abstract_RxDisplayObject
	{
		private var _class:Class;
		private var _params:Object;
		/**
		 * constructor for creating a RxAnimation. 
		 * @param movieclipClass : Class This is not an instance of the movieclip, it is the classname of the movieclip. The RxAnimation class will decide if it can reuse
		 * data previously converted, or if it needs to create and convert a new instance of the movieclip Class passed in.
		 * @param params : Object settings object for the RxAnimation class. The current settings are {fillColor:0x00000000, transparent:true}
		 * 
		 */		
		public function RxAnimation(movieClipClass:Class,params:Object = null)
		{
			_class = movieClipClass;
			_params = params;
			init();
			
			super();
		}
		
		private function init():void
		{
			
		}
		/**
		 * setup the renderer, in this case the bitmapAnimation renderer 
		 * 
		 */		
		override protected function setupDisplayable():void
		{
			_component_displayable = new RxComponent_BitmapAnimation(_class,_params);
		}
		
		///////////////CALLBACKS///////////////
		///////////PUBLIC FUNCTIONS////////////
		/**
		 * Moves the playhead to the specified frame number. Will default to 0 if the frame is a negative number and default to the last frame
		 * if a value out of bounds is chosen. 
		 * @param frameNumber
		 * 
		 */
		public function gotoAndStop(frameNumber:int):void
		{
			(_component_displayable as RxComponent_BitmapAnimation).gotoAndStop(frameNumber);
		}
		
		/**
		 * Similar to the Flash movieclip method. Goes to frame number specified and plays from there, 
		 * if the frame is greater than the total number, than the last frame is used 
		 * @param frameNumber : int frame number to move to and play from.
		 * @param reverse : Boolean indicates if reverse playing is to be set
		 * 
		 */	
		public function gotoAndPlay(frameNumber:int):void
		{
			(_component_displayable as RxComponent_BitmapAnimation).gotoAndPlay(frameNumber);
		}
		
		/**
		 * starts the RxAnimation playing from where ever the playhead is currently. 
		 * 
		 */	
		public function play():void
		{
			(_component_displayable as RxComponent_BitmapAnimation).play();
		}
		
		/**
		 * Stops the play head at whatever the currentFrame value is 
		 * 
		 */	
		public function stop():void
		{
			(_component_displayable as RxComponent_BitmapAnimation).stop();
		}
		
		////////////GETTERS SETTERS////////////
		
		/**
		 * returns the value for reverse, true being reverse, false being forward 
		 * @return 
		 * 
		 */	
		public function get reverse():Boolean
		{
			return (_component_displayable as RxComponent_BitmapAnimation).reverse;
		}
		
		/**
		 * sets the play direction, true being reverse and false being forward 
		 * @param value
		 * 
		 */	
		public function set reverse(value:Boolean):void
		{
			(_component_displayable as RxComponent_BitmapAnimation).reverse = value;
		}
		
		/**
		 * returns the number of total frames in the animation 
		 * @return int
		 * 
		 */	
		public function get totalFrames():int
		{
			return (_component_displayable as RxComponent_BitmapAnimation).totalFrames;
		}
		
		/**
		 * Returns the number of the current frame being displayed. 
		 * @return  int
		 * 
		 */	
		public function get currentFrame():int
		{
			return (_component_displayable as RxComponent_BitmapAnimation).currentFrame;
		}
	}
} 