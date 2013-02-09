package
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.display.Sprite; 

	public class Main extends MovieClip
	{
		// Snake object
		public var snake:Snake;
		
		// The next player move
		public var nextMove:String;
		
		// Food and powerup toggles
		public var foodOut:Boolean;
		public var powerupOut:Boolean;
		
		// Food object
		public var food:Food;
		public var eatSound:Sound;
		
		// Powerup object
		public var powerup:Powerup;
		
		// Score
		public var score:Number;
		public var scoreMultiplier:Number;
		
		public var gameRunning:Boolean;
		
		public var deathSound:Sound;
		
		public function Main()
		{
			gameOverScreen.visible = false;
			
			this.gameRunning = false;
			
			this.foodOut = false;
			
			// For some reason we have to put a powerup out before the snake can eat food, don't ask me why
			// it's just one of those bugs. The code looks solid to me... anyway, since it's 6am and I can't
			// be bothered to do it properly here's a hacky workaround.
			this.powerup = new Powerup(stage, -100, -100);
			this.powerupOut = false;
			
			this.score = 0;
			this.scoreMultiplier = 1;
			
			// Sounds
			this.eatSound = new EatSound();
			this.deathSound = new DeathSound();
			
			// Hide lavels
			scoreLabel.visible = false;
			multiplierLabel.visible = false;
			teleportLabel.visible = false;
			
			// Listen for key presses
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		}
		
		public function gameLoop(event):void
		{
			if(this.gameRunning)
			{		
				// Update snake
				this.snake.update();
				
				// If food isn't out, put some out at a random position
				if(!this.foodOut)
				{
					this.food = new Food(stage, this.randomNumber(0, 79) * 10, this.randomNumber(0, 59) * 10);
					this.foodOut = !this.foodOut;
				}
				
				// Update food
				this.food.update();
				
				// Randomly decide to put out a power up
				if(this.randomNumber(0, 500) == 1 && !this.powerupOut)
				{
					this.powerup = new Powerup(stage, this.randomNumber(0, 79) * 10, this.randomNumber(0, 59) * 10);
					this.powerupOut = !this.powerupOut;
				}
				
				// Update the powerup if we have one
				if(this.powerup != null)
				{
					this.powerup.update();
				}
				
				// Check for collision between snake and powerup
				if(this.snake.segments[0].x == this.powerup.x && this.snake.segments[0].y == this.powerup.y)
				{
					// Player chomp'd dat powerup
					stage.removeChild(this.powerup.powerupSprite);
					
					// Increase multiplier
					this.scoreMultiplier += 1;
					multiplierLabel.text = "Multiplier: " + this.scoreMultiplier.toString();
					
					// Play the eat sound
					this.eatSound.play();
					
					this.powerupOut = false;
				}
				
				// Check for collision between snake and food
				if(this.snake.segments[0].x == this.food.x && this.snake.segments[0].y == this.food.y)
				{
					// Player ate the food
					stage.removeChild(this.food.foodSprite);
					
					// Increase score
					this.score += 10 * this.scoreMultiplier;
					scoreLabel.text = "Score: " + this.score.toString();
					
					// Play the eat sound
					this.eatSound.play();
					
					this.foodOut = !this.foodOut;
					
					// Add 3 snake segments
					this.snake.addSegment(-100, -100);
					this.snake.addSegment(-100, -100);
					this.snake.addSegment(-100, -100);
				}
				
				// Check if the snake is eating itself
				for(var i:Number = 1; i < this.snake.segments.length; i++)
				{
					if(this.snake.segments[0].x == this.snake.segments[i].x && this.snake.segments[0].y == this.snake.segments[i].y)
					{
						this.gameOver();
					}
				}
				
				// Update teleport label, we can't do it in the snake class because it can't access it for some reason :/
				teleportLabel.text = "Teleports: " + this.snake.teleportsLeft.toString();
			}
		}
		
		public function keyDown(event:KeyboardEvent):void
		{		
			if(event.keyCode == 32 && !this.gameRunning)
			{
				// Clear any snake or food children, this happens when a player loses and restarts
				// this.food.removeFood();
				if(this.snake != null && this.food != null)
				{
					for(var i:Number = 0; i < this.snake.segments.length; i++)
					{
						stage.removeChild(this.snake.segments[i]);
					}
					stage.removeChild(this.food.foodSprite);
					this.foodOut = !this.foodOut;
					
					// Remove the game over screen
					gameOverScreen.visible = false;
					
					// Reset score and multiplier
					this.score = 0;
					scoreLabel.text = "Score: 0";
					this.scoreMultiplier = 1;
					multiplierLabel.text = "Multiplier: 1";
				}
				
				if(stage.contains(this.powerup.powerupSprite))
				{
					stage.removeChild(this.powerup.powerupSprite);
					this.powerupOut = false;
				}
				
				splashScreen.visible = false;
				controls.visible = false;
				this.snake = new Snake(stage);
				
				// Fire off the game loop
				addEventListener("enterFrame", gameLoop);
				this.gameRunning = true;
				
				// Show labels
				scoreLabel.visible = true;
				multiplierLabel.visible = true;
				teleportLabel.visible = true;
			}
		}
		
		public function gameOver():void
		{
			// Stop the game from running
			this.gameRunning = false;
			
			gameOverScreen.visible = true;
			
			// Play death sound
			this.deathSound.play();
		}
		
		public function randomNumber(low:Number = 0, high:Number = 1):Number
		{
			return Math.floor(Math.random() * (1 + high - low)) + low;
		}
	}
}