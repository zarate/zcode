package controllers;

class Test extends MyController
{
	public function new()
	{
		super();
	}
	
	public function index()
	{
		var contentTemplate = new haxigniter.server.views.HaxeTemplate(config);
		contentTemplate.assign("gatewayurl", baseUrl + "gateway");
		
		view.assign("content", contentTemplate.render("test/index.html"));
		view.display("common.html");
	}	
}