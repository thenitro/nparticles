package com.thenitro.ngine.particles.abstract.particles {
	import starling.display.Image;
	import starling.textures.Texture;
    import starling.textures.TextureSmoothing;

    public final class ImageParticle extends Particle {
		private var _texture:Texture;
		
		public function ImageParticle() {
			super();
		};
		
		override public function get reflection():Class {
			return ImageParticle; 
		};
		
		override public function draw(pTexure:*):void {
			if (!needRedraw(pTexure)) {
				return;
			}
			
			_canvas = new Image(pTexure);

			_canvas.pivotX = _canvas.width  / 2;
			_canvas.pivotY = _canvas.height / 2;

            (_canvas as Image).textureSmoothing = TextureSmoothing.NONE;
		};
		
		protected function needRedraw(pTexture:Texture):Boolean {
			if (pTexture != _texture) {
				_texture = pTexture;
				
				if (_canvas) {
					_canvas.dispose();
					_canvas = null;
				}
				
				return true;
			}
			
			return false;
		};
	};
}