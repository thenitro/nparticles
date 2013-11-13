package com.thenitro.ngine.particles.abstract.emitters.position {
	import com.thenitro.ngine.particles.abstract.particles.Particle;
	
	import ngine.pool.IReusable;
	import ngine.pool.Pool;
	
	public class ParticlesPosition implements IReusable {
		protected static var _pool:Pool = Pool.getInstance();
		
		public function ParticlesPosition() {
			
		};
		
		public function get reflection():Class {
			return ParticlesPosition;
		};
		
		public function update():void {
			
		};
		
		public function setUpParticle(pParticle:Particle):void {
			
		};
		
		public function poolPrepare():void {
			
		};
		
		public function dispose():void {
			
		};
	}
}