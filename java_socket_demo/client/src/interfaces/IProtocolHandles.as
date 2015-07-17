package interfaces
{
	import jing.net.server.ByteBuffer;
	

	public interface IProtocolHandles
	{
		function handle(data:ByteBuffer):void;
	}
}