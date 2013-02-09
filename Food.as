package
{
	import flash.display.Stage;
	import flash.display.Sprite; 
	import flash.filters.GlowFilter;
	
	public class Food
	{
		// Food position
		public var x:Number;
		public var y:Number;
		
		// Stage
		private var stage:Stage;
		
		// The food sprite
		public var foodSprite:Sprite;
		
		// Lets us keep track of how to scale
		public var scaleDirection:Number;
		
		public function Food(stage:Stage, x:Number, y:Number)
		{
			this.stage = stage;
			
			this.x = x;
			this.y = y;
			
			this.foodSprite = new Sprite();
			this.foodSprite.graphics.beginFill(0xFFFFFF);
			this.foodSprite.graphics.drawRect(-5, -5, 10, 10);
			this.foodSprite.filters = [new GlowFilter(0xFF6699, .80, 5, 5, 2, 2, false, false)];
			this.foodSprite.graphics.endFill();
			this.foodSprite.x = this.x + 5;
			this.foodSprite.y = this.y + 5;
			this.stage.addChild(this.foodSprite);
		}
		
		public function removeFood()
		{
			this.stage.removeChild(this.foodSprite);
		}
		
		public function update():void
		{
			// Scale the powerup based on scale direction. 1 = get bigger, 0 = get smaller
			if(this.scaleDirection == 1)
			{
				this.foodSprite.scaleX += .03;
				this.foodSprite.scaleY += .03;
				if(this.foodSprite.width > 13)
				{
					this.scaleDirection = 0;
				}
			}
			else
			{
				this.foodSprite.scaleX -= .03;
				this.foodSprite.scaleY -= .03;
				if(this.foodSprite.width < 9)
				{
					this.scaleDirection = 1;
				}
			}
			
			// Also rotate it for lols
			this.foodSprite.rotation += 1;
			
			// Spin the food
			this.foodSprite.rotation += 1;
		}
	}
}
