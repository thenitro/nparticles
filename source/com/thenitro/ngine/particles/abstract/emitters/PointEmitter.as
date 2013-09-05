package com.thenitro.ngine.particles.abstract.emitters {
	import com.thenitro.ngine.particles.abstract.Particle;
	
	public final class PointEmitter extends ParticlesEmitter {		
		
		public function PointEmitter() {
			super();			
		};
		
		override public function get reflection():Class {
			return PointEmitter;
		};

		override protected function initPosition(pParticle:Particle):void {
			pParticle.position.x = position.x;
			pParticle.position.y = position.y;
		};
	}
}