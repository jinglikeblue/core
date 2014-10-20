import java.io.IOException;

import chat.Chat;
import chat.Login;
import chat.Protocol;
import core.net.Server;

public class Main
{	
	/**
	 * HelloWorld
	 * 
	 * @param args
	 */
	public static void main(String[] args)
	{				
		// TODO Auto-generated method stub
		System.out.print("running...");
		
		Server.instance().registProtocolCacher((short)Protocol.PROTOCOL_C2S.LOGIN.ordinal(), new Login());
		Server.instance().registProtocolCacher((short)Protocol.PROTOCOL_C2S.CHAT.ordinal(), new Chat());
		
		try
		{
			Server.instance().run(7654, 100000, 40);
		}
		catch(IOException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	}
}
