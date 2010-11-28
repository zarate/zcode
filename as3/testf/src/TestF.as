package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	import net.hires.debug.Stats;
	import test.TestRunner;
	import test.common.ITest;
	import test.common.Test;
	import ui.LogField;

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
// ::forcedImports::
		
		public function TestF()
		{
			super();
			
			// TODO: warn the user if debug version of the player
			
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
			runner.addEventListener(Test.DONE, testsFinished);
			
			var testsXml : XML = new XML(event.target["data"]);

			for each(var testXml : XML in testsXml.test)
			{
				var ClassReference : Class = Class(getDefinitionByName(testXml.toString()));
				runner.addTest(ITest(new ClassReference()));
			}
			
			stats = new Stats();
			stats.x = (stage.stageWidth - stats.width) >> 1;
			stats.y = (stage.stageHeight - stats.height) >> 1;
			
			addChild(runner);
			addChild(stats);
			
			runner.run();
		}

		private function testsFinished(event : Event) : void
		{
			removeChild(stats);
			stats = null;
			
			runner.removeEventListener(Test.DONE, testsFinished);
			log(runner.getResult());
		}

		private function log(text : String) : void
		{
			logField.log(text);
		}
	}
}
