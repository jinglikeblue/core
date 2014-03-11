package jing.turbo.handle
{
	public interface IHandleDispatcher
	{
		function addHandleListener(handleType:String, handler:Function):void;
		
		function removeHandleListener(handleType:String, handler:Function):void;
		
		function sendHandle(handle:Handle):void;
	}
}