package elementos
{
	import assets.Loading;
	import com.adobe.images.JPGEncoder;
	import com.adobe.serialization.json.JSON;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenLite;
	import com.marston.utils.URLRequestWrapper;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;
	import objetos3d.Car3D;
	import objetos3d.Objeto3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.view.BasicView;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	public class Auto extends Sprite
	{
		//constantes de eventos publicos
		public static const EVENT_LOAD_COMPLETE:String = 'eventLoadComplete';
		
		//constantes de tipos de piezas
		public static const TIPO_AUTO:String = 'tipoAuto';
		public static const TIPO_CHASIS:String = 'tipoChasis';
		public static const TIPO_RUEDAS:String = 'tipoRuedas';
		public static const TIPO_SPOLIERS:String = 'tipoSpoilers';
		public static const TIPO_RETROVISORES:String = 'tipoRetrovisores';
		public static const TIPO_CAPOTS:String = 'tipoCapots';
		public static const TIPO_FALDONES:String = 'tipoFaldones';
		
		//constanets de loaders de esta clase
		public static const JSON_LOADER:String = 'jsonLoader';
		
		//variables de tipos de piezas actuales (default: -1, no existe)
		private var tipo_auto_actual:int = -1;
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
		
		//array de piezas
		private var autoArray:Array;
		private var chasisArray:Array;
		private var spoilersArray:Array;
		
		private var mouse_target:DisplayObject;
		private var posInicialMouseX:Number;
		private var desired_rotation:Number;
		
		private var loadingBar:Loading;
		
		private var loader_max:LoaderMax;
		
		private var json_url:String;
		
		//sprite de cargando info de usuario
		private var loading_user_data_sprite:Sprite;
		
		public function Auto()
		{
			//this.mouse_target = mouse_target;
			
			this.setup();
			//this.agregarListeners();
			this.fillArrays();
			this.load();
		}
		
		private function agregarMouseListeners():void
		{
			this.mouse_target.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.mouse_target.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			this.mouse_target.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			//trace('Auto.onMouseUp');
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			this.mouse_target.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.posInicialMouseX = this.mouseX;
			//trace('Auto.onMouseDown');
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			var deltaX:Number = this.posInicialMouseX - this.mouseX;
			this.updateRotation(deltaX * 0.5);
			this.posInicialMouseX = this.mouseX;
			//trace('Auto.onMouseMove');
		}
		
		public function updateRotation(r:Number):void
		{
			//verificar que no este deshabilitado el mouse
			if (!this.mouseEnabled)
				return;
			
			this.desired_rotation += r;
			
			//que no sobrepase 360
			this.desired_rotation = this.desired_rotation % 360;
			
			this.main_display_object_3d.rotationY = this.desired_rotation;
		}
		
		private function fillArrays():void
		{
			//Auto 1
			//var car:Car3D = new Car3D('assets/daes/wv_UV.dae'); //21X
			//car.setTex('images/auto_1_lateral_izq_b.jpg', Car3D.LADO_IZQUIERDO);
			//car.setTex('images/grass.png', Car3D.LADO_SUPERIOR);
			//this.autoArray.push(new Car3D('assets/daes/auto_1_piso40segs.DAE'));
			//this.autoArray.push(new Car3D('assets/daes/wv_modelado2.dae'));
			this.autoArray.push(new Car3D('assets/daes/auto_1.DAE'));
			//this.autoArray.push(new Car3D('assets/daes/autojoe.dae'));
			
			//this.chasisArray.push(new Car3D('assets/daes/auto_9.DAE'));
			//this.chasisArray.push(new Car3D('assets/daes/auto_mas_poligonos.DAE'));
			
			//spoiler 1			
			this.spoilersArray.push(new Objeto3D('assets/daes/spoiler1.DAE'));
			this.spoilersArray.push(new Objeto3D('assets/daes/spoiler2.DAE'));
		}
		
		private function dibujar():void
		{
			//agregar a la escena los elementos por defecto
			this.main_display_object_3d.addChild(Car3D(this.autoArray[this.tipo_auto_actual]).getDae(), TIPO_AUTO);
			
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
			s.graphics.drawRect((this.main_basic_view.viewport.x), (this.main_basic_view.viewport.y), this.main_basic_view.viewport.viewportWidth, this.main_basic_view.viewport.viewportHeight);
			
			s.graphics.lineStyle(2, 0xff0000);
			
			var centrox:Number = (this.main_basic_view.viewport.x) + (this.main_basic_view.viewport.viewportWidth / 2)
			var centroy:Number = (this.main_basic_view.viewport.y) + (this.main_basic_view.viewport.viewportHeight / 2)
			
			//centro
			s.graphics.drawCircle(centrox, centroy, 5);
			
			s.graphics.lineStyle(1, 0xff0000);
			s.graphics.drawCircle(centrox, centroy, Math.min(sx, sy) / 2);
			
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
			this.loader_max = new LoaderMax({name: 'main_queue', maxConnections: 3, onProgress: onLoaderMaxProgress, onComplete: onLoaderMaxComplete, onError: onLoaderMaxError});
			
			this.loader_max.append(new DataLoader(this.json_url, {name: JSON_LOADER, onComplete: onJsonLoaded}));
			
			//configurar el basic view
			this.main_basic_view = new BasicView();
			this.main_basic_view.viewport.autoScaleToStage = false;
			
			this.main_basic_view.viewport.viewportWidth = 400;
			this.main_basic_view.viewport.viewportHeight = 400;
			
			this.main_basic_view.viewport.x = 0;
			this.main_basic_view.viewport.y = 0;
			
			this.main_basic_view.camera.zoom = 1 * 1000 / this.main_basic_view.camera.focus + 1;
			this.main_basic_view.camera.y = 200;
			
			//configurar el main displayObject3D
			this.main_display_object_3d = new DisplayObject3D();
			this.desired_rotation = 0;
			
			//crear arreglos de elementos
			this.autoArray = new Array();
			this.chasisArray = new Array();
			this.spoilersArray = new Array();
			
			//setear los elementos a mostrar or defecto
			this.tipo_auto_actual = 0;
			this.tipo_chasis_actual = -1;
			this.tipo_spoilers_actual = -1;
		}
		
		private function load():void
		{
			trace('Auto.load');
			//agregar barra de loading
			this.agregarLoadingBar();
			
			var o3d:Objeto3D;
			
			//agregar los loaders de cada elemento DAE
			for each (o3d in this.autoArray)
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
		
		private function onJsonLoaded(e:LoaderEvent):void
		{
			trace('Auto.onJsonLoaded');
			//trace(e.target.content);
			this.config = JSON.decode(e.target.content);
			
			trace(this.config.auto.texturas.left);
			
			//this.cambiarElemento(Auto.TIPO_AUTO, this.config.auto.piezas.auto);
			//this.cambiarElemento(Auto.TIPO_CHASIS, this.config.auto.piezas.chasis);
			//this.cambiarElemento(Auto.TIPO_SPOLIERS, this.config.auto.piezas.spoilers);
			
			//recargar texturas
			Car3D(this.autoArray[this.tipo_auto_actual]).setTex(this.config.auto.texturas.left, Car3D.LADO_IZQUIERDO);
			Car3D(this.autoArray[this.tipo_auto_actual]).setTex(this.config.auto.texturas.right, Car3D.LADO_DERECHO);
			Car3D(this.autoArray[this.tipo_auto_actual]).setTex(this.config.auto.texturas.top, Car3D.LADO_SUPERIOR);
			
			LoaderMax(Car3D(this.autoArray[this.tipo_auto_actual]).getLoaderMax().getLoader(Car3D.LOADER_MAX_TEXS)).addEventListener(LoaderEvent.COMPLETE, onLoadTexs);
			Car3D(this.autoArray[this.tipo_auto_actual]).getLoaderMax().getLoader(Car3D.LOADER_MAX_TEXS).load();
		}
		
		private function onLoadTexs(e:LoaderEvent):void
		{
			trace('Auto.onLoadTexs');
			
			//deprecated
			//Car3D(this.autoArray[this.tipo_auto_actual]).cambiarTexturasAuto();
			
			//obtener texturas cargadas
			var bmpd_izq:BitmapData = Bitmap(ImageLoader(LoaderMax(Car3D(this.autoArray[this.tipo_auto_actual]).getLoaderMax().getLoader(Car3D.LOADER_MAX_TEXS)).getLoader(Car3D.LADO_IZQUIERDO)).rawContent).bitmapData;
			var bmpd_der:BitmapData = Bitmap(ImageLoader(LoaderMax(Car3D(this.autoArray[this.tipo_auto_actual]).getLoaderMax().getLoader(Car3D.LOADER_MAX_TEXS)).getLoader(Car3D.LADO_DERECHO)).rawContent).bitmapData;
			var bmpd_top:BitmapData = Bitmap(ImageLoader(LoaderMax(Car3D(this.autoArray[this.tipo_auto_actual]).getLoaderMax().getLoader(Car3D.LOADER_MAX_TEXS)).getLoader(Car3D.LADO_SUPERIOR)).rawContent).bitmapData;
			
			this.cambiarTextura(bmpd_izq, Car3D.LADO_IZQUIERDO);
			this.cambiarTextura(bmpd_der, Car3D.LADO_DERECHO);
			this.cambiarTextura(bmpd_top, Car3D.LADO_SUPERIOR);
			
			//hacer que estas nuevas texturas sean default
			Car3D(this.autoArray[this.tipo_auto_actual]).updateDefaultMaterials();
			
			this.quitarLoadingBarInfoUsuario();
		}
		
		private function onLoaderMaxComplete(e:LoaderEvent):void
		{
			trace('Auto.onLoaderMaxComplete');
			
			this.mouse_target = this.stage;
			this.agregarMouseListeners();
			this.quitarLoadingBar();
			this.dibujar();
			
			//disparar evento
			this.dispatchEvent(new Event(EVENT_LOAD_COMPLETE));
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
				case TIPO_AUTO: 
					//al escoger un auto nuevo, se deben remover todos los objetos y poner el auto vacio
					this.resetCar();
					this.tipo_auto_actual = id;
					this.main_display_object_3d.addChild(this.autoArray[this.tipo_auto_actual].getDae(), TIPO_AUTO);
					break;
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
		
		private function resetCar():void
		{
			trace('Auto.resetCar');
			
			//setear tipos actuales
			this.tipo_auto_actual = -1;
			this.tipo_capots_actual = -1;
			this.tipo_chasis_actual = -1;
			this.tipo_faldones_actual = -1;
			this.tipo_retrovisores_actual = -1;
			this.tipo_ruedas_actual = -1;
			this.tipo_spoilers_actual = -1;
			
			//borrar elementos main display object 3d
			trace(this.main_display_object_3d.numChildren);
			for each (var i:DisplayObject3D in this.main_display_object_3d.children)
			{
				this.main_display_object_3d.removeChild(i);
			}
			trace(this.main_display_object_3d.numChildren);
			//ObjectUtil.pr(this.main_display_object_3d.children);
		}
		
		public function cambiarTextura(tex:BitmapData, tipo:String):Bitmap
		{
			
			trace('Auto.cambiarTextura');
			trace(tex);
			trace(tipo);
			
			var mat:MaterialObject3D;
			var c3d:Car3D = Car3D(this.autoArray[this.tipo_auto_actual]);
			
			switch (tipo)
			{
				case Car3D.LADO_IZQUIERDO: 
					mat = c3d.tex_left_material;
					break;
				case Car3D.LADO_DERECHO: 
					mat = c3d.tex_right_material;
					break;
				case Car3D.LADO_SUPERIOR: 
					mat = c3d.tex_top_material;
					break;
			}
			
			return  c3d.cambiarTextura(tipo + '-material', mat, tex);
		}
		
		public function getIdElemento(tipo:String):int
		{
			switch (tipo)
			{
				case TIPO_AUTO: 
					return this.tipo_auto_actual;
					break;
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
			trace('Auto.setJsonUrl');
			trace(string);
			this.json_url = string;
			this.loader_max.getLoader(JSON_LOADER).url = this.json_url;
		}
		
		public function reloadJson():void
		{
			trace('Auto.reloadJson');
			
			//setear loading icon de informacion de usuario
			this.agregarLoadingBarInfoUsuario();
			
			this.loader_max.getLoader(JSON_LOADER).load(true);
		
		/*switch(this.loader_max.getLoader(JSON_LOADER).status) {
		   case LoaderStatus.COMPLETED:
		   trace('COMPLETED');
		   break;
		   case LoaderStatus.DISPOSED:
		   trace('DISPOSED');
		   break;
		   case LoaderStatus.FAILED:
		   trace('FAILED');
		   break;
		   case LoaderStatus.LOADING:
		   trace('LOADING');
		   break;
		   case LoaderStatus.PAUSED:
		   trace('PAUSED');
		   break;
		   case LoaderStatus.READY:
		   trace('READY');
		   break;
		 }*/
		}
		
		public function sendData():void
		{
			trace('Auto.sendData');
			
			//setear config con las config actuales
			this.updateConfig();
			
			//sacar screenshot del auto e incluirla en los datos a enviar
			var ba_screenshot:ByteArray = this.takeScreenshot();
			
			//texturas
			var je_izq:JPGEncoder = new JPGEncoder();
			var ba_textura_izq:ByteArray = je_izq.encode(MaterialObject3D(Car3D(this.autoArray[this.tipo_auto_actual]).getActualMaterial(Car3D.LADO_IZQUIERDO)).bitmap);
			
			var je_der:JPGEncoder = new JPGEncoder();
			var ba_textura_der:ByteArray = je_der.encode(MaterialObject3D(Car3D(this.autoArray[this.tipo_auto_actual]).getActualMaterial(Car3D.LADO_DERECHO)).bitmap);
			
			var je_top:JPGEncoder = new JPGEncoder();
			var ba_textura_top:ByteArray = je_top.encode(MaterialObject3D(Car3D(this.autoArray[this.tipo_auto_actual]).getActualMaterial(Car3D.LADO_SUPERIOR)).bitmap);
			
			//crear array de los byteArrays de las texturas
			var bav:Vector.<ByteArray> = new Vector.<ByteArray>;
			
			bav.push(ba_screenshot);
			bav.push(ba_textura_izq);
			bav.push(ba_textura_der);
			bav.push(ba_textura_top);
			
			var reqw:URLRequestWrapper = new URLRequestWrapper(bav, {json: JSON.encode(this.config)});
			//reqw.method = URLRequestMethod.POST;
			//reqw.data = vars;
			reqw.url = '../send.php';
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onSendData);
			loader.load(reqw.request);
		}
		
		public function setViewportWidth(number:Number):void
		{
			this.main_basic_view.viewport.viewportWidth = number;
		}
		
		public function setViewportHeight(number:Number):void
		{
			this.main_basic_view.viewport.viewportHeight = number;
		}
		
		public function mostrarLado(lado:String):void
		{
			var anguloY:Number;
			var anguloX:Number;
			
			switch (lado)
			{
				case Car3D.LADO_IZQUIERDO: 
					anguloY = 0;
					anguloX = 0;
					break;
				case Car3D.LADO_DERECHO: 
					anguloY = 180;
					anguloX = 0;
					break;
				case Car3D.LADO_SUPERIOR: 
					anguloY = 0;
					anguloX = -90;
					break;
				default: 
					anguloY = 0;
					anguloX = 0;
					break;
			}
			
			//actualizar desired rotation
			this.desired_rotation = anguloY;
			
			TweenLite.to(this.main_display_object_3d, 0.4, {rotationX: anguloX, rotationY: anguloY});
		}
		
		public function resetRotationX():void
		{
			TweenLite.to(this.main_display_object_3d, 0.4, {rotationX: 0});
		}
		
		private function takeScreenshot(quality:Number = 50, screenshot_width:Number = 400, screenshot_height:Number = 300):ByteArray
		{
			var jpgSource:BitmapData = new BitmapData(this.main_basic_view.width, this.main_basic_view.height);
			jpgSource.draw(this.main_basic_view.viewport);
			
			var bmp:Bitmap = new Bitmap(jpgSource);
			
			var sx:int = screenshot_width;
			var sy:int = screenshot_height;
			
			bmp.scrollRect = new Rectangle((this.main_basic_view.viewport.viewportWidth / 2) - (sx / 2), (this.main_basic_view.viewport.viewportHeight / 2) - (sy / 2), sx, sy);
			
			//final bitmapdata
			var final_bmpd:BitmapData = new BitmapData(screenshot_width, screenshot_height);
			final_bmpd.draw(bmp);
			
			//debug
			//var bmpt:Bitmap = new Bitmap(final_bmpd);
			//this.addChild(bmpt);
			
			var jpgEncoder:JPGEncoder = new JPGEncoder(quality);
			return jpgEncoder.encode(final_bmpd);
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
		
		private function onSendData(e:DataEvent):void
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
		
		private function agregarLoadingBarInfoUsuario():void
		{
			this.loading_user_data_sprite = new Sprite();
			
			var centerx:Number = (this.main_basic_view.viewport.x) + (this.main_basic_view.viewport.viewportWidth / 2);
			var centery:Number = (this.main_basic_view.viewport.y) + (this.main_basic_view.viewport.viewportHeight / 2);
			
			this.loading_user_data_sprite.graphics.beginFill(0xffff00, 0.7);
			this.loading_user_data_sprite.graphics.drawCircle(centerx, centery, 30);
			this.loading_user_data_sprite.graphics.endFill();
			
			this.addChild(this.loading_user_data_sprite);
		}
		
		private function quitarLoadingBarInfoUsuario():void
		{
			//sacar icono de cargando informacion de usuario
			if ((this.loading_user_data_sprite) && (this.contains(this.loading_user_data_sprite)))
			{
				this.removeChild(this.loading_user_data_sprite);
			}
		}
	}

}