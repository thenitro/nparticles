package com.thenitro.ngine.particles.abstract.emitters.position {
	import com.thenitro.ngine.particles.abstract.emitters.ParticlesEmitter;
	import com.thenitro.ngine.particles.abstract.particles.Particle;
	
	public final class PointParticles extends ParticlesPosition {
		private var _emitter:ParticlesEmitter;
		
		public function PointParticles() {
			super();
		};
		
		public static function get NEW():PointParticles {
			var result:PointParticles = _pool.get(PointParticles) as PointParticles;
			
			if (!result) {
				result = new PointParticles();
				_pool.allocate(PointParticles, 1);
			}
			
			return result;
		};
		
		public function init(pEmitter:ParticlesEmitter):void {
			_emitter = pEmitter;
		};
		
		override public function get reflection():Class {
			return PointParticles;
		};
		
		override public function setUpParticle(pParticle:Particle):void {
			pParticle.position.x = _emitter.position.x;
			pParticle.position.y = _emitter.position.y;
		};
		
		override public function poolPrepare():void {
			super.poolPrepare();
			
			_emitter = null;
		};
		
		override public function dispose():void {
			super.dispose();
			
			_emitter = null;
		};
	};
}