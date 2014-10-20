package chat;

import core.net.Client;


public class User
{

	public int id;
	public String name;
	public Client client;
	
	public User(int id, String name, Client client)
	{
		// TODO Auto-generated constructor stub
		this.id = id;
		this.name = name;
		this.client = client;
	}

}
