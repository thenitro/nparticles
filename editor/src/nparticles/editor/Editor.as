package nparticles.editor {
    import com.thenitro.ngine.particles.abstract.emitters.ParticlesEmitter;
    import com.thenitro.ngine.particles.abstract.emitters.position.RectangleParticles;
    import com.thenitro.ngine.particles.abstract.loader.EmitterParametersLoader;
    import com.thenitro.ngine.particles.abstract.particles.ImageParticle;
    import com.thenitro.ngine.particles.abstract.particles.QuadParticle;

    import feathers.controls.Button;
    import feathers.controls.Label;
    import feathers.controls.NumericStepper;
    import feathers.controls.PickerList;
    import feathers.controls.ScrollContainer;
    import feathers.data.ListCollection;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;
    import feathers.themes.MinimalDesktopTheme;

    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.utils.ByteArray;
    import flash.utils.getTimer;

    import nmath.Random;
    import nmath.vectors.Vector2D;

    import starling.display.BlendMode;
    import starling.display.Image;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    import starling.utils.deg2rad;
    import starling.utils.rad2deg;

    public final class Editor extends Sprite {
		private var _emitter:ParticlesEmitter;
		
		private var _file:ScrollContainer;
		private var _parameters:ScrollContainer;
		
		private var _background:Sprite;
		
		private var _prewarm:NumericStepper;
		
		private var _emissionRate:NumericStepper;
		private var _emissionRateVariation:NumericStepper;
		
		private var _emissionDelay:NumericStepper;
		private var _emissionTime:NumericStepper;
		
		private var _particleLife:NumericStepper;
		private var _particleLifeVariation:NumericStepper;
		
		private var _particleScale:NumericStepper;
		private var _particleScaleVariation:NumericStepper;
		
		private var _particleGrowRatio:NumericStepper;
		private var _particleShrinkRatio:NumericStepper;
		
		private var _particleAlpha:NumericStepper;
		private var _particleAlphaVariation:NumericStepper;
		
		private var _particleAlphaGrowRatio:NumericStepper;
		private var _particleAlphaShrinkRatio:NumericStepper;
		
		private var _particleSpeed:NumericStepper;
		private var _particleSpeedVariation:NumericStepper;
		
		private var _particleOmegaVariation:NumericStepper;
		
		private var _direction:NumericStepper;
		private var _directionVariation:NumericStepper;
		
		private var _blendMode:PickerList;
		
		private var _isDown:Boolean;
		private var _downTime:int;
		
		public function Editor() {
			super();
			addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageEventHandler);
		};
		
		private function addedToStageEventHandler(pEvent:starling.events.Event):void {
			removeEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageEventHandler);
			
			new MinimalDesktopTheme();
			
			createBackground();
			createWorkingZone();
			createParticles();
			createGUI();
			
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
			_emitter.emissionRateVariation = 0.5;
			
			_emitter.emissionDelay =   0.0;
			_emitter.emissionTime  = 100.0;
			
			_emitter.particleLife = 8.0;
			_emitter.particleLifeVariation = 1.0;
			
			_emitter.particleScale = 0.5;
			_emitter.particleScaleVariation = 0.3;
			
			_emitter.particleGrowRatio   = 0.3;
			_emitter.particleShrinkRatio = 0.5;
			
			_emitter.particleAlpha = 0.5;
			_emitter.particleAlphaVariation = 0.3;
			
			_emitter.particleAlphaGrowRatio   = 0.3;
			_emitter.particleAlphaShrinkRatio = 0.5;
			
			_emitter.particleSpeed = -75;
			_emitter.particleSpeedVariation = 25;
			
			_emitter.particleOmegaVariation = Math.PI / 128;
			
			_emitter.direction = Math.PI / 2;
			_emitter.directionVariation = Math.PI / 8;
			
			_emitter.ParticleClass = QuadParticle;
			
			_emitter.particleData = Math.random() * 0xFFFFFF;
			
			_emitter.blendMode = BlendMode.AUTO;
			
			var position:RectangleParticles = new RectangleParticles();
				position.init(_emitter, new Vector2D(20, 20));
			
			_emitter.particlesPosition = position;
			
			addChild(_emitter.canvas);
			
			_emitter.prewarm(1.0, 60);
		};
		
		private function createGUI():void {
			createFileContainer();
			createParametersContainer();
			
			createButton("Background", backgroundButtonTriggeredEventHandler);
			createButton("Particle",   particleButtonTriggeredEventHandler);
			createButton("Save", 	   saveButtonTriggeredEventHandler);
			createButton("Load", 	   loadButtonTriggeredEventHandler);
			
			_prewarm = createStepper("Prewarm", 1.0, 0.05, emissionPrewarmChangeEventHandler);
			
			_emissionRate 		   = createStepper("Emission rate",  _emitter.emissionRate, 0.05, emissionRateChangeEventHandler);
			_emissionRateVariation = createStepper("Rate variation", _emitter.emissionRateVariation, 0.05, emissionRateVariationChangeEventHandler);
			
			_emissionDelay = createStepper("Emission delay", _emitter.emissionDelay, 0.05, emissionDelayChangeEventHandler);
			_emissionTime  = createStepper("Emission time",  _emitter.emissionTime, 0.05, emissionTimeChangeEventHandler);
			
			_particleLife = createStepper("Particle life", _emitter.particleLife, 0.1, particleLifeChangeEventHandler);
			_particleLifeVariation = createStepper("Life variation", _emitter.particleLifeVariation, 0.1, particleLifeVariationChangeEventHandler);
			
			_particleScale = createStepper("Particle scale",  _emitter.particleScale, 0.05, particleScaleChangeEventHandler);
			_particleScaleVariation = createStepper("Scale variation", _emitter.particleScaleVariation, 0.01, particleScaleVariationChangeEventHandler);
			
			_particleGrowRatio = createStepper("Pt Grow ratio",   _emitter.particleGrowRatio, 0.05, particleGrowRatioChangeEventHandler);
			_particleShrinkRatio = createStepper("Pt Shrink ratio", _emitter.particleShrinkRatio, 0.05, particleShrinkRatioChangeEventHandler);
			
			_particleAlpha = createStepper("Particle alpha",  _emitter.particleAlpha, 0.05, particleAlphaChangeEventHandler);
			_particleAlphaVariation = createStepper("Alpha variation", _emitter.particleAlphaVariation, 0.01, particleAlphaVariationChangeEventHandler);
			
			_particleAlphaGrowRatio = createStepper("Pt Alpha Grow",   _emitter.particleAlphaGrowRatio, 0.05, particleAlphaGrowRatioChangeEventHandler);
			_particleAlphaShrinkRatio = createStepper("Pt Alpha Shrink", _emitter.particleAlphaShrinkRatio, 0.05, particleAlphaShrinkRatioChangeEventHandler);
			
			_particleSpeed = createStepper("Particle speed",  _emitter.particleSpeed, 1, particleSpeedChangeEventHandler);
			_particleSpeedVariation = createStepper("Speed variation", _emitter.particleSpeedVariation, 1, particleSpeedVariationChangeEventHandler);
			
			_particleOmegaVariation = createStepper("Pt Omega variation", rad2deg(_emitter.particleOmegaVariation), 0.1, particleOmegaVariationChangeEventHandler);
			
			_direction = createStepper("Particle direction", rad2deg(_emitter.direction), 1, particleDirectionChangeEventHandler);
			_directionVariation = createStepper("Direction variation", rad2deg(_emitter.directionVariation), 1, particleDirectionVariationChangeEventHandler);
			
			createStepper("Emitter width", 20, 1, emitterWidthChangeEventHandler);
			createStepper("Emitter height", 20, 1, emitterHeightChangeEventHandler);
			
			var label:Label = new Label();
				label.text  = "Blend mode";
			
			_parameters.addChild(label);
			
			_blendMode = new PickerList();
			
			_blendMode.width  = 100;
			_blendMode.height = 20;
				
			_blendMode.dataProvider = new ListCollection( [ { text: BlendMode.AUTO }, 
														  { text: BlendMode.ADD },
														  { text: BlendMode.ERASE },
														  { text: BlendMode.MULTIPLY },
														  { text: BlendMode.NONE },
														  { text: BlendMode.NORMAL },
														  { text: BlendMode.SCREEN } ] );
				
			_blendMode.listProperties.@itemRendererProperties.labelField = "text";
				
			_blendMode.labelField    = "text";
			_blendMode.selectedIndex = 0;
				
			_blendMode.addEventListener(starling.events.Event.CHANGE, 
									  blendModeTriggeredEventHandler);
				
			_parameters.addChild(_blendMode);
		};
		
		private function createBackground():void {
			_background = new Sprite();
			
			addChild(_background);
		};
		
		private function createWorkingZone():void {
			var workingZone:Sprite = new Sprite();
				workingZone.addChild(new Quad(stage.stageWidth - 100, stage.stageHeight - 20, Math.random() * 0xFFFFFF));
				workingZone.alpha = 0;
			
			addChild(workingZone);
			
			workingZone.addEventListener(TouchEvent.TOUCH, touchEventHandler);
		};
		
		private function createParametersContainer():void {
			_parameters = new ScrollContainer();
			
			_parameters.x = stage.stageWidth - 115;
			
			_parameters.width  = 115;
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
									   pStep:Number, pCallback:Function):NumericStepper {
			var label:Label = new Label();
				label.text  = pLabel;
			
			_parameters.addChild(label);
			
			var stepper:NumericStepper = new NumericStepper();
			 	
				stepper.width  = 100;
				stepper.height =  20;
				
				stepper.minimum = -uint.MAX_VALUE;
				stepper.maximum =  uint.MAX_VALUE;
				
				stepper.value = pInitValue;
				
				stepper.step = pStep;
				
				stepper.addEventListener(starling.events.Event.CHANGE, pCallback);
				
			_parameters.addChild(stepper);
			
			return stepper;
		};
		
		private function emissionPrewarmChangeEventHandler(pEvent:starling.events.Event):void {
			
		};
		
		private function emissionRateChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.emissionRate = (pEvent.target as NumericStepper).value;
		};
		
		private function emissionRateVariationChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.emissionRateVariation = (pEvent.target as NumericStepper).value;
		};
		
		private function emissionDelayChangeEventHandler(pEvent:starling.events.Event):void {
			
		};
		
		private function emissionTimeChangeEventHandler(pEvent:starling.events.Event):void {
			
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
		
		private function particleAlphaChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.particleAlpha = (pEvent.target as NumericStepper).value;
		};
		
		private function particleAlphaVariationChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.particleAlphaVariation = (pEvent.target as NumericStepper).value;
		};
		
		private function particleAlphaGrowRatioChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.particleAlphaGrowRatio = (pEvent.target as NumericStepper).value;
		};
		
		private function particleAlphaShrinkRatioChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.particleAlphaShrinkRatio = (pEvent.target as NumericStepper).value;
		};
		
		private function particleSpeedChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.particleSpeed = (pEvent.target as NumericStepper).value;
		};
		
		private function particleSpeedVariationChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.particleSpeedVariation = (pEvent.target as NumericStepper).value;
		};
		
		private function particleOmegaVariationChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.particleOmegaVariation = deg2rad((pEvent.target as NumericStepper).value);
		};
		
		private function particleDirectionChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.direction = deg2rad((pEvent.target as NumericStepper).value);
		};
		
		private function particleDirectionVariationChangeEventHandler(pEvent:starling.events.Event):void {
			_emitter.directionVariation = deg2rad((pEvent.target as NumericStepper).value);
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
			var output:ByteArray = new ByteArray();
				output.writeUTF("npt");
				output.writeUTF(ParticlesEmitter.VERSION);
				
				output.writeDouble(_emitter.emissionRate);
				output.writeDouble(_emitter.emissionRateVariation);
				
				output.writeDouble(_emitter.emissionDelay);
				output.writeDouble(_emitter.emissionTime);
				
				output.writeDouble(_emitter.particleLife);
				output.writeDouble(_emitter.particleLifeVariation);
				
				output.writeDouble(_emitter.particleScale);
				output.writeDouble(_emitter.particleScaleVariation);
				
				output.writeDouble(_emitter.particleGrowRatio);
				output.writeDouble(_emitter.particleShrinkRatio);
				
				output.writeDouble(_emitter.particleAlpha);
				output.writeDouble(_emitter.particleAlphaVariation);
				
				output.writeDouble(_emitter.particleAlphaGrowRatio);
				output.writeDouble(_emitter.particleAlphaShrinkRatio);
				
				output.writeDouble(_emitter.particleSpeed);
				output.writeDouble(_emitter.particleSpeedVariation);
				
				output.writeDouble(_emitter.particleOmegaVariation);
				
				output.writeDouble(_emitter.direction);
				output.writeDouble(_emitter.directionVariation);
				
				output.writeUTF(_emitter.blendMode);
				
				output.compress();
			
			var fileRef:FileReference = new FileReference();
				fileRef.save(output, "my_new_particle.npt");
		};
		
		private function loadButtonTriggeredEventHandler(pEvent:starling.events.Event):void {
			var filter:FileFilter     = new FileFilter("NPT (*.npt)", "*.npt;");
			
			var file:FileReference = new FileReference();
				file.addEventListener(flash.events.Event.SELECT, function(pEvent:flash.events.Event):void {
					file.load();
				});
				file.addEventListener(flash.events.Event.COMPLETE, function(pEvent:flash.events.Event):void {
					var loader:EmitterParametersLoader = new EmitterParametersLoader();	
						loader.loadBytes(file.data, _emitter);
						
					_emissionRate.value  		 = _emitter.emissionRate;
					_emissionRateVariation.value = _emitter.emissionRateVariation;
					
					_emissionDelay.value = _emitter.emissionDelay;
					_emissionTime.value  = _emitter.emissionTime;
					
					_particleLife.value = _emitter.particleLife;
					_particleLifeVariation.value = _emitter.particleLifeVariation;
					
					_particleScale.value = _emitter.particleScale;
					_particleScaleVariation.value = _emitter.particleScaleVariation;
					
					_particleGrowRatio.value = _emitter.particleGrowRatio;
					_particleShrinkRatio.value = _emitter.particleShrinkRatio;
					
					_particleAlpha.value = _emitter.particleAlpha;
					_particleAlphaVariation.value = _emitter.particleAlphaVariation;
					
					_particleAlphaGrowRatio.value = _emitter.particleAlphaGrowRatio;
					_particleAlphaShrinkRatio.value = _emitter.particleAlphaShrinkRatio;
					
					_particleSpeed.value = _emitter.particleSpeed;
					_particleSpeedVariation.value = _emitter.particleSpeedVariation;
					
					_particleOmegaVariation.value = rad2deg(_emitter.particleOmegaVariation);
					
					_direction.value = rad2deg(_emitter.direction);
					_directionVariation.value = rad2deg(_emitter.directionVariation);
					
					for each (var item:Object in _blendMode.dataProvider.data) {
						if (_emitter.blendMode == item.text) {
							_blendMode.selectedItem = item;
							break;
						}						
					}
					
				});
			
			file.browse( [ filter ] );
		};
		
		private function touchEventHandler(pEvent:TouchEvent):void {
			var touch:Touch = pEvent.touches[0];
			
			if (!touch) {
				return;
			}
			
			switch(touch.phase) {
				case TouchPhase.BEGAN: {
					_isDown = true;
					_downTime = getTimer();
					
					break;
				}
					
				case TouchPhase.HOVER:
				case TouchPhase.MOVED: {
					if (_isDown) {
						_emitter.position.x = touch.globalX;
						_emitter.position.y = touch.globalY;
					}
					
					break;
				}
					
					
				case TouchPhase.ENDED: {
					_isDown = false;
					
					var diff:int = getTimer() - _downTime;
					
					if (diff < 150) {
						_emitter.clean();
						
						_emitter.position.x = touch.globalX;
						_emitter.position.y = touch.globalY;
						
						_emitter.expire();
						
						_emitter.emissionDelay = _emissionDelay.value;
						_emitter.emissionTime  = _emissionTime.value;
						
						_emitter.prewarm(_prewarm.value, 60);
					}
					
					break;
				}
					
				default: {
					break;
				}
			}
		};
	};
}