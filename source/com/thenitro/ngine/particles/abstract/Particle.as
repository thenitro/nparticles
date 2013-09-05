package com.thenitro.ngine.particles.abstract {
	import com.thenitro.ngine.display.gameentity.Entity;
	import com.thenitro.ngine.math.TMath;
	import com.thenitro.ngine.math.vectors.Vector2D;
	
	import starling.display.Shape;
	
	public final class Particle extends Entity {
		public var initLife:Number;
		public var life:Number;
		
		public var growTime:Number;
		public var shrinkTime:Number;
		
		public var omega:Number;
		
		public var initScale:Number;
		public var scale:Number;
		
		public function Particle() {
			super();
			
			var shape:Shape = new Shape();
				shape.graphics.beginFill(0x0);
				shape.graphics.drawRect(0, 0, 10, 10);
				shape.graphics.endFill();
			
			_canvas = shape;
		};
		
		override public function get reflection():Class {
			return Particle;
		};
		
		override public function update():void {
			life -= 0.01;
			
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
				
			super.update();
			
			_canvas.scaleX = _canvas.scaleY = scale;
		};
		
		override public function poolPrepare():void {
			super.poolPrepare();
		};
		
		override public function dispose():void {
			super.dispose();
		};
	}
}