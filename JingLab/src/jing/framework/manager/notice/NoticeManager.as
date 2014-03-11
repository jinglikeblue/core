package jing.framework.manager.notice
{
	import flash.utils.Dictionary;

	/**
	 * 通知收发器 
	 * @author jing
	 * 
	 */	
	public class NoticeManager
	{
		//注册的通知
		static private var _registeredNotice:Dictionary = new Dictionary();
		
		/**
		 * 初始化通知管理器 
		 * 
		 */		
		static public function init():void
		{
			_registeredNotice = new Dictionary();
		}
		
		/**
		 * 注册一个通知的监听（类似于事件机制,通过回调实现) 
		 * @param handleType 操作类型
		 * @param handler 回调方法
		 * 
		 */		
		static public function addNoticeAction(type:String, action:Function):void
		{				
			if(null == _registeredNotice[type])
			{
				_registeredNotice[type] = new Vector.<Function>;
			}
			
			var actions:Vector.<Function> = _registeredNotice[type] as Vector.<Function>;
			
			if(null != action && -1 == actions.indexOf(action))
			{
				actions.push(action);
			}
		}
		
		/**
		 * 注销一个操作监听 
		 * @param handleType 操作类型
		 * @param handler 回调方法
		 * 
		 */		
		static public function removeNoticeAction(type:String, action:Function):void
		{
			if(null == _registeredNotice)
			{
				return;
			}
			
			if(null == _registeredNotice[type])
			{
				return;
			}
			
			var actions:Vector.<Function> = _registeredNotice[type] as Vector.<Function>;
			var actionIndex:int = actions.indexOf(action);
			
			if(-1 != actionIndex)
			{
				actions.splice(actionIndex,1);
			}
		}
		
		/**
		 * 发送通知 
		 * @notice Action
		 */		
		static public function sendNotice(notice:Notice):void
		{
			if(null == _registeredNotice)
			{
				return;
			}
			
			if(null == _registeredNotice[notice.type])
			{
				return;
			}
			
			//和该事件关联的所有的方法
			var notices:Vector.<Function> = _registeredNotice[notice.type] as Vector.<Function>;
			var noticeCount:int = notices.length;
			
//			try
//			{
				while(--noticeCount > -1)
				{			
					if(noticeCount >= notices.length)
					{
						continue;
					}
					notices[noticeCount](notice);
				}
//			}
//			catch(e:Error)
//			{
//				trace(e);
//			}
				
		}
	}
}