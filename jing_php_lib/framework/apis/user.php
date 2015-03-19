<?php
class user
{
	public function login(&$params, &$res)
	{
		$res['data'] = '1';
		
		$sql = "SELECT * FROM tbl_admin";
		$sqlHelper = new SqlHelper();
		$sqlHelper->conn();
		var_dump($sqlHelper->query($sql));
	}
	
	public function addUser(&$params, &$res)
	{
		
	}
}