package test.common
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	/**
	 * @author Juan Delgado
	 */
	public class Test extends Sprite implements ITest
	{
		public static const DONE : String = "DONE";
		
		protected var result : String = "";
		
		protected var initTime : int;
		
		protected var endTime : int;
		
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
		
		protected function stop() : void
		{
			endTime = getTimer();
			result = getHeader() + result + getFooter();
			
			dispatchEvent(new Event(DONE));
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
