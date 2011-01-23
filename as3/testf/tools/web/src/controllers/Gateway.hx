package controllers;

class Gateway extends MyController
{
	public function new()
	{
		super();
	}
	
	// REST reference: https://github.com/ciscoheat/haxigniter/wiki/rest-reference
	
	// GET
	// gateway > index
	// gateway/new > make(?arg)
	// gatewat/id > show(id, ?arg)
	// gateway/id/edit > edit(id, ?arg)

	// POST
	// gateway > create(formData : Hash<String>)
	// gatewat/id > update(id, formData : Hash<String>)
	// gateway/id/delete > destroy(id, formData : Hash<String>)
	

	public function index() : Void
	{
		setAnswer(403);
	}
	
	public function create(formData : Hash<String>) : Void
	{
		// TODO: pick up DB values from haxigniter config
		var cnx = php.db.Mysql.connect({ 
		    host : "localhost",
		    port : 3306,
		    user : "root",
		    pass : "",
		    socket : null,
		    database : "testf"
		});
		
		php.db.Manager.cnx = cnx;
		php.db.Manager.initialize();

		// Let's clean up all the params before even touching them
		for(key in formData.keys())
		{
			formData.set(key, cnx.quote(formData.get(key)));
		}
		
		// TODO, check we have all the data we need
		
		var test = new models.Test();
		test.ip = php.Web.getClientIP(); // TODO: this is not working for some reason
		test.version = formData.get("version");
		test.result = formData.get("result");
		test.insert();
		
		php.db.Manager.cleanup();
		cnx.close();
		
		setAnswer(200);
	}
	
	private function setAnswer(errorCode : Int) : Void
	{
		php.Web.setHeader("Content-Type", "text/xml");
		view.assign("errorCode", Std.string(errorCode));
		view.display("gateway/answer.xml");	
	}
}