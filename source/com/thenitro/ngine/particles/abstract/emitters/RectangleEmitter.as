package com.thenitro.ngine.particles.abstract.emitters {
	import com.thenitro.ngine.math.Random;
	import com.thenitro.ngine.math.vectors.Vector2D;
	import com.thenitro.ngine.particles.abstract.Particle;
	
	public final class RectangleEmitter extends ParticlesEmitter {
		private var _dimension:Vector2D;
		
		public function RectangleEmitter() {
			super();
			
			_dimension = Vector2D.ZERO;
		};
		
		override public function get reflection():Class {
			return PointEmitter;
		};
		
		public function get dimension():Vector2D {
			return _dimension;
		};
		
		override protected function initPosition(pParticle:Particle):void {
			pParticle.position.x = Random.range(_position.x, _dimension.x);
			pParticle.position.y = Random.range(_position.y, _dimension.y);
		};
		
		override public function poolPrepare():void {
			super.poolPrepare();
			
			_dimension.zero();
		};
		
		override public function dispose():void {
			super.dispose();
			
			_pool.put(_dimension);
			_dimension = null;
		};
	};
}