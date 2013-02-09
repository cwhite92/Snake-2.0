package
{
	import flash.display.Stage;
	import flash.display.Sprite; 
	import flash.filters.GlowFilter;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	
	public class Snake
	{
		// This holds the snakes body
		public var segments:Array = [];
		
		private var stage:Stage;
		
		// Holds the players next move
		private var nextMove:String;
		
		// Determins if the player wants to teleport
		public var doTeleport:Boolean;
		public var teleportsLeft:Number;
		public var teleportSound:Sound;
		
		// There was a problem where if the player quickly changed the snakes direction before the update
		// function was called, they could digest themselves and it would be game over. This stops that by
		// only letting the player update their direction once every game loop.
		public var movable:Boolean;
		
		public function Snake(stage:Stage)
		{
			this.stage = stage;
			
			// Start off with 6 snake segments
			for(var i:Number = 0; i < 1; i++)
			{
				this.addSegment(i * 10, 250);
			}
			
			// Listen for key presses
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			
			// Make the snake move right when game starts
			this.nextMove = "RIGHT";
			
			// Telep0rtz
			this.doTeleport = false;
			this.teleportsLeft = 5;
			this.teleportSound = new TeleportSound();
			
			this.movable = true;
		}
		
		public function update()
		{
			if(this.doTeleport)
			{
				this.teleport();
				this.doTeleport = false;
			}
			
			// Loop through each segment and set its co-ords to the one before it
			for (var i:Number = this.segments.length - 1; i > 0; i--)
			{
				this.segments[i].x = this.segments[i - 1].x;
				this.segments[i].y = this.segments[i - 1].y;
			}
			
			// Update snake head based on user input
			switch(this.nextMove)
			{
				case "UP":
					this.segments[0].y -= 10;
					break;
				case "RIGHT":
					this.segments[0].x += 10;
					break;
				case "DOWN":
					this.segments[0].y += 10;
					break;
				case "LEFT":
					this.segments[0].x -= 10;
					break;
			}
			
			// Check if snake is outside of the stage and if it is wrap it around to the other side
			if(this.segments[0].x > this.stage.stageWidth - 10)
			{
				this.segments[0].x = 0;
			}
			else if(this.segments[0].x < 0)
			{
				this.segments[0].x = this.stage.stageWidth - 10;
			}
			else if(this.segments[0].y > this.stage.stageHeight - 10)
			{
				this.segments[0].y = 0;
			}
			else if(this.segments[0].y < 0)
			{
				this.segments[0].y = this.stage.stageHeight - 10;
			}
			
			this.movable = true;
		}
		
		public function teleport()
		{
			// Jump ahead 5 blocks in whatever direction the snake is facing
			switch (this.nextMove)
			{
				case "UP":
					this.segments[0].y -= 50;
					break;
				case "RIGHT":
					this.segments[0].x += 50;
					break;
				case "DOWN":
					this.segments[0].y += 50;
					break;
				case "LEFT":
					this.segments[0].x -= 50;
					break;
			}
			
			// Play the teleport sound
			this.teleportSound.play();
		}
		
		public function addSegment(x:Number, y:Number)
		{
			var segment:Sprite = new Sprite();
			segment.graphics.beginFill(0xFFFFFF);
			segment.graphics.drawRect(0, 0, 10, 10);
			segment.filters = [new GlowFilter(0xFF6699, .50, 3, 3, 2, 2, false, false)];
			segment.graphics.endFill();
			segment.x = x;
			segment.y = y;
			this.stage.addChild(segment);
			this.segments.push(segment);
		}
		
		public function keyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case 37:
					if(this.nextMove != "RIGHT" && this.movable)
					{
						this.nextMove = "LEFT";
					}
					break;
				case 38:
					if(this.nextMove != "DOWN" && this.movable)
					{
						this.nextMove = "UP";
					}
					break;
				case 39:
					if(this.nextMove != "LEFT" && this.movable)
					{
						this.nextMove = "RIGHT";
					}
					break;
				case 40:
					if(this.nextMove != "UP" && this.movable)
					{
						this.nextMove = "DOWN";
					}
					break;
				case 17:
					if(this.teleportsLeft > 0)
					{
						this.doTeleport = true;
						this.teleportsLeft--;
					}
					break;
			}
			
			this.movable = false;
		}
	}
}
