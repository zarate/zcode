package test.common
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * @author Juan Delgado
	 */
	public class TestRunner extends Test implements ITest
	{
		private var tests : Vector.<ITest> = new Vector.<ITest>();
		
		private var index : int;
		
		private var timer : Timer;
		
		public function addTest(testCase : ITest) : void
		{
			tests.push(testCase);
		}

		override public function run() : void
		{
			super.run();
			
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, delay);
			
			index = -1;
			nextTest();
		}

		override public function getResult() : String
		{
			return result;
		}
		
		override public function getName() : String
		{
			return "TestRunner";
		}
		
		override protected function stop() : void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, delay);
			timer = null;
			
			super.stop();
		}

		private function nextTest() : void
		{
			index++;

			if(index < tests.length)
			{
				timer.start();
			}
			else
			{
				tests = null;
				stop();
			}
		}
		
		private function delay(event : TimerEvent) : void
		{
			timer.stop();
			
			var testCase : ITest = tests[index];
			
			Sprite(testCase).addEventListener(Test.DONE, testFinised);
			
			try
			{
				addChild(Sprite(testCase));
				
				testCase.run();
			}
			catch(e : Error)
			{
				addResult(testCase.getName() + " crashed :/");
				addResult(e.getStackTrace());
				
				testFinised(null);
			}
		}
		
		private function testFinised(event : Event) : void
		{
			var testCase : ITest = tests[index];
			
			Sprite(testCase).removeEventListener(Test.DONE, testFinised);
			removeChild(Sprite(testCase));
			
			addResult(testCase.getResult());
			
			nextTest();
		}
		
		private function addResult(result : String) : void
		{
			this.result += result;
		}
	}
}
