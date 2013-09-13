package com.thenitro.ngine.particles.abstract {
	import starling.display.Shape;

	public class ShapeParticle extends Particle {
		private var _color:uint;
		
		public function ShapeParticle() {
			super();
		};
		
		override public function get reflection():Class {
			return ShapeParticle;
		};
		
		override public function draw(pColor:*):void {
			if (!needRedraw(pColor)) {
				return;
			}
			
			var shape:Shape = new Shape();
				shape.graphics.beginFill(pColor);
				shape.graphics.drawRect(0, 0, 10, 10);
				shape.graphics.endFill();
			
			_canvas = shape;
		};
		
		protected function needRedraw(pColor:uint):Boolean {
			if (pColor != _color) {
				_color = pColor;
				
				if (_canvas) {
					_canvas.dispose();
					_canvas = null;
				}
				
				return true;
			}
			
			return false;
		};
	}
}