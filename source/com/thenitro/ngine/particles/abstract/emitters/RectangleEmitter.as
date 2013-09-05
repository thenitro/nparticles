package com.thenitro.ngine.particles.abstract.emitters {
	import com.thenitro.ngine.math.vectors.Vector2D;
	import com.thenitro.ngine.particles.abstract.Particle;
	
	public final class RectangleEmitter extends ParticlesEmitter {
		private var _size:Vector2D;
		
		public function RectangleEmitter() {
			super();
			
			_size = Vector2D.ZERO;
		};
		
		override public function get reflection():Class {
			return PointEmitter;
		};
		
		public function get size():Vector2D {
			return _size;
		};
		
		override protected function initPosition(pParticle:Particle):void {
			pParticle.position.x = position.x;
			pParticle.position.y = position.y;
		};
		
		override public function poolPrepare():void {
			super.poolPrepare();
			
			_size.zero();
		};
		
		override public function dispose():void {
			super.dispose();
			
			_pool.put(_size);
			_size = null;
		};
	};
}