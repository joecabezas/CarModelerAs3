/**
 * VERSION: 1.84
 * DATE: 2011-03-23
 * AS3
 * UPDATES AND DOCS AT: http://www.greensock.com/loadermax/
 **/
package loaders {
	import com.greensock.loading.core.LoaderItem;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.objects.parsers.DAE;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	
	/** Dispatched when the loader's <code>httpStatus</code> value changes. **/
	[Event(name="httpStatus", 		type="com.greensock.events.LoaderEvent")]
	/** Dispatched when the loader experiences a SECURITY_ERROR while loading or auditing its size. **/
	[Event(name="securityError", 	type="com.greensock.events.LoaderEvent")]

	public class DaeLoader extends LoaderItem {
		/** @private **/
		private static var _classActivated:Boolean = _activateClass("DaeLoader", DaeLoader, "dae");
		/** @private **/
		protected var _loader:URLLoader;
		
		private var dae:DAE;
		private var dae_url:String;
		
		public function DaeLoader(urlOrRequest:*, vars:Object=null) {
			super(urlOrRequest, vars);
			
			_loader = new URLLoader(null);
			
			_loader.dataFormat = "binary"; //just to make sure it wasn't overridden if the "format" special vars property was passed into in DataLoader's constructor.
			_type = "DaeLoader";
			
			/*_loader.addEventListener(ProgressEvent.PROGRESS, _progressHandler, false, 0, true);
			_loader.addEventListener(Event.COMPLETE, _receiveDataHandler, false, 0, true);
			_loader.addEventListener("ioError", _failHandler, false, 0, true);
			_loader.addEventListener("securityError", _failHandler, false, 0, true);
			_loader.addEventListener("httpStatus", _httpStatusHandler, false, 0, true);*/
			
			this.dae = new DAE();
			this.dae_url = urlOrRequest as String;
			
			this.dae.addEventListener(FileLoadEvent.LOAD_COMPLETE, onLoadComplete);
			this.dae.addEventListener(FileLoadEvent.LOAD_PROGRESS, onLoadProgress);
			this.dae.addEventListener(FileLoadEvent.LOAD_ERROR, onLoadError);this.dae.load(urlOrRequest);
		}
		
		private function onLoadComplete(e:FileLoadEvent):void 
		{
			trace(e);
			trace('DaeLoader.onLoadComplete');
			
			super._completeHandler(e);
		}
		
		private function onLoadProgress(e:FileLoadEvent):void 
		{
			//trace(e);
		}
		
		private function onLoadError(e:FileLoadEvent):void 
		{
			trace(e);
		}
		
		/** @private **/
		override protected function _load():void {
			trace('DaeLoader._load');
			/*trace(_request);
			_prepRequest();
			_loader.load(_request);*/
			
			this.dae.load(this.dae_url);
		}
		
		/** @private scrubLevel: 0 = cancel, 1 = unload, 2 = dispose, 3 = flush **/
		/*override protected function _dump(scrubLevel:int=0, newStatus:int=0, suppressEvents:Boolean=false):void {
			if (_status == LoaderStatus.LOADING) {
				try {
					_loader.close();
				} catch (error:Error) {
					
				}
			}
			super._dump(scrubLevel, newStatus, suppressEvents);
		}*/
		
		
//---- EVENT HANDLERS ------------------------------------------------------------------------------------
		
		/** @private Don't use _completeHandler so that subclasses can set _content differently and still call super._completeHandler() (otherwise setting _content in the _completeHandler would always override the _content previously set in sublcasses). **/
		/*protected function _receiveDataHandler(event:Event):void {
			_content = _loader.data;
			super._completeHandler(event);
		}*/
		
		private function _receiveDataHandler(e:Event):void 
		{
			trace('DaeLoader._receiveDataHandler');
			_content = _loader.data;
			//trace(_content);
			
			this.dae = new DAE();
			_loader.removeEventListener(Event.COMPLETE, _receiveDataHandler, false);
			this.dae.addEventListener(FileLoadEvent.LOAD_COMPLETE, onDaeParsed);
			this.dae.load(_content);
		}
		
		protected function onDaeParsed(e:FileLoadEvent):void
		{
			trace('DaeLoader.onDaeParsed');
			super._completeHandler(e);
		}
		
		public function getDae():DAE
		{
			return this.dae;
		}
	}
}