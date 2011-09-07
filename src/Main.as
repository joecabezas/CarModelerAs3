package
{
	import com.as3joelib.generators.TextFieldGenerator;
	import com.as3joelib.joeeditor.JoeEditor;
	//import com.as3joelib.ppv3d.SimpleDAELoader;
	import com.as3joelib.ui.UISwitcher;
	import elementos.Auto;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import objetos3d.Car3D;
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	[SWF(backgroundColor="#cccccc",width=920,height=600,frameRate="60")]
	[Frame(factoryClass="Preloader")]
	
	public class Main extends Sprite
	{
		//elementos de switcher
		private var auto:Auto;
		
		//editores
		private var editor_lado_izquierdo:JoeEditor;
		private var editor_lado_derecho:JoeEditor;
		private var editor_lado_superior:JoeEditor;
		
		//vars
		private var lado_que_se_esta_editando:String;
		
		//external
		private var ei:ExternalInterfaceExample;
		
		//switchers
		private var switcher_main:UISwitcher;
		//private var switcher_editores:UISwitcher;
		
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
			
			this.auto.addEventListener(Auto.EVENT_LOAD_COMPLETE, onAutoLoaded);
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
					this.pintarAutoReady();
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
			this.switcher_main.switchTo(this.auto);
			
			//recordar que estamos modificando este lado
			this.lado_que_se_esta_editando = lado;
			
			//hacer que el auto se mueva al lado a pintar
			this.auto.mostrarLado(lado);
			
			//hacer que el switcher deje activado el editor
			switch(lado) {
				case Car3D.LADO_IZQUIERDO:
					this.switcher_main.switchTo(this.editor_lado_izquierdo, false);
					break;
				case Car3D.LADO_DERECHO:
					this.switcher_main.switchTo(this.editor_lado_derecho, false);
					break;
				case Car3D.LADO_SUPERIOR:
					this.switcher_main.switchTo(this.editor_lado_superior, false);
					break;
			}
		}
		
		private function pintarAutoReady():void 
		{
			//obtener bitmap del editor
			var bmpd:BitmapData;
			
			switch(this.lado_que_se_esta_editando) {
				case Car3D.LADO_IZQUIERDO:
					bmpd = this.editor_lado_izquierdo.getBitmapData();
					break;
				case Car3D.LADO_DERECHO:
					bmpd = this.editor_lado_derecho.getBitmapData();
					break;
				case Car3D.LADO_SUPERIOR:
					bmpd = this.editor_lado_superior.getBitmapData();
					break;
			}
			
			//this.addChild(new Bitmap(bmpd));
			
			//cambiar textura al auto
			var bmp:Bitmap = this.auto.cambiarTextura(bmpd, this.lado_que_se_esta_editando);
			
			//restaurar la rotacion en X si es que se estaba editando la parte superior
			this.auto.resetRotationX();
			
			//debug: ver textura
			var t:TextField = TextFieldGenerator.crearTextField('DEBUG: textura resultante:', { size:9 } );
			
			this.addChild(t);
			t.x = this.stage.stageWidth - 150 - 10;
			t.y = this.stage.stageHeight - 150 - 25;
			
			this.addChild(bmp);
			bmp.width = bmp.height = 150;
			bmp.x = this.stage.stageWidth - 150 - 10;
			bmp.y = this.stage.stageHeight - 150 - 10;
			
			//hacer que el switcher me cambie al visor del auto nuevamente
			this.switcher_main.switchTo(this.auto);
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
			
			//editores
			this.editor_lado_izquierdo = new JoeEditor();
			this.editor_lado_derecho = new JoeEditor();
			this.editor_lado_superior = new JoeEditor();
			
			//switchers
			this.switcher_main = new UISwitcher();
			this.switcher_main.animation_in_object = {duration:0.3, alpha:1}
			this.switcher_main.animation_out_object = { duration:0.3, alpha:0 }
			
			//this.switcher_editores = new UISwitcher();
			//this.switcher_editores.animation_in_object = {duration:0, alpha:1}
			//this.switcher_editores.animation_out_object = {duration:0, alpha:0}
			
			//ei
			//this.ei = new ExternalInterfaceExample();
		}
		
		private function dibujar():void
		{
			this.addChild(this.auto);

			this.addChild(this.editor_lado_izquierdo);
			this.addChild(this.editor_lado_derecho);
			this.addChild(this.editor_lado_superior);

			this.switcher_main.addItem(this.auto);
			this.switcher_main.addItem(this.editor_lado_izquierdo);
			this.switcher_main.addItem(this.editor_lado_derecho);
			this.switcher_main.addItem(this.editor_lado_superior);
			
			this.switcher_main.hideAllItems();
			this.switcher_main.switchTo(this.auto);
			
			//this.addChild(new SimpleDAELoader('assets/daes/autojoe.dae'));
		}
	
	}

}