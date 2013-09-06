package com.thenitro.ngine.particles.abstract.emitters {
	import com.thenitro.ngine.display.gameentity.Entity;
	import com.thenitro.ngine.display.gameentity.manager.EntityManager;
	import com.thenitro.ngine.math.Random;
	import com.thenitro.ngine.particles.abstract.Particle;
	import com.thenitro.ngine.particles.abstract.emitters.expire.ParticlesExpire;
	import com.thenitro.ngine.particles.abstract.emitters.position.ParticlesPosition;
	import com.thenitro.ngine.pool.IReusable;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ParticlesEmitter extends Entity implements IReusable {
		public var emissionRate:Number;
		
		public var particleLife:Number;
		public var particleLifeVariation:Number;
		
		public var particleScale:Number;
		public var particleScaleVariation:Number;
		
		public var particleGrowRatio:Number;
		public var particleShrinkRatio:Number;
		
		public var particleSpeed:Number;
		public var particleSpeedVariation:Number;
		
		public var particleOmegaVariation:Number;
		
		public var direction:Number;
		public var directionVariation:Number;
		
		public var ParticleClass:Class;
		
		public var particlesPosition:ParticlesPosition;
		public var particlesExpire:ParticlesExpire;
		
		private var _container:Sprite;
		private var _manager:EntityManager;
		
		private var _framesPerParticle:Number;
		
		public function ParticlesEmitter() {
			super();
			
			_canvas  = _container = new Sprite();
			
			_manager =_pool.get(EntityManager) as EntityManager;
			
			if (!_manager) {
				_manager = new EntityManager();
				_pool.allocate(EntityManager, 1);
			}
			
			_manager.init(false);
			_manager.addEventListener(EntityManager.EXPIRED, expiredEventHandler);
			
			_framesPerParticle = 0;
		};
		
		override public function get reflection():Class {
			return ParticlesEmitter;
		};
		
		override public function update():void {
			if (particlesExpire) {
				particlesExpire.update();
			}
			
			_position.x += _velocity.x;
			_position.y += _velocity.y;
			
			_manager.update();
			
			if (emissionRate >= 1) {
				createParticles(emissionRate);
			} else {
				if (emissionRate < 1) {
					_framesPerParticle += emissionRate;
					
					if (_framesPerParticle > 1) {
						createParticles(1);
						
						_framesPerParticle = 0;
					}
				}
			}
		};
		
		override public function poolPrepare():void {
			super.poolPrepare();
			
			_framesPerParticle = 0;
		};
		
		override public function dispose():void {
			super.dispose();
			
			_pool.put(_manager);
			
			_container.dispose();
			_container = null;
		};
		
		private function createParticles(pNumParticles:uint):void {
			for (var i:int = 0; i < pNumParticles; i++) {
				var particle:Particle = _pool.get(ParticleClass) as Particle;
				
				if (!particle) {
					particle = new ParticleClass();
					_pool.allocate(ParticleClass, 1);
				}
				
					particle.orientation = Random.variation(0, 180);
					
					particle.initScale   = Random.variation(particleScale,
															particleScaleVariation);
					
					particle.scale = particle.initScale;
					
					particle.initLife = Random.variation(particleLife,
														 particleLifeVariation);
					
					particle.growTime   = particleGrowRatio   * particle.initLife;
					particle.shrinkTime = particleShrinkRatio * particle.initLife;
					
					particle.velocity.fromAngle(Random.variation(direction, 
																 directionVariation), 
												Random.variation(particleSpeed, 
																 particleSpeedVariation));
					
					particle.omega = Random.variation(0.0, particleOmegaVariation);
					particle.life  = particle.initLife;
					
					particlesPosition.setUpParticle(particle);
				
				_container.addChild(particle.canvas);
				
				_manager.add(particle);
			}
		};
		
		private function expiredEventHandler(pEvent:Event):void {
			if (!pEvent.data || !_container) {
				return;
			}
			
			_container.removeChild(pEvent.data.canvas);
		};
	};
}