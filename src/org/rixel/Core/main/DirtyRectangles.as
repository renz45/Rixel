package org.rixel.Core.main
{
	import flash.geom.Rectangle;
	
	import org.rixel.Core.Geometry.RxRectangle;
	import org.rixel.Core.displayObjects.RxSprite;
	import org.rixel.Core.nameSpaces.rixel;

	use namespace rixel;
	
	public class DirtyRectangles
	{
		
		
		rixel function getRedrawAreas(displayList:Vector.<RxSprite>):Vector.<RxRectangle>
		{
			var rectList:Vector.<RxRectangle> =  createRectangles(displayList);
			
			rectList = mergeIntersects(rectList);
			
			
			return rectList;
		}
		
		private function createRectangles(displayList:Vector.<RxSprite>):Vector.<RxRectangle>
		{
			var rectList:Vector.<RxRectangle> = new Vector.<RxRectangle>;
			
			for each(var sp:RxSprite in displayList)
			{
				if(sp.dirty)
				{
					var rect:RxRectangle = new RxRectangle(sp.rixel::renderX,sp.rixel::renderY,sp.width,sp.height);
					rectList.push(rect);
				}
			}
			
			return rectList;
		}
		
		//this function takes a list of rectangles and recursively merges them if they are overlapping. The function will continue to call itself 
		//until there are no overlapping rectangles left.
		private function mergeIntersects(rectangleList:Vector.<RxRectangle>):Vector.<RxRectangle>
		{
			var mergedRectList:Vector.<RxRectangle> = new Vector.<RxRectangle>;
			var numIntersects:int = 0;
			var length:int = rectangleList.length;
			
			var rect1:RxRectangle;
			var hasIntersected:Boolean;
			
			for(var i:int = 0; i < length; i++)
			{
				rect1 = rectangleList[i] as RxRectangle;
				hasIntersected = false;
				
				for(var k:int = i + 1; k < length; k++)
				{
					var rect2:RxRectangle = rectangleList[k] as RxRectangle;
					
					if( (rect1).intersects(rect2) ) 
					{
						mergedRectList.push( rect1.merge(rect2) );
			
						numIntersects++;
						hasIntersected = true
						
						rectangleList.splice(k,1); 
						length --;
					}
				}
				
				if(!hasIntersected)
				{
					mergedRectList.push(rect1);
				}
			}
			
			if(numIntersects > 0)
			{
				mergedRectList = mergeIntersects(mergedRectList);
			}
			
			return mergedRectList;
		}
		
	}
}