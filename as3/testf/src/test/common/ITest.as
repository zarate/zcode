package test.common
{
	/**
	 * @author Juan Delgado
	 */
	public interface ITest
	{
		function run() : void;
		function getResult() : String;
		function getName() : String;
		function setParams(params : Vector.<String>) : void;
	}
}
