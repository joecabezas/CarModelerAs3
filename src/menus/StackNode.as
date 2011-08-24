package menus 
{
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	public class StackNode extends Sprite 
	{
		//private var name:String; //viene implementado con sprite
		
		//icono
		//private var icon:Sprite; //http://www.veryicon.com/icon/png/Object/Global%20Warming/Wheel.png
		private var icon_image_url:String;
		private var image_loader:ImageLoader;
		
		public function StackNode(image_url:String, name:String) 
		{
			this.icon_image_url = image_url;
			this.name = name;
			
			this.setup();
			this.dibujar();
		}
		
		private function setup():void 
		{
			this.image_loader = new ImageLoader(this.icon_image_url, {
				name:'imageLoader',
				centerRegistration:true,
				
				width:50,
				height:50,
				
				//debug
				bgColor:0xff0000,
				noCache:true,
				//
				
				onComplete:onImageLoaderComplete,
				onError:onImageLoaderError
			});
			this.image_loader.load();
		}
		
		private function onImageLoaderError(e:LoaderEvent):void 
		{
			MonsterDebugger.trace(this, {funct:'onImageLoaderError', msg:e});
		}
		
		private function onImageLoaderComplete(e:LoaderEvent):void 
		{
			MonsterDebugger.trace(this, {funct:'onImageLoaderComplete', msg:e});
			//this.dibujar();
		}
		
		private function dibujar():void 
		{
			this.addChild(this.image_loader.content);
		}
		
		
		
	}

}