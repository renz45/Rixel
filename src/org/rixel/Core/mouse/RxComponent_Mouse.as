package org.rixel.Core.mouse
{
	import org.osflash.signals.Signal;

	public class RxComponent_Mouse implements IMouseTriggerable
	{
		public var Event_MouseOver:Signal;
		public var Event_MouseOut:Signal;
		public var Event_MouseClick:Signal;
		public var Event_MouseDown:Signal;
		
		public function RxComponent_Mouse()
		{
			
		}
		

		
		
		///////////////CALLBACKS///////////////
		///////////PUBLIC FUNCTIONS////////////
		public function RxMouseOver():void
		{
			//trace("HIT!");
		}
		public function RxMouseOut():void
		{
			//trace("MOUSE OUT!");
		}
		public function RxMouseClick():void
		{
			//trace("CLICK!");
		}
		public function RxMouseDown():void
		{
			//trace("DOWN!");
		}
		public function RxMouseUp():void
		{
			//trace("UP!");
		}
		////////////GETTERS SETTERS////////////
	}
}