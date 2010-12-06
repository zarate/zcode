package
{
	import net.hires.debug.Stats;

	import test.common.ITest;
	import test.common.TestRunner;
	import test.common.events.TestEvent;

	import ui.LogField;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;

	// ::forcedImports::

	/**
	 * @author Juan Delgado
	 */
	public class TestF extends Sprite
	{
		private var logField : LogField;
		
		private var runner : TestRunner;
		
		private var stats : Stats;
		
		private const VERSION : String = "0.1";
		
		private const TESTS_XML : String = "tests.xml";
		
		// Tests are defined in a XML, we need
		// to force the compiler to compile these classes.
		// See tools/preprocess for more info
// ::forcedVars::
		
		public function TestF()
		{
			super();
			
			// TODO: warn the user if debug version of the player
			// TODO: allow passing xmlFalse when calling ant to prevent creating the tests.xml
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			logField = new LogField();
			addChild(logField);

			log("Welcome to TestF (v" + VERSION + ")");
			
			loadTests();
		}

		private function loadTests() : void
		{
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, testXmlLoaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR, testXmlFailed);
			loader.load(new URLRequest(TESTS_XML));
		}

		private function testXmlFailed(event : IOErrorEvent) : void
		{
			log("Cannot load tests xml: " + TESTS_XML);
		}

		private function testXmlLoaded(event : Event) : void
		{
			runner = new TestRunner();
			runner.addEventListener(TestEvent.DONE, testsFinished);
			runner.addEventListener(TestEvent.UPDATE, runnerUpdate);
			
			var testsXml : XML = new XML(event.target["data"]);
			
			var testList : XMLList = testsXml.test;
			
			log(testList.length() + " tests found");
			
			for each(var testXml : XML in testList)
			{
				var testClassPath : String;
				
				var testParams : Vector.<String> = null;
				
				var xmlValue : String = testXml.toString();
				
				if(xmlValue.indexOf(" ") == -1)
				{
					testClassPath = xmlValue;
				}
				else
				{
					var bits : Array = xmlValue.split(" ");
					
					testClassPath = bits.shift();
					
					testParams = new Vector.<String>();
					
					while(bits.length > 0)
					{
						testParams.push(bits.shift());
					}
				}
				
				var ClassReference : Class = Class(getDefinitionByName(testClassPath));
				
				var testCase : ITest = ITest(new ClassReference());
				testCase.setParams(testParams);
				
				runner.addTest(testCase);
			}
			
			stats = new Stats();
			stats.x = (stage.stageWidth - stats.width) >> 1;
			stats.y = (stage.stageHeight - stats.height) >> 1;
			
			addChild(runner);
			addChild(stats);
			
			runner.run();
		}

		private function runnerUpdate(event : TestEvent) : void
		{
			log(event.textUpdate);
		}

		private function testsFinished(event : TestEvent) : void
		{
			removeChild(stats);
			stats = null;
			
			runner.removeEventListener(TestEvent.DONE, testsFinished);			runner.removeEventListener(TestEvent.UPDATE, runnerUpdate);
			log(runner.getResult());
			
			log("TestF FINISHED");
		}

		private function log(text : String) : void
		{
			logField.log(text);
		}
	}
}
