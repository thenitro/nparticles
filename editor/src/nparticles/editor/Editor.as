package nparticles.editor {
	import com.thenitro.ngine.particles.abstract.emitters.ParticlesEmitter;
	import com.thenitro.ngine.particles.abstract.emitters.position.RectangleParticles;
	import com.thenitro.ngine.particles.abstract.particles.ImageParticle;
	import com.thenitro.ngine.particles.abstract.particles.QuadParticle;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.NumericStepper;
	import feathers.controls.PickerList;
	import feathers.controls.ScrollContainer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.themes.AeonDesktopTheme;
	import feathers.themes.MinimalMobileTheme;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import ngine.math.Geometry;
	import ngine.math.Random;
	import ngine.math.vectors.Vector2D;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public final class Editor extends Sprite {
		private var _emitter:ParticlesEmitter;
		
		private var _file:ScrollContainer;
		private var _parameters:ScrollContainer;
		
		private var _background:Sprite;
		
		public function Editor() {
			super();
			addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageEventHandler);
		};
		
		private function addedToStageEventHandler(pEvent:starling.events.Event):void {
			removeEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageEventHandler);
			
			new AeonDesktopTheme();
			
			createGUI();
			createParticles();
			
			addEventListener(starling.events.Event.ENTER_FRAME, enterFrameEventHandler);
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
			
			_emitter.blendMode = BlendMode.AUTO;
			
			var position:RectangleParticles = new RectangleParticles();
				position.init(_emitter, new Vector2D(20, 20));
			
			_emitter.particlesPosition = position;
			
			addChild(_emitter.canvas);
		};
		
		private function createGUI():void {
			createBackground();
			
			createFileContainer();
			createParametersContainer();
			
			createButton("Background", backgroundButtonTriggeredEventHandler);
			createButton("Particle",   particleButtonTriggeredEventHandler);
			createButton("Save", 	   saveButtonTriggeredEventHandler);
			createButton("Load", 	   loadButtonTriggeredEventHandler);
			
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
			
			var list:PickerList = new PickerList();
			
				list.width  = 100;
				list.height = 20;
				
				list.dataProvider = new ListCollection( [ { text: BlendMode.AUTO }, 
														  { text: BlendMode.ADD },
														  { text: BlendMode.ERASE },
														  { text: BlendMode.MULTIPLY },
														  { text: BlendMode.NONE },
														  { text: BlendMode.NORMAL },
														  { text: BlendMode.SCREEN } ] );
				
				list.listProperties.@itemRendererProperties.labelField = "text";
				
				list.labelField    = "text";
				list.selectedIndex = 0;
				
				list.addEventListener(starling.events.Event.CHANGE, 
									  blendModeTriggeredEventHandler);
				
			_parameters.addChild(list);
		};
		
		private function createBackground():void {
			_background = new Sprite();
			
			addChild(_background);
		};
		
		private function createParametersContainer():void {
			_parameters = new ScrollContainer();
			
			_parameters.x = stage.stageWidth - 100;
			
			_parameters.width  = 100;
			_parameters.height = stage.stageHeight;
			
			_parameters.layout = new VerticalLayout();
			
			_parameters.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			
			addChild(_parameters);
		};
		
		private function createFileContainer():void {
			_file = new ScrollContainer();
			
			_file.y = stage.stageHeight - 20;
			
			_file.width  = stage.stageWidth;
			_file.height = 20;
			
			_file.layout = new HorizontalLayout();
			
			_file.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			
			addChild(_file);
		};
		
		private function createButton(pLabel:String, pCallback:Function):void {
			var button:Button = new Button();
				
				button.width  = 100;
				button.height =  20;
			
				button.label  = pLabel;
				
				button.addEventListener(starling.events.Event.TRIGGERED, pCallback);
			
			_file.addChild(button);
		};
		
		private function createStepper(pLabel:String, pInitValue:Number, 
									   pStep:Number, pCallback:Function):void {
			var label:Label = new Label();
				label.text  = pLabel;
			
			_parameters.addChild(label);
			
			var stepper:NumericStepper = new NumericStepper();
			 	
				stepper.width  = 100;
				stepper.height =  20;
				
				stepper.minimum = -Number.MAX_VALUE;
				stepper.maximum =  Number.MAX_VALUE;
				
				stepper.value = pInitValue;
				
				stepper.step = pStep;
				
				stepper.addEventListener(starling.events.Event.CHANGE, pCallback);
				
			_parameters.addChild(stepper);
		};
		
		private function emissionRateChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.emissionRate = (pEvent.target as NumericStepper).value;
		};
		
		private function particleLifeChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.particleLife = (pEvent.target as NumericStepper).value;
		};
		
		private function particleLifeVariationChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.particleLifeVariation = (pEvent.target as NumericStepper).value;
		};
		
		private function particleScaleChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.particleScale = (pEvent.target as NumericStepper).value;
		};
		
		private function particleScaleVariationChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.particleScaleVariation = (pEvent.target as NumericStepper).value;
		};
		
		private function particleGrowRatioChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.particleGrowRatio = (pEvent.target as NumericStepper).value;
		};
		
		private function particleShrinkRatioChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.particleShrinkRatio = (pEvent.target as NumericStepper).value;
		};
		
		private function particleSpeedChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.particleSpeed = (pEvent.target as NumericStepper).value;
		};
		
		private function particleSpeedVariationChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.particleSpeedVariation = (pEvent.target as NumericStepper).value;
		};
		
		private function particleOmegaVariationChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.particleOmegaVariation = (pEvent.target as NumericStepper).value;
		};
		
		private function particleDirectionChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.direction = (pEvent.target as NumericStepper).value;
		};
		
		private function particleDirectionVariationChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.directionVariation = (pEvent.target as NumericStepper).value;
		};
		
		private function positionXChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.position.x = (pEvent.target as NumericStepper).value;
		};
		
		private function positionYChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.position.y = (pEvent.target as NumericStepper).value;
		};
		
		private function emitterWidthChangeEventHandler(pEvent:starling.events.Event):void {
			(_emitter.particlesPosition as RectangleParticles).dimension.x = (pEvent.target as NumericStepper).value;
		};
		
		private function emitterHeightChangeEventHandler(pEvent:starling.events.Event):void {
			(_emitter.particlesPosition as RectangleParticles).dimension.y = (pEvent.target as NumericStepper).value;
		};
		
		private function blendModeTriggeredEventHandler(pEvent:starling.events.Event):void {
			var target:PickerList = pEvent.target as PickerList;
			
			_emitter.blendMode = target.selectedItem.text;
		};
		
		private function backgroundButtonTriggeredEventHandler(pEvent:starling.events.Event):void {
			var filter:FileFilter   = new FileFilter("Images", "*.jpg;*.jpeg;*.gif;*.png;");
			
			var file:FileReference = new FileReference();
				file.addEventListener(flash.events.Event.SELECT, function(pEvent:flash.events.Event):void {
					file.load();
				});
				file.addEventListener(flash.events.Event.COMPLETE, function(pEvent:flash.events.Event):void {
					var loader:Loader = new Loader();
						loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function(pEvent:flash.events.Event):void {
							var bitmap:Bitmap = pEvent.currentTarget.loader.content as Bitmap;
							var image:Image   = new Image(Texture.fromBitmap(bitmap, false));
							
							Geometry.resizeDisplayObject(image, stage.stageWidth, stage.stageHeight, Geometry.determineMinScale);
							
							image.x = (stage.stageWidth  - image.width)  / 2;
							image.y = (stage.stageHeight - image.height) / 2;
							
							_background.removeChildren(0, -1, true);
							_background.addChild(image);
						});
						
						loader.loadBytes(file.data);
				});
				
				file.browse( [ filter ] );
		};
		
		private function particleButtonTriggeredEventHandler(pEvent:starling.events.Event):void {
			var filter:FileFilter   = new FileFilter("Images", "*.jpg;*.jpeg;*.gif;*.png;");
			
			var file:FileReference = new FileReference();
				file.addEventListener(flash.events.Event.SELECT, function(pEvent:flash.events.Event):void {
					file.load();
				});
				file.addEventListener(flash.events.Event.COMPLETE, function(pEvent:flash.events.Event):void {
					var loader:Loader = new Loader();
						loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function(pEvent:flash.events.Event):void {
							var bitmap:Bitmap = pEvent.currentTarget.loader.content as Bitmap;
							
							_emitter.ParticleClass = ImageParticle;
							_emitter.particleData  = Texture.fromBitmap(bitmap);
						});
					
					loader.loadBytes(file.data);
				});
			
			file.browse( [ filter ] );
		};
		
		private function saveButtonTriggeredEventHandler(pEvent:starling.events.Event):void {
			
		};
		
		private function loadButtonTriggeredEventHandler(pEvent:starling.events.Event):void {
			
		};
	};
}