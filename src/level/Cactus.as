package level 
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Jens Kooij
	 */
	public class Cactus extends Sprite
	{
		private var _dance:TimelineMax = new TimelineMax();
		
		[Embed(source = "../../lib/head.png")]
		private var HeadImage:Class;
		
		private var headImage:Bitmap = new HeadImage();

		[Embed(source = "../../lib/cactus.png")]
		private var CactusImage:Class;
		
		public function Cactus() 
		{
			headImage.alpha = 0;
			headImage.y = -20;
			this.scaleX = 0.3;
			this.scaleY = 0.3;
			var tmpCactusImage:Bitmap = addChild(new CactusImage()) as Bitmap;
			tmpCactusImage.x = x - (headImage.width / 2);
			headImage.x = x - (headImage.width / 2)
			addChild(headImage);
			tmpCactusImage.smoothing = true;
		}
		
		public function dance():void 
		{
			TweenLite.to(this, 2, { scaleX: 0.8, scaleY: 0.8, y: "-140"} );
			TweenLite.to(headImage, 1, { alpha:1, y:0 } );
			
			_dance.append( new TweenLite(this, 3, { rotationY: 360 * 4 } ));
			_dance.append( new TweenLite(this, 0.5, { y: "-20" } ));
			_dance.append( new TweenLite(this, 0.5, { y: "20" } ));
			_dance.append( new TweenLite(this, 3, { rotationY: 0 } ));
			_dance.append( new TweenLite(this, 1, { colorMatrixFilter: { colorize: 0xff0000, amount: 1 }} ));
			_dance.append( new TweenLite(this, 1, { colorMatrixFilter: {colorize: 0xff0000, amount: 0}} ));
			_dance.append( new TweenLite(this, 0.25, { rotation: 15 } ));
			_dance.append( new TweenLite(this, 0.5, { rotation: -15 } ));
			_dance.append( new TweenLite(this, 0.5, { rotation: 15 } ));
			_dance.append( new TweenLite(this, 0.5, { rotation: -15 } ));
			_dance.append( new TweenLite(this, 0.5, { rotation: 15 } ));
			_dance.append( new TweenLite(this, 0.5, { rotation: -15 } ));
			_dance.append( new TweenLite(this, 0.25, { rotation: 0 } ));
			_dance.repeat = int.MAX_VALUE;
			_dance.yoyo = true;
			_dance.play();
		}
	}

}