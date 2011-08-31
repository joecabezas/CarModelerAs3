package objetos3d

{
	import com.adobe.air.crypto.EncryptionKeyGenerator;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.special.CompositeMaterial;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.DAE;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	public class Objeto3D extends DisplayObject3D
	{
		public static const DAE_FILE:String = 'daeFile';
		
		private var dae:DAE;
		protected var dae_file:String;
		
		//loader
		protected var loader_max_dae:LoaderMax;
		
		public function Objeto3D(dae_file:String)
		{
			this.dae_file = dae_file;
			this.setup();
			this.agregarListeners();
			this.load();
		}
		
		private function load():void
		{
			trace('Objeto3D.load');
			this.dae.load(this.dae_file);
		}
		
		private function agregarListeners():void
		{
			trace('Objeto3D.agregarListeners');
			this.dae.addEventListener(FileLoadEvent.LOAD_COMPLETE, onDaeLoadComplete);
		}
		
		private function onDaeLoadComplete(e:FileLoadEvent):void
		{
			trace('Objeto3D.onDaeLoadComplete');
			//trace(this.loader_max_dae);
			//this.dae = this.loader_max_dae.getLoader(DAE_FILE).getDae();
			this.dae.y = -6;
			
			this.onDaeParsedExtraSteps();
		}
		
		public function cambiarTextura(objectName:String, material_original:MaterialObject3D, material_over:BitmapData):Bitmap
		{
			trace('Objeto3D.cambiarTextura objectName: ' + objectName);
			
			// TODO
			//este if, en estricto rigor no debiera hacerse, ya que los modelos seguiran un estandar de tener las mismas ID de texturas
			//if (this.dae.getChildByName('COLLADA_Scene').getChildByName(objectName))
			//{
			
			//crear copia bitmap original
			var bmpd:BitmapData;
			
			//si es un bitmap material
			if (material_original is BitmapMaterial) {
				bmpd = material_original.bitmap.clone();
			}
			
			//si es un color material
			if (material_original is ColorMaterial) {
				trace(ColorMaterial(material_original).fillColor);
				trace(ColorMaterial(material_original).bitmap);
				bmpd = new BitmapData(512, 512, false, ColorMaterial(material_original).fillColor);
			}
			
			//pegar encima el material_over
			bmpd.draw(material_over);
			
			//reemplazar
			this.dae.replaceMaterialByName(new BitmapMaterial(bmpd), objectName);
			
			//devovler el bitmap generado, posiblemente para guardarlo despues
			return new Bitmap(bmpd);
		}
		
		private function setup():void
		{
			trace('Objeto3D.setup');
			this.dae = new DAE();
		
		/*this.loader_max_dae = new LoaderMax({name: 'dae_queue', maxConnections: 3, onProgress: onLoaderMaxDaeProgress, onComplete: onLoaderMaxDaeComplete, onError: onLoaderMaxDaeError});
		
		 this.loader_max_dae.append(new DaeLoader(this.dae_file, {name: DAE_FILE}));*/
		}
		
		private function onLoaderMaxDaeError(e:LoaderEvent):void
		{
		
		}
		
		private function onLoaderMaxDaeProgress(e:LoaderEvent):void
		{
		
		}
		
		private function onLoaderMaxDaeComplete(e:LoaderEvent):void
		{
			trace('Objeto3D.onLoaderMaxDaeComplete');
			this.dae = this.loader_max_dae.getLoader(DAE_FILE).getDae();
			trace(this.dae.filename);
			dae.y = -6;
			
			this.onDaeParsedExtraSteps();
		}
		
		protected function onDaeParsedExtraSteps():void
		{
			trace('Objeto3D.onDaeParsedExtraSteps');
		}
		
		public function getDae():DAE
		{
			return this.dae;
		}
		
		public function getLoaderMax():LoaderMax
		{
			//debe ser sobrecargada
			return this.loader_max_dae;
		}
	
	/*override protected function onRenderTick(event:Event = null):void
	   {
	   //dae.rotationY = this.desired_rotation;
	   //super.onRenderTick(event);
	 }*/
	}
}