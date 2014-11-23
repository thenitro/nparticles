package com.thenitro.ngine.particles.abstract.emitters.expire {
	import com.thenitro.ngine.particles.abstract.emitters.ParticlesEmitter;
	
	public final class EmissionExpire extends ParticlesExpire {
		private var _step:Number;
		private var _target:Number;
		
		private var _emitter:ParticlesEmitter;
		
		public function EmissionExpire() {
			super();
		};
		
		public static function get NEW():EmissionExpire {
			var result:EmissionExpire = _pool.get(EmissionExpire) as EmissionExpire;
			
			if (!result) {
				result = new EmissionExpire();
				_pool.allocate(EmissionExpire, 1);
			}
			
			return result;
		};
		
		override public function get reflection():Class {
			return EmissionExpire;
		};
		
		override public function update(pElapsed:Number):void {
			_emitter.emissionRate += _step;
			
			if (_emitter.emissionRate < _target) {
				_emitter.expire();
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
		
		public function init(pEmitter:ParticlesEmitter, pStep:Number, pTarget:Number):void {
			_step    = pStep;
			_target  = pTarget;
			_emitter = pEmitter;
		};
	};
}