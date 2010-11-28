package test
{
	import flash.display.Sprite;
	import flash.events.Event;
	import test.common.ITest;
	import test.common.Test;
	
	/**
	 * @author Juan Delgado
	 */
	public class TestRunner extends Test implements ITest
	{
		private var tests : Vector.<ITest> = new Vector.<ITest>();
		
		private var index : int;
		
		public function addTest(testCase : ITest) : void
		{
			tests.push(testCase);
		}

		override public function run() : void
		{
			super.run();
			
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
		
		private function nextTest() : void
		{
			index++;

			if(index < tests.length)
			{
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
			else
			{
				tests = null;
				stop();
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
