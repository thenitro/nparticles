package com.thenitro.ngine.particles.abstract {
	import starling.display.Shape;

	public class ShapeParticle extends Particle {
		protected var _shape:Shape;
		private var _color:uint;
		
		public function ShapeParticle() {
			super();
			
			_shape = new Shape();
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
			_shape.graphics.clear();
			_shape.graphics.beginFill(pColor);
			_shape.graphics.drawRect(0, 0, 10, 10);
			_shape.graphics.endFill();
		};
	}
}