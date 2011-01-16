package controllers;

class Start extends MyController
{
	public function new()
	{
		super();
	}
	
	public function index()
	{
		var url = new haxigniter.server.libraries.Url(this.config);
		
		view.assign('siteurl', url.siteUrl());
	
		var contentTemplate = new haxigniter.server.views.HaxeTemplate(config);
		
		view.assign("content", contentTemplate.render("start/index.html"));
		view.display("common.html");
	}
}