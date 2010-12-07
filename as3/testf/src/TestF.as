package
{

	import net.hires.debug.Stats;

	import test.common.ITest;
	import test.common.TestRunner;

	import ui.LogField;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
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

		private var timer : Timer;
		
		private var countDown : int = 5;
		
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
			logField.x = logField.y = 10;
			addChild(logField);

			log("Welcome to TestF (v" + VERSION + ")\n");
			log("This log field would go away when tests start and come back when they are finished. You can toggle it at any time by pressing ENTER.\n");
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, toggleFurniture);
			
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
			runner.finishedSignal.addOnce(testsFinished);
			runner.updateSignal.add(runnerUpdate);
			
			var testsXml : XML = new XML(event.target["data"]);
			
			var testList : XMLList = testsXml.test;
			
			log(testList.length() + " tests found\n");
			
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
			
			addChild(runner);
			
			stats = new Stats();
			addChild(stats);
			
			stats.x = (stage.stageWidth - stats.width) >> 1;
			stats.y = (stage.stageHeight - stats.height) >> 1;

			swapChildren(runner, logField);

			timer = new Timer(1000, countDown);
			timer.addEventListener(TimerEvent.TIMER, updateCountDown);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, startTests);
			timer.start();
		}

		private function startTests(event : TimerEvent) : void
		{
			hideFurniture();
			
			runner.run();
		}

		private function updateCountDown(event : TimerEvent) : void
		{
			log("Starting in " + --countDown);
		}

		private function runnerUpdate(testCase : ITest, update : String) : void
		{
			log(update);
		}

		private function testsFinished(testCase : ITest) : void
		{
			removeChild(stats);
			stats = null;
			
			runner.updateSignal.remove(runnerUpdate);
			log(runner.getResult());
			
			log("TestF FINISHED");
			
			showFurniture();
		}

		private function toggleFurniture(event : KeyboardEvent) : void
		{
			if(event.keyCode == Keyboard.ENTER)
			{
				logField.visible = !logField.visible;
				stats.visible = logField.visible;
			}
		}

		private function showFurniture() : void
		{
			logField.visible = true;
			stats.visible = false;
		}
		
		private function hideFurniture() : void
		{
			logField.visible = false;
			stats.visible = false;
		}

		private function log(text : String) : void
		{
			logField.log(text);
		}
	}
}
