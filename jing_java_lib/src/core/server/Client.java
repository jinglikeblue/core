
package core.server;

import java.io.IOException;
import java.net.InetAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;

import core.server.interfaces.IProtocolCacher;

/**
 * 连接到服务器的客户端
 * 
 * @author Jing
 */
public class Client
{
	/**
	 * 客户端的连接通道
	 */
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
	}

	/**
	 * 接收到数据
	 * 
	 * @param buff 数据内容
	 * @return 使用了的数据长度
	 */
	public void onAcceptProtocol(ByteBuffer buff) throws IOException
	{
		short length = buff.getShort();
		if(length != buff.limit())
		{
			System.out.println("protocol wrong!!!");
			return;
		}
		// 获取协议号码
		short code = buff.getShort();

		IProtocolCacher cacher = Server.instance().getProtocolCacher(code);
		if(null == cacher)
		{
			System.out.println(String.format("protocol code [%d] no cacher", code));
			return;
		}
		cacher.onCacheProtocol(this, code, buff);
	}

	/**
	 * 向对应的客户端发送数据
	 * 
	 * @param code 协议编号
	 * @param buff 协议的数据
	 */
	public void sendProtocol(short code, ByteBuffer buff)
	{
		short length = (short)(buff.limit() + 4);
		ByteBuffer protocolBuf = ByteBuffer.allocate(length);
		protocolBuf.putShort(length);
		protocolBuf.putShort(code);
		protocolBuf.put(buff);
		protocolBuf.position(0);
		try
		{
			_channel.write(protocolBuf);
		}
		catch(IOException e)
		{
			e.printStackTrace();
		}
	}

	/**
	 * 销毁客户端
	 */
	public void dispose()
	{
		InetAddress address = _channel.socket().getLocalAddress();

		try
		{
			_channel.close();
		}
		catch(IOException e)
		{
			e.printStackTrace();
		}
		System.out.println("client " + address.toString() + " disposed");
	}

}
