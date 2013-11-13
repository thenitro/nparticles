package nparticles.editor {
	import com.thenitro.ngine.particles.abstract.emitters.ParticlesEmitter;
	import com.thenitro.ngine.particles.abstract.emitters.position.RectangleParticles;
	import com.thenitro.ngine.particles.abstract.particles.QuadParticle;
	
	import feathers.controls.Label;
	import feathers.controls.NumericStepper;
	import feathers.controls.ScrollContainer;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.themes.MinimalMobileTheme;
	
	import ngine.math.Random;
	import ngine.math.vectors.Vector2D;
	
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	public final class Editor extends Sprite {
		private var _emitter:ParticlesEmitter;
		private var _container:ScrollContainer;
		
		public function Editor() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
		};
		
		private function addedToStageEventHandler(pEvent:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
			
			new MinimalMobileTheme();
			
			createParticles();
			createGUI();
			
			addEventListener(Event.ENTER_FRAME, enterFrameEventHandler);
		};
		
		private function enterFrameEventHandler(pEvent:EnterFrameEvent):void {
			_emitter.update(pEvent.passedTime);
		};
		
		private function createParticles():void {
			_emitter = new ParticlesEmitter();
			
			_emitter.position.x = stage.stageWidth / 2;
			_emitter.position.y = stage.stageHeight / 2;
			
			_emitter.emissionRate = 1.0;
			
			_emitter.particleLife = 8.0;
			_emitter.particleLifeVariation = 1.0;
			
			_emitter.particleScale = 0.5;
			_emitter.particleScaleVariation = 0.3;
			
			_emitter.particleGrowRatio   = 0.3;
			_emitter.particleShrinkRatio = 0.5;
			
			_emitter.particleSpeed = -75;
			_emitter.particleSpeedVariation = 25;
			
			_emitter.particleOmegaVariation = Math.PI / 128;
			
			_emitter.direction = Math.PI / 2;
			_emitter.directionVariation = Math.PI / 8;
			
			_emitter.ParticleClass = QuadParticle;
			
			_emitter.particleData = Random.color;
			
			var position:RectangleParticles = new RectangleParticles();
				position.init(_emitter, new Vector2D(20, 20));
			
			_emitter.particlesPosition = position;
			
			addChild(_emitter.canvas);
		};
		
		private function createGUI():void {
			createContainer();
			
			createStepper("Emission rate",  1.0, 0.05, emissionRateChangeEventHandler);
			
			createStepper("Particle life",  8.0, 0.1, particleLifeChangeEventHandler);
			createStepper("Life variation", 4.0, 0.1, particleLifeVariationChangeEventHandler);
			
			createStepper("Particle scale",  1.0, 0.05, particleScaleChangeEventHandler);
			createStepper("Scale variation", 0.2, 0.01, particleScaleVariationChangeEventHandler);
			
			createStepper("Pt Grow ratio",   0.3, 0.05, particleGrowRatioChangeEventHandler);
			createStepper("Pt Shrink ratio", 0.5, 0.05, particleShrinkRatioChangeEventHandler);
			
			createStepper("Particle speed",  -75, 1, particleSpeedChangeEventHandler);
			createStepper("Speed variation", 25, 1, particleSpeedVariationChangeEventHandler);
			
			createStepper("Pt Omega variation", Math.PI / 128, Math.PI / 512, particleOmegaVariationChangeEventHandler);
			
			createStepper("Particle direction", Math.PI / 2, Math.PI / 32, particleDirectionChangeEventHandler);
			createStepper("Direction variation", Math.PI / 8, Math.PI / 32, particleDirectionVariationChangeEventHandler);
			
			createStepper("Emitter pos X", stage.stageWidth  / 2, 10, positionXChangeEventHandler);
			createStepper("Emitter pos Y", stage.stageHeight / 2, 10, positionYChangeEventHandler);
			
			createStepper("Emitter width", 20, 1, emitterWidthChangeEventHandler);
			createStepper("Emitter height", 20, 1, emitterHeightChangeEventHandler);
		};
		
		private function createContainer():void {
			_container = new ScrollContainer();
			
			_container.x = stage.stageWidth - 100;
			
			_container.width  = 100;
			_container.height = stage.stageHeight;
			
			_container.layout = new VerticalLayout();
			
			_container.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			
			addChild(_container);
		};
		
		private function createStepper(pLabel:String, pInitValue:Number, 
									   pStep:Number, pCallback:Function):void {
			var label:Label = new Label();
				label.text  = pLabel;
			
			_container.addChild(label);
			
			var stepper:NumericStepper = new NumericStepper();
			 	
				stepper.width  = 100;
				stepper.height =  20;
				
				stepper.minimum = -Number.MAX_VALUE;
				stepper.maximum =  Number.MAX_VALUE;
				
				stepper.value = pInitValue;
				
				stepper.step = pStep;
				
				stepper.addEventListener(Event.CHANGE, pCallback);
				
			
			_container.addChild(stepper);
		};
		
		private function emissionRateChangeEventHandler(pEvent:Event):void {
			_emitter.emissionRate = (pEvent.target as NumericStepper).value;
		};
		
		private function particleLifeChangeEventHandler(pEvent:Event):void {
			_emitter.particleLife = (pEvent.target as NumericStepper).value;
		};
		
		private function particleLifeVariationChangeEventHandler(pEvent:Event):void {
			_emitter.particleLifeVariation = (pEvent.target as NumericStepper).value;
		};
		
		private function particleScaleChangeEventHandler(pEvent:Event):void {
			_emitter.particleScale = (pEvent.target as NumericStepper).value;
		};
		
		private function particleScaleVariationChangeEventHandler(pEvent:Event):void {
			_emitter.particleScaleVariation = (pEvent.target as NumericStepper).value;
		};
		
		private function particleGrowRatioChangeEventHandler(pEvent:Event):void {
			_emitter.particleGrowRatio = (pEvent.target as NumericStepper).value;
		};
		
		private function particleShrinkRatioChangeEventHandler(pEvent:Event):void {
			_emitter.particleShrinkRatio = (pEvent.target as NumericStepper).value;
		};
		
		private function particleSpeedChangeEventHandler(pEvent:Event):void {
			_emitter.particleSpeed = (pEvent.target as NumericStepper).value;
		};
		
		private function particleSpeedVariationChangeEventHandler(pEvent:Event):void {
			_emitter.particleSpeedVariation = (pEvent.target as NumericStepper).value;
		};
		
		private function particleOmegaVariationChangeEventHandler(pEvent:Event):void {
			_emitter.particleOmegaVariation = (pEvent.target as NumericStepper).value;
		};
		
		private function particleDirectionChangeEventHandler(pEvent:Event):void {
			_emitter.direction = (pEvent.target as NumericStepper).value;
		};
		
		private function particleDirectionVariationChangeEventHandler(pEvent:Event):void {
			_emitter.directionVariation = (pEvent.target as NumericStepper).value;
		};
		
		private function positionXChangeEventHandler(pEvent:Event):void {
			_emitter.position.x = (pEvent.target as NumericStepper).value;
		};
		
		private function positionYChangeEventHandler(pEvent:Event):void {
			_emitter.position.y = (pEvent.target as NumericStepper).value;
		};
		
		private function emitterWidthChangeEventHandler(pEvent:Event):void {
			(_emitter.particlesPosition as RectangleParticles).dimension.x = (pEvent.target as NumericStepper).value;
		};
		
		private function emitterHeightChangeEventHandler(pEvent:Event):void {
			(_emitter.particlesPosition as RectangleParticles).dimension.y = (pEvent.target as NumericStepper).value;
		};
	};
}