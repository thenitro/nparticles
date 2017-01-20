package com.thenitro.ngine.particles.abstract.loader {
	import com.thenitro.ngine.particles.abstract.emitters.ParticlesEmitter;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	
	import starling.events.EventDispatcher;
	
	public final class EmitterParametersLoader extends EventDispatcher {
		
		public function EmitterParametersLoader() {
			super();
		};
		
		public function loadBytes(pBytes:ByteArray, pTarget:ParticlesEmitter, 
								  pScaleFactor:Number = 1.0):void {
			pBytes.uncompress();

			pBytes.position = 0;
			
			if (pBytes.readUTF() != "npt") {
				return;
			}
			
			if (pBytes.readUTF() != ParticlesEmitter.VERSION) {
				throw new IllegalOperationError("EmitterParametersLoader.loadBytes: invalid version!");
				return;
			}
			
			pTarget.emissionRate  = pBytes.readDouble() * pScaleFactor;
			pTarget.emissionRateVariation = pBytes.readDouble() * pScaleFactor;
			
			pTarget.emissionDelay = pBytes.readDouble();
			pTarget.emissionTime  = pBytes.readDouble();
			
			pTarget.particleLife = pBytes.readDouble();
			pTarget.particleLifeVariation = pBytes.readDouble();
			
			pTarget.particleScale = pBytes.readDouble() * pScaleFactor;
			pTarget.particleScaleVariation = pBytes.readDouble() * pScaleFactor;
			
			pTarget.particleGrowRatio = pBytes.readDouble();
			pTarget.particleShrinkRatio = pBytes.readDouble();
			
			pTarget.particleAlpha = pBytes.readDouble();
			pTarget.particleAlphaVariation = pBytes.readDouble();
			
			pTarget.particleAlphaGrowRatio = pBytes.readDouble();
			pTarget.particleAlphaShrinkRatio = pBytes.readDouble();
			
			pTarget.particleSpeed = pBytes.readDouble() * pScaleFactor;
			pTarget.particleSpeedVariation = pBytes.readDouble() * pScaleFactor;
			
			pTarget.particleOmegaVariationMax = pBytes.readDouble() * pScaleFactor;
			
			pTarget.direction = pBytes.readDouble();
			pTarget.directionVariation = pBytes.readDouble();
			
			pTarget.blendMode = pBytes.readUTF();				
		};
	};
}