package org.rixel.Core.displayObjects
{
	import org.rixel.Core.main.Abstract_RxDisplayObject;
	import org.rixel.Core.main.RxComponent_BitmapAnimation;
	
	public class RxAnimation extends Abstract_RxDisplayObject
	{
		private var _class:Class;
		private var _params:Object;
		
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
		
		override protected function setupDisplayable():void
		{
			_component_displayable = new RxComponent_BitmapAnimation(_class,_params);
		}
		
		///////////////CALLBACKS///////////////
		///////////PUBLIC FUNCTIONS////////////
		public function gotoAndStop(frameNumber:int):void
		{
			(_component_displayable as RxComponent_BitmapAnimation).gotoAndStop(frameNumber);
		}
		
		public function gotoAndPlay(frameNumber:int):void
		{
			(_component_displayable as RxComponent_BitmapAnimation).gotoAndPlay(frameNumber);
		}
		
		public function play():void
		{
			(_component_displayable as RxComponent_BitmapAnimation).play();
		}
		
		public function stop():void
		{
			(_component_displayable as RxComponent_BitmapAnimation).stop();
		}
		
		
		
		////////////GETTERS SETTERS////////////
		public function get reverse():Boolean
		{
			return (_component_displayable as RxComponent_BitmapAnimation).reverse;
		}
		
		public function set reverse(value:Boolean):void
		{
			(_component_displayable as RxComponent_BitmapAnimation).reverse = value;
		}
		
		public function get totalFrames():int
		{
			return (_component_displayable as RxComponent_BitmapAnimation).totalFrames;
		}
		
		public function get currentFrame():int
		{
			return (_component_displayable as RxComponent_BitmapAnimation).currentFrame;
		}
	}
}