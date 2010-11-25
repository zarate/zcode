package ui
{
	import flash.text.TextFormat;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * @author Juan Delgado
	 */
	public class LogField extends Sprite
	{
		private var field : TextField;
		
		public function LogField()
		{
			field = new TextField();
			field.border = true;
			field.multiline = field.wordWrap = true;
			field.defaultTextFormat = new TextFormat(null, null, 0xff0000);
			
			addChild(field);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}

		public function log(text : String) : void
		{
			field.text = text + "\n";
			field.scrollV = field.maxScrollV;
		}
		
		private function removedFromStage(event : Event) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}

		private function addedToStage(event : Event) : void
		{
			field.width = 300;
			field.height = stage.stageHeight;
		}
	}
}
