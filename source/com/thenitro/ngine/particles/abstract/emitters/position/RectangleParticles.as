package com.thenitro.ngine.particles.abstract.emitters.position {
	import com.thenitro.ngine.math.Random;
	import com.thenitro.ngine.math.TRectangle;
	import com.thenitro.ngine.math.vectors.Vector2D;
	import com.thenitro.ngine.particles.abstract.Particle;
	import com.thenitro.ngine.particles.abstract.emitters.ParticlesEmitter;
	
	public final class RectangleParticles extends ParticlesPosition {
		private var _emitter:ParticlesEmitter;
		private var _dimension:Vector2D;
		
		public function RectangleParticles() {
			super();
		};
		
		public function init(pEmitter:ParticlesEmitter, pDimension:Vector2D):void {
			_emitter   = pEmitter;
			_dimension = pDimension;
		};
		
		override public function get reflection():Class {
			return RectangleParticles;
		};
		
		override public function setUpParticle(pParticle:Particle):void {
			pParticle.position.x = Random.range(_emitter.position.x, _dimension.x);
			pParticle.position.y = Random.range(_emitter.position.y, _dimension.y);
		};
		
		override public function poolPrepare():void {
			super.poolPrepare();
			
			_emitter = null;
			
			_pool.put(_dimension);
			_dimension = null;
		};
		
		override public function dispose():void {
			super.dispose();
			
			_emitter = null;
			
			_pool.put(_dimension);
			_dimension = null;
		};
	};
}