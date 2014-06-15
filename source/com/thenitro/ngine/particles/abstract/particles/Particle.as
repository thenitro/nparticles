package com.thenitro.ngine.particles.abstract.particles {
    import ngine.core.Entity;

    import nmath.TMath;

    public class Particle extends Entity {
		public var initLife:Number;
		public var life:Number;
		
		public var omega:Number;
		
		public var growTime:Number;
		public var shrinkTime:Number;
		
		public var initScale:Number;
		public var scale:Number;
		
		public var initAlpha:Number;
		public var alpha:Number;
		
		public var alphaGrowTime:Number;
		public var alphaShrinkTime:Number;
		
		public function Particle() {
			super();
		};
		
		override public function get reflection():Class {
			return Particle;
		};
		
		override public function update(pElapsed:Number):void {
			life -= pElapsed;
			
			if (life <= 0) {
				expire();
				return;
			}
			
			if (life > initLife - growTime) {
				scale = TMath.lerp(0.0, initScale, (initLife - life) / growTime);
			} else if (life < shrinkTime) {
				scale = TMath.lerp(initScale, 0.0, (shrinkTime - life) / shrinkTime);
			} else {
				scale = initScale;
			}
			
			if (life > initLife - alphaGrowTime) {
				alpha = TMath.lerp(0.0, initAlpha, (initLife - life) / alphaGrowTime);
			} else if (life < shrinkTime) {
				alpha = TMath.lerp(initAlpha, 0.0, (alphaShrinkTime - life) / alphaShrinkTime);
			} else {
				alpha = initAlpha;
			}
			
			_orientation += omega;
				
			super.update(pElapsed);
			
			_canvas.scaleX = _canvas.scaleY = scale;
			_canvas.alpha  = alpha;
		};
		
		public function draw(pData:*):void {
			
		};
	}
}