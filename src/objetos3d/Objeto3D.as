package objetos3d

{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.LoaderMax;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import loaders.DaeLoader;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.core.geom.TriangleMesh3D;
	
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
		}
		
		public static function swapObjectMaterials(dae:DAE, objectName:String, material:MaterialObject3D):void
		{
			var length:int = dae.getChildByName("COLLADA_Scene").getChildByName(objectName).geometry.faces.length;
			for (var i:int = 0; i < length; i++)
			{
				TriangleMesh3D(dae.getChildByName("COLLADA_Scene").getChildByName(objectName).geometry.faces[i]).material = material;
			}
		}
		
		public function cambiarTextura(objectName:String, material:MaterialObject3D):void
		{
			trace('Objeto3D.cambiarTextura');
			this.dae.getChildByName('COLLADA_Scene').getChildByName(objectName).material = material;
		}
		
		
		
		private function setup():void
		{
			trace('Objeto3D.setup');
			this.dae = new DAE();
			
			this.loader_max_dae = new LoaderMax({
				name: 'dae_queue',
				maxConnections: 3,
				onProgress: onLoaderMaxDaeProgress, 
				onComplete: onLoaderMaxDaeComplete,
				onError: onLoaderMaxDaeError
			});
			
			this.loader_max_dae.append( new DaeLoader(this.dae_file, {name:DAE_FILE} ) );
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
			trace(this.loader_max_dae);
			this.dae = this.loader_max_dae.getLoader(DAE_FILE).getDae();
			dae.y = -6;
			
			this.onDaeParsedExtraSteps();
		}
		
		protected function onDaeParsedExtraSteps():void 
		{
			trace('Objeto3D.onDaeParsed');
		}
		
		public function getDae():DAE {
			return this.dae;
		}
		
		public function getLoaderMax():LoaderMax {
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