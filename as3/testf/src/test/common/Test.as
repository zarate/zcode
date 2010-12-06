package test.common
{
	import test.common.events.TestEvent;

	import flash.display.Sprite;
	import flash.utils.getTimer;
	/**
	 * @author Juan Delgado
	 */
	public class Test extends Sprite implements ITest
	{
		protected var result : String = "";
		
		protected var initTime : int;
		
		protected var endTime : int;
		
		protected var params : Vector.<String>;
		
		public function getResult() : String
		{
			return result;
		}

		public function run() : void
		{
			initTime = getTimer();
		}

		public function getName() : String
		{
			return "Test";
		}
		
		public function setParams(params : Vector.<String>) : void
		{
			this.params = params;
		}
		
		protected function stop() : void
		{
			endTime = getTimer();
			result = getHeader() + result + getFooter();
			
			dispatchEvent(new TestEvent(TestEvent.DONE, this));
		}
		
		protected function getHeader() : String
		{
			return "**************** " + getName() + ": " + (endTime - initTime) + "ms \n";
		}
		
		protected function getFooter() : String
		{
			return "\n";
		}
	}
}
