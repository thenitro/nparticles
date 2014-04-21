package com.thenitro.ngine.particles.abstract.emitters.expire {
	import com.thenitro.ngine.particles.abstract.emitters.ParticlesEmitter;

	public final class EmissionNumExpire extends ParticlesExpire {
		private var _target:Number;
		private var _emitter:ParticlesEmitter;

		
		public function EmissionNumExpire() {
			super();
		};
		
		public static function get NEW():EmissionNumExpire {
			var result:EmissionNumExpire = _pool.get(EmissionNumExpire) as EmissionNumExpire;
			
			if (!result) {
				result = new EmissionNumExpire();
				_pool.allocate(EmissionNumExpire, 1);
			}
			
			return result;
		};
		
		override public function get reflection():Class {
			return EmissionNumExpire;
		};
		
		override public function update(pElapsed:Number):void {
			if (_emitter.numParticles == _target) {
				_emitter.emissionRate = 0.0;
			}
		};
		
		override public function poolPrepare():void {
			super.poolPrepare();
			
			_emitter = null;
		};
		
		override public function dispose():void {
			super.dispose();
			
			_emitter = null;
		};
		
		public function init(pEmitter:ParticlesEmitter, pTarget:int):void {
			_target  = pTarget;
			_emitter = pEmitter;
		};
	}
}