package ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

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
			field.embedFonts = true;
			field.defaultTextFormat = new TextFormat("GentiumBasic", 18, 0xFFFFFF);
			
			addChild(field);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}

		public function log(text : String) : void
		{
			field.appendText(text + "\n");
			field.scrollV = field.maxScrollV;
		}
		
		private function removedFromStage(event : Event) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}

		private function addedToStage(event : Event) : void
		{
			var totalWidth : int = stage.stageWidth * .9;
			var totalHeight : int = stage.stageHeight * .9;
			
			field.width = totalWidth;
			field.height = totalHeight;
			
			var bg : Sprite = new Sprite();
			bg.graphics.beginFill(0x000000, .7);
			bg.graphics.drawRect(0, 0, totalWidth, totalHeight);
			bg.graphics.endFill();
			
			addChild(bg);
			swapChildren(bg, field);
		}
		
		[Embed(source="../assets/fonts/GenBasR.ttf", fontFamily="GentiumBasic", embedAsCFF="false", mimeType="application/x-font")]
		private var c4Regular : Class;
	}
}
