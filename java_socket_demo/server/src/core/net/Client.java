
package core.net;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;

import core.net.interfaces.IProtocolCacher;

/**
 * 连接到服务器的客户端
 * 
 * @author Jing
 *
 */
public class Client
{

	private SocketChannel _channel = null;

	/**
	 * 连接客户端的通道
	 */
	public SocketChannel channel()
	{
		return _channel;
	}

	public Client(SocketChannel channel)
	{
		_channel = channel;
		// TODO Auto-generated constructor stub
	}

	/**
	 * 接收到数据
	 * 
	 * @param buf
	 *            数据内容
	 * @return 使用了的数据长度
	 */
	public void onAcceptProtocol(ByteBuffer buf) throws IOException
	{
		short length = buf.getShort();
		if(length != buf.limit())
		{
			System.out.println("protocol wrong!!!");
			return;
		}
		// 获取协议号码
		short code = buf.getShort();

		IProtocolCacher cacher = Server.instance().getProtocolCacher(code);
		if(null == cacher)
		{
			System.out.println(String.format("protocol code [%d] no cacher", code));
			return;
		}
		cacher.onCacheProtocol(this, code, buf);

	}

	/**
	 * 向对应的客户端发送数据
	 * 
	 * @param code
	 *            协议编号
	 * @param buf
	 *            协议的数据
	 */
	public void sendProtocol(short code, ByteBuffer buf)
	{
		short length = (short) (buf.limit() + 4);
		ByteBuffer protocolBuf = ByteBuffer.allocate(length);
		protocolBuf.putShort(length);
		protocolBuf.putShort(code);
		protocolBuf.put(buf);
		protocolBuf.position(0);
		try
		{
			_channel.write(protocolBuf);
		}
		catch(IOException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * 销毁客户端
	 */
	public void dispose()
	{
		try
		{
			_channel.close();
		}
		catch(IOException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("remove client");
	}

}
