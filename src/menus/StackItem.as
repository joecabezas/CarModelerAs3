package menus 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	public class StackItem extends Sprite 
	{
		private var nodes:Vector.<StackNode>
		
		public function StackItem() 
		{
			this.setup();
			this.fillVector();
			this.dibujar();
		}
		
		private function setup():void 
		{
			this.nodes = new Vector.<StackNode>;
		}
		
		private function fillVector():void 
		{
			
		}
		
		public function addNode(sn:StackNode):void {
			this.nodes.push(sn);
		}
		
		private function dibujar():void 
		{
			for each(var sn:StackNode in this.nodes) {
					
			}
		}
		
	}

}