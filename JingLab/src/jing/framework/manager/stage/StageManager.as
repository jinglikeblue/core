package jing.framework.manager.stage
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;

	/**
	 * 舞台场景管理 
	 * 
	 * 
	 * **future**
	 * 可自定义默认的场景
	 * 
	 * @author Jing
	 * 
	 */	
	public class StageManager
	{		
		static private var _stage:Stage = null;
			
		/**
		 * 获取应用的舞台 
		 * @return 
		 * 
		 */			
		static public function get stage():Stage
		{
			return _stage;
		}
		
		/**
		 * 
		 * @param defaultStage 默认的舞台
		 * 
		 */		
		static public function init(defaultStage:DisplayObjectContainer):void
		{
		
			if(_stage == null && defaultStage.stage != null)
			{
				_stage = defaultStage.stage;
			}
			
			if(null == _stageDic)
			{
				_stageDic = new Object();
			}
			_stageDic[DEFAULT_STAGE] = defaultStage;
		}
		
		/**
		 * 存储的场景字典 
		 */		
		static private var _stageDic:Object = null;
		
		/**
		 * 得到一个场景 
		 * @param stageName 场景的名字，如果不带参数，则默认取出第一次存入的场景
		 * @return 
		 * 
		 */		
		static public function getStage(stageName:String = null):DisplayObjectContainer
		{			
			if(null == stageName)
			{
				stageName = DEFAULT_STAGE;	
			}
			
			return _stageDic[stageName];
		}
		
		/**
		 * 添加一个场景到管理器,第一个存入的场景将作为默认场景
		 * @param stage
		 * @param stageName
		 * @return 返回的执行结果
		 * 
		 */		
		static public function addStage(stageName:String, stage:DisplayObjectContainer):int
		{
			if(null == _stageDic)
			{
				_stageDic = new Object();
				_stageDic[DEFAULT_STAGE] = stage;
			}
			_stageDic[stageName] = stage;
			return 0;
		}
		
		//----------------------------------------------------------------------------
		
		/**
		 * 默认的场景 
		 */		
		static private const DEFAULT_STAGE:String = "default";
	}
}