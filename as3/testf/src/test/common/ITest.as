package test.common
{
	import org.osflash.signals.Signal;

	import flash.events.IEventDispatcher;
	
	/**
	 * Main interface for the tests to implement.
	 * @see flash.events.IEventDispatcher
	 * 
	 * @author Juan Delgado
	 */
	public interface ITest extends IEventDispatcher
	{
		/**
		 * Dispatched when the test has finished. Receives (ITest)
		 */
		function get finishedSignal() : Signal;
		
		/**
		 * Dispatched when the test sends a text update. Receives (ITest, String)
		 */		function get updateSignal() : Signal;
		
		/**
		 * Call it for the test to being.
		 */
		function run() : void;
		
		/**
		 * @return The result of the test as a String.
		 */
		function getResult() : String;
		
		/**
		 * @return The name of the test.
		 */
		function getName() : String;
		
		/**
		 * Some tests accept params to tweak how they work. This method
		 * would only store them for children to use.
		 * 
		 * @param params Vector of Strings to act as parameters.
		 */
		function setParams(params : Vector.<String>) : void;
	}
}
