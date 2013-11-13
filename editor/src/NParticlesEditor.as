package {
	import ngine.display.DocumentClass;
	
	import nparticles.editor.Editor;
	
	[SWF(frameRate="60", width="1024", height="768")]
	public class NParticlesEditor extends DocumentClass {
		
		public function NParticlesEditor() {
			super(Editor, true);
		};
	}
}