package com.thenitro.ngine.particles.abstract.emitters.expire {
	import npooling.IReusable;
	
	public class ParticlesExpire implements IReusable {
		
		public function ParticlesExpire() {
			
		};
		
		public function get reflection():Class {
			return ParticlesExpire;
		};
		
		public function update(pElapsed:Number):void {
			
		};
		
		public function poolPrepare():void {
			
		};
		
		public function dispose():void {
			
		};
	}
}