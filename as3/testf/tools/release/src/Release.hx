package;

class Release
{
	private var version : String;
	
	private var propertiesFile : String;
	
	private var properties : Hash<String>;
	
	private var tmpFolder : String;
	
	private var flexHome : String;
	
	// TODO: dont hardcode, pass it to the app, maybe in properties file
	private static var GIT_REPO_PATH : String = "/home/juan/projects/zarate/zcode/git";
	
	private static var TESTF_FOLDER : String = "as3/testf";
	
	private static var PARAM_VERSION = "-v";
	
	private static var PROPERTIES = "-p";
	
	private static var MIN_AIR_VERSION : Float = 2.5;
	
	private static var FLEX_HOME_PROPERTY : String = "FLEX_HOME";
	
	public function new()
	{
		log("Welcome to TestF release generator!");
		
		parseParams();
		
		if(version == null)
		{
			exit("Could not find which version to release.");
		}
		
		if(propertiesFile == null)
		{
			exit("Could not find properties file");
		}
		
		readPropertiesFile();
		
		checkEnvVars();
		
		checkout();
		
		copyPropertiesFile();
		
		compile();
		
		cleanup();
		
		log("Done!");
	}

	private function compile() : Void
	{
		log("Calling ant to compile");
		
		var ant = new xa.Process("ant", ["compile-all", "-DxmlOutput=true"]);
		
		if(!ant.success())
		{
			cleanup();
			exit(ant.getError());
		}
		
		log(ant.getOutput());
	}

	private function copyPropertiesFile() : Void
	{
		xa.File.copy(propertiesFile, "properties" + xa.System.getSeparator() + xa.FileSystem.getNameFromPath(propertiesFile));
	}

	private function checkout() : Void
	{
		// TODO: add some random string to the end of the path
		tmpFolder = xa.System.getTempFolder() + xa.System.getSeparator() + "testf_" + version;
		
		if(xa.Folder.isFolder(tmpFolder))
		{
			xa.Folder.forceDelete(tmpFolder);
		}
		
		log("Creating temp folder: " + tmpFolder);
		
		xa.Folder.create(tmpFolder);
		
		// Moving CWD to the temp folder
		neko.Sys.setCwd(tmpFolder);
		
		log("Checking out repository from: " + GIT_REPO_PATH);
		
		var git = new xa.Process("git", ["clone", GIT_REPO_PATH, "."]);
		
		if(!git.success())
		{
			cleanup();
			exit(git.getError());
		}
		
		log(git.getOutput());
		
		// FIXME: most likely we won't need
		// this once we move TestF to its own repo
		
		var cwd = neko.Sys.getCwd() + TESTF_FOLDER;
		
		log("Setting up current working directory: " + cwd);
		
		neko.Sys.setCwd(cwd);
	}

	private function readPropertiesFile() : Void
	{
		if(!xa.File.isFile(propertiesFile))
		{
			exit("Cannot read properties file: " + propertiesFile);
		}
		
		properties = new Hash<String>();
		
		var content = xa.File.read(propertiesFile);
		
		var lines = content.split("\n");
		
		for(x in 0...lines.length)
		{
			var line = StringTools.trim(lines[x]);
			
			// ignore comments
			if(StringTools.startsWith(line, "#"))
			{
				continue;
			}
			
			// ignore lines without a property definition
			if(line.indexOf("=") == -1)
			{
				continue;
			}
			
			var bits = line.split("=");
			
			properties.set(bits[0], bits[1]);
		}
		
		flexHome = properties.get(FLEX_HOME_PROPERTY);
		
		if(!xa.Folder.isFolder(flexHome))
		{
			exit(flexHome + " is not a valid " + FLEX_HOME_PROPERTY + " folder");
		}
	}

	private function checkEnvVars() : Void
	{
		// TODO: Check this whole process in Windows
		
		log("Checking for GIT");
		
		var git = new xa.Process("git", ["--version"]);
		
		if(!git.success())
		{
			exit(git.getError());
		}
		
		log("Checking for ANT");
		
		var ant = new xa.Process("ant", ["-version"]);
		
		if(!ant.success())
		{
			exit(ant.getError());
		}
		
		log("Checking for ADT");
		
		// TODO: this wont work on Windows
		var adtPath = flexHome + "/bin/adt";
		
		if(!xa.File.isFile(adtPath))
		{
			exit("Cannot find ADT on: " + adtPath);
		}
		
		var adt = new xa.Process(adtPath, ["-version"]);
		
		if(!adt.success())
		{
			exit(adt.getError());
		}
		
		// adt -version output looks like this:
		// adt version "2.5.0.15980"
		
		var adtVersion = Std.parseFloat(StringTools.trim(adt.getOutput()).split(" ")[2].split("\"")[1]);
		
		if(adtVersion < MIN_AIR_VERSION)
		{
			exit("ADT version is: " + adtVersion + ", you need at least " + MIN_AIR_VERSION);
		}
	}

	private function cleanup() : Void
	{
		log("Cleaning up");
		
		if(xa.Folder.isFolder(tmpFolder))
		{
			xa.Folder.forceDelete(tmpFolder);
		}
	}

	private function parseParams() : Void
	{
		var params = xa.Application.getArguments();
		
		// Windows-only xcross bug 
		if(xa.System.isWindows())
		{
			params = params[0].split(" ");
		}
		
		for(x in 0...params.length)
		{
			switch(params[x])
			{
				case PARAM_VERSION:
					version = params[x+1];
				
				case PROPERTIES:
					propertiesFile = neko.FileSystem.fullPath(params[x+1]);
			}
		}
	}

	private function printHelp() : Void
	{
		log("Usage");
		log("release -v 0.1 -p path/to/developer.properties");
	}

	private function exit(txt : String) : Void
	{
		log("ERROR: " + txt);
		xa.Application.exit(1);
	}

	private function log(txt : String) : Void
	{
		xa.Utils.print("  " + txt);
	}

	// Entry point
	public static function main()
	{
		var release = new Release();
	}
}