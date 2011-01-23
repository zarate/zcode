package models;

class Test extends php.db.Object
{
	public var ip : String;
	
	public var version : String;
	
	public var result : String;
	
	public static var manager = new php.db.Manager<Test>(Test);
}