package org.rixel.Core.mouse
{
	import org.osflash.signals.Signal;
	import org.rixel.Core.displayObjects.Abstract_RxDisplayObject;
	import org.rixel.Core.main.Abstract_internalDisplayObject;

	/**
	 * Used for when the mouse calls events on objects 
	 * @author adamrensel
	 * 
	 */
	public class RxComponent_Mouse implements IMouseTriggerable
	{
		private var _displayObject:Abstract_internalDisplayObject;
		
		/**
		 * signal for event dispatching, callback function needs to have arguments: Abstract_internalDisplayObject,int,int
		 */		
		public var Event_MouseOver:Signal;
		/**
		 * signal for event dispatching, callback function needs to have arguments: Abstract_internalDisplayObject,int,int
		 */	
		public var Event_MouseOut:Signal;
		/**
		 * signal for event dispatching, callback function needs to have arguments: Abstract_internalDisplayObject,int,int
		 */	
		public var Event_MouseClick:Signal;
		/**
		 * signal for event dispatching, callback function needs to have arguments: Abstract_internalDisplayObject,int,int
		 */	
		public var Event_MouseDown:Signal;
		/**
		 * signal for event dispatching, callback function needs to have arguments: Abstract_internalDisplayObject,int,int
		 */	
		public var Event_MouseUp:Signal;
		
		public function RxComponent_Mouse(displayObject:Abstract_internalDisplayObject)
		{
			_displayObject = displayObject;
			
			Event_MouseOver = new Signal(Abstract_internalDisplayObject,int,int);
			Event_MouseOut = new Signal(Abstract_internalDisplayObject,int,int);
			Event_MouseClick = new Signal(Abstract_internalDisplayObject,int,int);
			Event_MouseDown = new Signal(Abstract_internalDisplayObject,int,int);
			Event_MouseUp = new Signal(Abstract_internalDisplayObject,int,int);
		}
		
		///////////////CALLBACKS///////////////
		///////////PUBLIC FUNCTIONS////////////
		public function RxMouseOver(mouseX:int,mouseY:int):void
		{
			Event_MouseOver.dispatch(_displayObject,mouseX,mouseY);
		}
		public function RxMouseOut(mouseX:int,mouseY:int):void
		{
			Event_MouseOut.dispatch(_displayObject,mouseX,mouseY);
		}
		public function RxMouseClick(mouseX:int,mouseY:int):void
		{
			Event_MouseClick.dispatch(_displayObject,mouseX,mouseY);
		}
		public function RxMouseDown(mouseX:int,mouseY:int):void
		{
			Event_MouseDown.dispatch(_displayObject,mouseX,mouseY);
		}
		public function RxMouseUp(mouseX:int,mouseY:int):void
		{
			Event_MouseUp.dispatch(_displayObject,mouseX,mouseY);
		}
		////////////GETTERS SETTERS////////////
	}
}