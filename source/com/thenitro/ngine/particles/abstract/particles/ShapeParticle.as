package com.thenitro.ngine.particles.abstract.particles {
	import starling.display.Canvas;

	public class ShapeParticle extends Particle {
		protected var _shape:Canvas;
		private var _color:uint;
		
		public function ShapeParticle() {
			super();
			
			_shape = new Canvas();
		};
		
		override public function get reflection():Class {
			return ShapeParticle;
		};
		
		override public function draw(pColor:*):void {
			if (!needRedraw(pColor)) {
				return;
			}
			
			drawShape(pColor);
			
			_canvas = _shape;
		};
		
		protected function needRedraw(pColor:uint):Boolean {
			if (pColor != _color) {
				_color = pColor;
				
				return true;
			}
			
			return false;
		};
		
		protected function drawShape(pColor:uint):void {
			_shape.clear();
			_shape.beginFill(pColor);
			_shape.drawRectangle(0, 0, 10, 10);
			_shape.endFill();
		};
	}
}