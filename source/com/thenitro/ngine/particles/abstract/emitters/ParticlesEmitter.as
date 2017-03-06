package com.thenitro.ngine.particles.abstract.emitters {
    import com.thenitro.ngine.particles.abstract.emitters.expire.ParticlesExpire;
    import com.thenitro.ngine.particles.abstract.emitters.position.ParticlesPosition;
    import com.thenitro.ngine.particles.abstract.particles.Particle;

    import ngine.core.Entity;
    import ngine.core.manager.EntityManager;

    import nmath.Random;

    import npooling.IReusable;

    import starling.display.BlendMode;
    import starling.display.Sprite;
    import starling.events.Event;

    public class ParticlesEmitter extends Entity implements IReusable {
		public static const VERSION:String = '1.0.5';
		
		public var emissionRate:Number;
		public var emissionRateVariation:Number = 0.0;
		
		public var emissionDelay:Number;
		
		public var particleLife:Number;
		public var particleLifeVariation:Number;
		
		public var particleScale:Number;
		public var particleScaleVariation:Number;
		
		public var particleGrowRatio:Number;
		public var particleShrinkRatio:Number;
		
		public var particleAlpha:Number = 1.0;
		public var particleAlphaVariation:Number = 0.0;
		
		public var particleAlphaGrowRatio:Number;
		public var particleAlphaShrinkRatio:Number;
		
		public var particleSpeed:Number;
		public var particleSpeedVariation:Number;
		
		public var particleOmegaVariationMin:Number = 0.0;
		public var particleOmegaVariationMax:Number;

		public var direction:Number;
		public var directionVariation:Number;
		
		public var ParticleClass:Class;
		
		public var particlesPosition:ParticlesPosition;
		public var particlesExpire:ParticlesExpire;
		
		public var particleData:*;
		
		public var blendMode:String = BlendMode.AUTO;
		
		private var _emissionTime:Number;
		
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
			
			_manager.addEventListener(EntityManager.ADDED,   adddedEventHandler);
			_manager.addEventListener(EntityManager.EXPIRED, expiredEventHandler);
			
			_framesPerParticle = 0;
		};
		
		public static function get NEW():ParticlesEmitter {
			var results:ParticlesEmitter = 
				_pool.get(ParticlesEmitter) as ParticlesEmitter;
			
			if (!results) {
				results = new ParticlesEmitter();
				_pool.allocate(ParticlesEmitter, 1);
			}
			
			return results;
		};
		
		override public function get reflection():Class {
			return ParticlesEmitter;
		};
        
        public function get manager():EntityManager {
            return _manager;
        };
		
		public function get emissionTime():Number {
			return _emissionTime;
		};

		public function set emissionTime(pValue:Number):void {
			if (pValue < 0) {
				_emissionTime = Number.MAX_VALUE;
			} else {
				_emissionTime = pValue;
			}
		};

		public function set expired(pValue:Boolean):void {
			_expired = pValue;
		};
		
		[Inline]
        public function get numParticles():int {
			return _manager.entities.count;
		};

		override public function update(pElapsed:Number):void {
			if (particlesExpire) {
				particlesExpire.update(pElapsed);
			}
			
			_position.x += _velocity.x;
			_position.y += _velocity.y;
			
			_manager.update(pElapsed);
			
			emissionDelay -= pElapsed;
			
			if (emissionDelay > 0) {
				return;
			}
			
			_emissionTime -= pElapsed;
			
			if (_emissionTime <= 0) {
				return;
			}
			
			generateNewParticles();
		};
		
		override public function poolPrepare():void {
			super.poolPrepare();
			clean();
			
			_framesPerParticle = 0;
			
			_pool.put(particlesPosition);
			_pool.put(particlesExpire);
			
			particlesPosition = null;
			particlesExpire   = null;
		};
		
		override public function dispose():void {
			super.dispose();
			
			_pool.put(_manager);
			
			_container.dispose();
			_container = null;
			
			_pool.put(particlesPosition);
			_pool.put(particlesExpire);
			
			particlesPosition = null;
			particlesExpire   = null;
		};
		
		public function prewarm(pTime:Number, pFPS:Number):void {		
			if (pTime == 0) {
				return;
			}
			
			var iterations:Number = pTime * pFPS;
			
			for (var i:int = 0; i < iterations; i++) {
				generateNewParticles();
				
				_manager.update(pTime / pFPS);
			}
		};
		
		public function clean():void {
			_manager.clean();
		};

		[Inline]
		private function generateNewParticles():void {
			var random:Number = Math.max(0, Random.variation(emissionRate, emissionRateVariation));

			if (emissionRate >= 1) {
				createParticles(random);
			} else {
				if (emissionRate < 1) {
					_framesPerParticle += random;
					
					if (_framesPerParticle > 1) {
						createParticles(1);
						
						_framesPerParticle = 0;
					}
				}
			}
		};

		[Inline]
		private function createParticles(pNumParticles:uint):void {
			for (var i:int = 0; i < pNumParticles; i++) {
				var particle:Particle = _pool.get(ParticleClass) as Particle;
				
				if (!particle) {
					particle = new ParticleClass();
					_pool.allocate(ParticleClass, 1);
				}
					
					particle.initScale = Random.variation(particleScale,
										     			  particleScaleVariation);
					
					particle.scale = particle.initScale;
					
					particle.growTime   = particleGrowRatio   * particle.initLife;
					particle.shrinkTime = particleShrinkRatio * particle.initLife;
					
					particle.initAlpha = Random.variation(particleAlpha,
										     			  particleAlphaVariation);
					
					particle.alpha = particle.initAlpha;
					
					
					particle.initLife = Random.variation(particleLife,
														 particleLifeVariation);
					
					particle.alphaGrowTime   = particleAlphaGrowRatio   * particle.initLife;
					particle.alphaShrinkTime = particleAlphaShrinkRatio * particle.initLife;
					
					particle.velocity.fromAngle(Random.variation(direction, 
																 directionVariation),
												Random.variation(particleSpeed, 
																 particleSpeedVariation));
					
					particle.omega = Random.variation(particleOmegaVariationMin, particleOmegaVariationMax);
					particle.life  = particle.initLife;
					
					particle.draw(particleData);
					
					particle.canvas.blendMode = blendMode;
					
					particlesPosition.setUpParticle(particle);
					
					particle.update(0);
				
				_manager.add(particle);
			}
		};
		
		private function adddedEventHandler(pEvent:Event):void {
			var particle:Particle = pEvent.data as Particle;
			
			if (!particle || particle.expired) {
				return;
			}

            if (!_container) {
                return;
            }
			
			_container.addChild(particle.canvas);
		};
		
		private function expiredEventHandler(pEvent:Event):void {
			if (!pEvent.data || !_container) {
				return;
			}
			
			_container.removeChild(pEvent.data.canvas);
			
			if (numParticles < 1) {
				expire();
			}
		};
	};
}