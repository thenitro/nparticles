package com.thenitro.ngine.particles.abstract.emitters.expire {
	import npooling.IReusable;
	import npooling.Pool;
	
	public class ParticlesExpire implements IReusable {
		protected static var _pool:Pool = Pool.getInstance();
		
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