package com.thenitro.ngine.particles.abstract.emitters.expire {
	import com.thenitro.ngine.particles.abstract.emitters.ParticlesEmitter;
	
	public final class TimerExpire extends ParticlesExpire {
		private var _target:Number;
		private var _emitter:ParticlesEmitter;
		
		public function TimerExpire() {
			super();
		};
		
		override public function get reflection():Class {
			return TimerExpire;
		};
		
		override public function update(pElapsed:Number):void {
			if (!_emitter) {
				return;
			}
			
			_target -= pElapsed;
			
			if (_target <= 0) {
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
		
		public function init(pEmitter:ParticlesEmitter, pTarget:Number):void {			
			if (pTarget < 0) {
				return;	
			}
			
			_target  = pTarget;
			_emitter = pEmitter;
		};
	};
}