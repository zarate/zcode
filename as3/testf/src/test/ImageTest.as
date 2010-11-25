package test
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * @author Juan Delgado
	 */
	public class ImageTest extends Test
	{
		private var timer : Timer;
		
		private var circles : Vector.<Circle> = new Vector.<Circle>();
		
		private var time : Number = -1;
		
		private var maxDelay : Number;
		
		override public function getName() : String
		{
			return "ImageTest";
		}
		
		override public function run() : void
		{
			super.run();
			
			// That's the time a frame would take to render at 10fps.
			// So we are going to keep adding circles until we bring the player
			// down to 10fps,
			maxDelay = (1/10) * 1000;

			addEventListener(Event.ENTER_FRAME, update);
			
			addCircles(null);
			
			timer = new Timer(100);
			timer.addEventListener(TimerEvent.TIMER, addCircles);
			timer.start();
		}

		private function update(event : Event) : void
		{
			if(time != -1)
			{
				if(getTimer() - time > maxDelay)
				{
					exit();
				}
			}
			
			for each(var circle : Circle in circles)
			{
				circle.x += (circle.xTo - circle.x) / 3;
				circle.y += (circle.yTo - circle.y) / 3;

				if(Math.abs(circle.x - circle.xTo) < 1)
				{
					circle.x = circle.xTo;
					circle.xTo = Math.ceil(Math.random() * stage.stageWidth);
				}

				if(Math.abs(circle.y - circle.yTo) < 1)
				{
					circle.y = circle.yTo;
					circle.yTo = Math.ceil(Math.random() * stage.stageHeight);
				}
			}
			
			time = getTimer();
		}

		private function exit() : void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, addCircles);
			timer = null;
			
			removeEventListener(Event.ENTER_FRAME, update);
			
			result += "Total images: " + circles.length;
			
			circles = null;
			
			stop();
		}

		private function addCircles(event : TimerEvent) : void
		{
			for(var i : int = 0; i < 10; i++)
			{
				var circle : Circle = new Circle();
				addChild(circle);
				
				circles.push(circle);
			}			
		}
	}
}
import flash.display.Sprite;

internal class Circle extends Sprite
{
	public var xTo : int = 0;
	
	public var yTo : int = 0;
	
	[Embed(source="../assets/wikipedia.png")]
	private var ImageClass : Class;
	
	public function Circle()
	{
		addChild(new ImageClass());
	}
}