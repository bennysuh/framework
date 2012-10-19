package org.flexlite.domDll.loaders
{
	import flash.utils.ByteArray;
	
	import org.flexlite.domDisplay.DxrData;
	import org.flexlite.domDisplay.DxrFile;
	
	/**
	 * DXR文件加载器
	 * @author DOM
	 */
	public class DxrResLoader extends ResLoaderBase
	{
		public function DxrResLoader()
		{
			super();
		}
		
		override protected function cacheFileBytes(bytes:ByteArray,name:String):void
		{
			fileDic[name] = new DxrFile(bytes,name);
		}
		
		override public function getRes(key:String):*
		{
			var res:* = fileDic[key];
			if(res)
				return res;
			if(sharedMap.has(key))
				return sharedMap.get(key);
			return null;
		}
		
		override public function getResAsync(key:String, compFunc:Function):void
		{
			if(compFunc==null)
				return;
			var res:* = getRes(key);
			if(res)
			{
				compFunc(res);
			}
			else 
			{
				var file:DxrFile;
				var found:Boolean = false;
				for each(file in fileDic)
				{
					if(file.hasKey(key))
					{
						found = true;
						break;
					}
				}
				if(found)
				{
					file.getDxrData(key,function(data:DxrData):void{
						sharedMap.set(key,data);
						compFunc(data);
					});
				}
				else
				{
					compFunc(null);
				}
			}
		}
	}
}