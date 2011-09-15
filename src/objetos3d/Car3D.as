package objetos3d
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import flash.display.BitmapData;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	
	/**
	 * ...
	 * @author Joe Cabezas
	 */
	public class Car3D extends Objeto3D
	{
		//constantes
		public static const LADO_DERECHO:String = 'auto_1_lateral_der';
		public static const LADO_IZQUIERDO:String = 'auto_1_lateral_izq';
		public static const LADO_SUPERIOR:String = 'auto_1_superior';
		
		//texturas url
		private var tex_right_url:String;
		private var tex_left_url:String;
		private var tex_top_url:String;
		
		//texturas en bitmapdata
		public var tex_right_material:MaterialObject3D;
		public var tex_left_material:MaterialObject3D;
		public var tex_top_material:MaterialObject3D;
		
		//loader
		private var loader_max:LoaderMax;
		private var loader_max_texs:LoaderMax;
		
		//loader names
		public static const LOADER_MAX_TEXS:String = 'loaderMaxTexs';
		
		public function Car3D(dae_file:String)
		{
			super(dae_file);
		
			this.inicializarLoaders();	
		}
		
		private function inicializarLoaders():void 
		{
			trace('Car3D.inicializarLoaders');
			
			this.loader_max_texs = new LoaderMax( {
				name: LOADER_MAX_TEXS,
				maxConnections: 3
				//onProgress: onTexsLoaderProgress,
				//onComplete: onTexsLoaderComplete,
				//onError: onTexsLoaderError
			});
			
			//agregar loader de texturas a un loader principal que incluya el dae y las texturas
			this.loader_max = new LoaderMax( {
				name: 'main_queue',
				maxConnections: 3,
				onProgress: onLoaderProgress,
				//onComplete: onLoaderComplete,
				onError: onTexsLoaderError
			});
			
			//this.loader_max.append(this.loader_max_dae);
			this.loader_max.append(this.loader_max_texs);
		}
		
		public function setTex(tex:String, target:String):void
		{
			trace('Car3D.setTex');
			switch (target)
			{
				case LADO_DERECHO: 
					this.tex_right_url = tex;
					this.loader_max_texs.append(new ImageLoader(this.tex_right_url, {name: LADO_DERECHO}));
					break;
				case LADO_IZQUIERDO: 
					this.tex_left_url = tex;
					this.loader_max_texs.append(new ImageLoader(this.tex_left_url, {name: LADO_IZQUIERDO}));
					break;
				case LADO_SUPERIOR: 
					this.tex_top_url = tex;
					this.loader_max_texs.append(new ImageLoader(this.tex_top_url, {name: LADO_SUPERIOR}));
					break;
			}
			
			//cargar texturas si se agregaron
			//if (this.tex_right_url)
			//if (this.tex_left_url)
			//if (this.tex_top_url)
		}
		
		override protected function onDaeParsedExtraSteps():void {
			trace('car3D.onDaeParsedExtraSteps');
			
			//guardar los bitmaps de los mapas originales
			this.updateDefaultMaterials();
		}
		
		public function updateDefaultMaterials():void {
			this.tex_left_material =  MaterialObject3D(this.getDae().materials.materialsByName[LADO_IZQUIERDO + '-material']);
			this.tex_right_material =  MaterialObject3D(this.getDae().materials.materialsByName[LADO_DERECHO + '-material']);
			this.tex_top_material =  MaterialObject3D(this.getDae().materials.materialsByName[LADO_SUPERIOR + '-material']);
		}
		
		public function getActualMaterial(lado:String):MaterialObject3D {
			return this.getDae().materials.materialsByName[lado + '-material'];
		}
		
		private function onTexsLoaderError(e:LoaderEvent):void
		{
		
		}
		
		/*public function cambiarTexturasAuto():void
		{
			trace('Car3D.cambiarTexturasAuto');
			
			
			if (this.tex_right_url)
			{
				this.cambiarTextura(LADO_DERECHO, new BitmapMaterial(this.loader_max.getLoader(LADO_DERECHO).rawContent.bitmapData),);
			}
			
			trace(this.loader_max.getLoader(LADO_IZQUIERDO));
			if (this.tex_left_url)
			{
				this.cambiarTextura(LADO_IZQUIERDO, new BitmapMaterial(this.loader_max.getLoader(LADO_IZQUIERDO).rawContent.bitmapData));
			}
			
			if (this.tex_top_url)
			{
				this.cambiarTextura(LADO_SUPERIOR, new BitmapMaterial(this.loader_max.getLoader(LADO_SUPERIOR).rawContent.bitmapData));
			}
		}*/
		
		private function onLoaderProgress(e:LoaderEvent):void
		{
			trace("Car3D.onLoaderProgress progress: " + e.target.progress);
			var p:Number = Number(e.target.progress) * 100;
			//this.loadingBar.porcentaje.text = 'Cargando: ' + p + '%';
		
		}
		
		override public function getLoaderMax():LoaderMax {
			trace('Car3D.getLoaderMax');
			return this.loader_max;
		}
	}
}