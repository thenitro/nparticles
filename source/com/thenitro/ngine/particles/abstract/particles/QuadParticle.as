package com.thenitro.ngine.particles.abstract.particles {
    import starling.display.Quad;

    public final class QuadParticle extends Particle {
		private var _color:uint;
		private var _quad:Quad;
		
		public function QuadParticle() {
			super();
			
			_color = Math.random() * 0xFFFFFF;
			
			_quad  = new Quad(100, 100, _color);
			
			_quad.pivotX = _quad.width / 2;
			_quad.pivotY = _quad.height / 2;
		};

		override public function get reflection():Class {
			return QuadParticle;
		};
		
		override public function draw(pColor:*):void {
			if (!needRedraw(pColor)) {
				return;
			}
			
			drawQuad(pColor);
			
			_canvas = _quad;
		};
		
		private function needRedraw(pColor:uint):Boolean {
			if (pColor != _color) {
				_color = pColor;
				
				return true;
			}
			
			return false;
		};
		
		private function drawQuad(pColor:uint):void {
			_quad.color = pColor;
		};
	};
}