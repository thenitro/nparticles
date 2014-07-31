package com.thenitro.ngine.particles.abstract.emitters.position {
	import com.thenitro.ngine.particles.abstract.particles.Particle;
	
	import npooling.IReusable;
	import npooling.Pool;
	
	public class ParticlesPosition implements IReusable {
		protected static var _pool:Pool = Pool.getInstance();

        private var _disposed:Boolean;
		
		public function ParticlesPosition() {
			
		};
		
		public function get reflection():Class {
			return ParticlesPosition;
		};

        public function get disposed():Boolean {
            return _disposed;
        };
		
		public function update():void {
			
		};
		
		public function setUpParticle(pParticle:Particle):void {
			
		};
		
		public function poolPrepare():void {
			
		};
		
		public function dispose():void {
			_disposed = true;
		};
	}
}