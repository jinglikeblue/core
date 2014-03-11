package jing.loader.consts
{
	/**
	 * 错误原因 
	 * @author Jing
	 * 
	 */	
	public class ErrorReason
	{
		/**
		 * 加载文件出错 
		 */		
		static public const IO_ERROR:String = "IOError";
		
		/**
		 * 安全沙箱错误 
		 */		
		static public const SECURITY_ERROR:String = "SecurityError";
		
		/**
		 * 不存在URLRequest数据 
		 */		
		static public const NONE_URLREQUEST:String = "NoneURLRequest";
	}
}