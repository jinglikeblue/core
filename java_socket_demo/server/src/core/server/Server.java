
package core.server;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import core.events.EventDispatcher;
import core.server.interfaces.IProtocolCacher;

/**
 * 服务类
 * 
 * @author Jing
 *
 */
public class Server extends EventDispatcher
{

	private Server()
	{

	}

	static private Server _instance = null;

	static public Server instance()
	{
		if(null == _instance)
		{
			_instance = new Server();
		}
		return _instance;
	}
	
	/**
	 * 服务器事件
	 * @author Jing
	 *
	 */
	static public enum EVENT
	{
		/**
		 * 客户端断开连接
		 */
		CLIENT_DISCONNECT
	}
	

	// 协议捕获器字典
	private HashMap<Short, IProtocolCacher> _protocolCacherMap = new HashMap<Short, IProtocolCacher>();

	//连接上的客户端
	private HashMap<SocketChannel, Client> _onlineMap = new HashMap<SocketChannel, Client>();

	/**
	 * 广播协议
	 * @param protocolCode 协议号
	 * @param buff
	 */
	public void dispatchProtocol(short protocolCode, ByteBuffer buff)
	{
		Iterator<Entry<SocketChannel, Client>> iter = _onlineMap.entrySet().iterator();
		while(iter.hasNext())
		{
			Map.Entry<SocketChannel, Client> entry = iter.next();
			Client client = entry.getValue();
			client.sendProtocol(protocolCode, buff);
			
		}
	}
	
	private int _port;

	/**
	 * 监听的端口号
	 * 
	 * @return
	 */
	public int port()
	{
		return _port;
	}

	private int _bufferSize;

	/**
	 * 缓冲区大小
	 * 
	 * @return
	 */
	public int bufferSize()
	{
		return _bufferSize;
	}

	private int _fps;

	/**
	 * 服务器帧率
	 * 
	 * @return
	 */
	public int fps()
	{
		return _fps;
	}

	public void run(int port, int bufferSize, int fps) throws IOException
	{
		_port = port;
		_bufferSize = bufferSize;
		_fps = fps;

		long timeout = 1000 / fps;

		Selector selector = Selector.open();

		ServerSocketChannel listenerChannel = ServerSocketChannel.open();

		listenerChannel.socket().bind(new InetSocketAddress(port));

		listenerChannel.configureBlocking(false);

		listenerChannel.register(selector, SelectionKey.OP_ACCEPT);

		while(true)
		{
			if(selector.select(timeout) > 0)
			{
				Iterator<SelectionKey> keyIter = selector.selectedKeys().iterator();

				while(keyIter.hasNext())
				{
					SelectionKey key = keyIter.next();

					try
					{
						if(key.isAcceptable())
						{
							handleAccept(key);
						}

						if(key.isReadable())
						{
							handleRead(key);
						}

						if(key.isValid() && key.isWritable())
						{
							handleWrite(key);
						}
					}
					catch(IOException ex)
					{
						keyIter.remove();
						continue;
					}

					keyIter.remove();
				}
			}

			enterFrame();

		}
	}

	/**
	 * 获取协议捕捉器
	 * 
	 * @param protocolCode
	 * @return
	 */
	public IProtocolCacher getProtocolCacher(short protocolCode)
	{
		return _protocolCacherMap.get(protocolCode);
	}

	/**
	 * 注册协议的捕获器
	 * 
	 * @param protocolCode
	 * @param cacher
	 */
	public void registProtocolCacher(short protocolCode, IProtocolCacher cacher)
	{
		_protocolCacherMap.put(protocolCode, cacher);
	}

	protected void enterFrame()
	{
		// TODO need override
	}

	// ---------------------协议处理相关代码--------------------------------

	private void handleAccept(SelectionKey key) throws IOException
	{
		SocketChannel clientChannel = ((ServerSocketChannel) key.channel()).accept();
		clientChannel.configureBlocking(false);
		clientChannel.register(key.selector(), SelectionKey.OP_READ, ByteBuffer.allocate(_bufferSize));

		Client client = new Client(clientChannel);
		if(_onlineMap.get(clientChannel) != null)
		{
			throw new IOException("can't accept same key twice");
		}
		_onlineMap.put(clientChannel, client);
	}

	private void handleRead(SelectionKey key) throws IOException
	{
		SocketChannel clientChannel = (SocketChannel) key.channel();

		Client client = _onlineMap.get(clientChannel);

		ByteBuffer buf = (ByteBuffer) key.attachment();

		long bytesRead = clientChannel.read(buf);

		if(bytesRead == -1)
		{
			this.dispatchEvent(EVENT.CLIENT_DISCONNECT.name(), client);
			client.dispose();
			if(null == _onlineMap.remove(clientChannel))
			{
				throw new IOException("wrong client disconnect");
			}
		}
		else
		{
			buf.flip();			
			int limit = buf.limit();
			// 进行协议的拆包处理
			int used = parse(buf, client);
			int remain = limit - used;
			if(0 == remain)
			{
				buf.clear();
			}
			else
			{
				buf.position(used);
				byte tempb[] = new byte[remain];
				buf.get(tempb);
				buf.clear();
				buf.put(tempb);
			}
		}
	}

	public void handleWrite(SelectionKey key) throws IOException
	{
		// TODO 这个用不上
	}

	/**
	 * 协议拆包
	 * 
	 * @param buf
	 * @param client
	 * @return 返回时用到的长度
	 */
	private int parse(ByteBuffer buf, Client client) throws IOException
	{
		int used = 0;
		int limit = buf.limit();
		while(true)
		{
			// 判断是否能够读取协议的长度
			if(buf.limit() - used < 2)
			{
				break;
			}

			buf.position(used);
			// 读取协议长度
			short protocolLength = buf.getShort();
			// 数据内容不够一个协议的长度
			if(buf.limit() - used < protocolLength)
			{
				break;
			}

			buf.position(used);
			buf.limit(used + protocolLength);
			ByteBuffer protocolBuf = buf.slice();
			buf.limit(limit);
			client.onAcceptProtocol(protocolBuf);
			used += protocolLength;
		}

		return used;
	}
}
