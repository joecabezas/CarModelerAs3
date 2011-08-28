package objetos3d
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
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
		
		//texturas
		private var tex_right:String;
		private var tex_left:String;
		private var tex_top:String;
		
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
					this.tex_right = tex;
					break;
				case LADO_IZQUIERDO: 
					this.tex_left = tex;
					break;
				case LADO_SUPERIOR: 
					this.tex_top = tex;
					break;
			}
			
			//cargar texturas si se agregaron
			if (this.tex_right)
				this.loader_max_texs.append(new ImageLoader(this.tex_right, {name: LADO_DERECHO}));
			if (this.tex_left)
				this.loader_max_texs.append(new ImageLoader(this.tex_left, {name: LADO_IZQUIERDO}));
			if (this.tex_top)
				this.loader_max_texs.append(new ImageLoader(this.tex_top, {name: LADO_SUPERIOR}));
		}
		
		override protected function onDaeParsedExtraSteps():void {
			trace('car3D.onDaeParsedExtraSteps');
			//this.cambiarTexturasAuto();
		}
		
		private function onTexsLoaderError(e:LoaderEvent):void
		{
		
		}
		
		public function cambiarTexturasAuto():void
		{
			trace('Car3D.cambiarTexturasAuto');
			
			
			if (this.tex_right)
			{
				this.cambiarTextura(LADO_DERECHO, new BitmapMaterial(this.loader_max.getLoader(LADO_DERECHO).rawContent.bitmapData));
			}
			
			trace(this.loader_max.getLoader(LADO_IZQUIERDO));
			if (this.tex_left)
			{
				this.cambiarTextura(LADO_IZQUIERDO, new BitmapMaterial(this.loader_max.getLoader(LADO_IZQUIERDO).rawContent.bitmapData));
			}
			
			if (this.tex_top)
			{
				this.cambiarTextura(LADO_SUPERIOR, new BitmapMaterial(this.loader_max.getLoader(LADO_SUPERIOR).rawContent.bitmapData));
			}
		}
		
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