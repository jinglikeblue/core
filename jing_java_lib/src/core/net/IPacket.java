
package core.net;

/**
 * 协议包接口
 * 
 * @author Jing
 */
public interface IPacket
{

	/**
	 * 协议打包
	 * 
	 * @param protoId
	 * @param protoData
	 * @return
	 */
	byte[] pack(short protoId, byte[] protoData);

	/**
	 * 协议解包
	 * 
	 * @param buffer
	 * @param offset
	 * @return
	 */
	Packet unpack(byte[] buffer, int offset);

	/**
	 * 协议号
	 * 
	 * @return
	 */
	short getProtoId();

	/**
	 * 协议数据
	 * 
	 * @return
	 */
	byte[] getProtoData();

}
