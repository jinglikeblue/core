package core.net.interfaces;

import java.io.IOException;
import java.nio.ByteBuffer;

import core.net.Client;


public interface IProtocolCacher
{
	/**
	 * 捕获到了协议
	 * @param client
	 * @param protocolCode
	 * @param data
	 * @throws IOException
	 */
	void onCacheProtocol(Client client,short protocolCode, ByteBuffer data) throws IOException;
}
