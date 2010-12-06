package test.common
{
	import test.common.events.TestEvent;

	import flash.display.Sprite;
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
			
			Sprite(testCase).addEventListener(TestEvent.DONE, testFinised);
			Sprite(testCase).addEventListener(TestEvent.UPDATE, testUpdate);
			
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

		private function testUpdate(event : TestEvent) : void
		{
			// TODO: tried re-dispathching and cloning the event to no avail :/
			
			var update : TestEvent = new TestEvent(TestEvent.UPDATE, event.test);
			update.textUpdate = event.textUpdate;
			dispatchEvent(update);
		}
		
		private function testFinised(event : TestEvent) : void
		{
			var testCase : ITest = tests[index];
			
			Sprite(testCase).removeEventListener(TestEvent.DONE, testFinised);
			Sprite(testCase).removeEventListener(TestEvent.UPDATE, testUpdate);
			removeChild(Sprite(testCase));
			
			addResult(testCase.getResult());
			
			var updateEvent : TestEvent = new TestEvent(TestEvent.UPDATE, this);
			updateEvent.textUpdate = testCase.getName() + " finished";

			dispatchEvent(updateEvent);
			
			nextTest();
		}
		
		private function addResult(result : String) : void
		{
			this.result += result;
		}
	}
}
