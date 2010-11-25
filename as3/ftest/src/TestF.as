package
{
	import test.MathTest;
	import test.SystemTest;
	import net.hires.debug.Stats;

	import test.DrawingAPITest;
	import test.Test;
	import test.TestRunner;

	import ui.LogField;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * @author Juan Delgado
	 */
	public class TestF extends Sprite
	{
		private var logField : LogField;
		
		private var runner : TestRunner;
		
		private const VERSION : String = "0.1";
		
		private var stats : Stats;
		
		public function TestF()
		{
			super();
			
			// TODO: warn the user if debug version of the player
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			logField = new LogField();

			log("Welcome to TestF (v" + VERSION + ")");
			
			runner = new TestRunner();

			runner.addEventListener(Test.DONE, testsFinished);
			runner.addTest(new SystemTest());
			runner.addTest(new MathTest());
			runner.addTest(new DrawingAPITest());
			
			stats = new Stats();
			stats.x = (stage.stageWidth - stats.width) >> 1;			stats.y = (stage.stageHeight - stats.height) >> 1;
						addChild(runner);
			addChild(logField);
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
