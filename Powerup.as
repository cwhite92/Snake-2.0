package
{
	import flash.display.Stage;
	import flash.display.Sprite; 

	public class Powerup
	{
		// Powerup position
		public var x:Number;
		public var y:Number;
		
		// Stage
		private var stage:Stage;
		
		// The powerup sprite
		public var powerupSprite:Sprite;
		
		// Lets us keep track of how to scale
		public var scaleDirection:Number;
		
		public function Powerup(stage:Stage, x:Number, y:Number)
		{
			// Set parameters
			this.stage = stage;
			this.x = x;
			this.y = y;
			
			// Make the sprite
			this.powerupSprite = new Sprite();
			this.powerupSprite.graphics.beginFill(0x991515);
			this.powerupSprite.graphics.drawRect(-5, -5, 10, 10);
			this.powerupSprite.graphics.endFill();
			this.powerupSprite.x = this.x + 5;
			this.powerupSprite.y = this.y + 5;
			this.stage.addChild(this.powerupSprite);
			
			this.scaleDirection = 1;
		}
		
		public function update()
		{
			// Scale the powerup based on scale direction. 1 = get bigger, 0 = get smaller
			if(this.scaleDirection == 1)
			{
				this.powerupSprite.scaleX += .03;
				this.powerupSprite.scaleY += .03;
				if(this.powerupSprite.width > 15)
				{
					this.scaleDirection = 0;
				}
			}
			else
			{
				this.powerupSprite.scaleX -= .03;
				this.powerupSprite.scaleY -= .03;
				if(this.powerupSprite.width < 8)
				{
					this.scaleDirection = 1;
				}
			}
			
			// Also rotate it for lols
			this.powerupSprite.rotation += 1;
		}
	}
}