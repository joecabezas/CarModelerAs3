package
{
	import assets.Loading;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.LoaderMax;
	import elementos.Auto;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
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
		
		//elementos para generar una textura tepomral
		private var tex_sprite:Sprite;
		private var tex_textfield:TextField;
		
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
			//entry point
			
			this.setup();
			this.agregarListeners();
			this.dibujar();
		}
		
		private function agregarListeners():void
		{
			this.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			this.auto.addEventListener(Auto.EVENT_LOAD_COMPLETE, onAutoLoaded);
		}
		
		private function onAutoLoaded(e:Event):void 
		{
			this.auto.setJsonUrl('data/auto.json');
			this.auto.reloadJson();
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
				case 51: //3
					this.cambiarTexturaAuto(Car3D.LADO_IZQUIERDO);
					break;
				case 76: //l
					//recargar auto
					this.auto.reloadJson();
					break;
				case 83: //s
					//cargar auto
					this.auto.sendData();
					break;
			}
		}
		
		private function cambiarTexturaAuto(tipo:String):void 
		{
			var bmpd:BitmapData = new BitmapData(this.tex_sprite.width, this.tex_sprite.height);
			var bmp:Bitmap = new Bitmap(bmpd);
			
			bmpd.draw(this.tex_sprite);
			
			var scale:Number = 0.3;
			var tbmpd:BitmapData = new BitmapData(bmp.width * scale, bmp.height * scale);
			tbmpd = bmpd.clone();
			
			var tbmp:Bitmap = new Bitmap();
			
			tbmp.scaleX = tbmp.scaleY = scale;
			
			bmpd.draw(tbmp);
			
			
			this.addChild(bmp);
			bmp.y = this.tex_sprite.y + bmp.height;
			
			this.auto.cambiarTextura(bmp.bitmapData, tipo);
		}
		
		private function setup():void
		{
			this.auto = new Auto();
			
			this.tex_sprite = new Sprite();
			this.tex_textfield = new TextField();
			this.tex_textfield.type = TextFieldType.INPUT;
			this.tex_textfield.multiline = true;
			this.tex_textfield.border = true;
			this.tex_textfield.width = 200;
			
			var tf:TextFormat = new TextFormat();
			tf.bold = true;
			tf.size = 30;
			
			this.tex_textfield.defaultTextFormat = tf;
			
			this.tex_sprite.addChild(this.tex_textfield);
			this.tex_sprite.y = this.stage.stageHeight / 2 + 30;
		}
		
		private function dibujar():void
		{
			this.addChild(this.auto);
			this.addChild(this.tex_sprite);
		}
	
	}

}