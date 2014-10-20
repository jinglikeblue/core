package interfaces
{
	import net.server.ByteBuffer;

	public interface IProtocolHandles
	{
		function handle(data:ByteBuffer):void;
	}
}