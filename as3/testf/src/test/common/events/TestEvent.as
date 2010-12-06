package test.common.events
{
	import test.common.ITest;

	import flash.events.Event;

	/**
	 * @author Juan Delgado
	 */
	public class TestEvent extends Event
	{
		public var test : ITest;
		
		public var textUpdate : String;
		
		public static const UPDATE : String = "UPDATE";
		
		public static const DONE : String = "DONE";
		
		public function TestEvent(type : String, test : ITest)
		{
			super(type);

			this.test = test;
		}
	}
}
