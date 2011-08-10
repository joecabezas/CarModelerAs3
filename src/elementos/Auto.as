package elementos
{
	import assets.Loading;
	import com.marston.utils.URLRequestWrapper;
	import com.adobe.images.JPGEncoder;
	import com.adobe.serialization.json.JSON;
	import com.base86.Tools;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.LoaderMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import objetos3d.Car3D;
	import objetos3d.Objeto3D;
	import org.papervision3d.cameras.DebugCamera3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.view.BasicView;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	public class Auto extends Sprite
	{
		//constantes de tipos de piezas
		//public static const TIPO_AUTO:String = 'tipoAuto';
		public static const TIPO_CHASIS:String = 'tipoChasis';
		public static const TIPO_RUEDAS:String = 'tipoRuedas';
		public static const TIPO_SPOLIERS:String = 'tipoSpoilers';
		public static const TIPO_RETROVISORES:String = 'tipoRetrovisores';
		public static const TIPO_CAPOTS:String = 'tipoCapots';
		public static const TIPO_FALDONES:String = 'tipoFaldones';
		
		//constanets de loaders de esta clase
		public static const JSON_LOADER:String = 'jsonLoader';
		
		//variables de tipos de piezas actuales (default: -1, no existe)
		//private var tipo_auto_actual:int = -1;
		private var tipo_chasis_actual:int = -1;
		private var tipo_ruedas_actual:int = -1;
		private var tipo_spoilers_actual:int = -1;
		private var tipo_retrovisores_actual:int = -1;
		private var tipo_capots_actual:int = -1;
		private var tipo_faldones_actual:int = -1;
		
		//variable de configuracion que almacena los tipos de elementos
		//que ha puesto el usuario, se envia como JSON
		private var config:Object;
		
		//basic view
		private var main_basic_view:BasicView;
		private var main_display_object_3d:DisplayObject3D;
		
		private var chasisArray:Array;
		private var spoilersArray:Array;
		
		private var mouse_target:DisplayObject;
		private var posInicialMouseX:Number;
		private var desired_rotation:Number;
		
		private var loadingBar:Loading;
		
		private var loader_max:LoaderMax;
		
		private var json_url:String;
		
		public function Auto(mouse_target:DisplayObject)
		{
			this.mouse_target = mouse_target;
			
			this.setup();
			this.agregarListeners();
			this.fillArrays();
			this.load();
		}
		
		private function agregarListeners():void
		{
			this.mouse_target.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.mouse_target.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			this.mouse_target.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			trace('Auto.onMouseUp');
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			this.mouse_target.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.posInicialMouseX = this.mouseX;
			trace('Auto.onMouseDown');
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			var deltaX:Number = this.posInicialMouseX - this.mouseX;
			this.updateRotation(deltaX * 0.5);
			this.posInicialMouseX = this.mouseX;
			trace('Auto.onMouseMove');
		}
		
		public function updateRotation(r:Number):void
		{
			this.desired_rotation += r;
			this.main_display_object_3d.rotationY = this.desired_rotation;
		}
		
		private function fillArrays():void
		{
			//Auto 1
			var car:Car3D = new Car3D('assets/daes/auto_1_piso40segs.DAE');
			//car.setTex('images/auto_1_lateral_izq_b.jpg', Car3D.LADO_IZQUIERDO);
			//car.setTex('images/grass.png', Car3D.LADO_SUPERIOR);
			this.chasisArray.push(car);
			
			//this.chasisArray.push(new Car3D('assets/daes/auto_9.DAE'));
			this.chasisArray.push(new Car3D('assets/daes/auto_mas_poligonos.DAE'));
			
			//spoiler 1			
			this.spoilersArray.push(new Objeto3D('assets/daes/spoiler1.DAE'));
			this.spoilersArray.push(new Objeto3D('assets/daes/spoiler2.DAE'));
		}
		
		private function dibujar():void
		{
			//agregar a la escena los elementos por defecto
			this.main_display_object_3d.addChild(this.chasisArray[this.tipo_chasis_actual].getDae(), TIPO_CHASIS);
			
			//agregar el main displayObject3d al main basic view
			this.main_basic_view.scene.addChild(this.main_display_object_3d);
			
			//agregar main_basic_view
			this.addChild(this.main_basic_view);
			this.main_basic_view.startRendering();
			
			//debug
			
			var s:Sprite = new Sprite();
			
			var sx:int = 400;
			var sy:int = 300;
			
			//marco
			s.graphics.lineStyle(3, 0x000000);
			s.graphics.drawRect((this.main_basic_view.viewport.x),(this.main_basic_view.viewport.y), this.main_basic_view.viewport.viewportWidth, this.main_basic_view.viewport.viewportHeight);
			
			s.graphics.lineStyle(2, 0xff0000);
			
			var centrox:Number = (this.main_basic_view.viewport.x) + (this.main_basic_view.viewport.viewportWidth / 2)
			var centroy:Number = (this.main_basic_view.viewport.y) + (this.main_basic_view.viewport.viewportHeight / 2)
			
			//centro
			s.graphics.drawCircle(centrox, centroy, 5);
			
			s.graphics.lineStyle(1, 0xff0000);
			s.graphics.drawCircle(centrox, centroy, Math.min(sx,sy)/2);
			
			s.graphics.lineStyle(1, 0xff0000);
			//lineas
			s.graphics.moveTo(centrox, centroy - 20);
			s.graphics.lineTo(centrox, centroy - 40);
			s.graphics.moveTo(centrox, centroy + 20);
			s.graphics.lineTo(centrox, centroy + 40);
			s.graphics.moveTo(centrox - 20, centroy);
			s.graphics.lineTo(centrox - 40, centroy);
			s.graphics.moveTo(centrox + 20, centroy);
			s.graphics.lineTo(centrox + 40, centroy);
			
			s.graphics.lineStyle(2, 0xff0000);
			s.graphics.drawRect(centrox - (sx / 2), centroy - (sy / 2), sx, sy);
			this.addChild(s);
		}
		
		private function setup():void
		{
			//iniciar la variable config
			//this.config = new Object();
			
			//setear con valores por defecto
			//this.config.piezas.spoilers = -1;
			
			//iniciar json url
			this.json_url = '';
			
			//setear el loader max
			this.loader_max = new LoaderMax({name: 'objects_queue', maxConnections: 3, onProgress: onLoaderMaxProgress, onComplete: onLoaderMaxComplete, onError: onLoaderMaxError});
			
			this.loader_max.append(new DataLoader(this.json_url, {name: JSON_LOADER, onComplete: onJsonLoaded}));
			
			//configurar el basic view
			this.main_basic_view = new BasicView();
			this.main_basic_view.viewport.autoScaleToStage = false;
			
			this.main_basic_view.viewport.viewportWidth = 400;
			this.main_basic_view.viewport.viewportHeight = 400;
			
			this.main_basic_view.viewport.x = 480;
			this.main_basic_view.viewport.y = 0;
			
			this.main_basic_view.camera.zoom = 1000 / this.main_basic_view.camera.focus + 1;
			this.main_basic_view.camera.y = 200;
			
			//configurar el main displayObject3D
			this.main_display_object_3d = new DisplayObject3D();
			this.desired_rotation = 0;
			
			//crear arreglos de elementos
			this.chasisArray = new Array();
			this.spoilersArray = new Array();
			
			//setear los elementos a mostrar or defecto
			this.tipo_chasis_actual = 0;
			this.tipo_spoilers_actual = 0;
		}
		
		private function onJsonLoaded(e:LoaderEvent):void
		{
			this.config = JSON.decode(e.target.content);
			
			//trace(data.auto.piezas.spoilers);
			
			this.cambiarElemento(Auto.TIPO_CHASIS, this.config.auto.piezas.chasis);
			this.cambiarElemento(Auto.TIPO_SPOLIERS, this.config.auto.piezas.spoilers);
		}
		
		private function load():void
		{
			//agregar barra de loading
			this.agregarLoadingBar();
			
			var o3d:Objeto3D;
			
			//agregar los loaders de cada elemento DAE
			for each (o3d in this.chasisArray)
			{
				this.loader_max.append(o3d.getLoaderMax());
					//trace('+'+o3d.getLoaderMax().numChildren);
			}
			
			for each (o3d in this.spoilersArray)
			{
				this.loader_max.append(o3d.getLoaderMax());
			}
			
			//cargar todo
			this.loader_max.load();
		}
		
		private function onLoaderMaxComplete(e:LoaderEvent):void
		{
			trace('Auto.onLoaderMaxComplete');
			this.quitarLoadingBar();
			this.dibujar();
		}
		
		private function onLoaderMaxProgress(e:LoaderEvent):void
		{
		
		}
		
		private function onLoaderMaxError(e:LoaderEvent):void
		{
		
		}
		
		public function cambiarElemento(tipo:String, id:Number):void
		{
			trace('Auto.cambiarElemento');
			
			//verificar que no se trata de un elemento vacio
			//por ejemplo: spoiler = -1;
			if (id < 0)
			{
				return;
			}
			
			switch (tipo)
			{
				case TIPO_SPOLIERS: 
					this.tipo_spoilers_actual = id;
					this.main_display_object_3d.addChild(this.spoilersArray[this.tipo_spoilers_actual].getDae(), TIPO_SPOLIERS);
					break;
				case TIPO_CHASIS: 
					this.tipo_chasis_actual = id;
					this.main_display_object_3d.addChild(this.chasisArray[this.tipo_chasis_actual].getDae(), TIPO_CHASIS);
					break;
			}
		}
		
		public function getIdElemento(tipo:String):int
		{
			switch (tipo)
			{
				case TIPO_SPOLIERS: 
					return this.tipo_spoilers_actual;
					break;
				case TIPO_CHASIS: 
					return this.tipo_chasis_actual;
					break;
			}
			
			return -1;
		}
		
		public function setJsonUrl(string:String):void
		{
			trace(string);
			this.json_url = string;
			this.loader_max.getLoader(JSON_LOADER).url = this.json_url;
		}
		
		public function reloadJson():void
		{
			this.loader_max.getLoader(JSON_LOADER).load(true);
		}
		
		public function sendData():void
		{
			trace('Auto.sendData');
			
			//setear config con las config actuales
			this.updateConfig();
			
			//sacar imagen del auto e incluirla en los datos a enviar
			var img:ByteArray = this.takeScreenshot();
			
			//debug
			//Tools.pr(this.config);
			
			var reqw:URLRequestWrapper = new URLRequestWrapper(img,{json:JSON.encode(this.config)});
			//reqw.method = URLRequestMethod.POST;
			//reqw.data = vars;
			reqw.url = '../send.php';
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onSendJson);
			loader.load(reqw.request);
		}
		
		private function takeScreenshot(quality:Number = 50, screenshot_width:Number = 400, screenshot_height:Number = 300):ByteArray
		{
			var jpgSource:BitmapData = new BitmapData(this.main_basic_view.width, this.main_basic_view.height);
			jpgSource.draw(this.main_basic_view.viewport);
			
			//debug
			var bmp:Bitmap = new Bitmap(jpgSource);
			
			var sx:int = screenshot_width;
			var sy:int = screenshot_height;
			
			bmp.scrollRect = new Rectangle((this.main_basic_view.viewport.viewportWidth / 2) - (sx / 2), (this.main_basic_view.viewport.viewportHeight / 2) - (sy / 2), sx, sy);
			this.addChild(bmp);
			
			bmp.x = 20;
			bmp.y = 20;
			
			//marco
			var s:Sprite = new Sprite();
			s.graphics.lineStyle(5);
			s.graphics.drawRect(bmp.x, bmp.y, bmp.width, 300);
			this.addChild(s);
			
			//end debug
			
			var jpgEncoder:JPGEncoder = new JPGEncoder(quality);
			
			return jpgEncoder.encode(jpgSource);
		}
		
		private function updateConfig():void
		{
			//piezas
			this.config.auto.piezas.faldones = this.tipo_faldones_actual;
			this.config.auto.piezas.capots = this.tipo_capots_actual;
			this.config.auto.piezas.retrovisores = this.tipo_ruedas_actual;
			this.config.auto.piezas.ruedas = this.tipo_ruedas_actual;
			this.config.auto.piezas.spoilers = this.tipo_spoilers_actual;
			this.config.auto.piezas.chasis = this.tipo_chasis_actual;
			
			//propiedades
			this.config.auto.propiedades.rotation = this.desired_rotation;
		
			//texturas
			//this.config.auto.texturas.top = ;
		}
		
		private function onSendJson(e:DataEvent):void
		{
		
		}
		
		private function agregarLoadingBar():void
		{
			this.loadingBar = new Loading();
			this.loadingBar.gotoAndStop(1);
			this.loadingBar.porcentaje.text = 'Cargando: 0%';
			
			//posicion
			this.loadingBar.x = 300;
			this.loadingBar.y = 300;
			
			this.addChild(this.loadingBar);
		}
		
		private function quitarLoadingBar():void
		{
			if (this.loadingBar && this.contains(this.loadingBar))
			{
				this.removeChild(this.loadingBar);
			}
		}
	}

}