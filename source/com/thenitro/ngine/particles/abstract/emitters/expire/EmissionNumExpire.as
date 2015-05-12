package com.thenitro.ngine.particles.abstract.emitters.expire {
	import com.thenitro.ngine.particles.abstract.emitters.ParticlesEmitter;

    import ngine.core.manager.EntityManager;

    import starling.events.Event;

    public final class EmissionNumExpire extends ParticlesExpire {
		private var _target:Number;
		private var _emitter:ParticlesEmitter;

        private var _count:int;
		
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
		
		override public function update(pElapsed:Number):void {};
		
		override public function poolPrepare():void {
			super.poolPrepare();

            _count  = 0;

            _emitter.manager.removeEventListener(EntityManager.ADDED, adddedEventHandler);
			_emitter = null;
		};
		
		override public function dispose():void {
			super.dispose();

            _emitter.manager.removeEventListener(EntityManager.ADDED, adddedEventHandler);
			_emitter = null;
		};
		
		public function init(pEmitter:ParticlesEmitter, pTarget:int):void {
            _count   = 0;
			_target  = pTarget;
			_emitter = pEmitter;
            _emitter.manager.addEventListener(EntityManager.ADDED, adddedEventHandler);
		};

        private function adddedEventHandler(pEvent:Event):void {
            _count++;

            if (_count >= _target) {
                _emitter.manager.removeEventListener(EntityManager.ADDED, adddedEventHandler);
                _emitter.emissionRate = 0.0;
            }
        };
	}
}