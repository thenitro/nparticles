package com.thenitro.ngine.particles.abstract {
	import ngine.core.Entity;
	import ngine.math.TMath;
	
	public class Particle extends Entity {
		public var initLife:Number;
		public var life:Number;
		
		public var growTime:Number;
		public var shrinkTime:Number;
		
		public var omega:Number;
		
		public var initScale:Number;
		public var scale:Number;
		
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
			
			_orientation += omega;
				
			super.update(pElapsed);
			
			_canvas.scaleX = _canvas.scaleY = scale;
		};
		
		public function draw(pData:*):void {
			
		};
	}
}