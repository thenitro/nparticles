package com.thenitro.ngine.particles.abstract.emitters.expire {
	import com.thenitro.ngine.pool.IReusable;
	
	public class ParticlesExpire implements IReusable {
		
		public function ParticlesExpire() {
			
		};
		
		public function get reflection():Class {
			return ParticlesExpire;
		};
		
		public function update():void {
			
		};
		
		public function poolPrepare():void {
			
		};
		
		public function dispose():void {
			
		};
	}
}