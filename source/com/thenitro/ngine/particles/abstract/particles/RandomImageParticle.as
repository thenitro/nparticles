package com.thenitro.ngine.particles.abstract.particles {
	import starling.display.Image;
	import starling.textures.Texture;
	
	public final class RandomImageParticle extends Particle {
		private var _textureID:int = -1;
		
		public function RandomImageParticle() {
			super();
		};
		
		override public function get reflection():Class {
			return RandomImageParticle;
		};
		
		override public function draw(pTexures:*):void {
			var textureID:int = Math.round(((pTexures as Array).length - 1) * Math.random());
			
			if (!needRedraw(textureID)) {
				return;
			}
			
			_canvas = new Image(pTexures[textureID] as Texture);
			_canvas.pivotX = _canvas.width  / 2;
			_canvas.pivotY = _canvas.height / 2;
		};
		
		protected function needRedraw(pTextureID:int):Boolean {
			if (pTextureID != _textureID) {
				_textureID = pTextureID;
				
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