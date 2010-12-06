package test.common
{
	import test.common.events.TestEvent;

	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	/**
	 * Base class for all the tests. Would take care of
	 * keeping track of time, holding parameters, and
	 * creating header/footer, etc.
	 * 
	 * @see test.common.events.TestEvent
	 * @see test.common.ITest
	 * 	 * @author Juan Delgado
	 */
	public class Test extends Sprite implements ITest
	{
		/**
		 * Holds the result of the test as a String. Extending
		 * classes should update it as required.
		 */
		protected var result : String = "";
		
		/**
		 * Time in milliseconds at which the test started.
		 */
		protected var initTime : int;
		
		/**
		 * Time in milliseconds at which the test finished.
		 */
		protected var endTime : int;
		
		/**
		 * Parameters for the test. Optional.
		 */
		protected var params : Vector.<String>;
		
		/**
		 * @inheritDoc
		 */		
		public function getResult() : String
		{
			return result;
		}

		/**
		 * @inheritDoc
		 * Extending classes must call super before executing their own code.
		 */
		public function run() : void
		{
			initTime = getTimer();
		}
		
		/**
		 * @inheritDoc
		 * Extending classes must override.
		 */
		public function getName() : String
		{
			throw "Please override";
			return null;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function setParams(params : Vector.<String>) : void
		{
			this.params = params;
		}
		
		/**
		 * Extending classes call stop() to stop the test. Calling stop
		 * would stop the timer, generate the result and dispatch an event.
		 * 
		 * Extending classes should call stop() after their own clean up.
		 * 
		 * @see test.common.events.TestEvent
		 */
		protected function stop() : void
		{
			endTime = getTimer();
			result = getHeader() + result + getFooter();
			
			dispatchEvent(new TestEvent(TestEvent.DONE, this));
		}
		
		/**
		 * @return The header for the result string, typically he name and elapsed time. 
		 */
		protected function getHeader() : String
		{
			return "**************** " + getName() + ": " + (endTime - initTime) + "ms \n";
		}
		
		/**
		 * @return The footer for the result string, typically a blank line.
		 */
		protected function getFooter() : String
		{
			return "\n";
		}
	}
}
