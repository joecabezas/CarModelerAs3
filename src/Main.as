package
{
	import assets.Loading;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.LoaderMax;
	import elementos.Auto;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import objetos3d.Car3D;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	[SWF(backgroundColor="#eeeeee",width=920,height=600,frameRate=60)]
	[Frame(factoryClass="Preloader")]
	
	public class Main extends Sprite
	{
		public var auto:Auto;
		private var loader_max:LoaderMax;
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			this.setup();
			this.agregarListeners();
			this.dibujar();
		}
		
		private function agregarListeners():void
		{
			this.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			trace(e);
			var id:int;
			var character:String = String.fromCharCode(e.charCode);
			
			switch(e.keyCode) {
				case 49: //1
					id = (this.auto.getIdElemento(Auto.TIPO_CHASIS)+1) % 3;
					this.auto.cambiarElemento(Auto.TIPO_CHASIS, id);
					break;
				case 50: //2
					id = (this.auto.getIdElemento(Auto.TIPO_SPOLIERS)+1) % 2;
					this.auto.cambiarElemento(Auto.TIPO_SPOLIERS, id);
					break;
				case 76: //l
					//cargar auto
					this.auto.setJsonUrl('data/auto.json');
					this.auto.reloadJson();
					break;
				case 83: //s
					//cargar auto
					this.auto.sendData();
					break;
			}
		}
		
		private function setup():void
		{
			this.auto = new Auto(this.stage);
		}
		
		private function dibujar():void
		{
			this.addChild(this.auto);
		}
	
	}

}