package controllers;

class Test extends MyController
{
	public function new()
	{
		super();
	}
	
	public function index()
	{
		var url = new haxigniter.server.libraries.Url(this.config);
		
		var contentTemplate = new haxigniter.server.views.HaxeTemplate(config);
		
		contentTemplate.assign('siteurl', url.siteUrl());
		
		view.assign('siteurl', url.siteUrl());
		view.assign("content", contentTemplate.render("test/index.html"));
		view.display("common.html");
	}	
}