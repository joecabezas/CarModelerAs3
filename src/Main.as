package
{
	import com.as3joelib.joeeditor.JoeEditor;
	import com.as3joelib.ui.UISwitcher;
	import elementos.Auto;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import objetos3d.Car3D;
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	[SWF(backgroundColor="#eeeeee",width=920,height=600,frameRate=60)]
	[Frame(factoryClass="Preloader")]
	
	public class Main extends Sprite
	{
		//elementos de switcher
		private var auto:Auto;
		private var editor:JoeEditor;
		
		//creoq  no sirve esto ya
		//private var loader_max:LoaderMax;
		
		//elementos para generar una textura tepomral
		//private var tex_sprite:Sprite;
		//private var tex_textfield:TextField;
		
		//external
		private var ei:ExternalInterfaceExample;
		
		//ui
		private var switcher:UISwitcher;
		
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
			
			//temp
			//var sn:StackNode = new StackNode('http://www.veryicon.com/icon/png/Object/Global%20Warming/Wheel.png', 'nombre');
			//this.addChild(sn);
			
			this.setup();
			this.agregarListeners();
			this.dibujar();
		}
		
		private function agregarListeners():void
		{
			this.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			//this.auto.addEventListener(Auto.EVENT_LOAD_COMPLETE, onAutoLoaded);
		}
		
		private function onAutoLoaded(e:Event):void 
		{
			trace('Main.onAutoLoaded');
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
					id = (this.auto.getIdElemento(Auto.TIPO_AUTO)+1) % 2;
					this.auto.cambiarElemento(Auto.TIPO_AUTO, id);
					break;
				case 50: //2
					id = (this.auto.getIdElemento(Auto.TIPO_SPOLIERS)+1) % 2;
					this.auto.cambiarElemento(Auto.TIPO_SPOLIERS, id);
					break;
				case 51: //3
					break;
				case 52: //4
					this.cambiarTexturaAuto(Car3D.LADO_IZQUIERDO);
					break;
				case 53: //5
					this.pintarAuto(Car3D.LADO_IZQUIERDO);
					break;
				case 54: //6
					this.pintarAuto(Car3D.LADO_DERECHO);
					break;
				case 55: //7
					this.pintarAuto(Car3D.LADO_SUPERIOR);
					break;
				case 56: //8
					this.pintarAutoReady(Car3D.LADO_IZQUIERDO);
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
		
		private function pintarAuto(lado:String):void 
		{
			//to do: considerar parametro "lado"
			
			//hacer que el auto se mueva al lado a pintar
			this.auto.mostrarLado(lado);
			
			//hacer que el switcher deje activado el editor
			this.switcher.switchTo(this.editor, false);
		}
		
		private function pintarAutoReady(lado:String):void 
		{
			//obtener bitmap del editor
			var bmpd:BitmapData = this.editor.getBitmapData();
			
			//this.addChild(new Bitmap(bmpd));
			
			//cambiar textura al auto
			this.auto.cambiarTextura(bmpd, lado);
			
			//hacer que el switcher me cambie al visor del auto nuevamente
			this.switcher.switchTo(this.auto);
		}
		
		private function cambiarTexturaAuto(tipo:String):void 
		{
			/*var bmpd:BitmapData = new BitmapData(this.tex_sprite.width, this.tex_sprite.height);
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
			
			this.auto.cambiarTextura(bmp.bitmapData, tipo);*/
		}
		
		private function setup():void
		{			
			this.auto = new Auto();
			this.auto.setViewportWidth(this.stage.stageWidth);
			this.auto.setViewportHeight(this.stage.stageHeight);
			
			this.editor = new JoeEditor();
			
			//switcher
			this.switcher = new UISwitcher();
			this.switcher.animation_in_object = {duration:0.3, alpha:1}
			this.switcher.animation_out_object = {duration:0.3, alpha:0}
			
			/*this.tex_sprite = new Sprite();
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
			this.tex_sprite.y = this.stage.stageHeight / 2 + 30;*/
			
			//editor
			//this.ei = new ExternalInterfaceExample();
		}
		
		private function dibujar():void
		{
			this.addChild(this.auto);
			this.switcher.addItem(this.auto);
			
			this.addChild(this.editor);
			this.switcher.addItem(this.editor);
			
			this.switcher.hideAllItems();
			this.switcher.switchTo(this.auto);
			
			//this.addChild(this.tex_sprite);
			
			//this.addChild(this.ei);
			
			//temp
			/*var sd:SimpleDAELoader = new SimpleDAELoader();
			this.addChild(sd);*/
		}
	
	}

}