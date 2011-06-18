package org.rixel.Core.main
{
	import org.osflash.signals.Signal;

	public class Abstract_internalDisplayObject
	{
		
		public function Abstract_internalDisplayObject()
		{
			
		}
		
		///////////////CALLBACKS///////////////
		///////////PUBLIC FUNCTIONS////////////
		////////////GETTERS SETTERS////////////
	
		///////////////INTERNAL///////////////
		internal function get componentProxy():IRxProxy
		{
			throw new Error("The componentProxy() method must be overridden.");
		}
		
		internal function get componentDisplayable():IDisplayable
		{
			throw new Error("The componentDisplayable() method must be overridden.");
		}
		
		internal function update():void
		{
			throw new Error("The update() method must be overridden.");
		}
	}
}