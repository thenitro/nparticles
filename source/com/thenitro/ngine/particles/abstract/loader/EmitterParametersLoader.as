package com.thenitro.ngine.particles.abstract.loader {
	import com.thenitro.ngine.particles.abstract.emitters.ParticlesEmitter;
	
	import flash.utils.ByteArray;
	
	import starling.events.EventDispatcher;
	
	public final class EmitterParametersLoader extends EventDispatcher {
		
		public function EmitterParametersLoader() {
			super();
		};
		
		public function loadBytes(pBytes:ByteArray, pTarget:ParticlesEmitter):void {
			pBytes.uncompress();
				
			pBytes.position = 0;
			
			if (pBytes.readUTF() != "npt") {
				return;
			}
			
			if (pBytes.readUTF() != ParticlesEmitter.VERSION) {
				return;
			}
			
			pTarget.emissionRate = pBytes.readDouble();
			pTarget.emissionTime = pBytes.readDouble();
			
			pTarget.particleLife = pBytes.readDouble();
			pTarget.particleLifeVariation = pBytes.readDouble();
			
			pTarget.particleScale = pBytes.readDouble();
			pTarget.particleScaleVariation = pBytes.readDouble();
			
			pTarget.particleGrowRatio = pBytes.readDouble();
			pTarget.particleShrinkRatio = pBytes.readDouble();
			
			pTarget.particleSpeed = pBytes.readDouble();
			pTarget.particleSpeedVariation = pBytes.readDouble();
			
			pTarget.particleOmegaVariation = pBytes.readDouble();
			
			pTarget.direction = pBytes.readDouble();
			pTarget.directionVariation = pBytes.readDouble();
			
			pTarget.blendMode = pBytes.readUTF();				
		};
	};
}