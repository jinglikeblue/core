package chat.cachers;

import core.server.Client;


public class User
{

	public int id;
	public String name;
	public Client client;
	
	public User(int id, String name, Client client)
	{
		this.id = id;
		this.name = name;
		this.client = client;
	}

}
