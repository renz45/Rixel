package org.rixel.Core.mouse
{
	public interface IMouseTriggerable
	{
		function RxMouseOver(mouseX:int,mouseY:int):void;
		function RxMouseOut(mouseX:int,mouseY:int):void;
		function RxMouseClick(mouseX:int,mouseY:int):void;
		function RxMouseDown(mouseX:int,mouseY:int):void;
		function RxMouseUp(mouseX:int,mouseY:int):void;
	}
}