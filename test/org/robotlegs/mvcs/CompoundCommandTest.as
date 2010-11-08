package org.robotlegs.mvcs {

	import asunit.framework.TestCase;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.core.ICompoundCommandMap;

	public class CompoundCommandTest extends TestCase {
		private var instance:CompoundCommand;

		public function CompoundCommandTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new CompoundCommand();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is CompoundCommand", instance is CompoundCommand);
		}
        
		public function test_is_command():void {
			assertTrue("Is command", instance is Command);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		}
		
		public function test_compoundCommandMap_property():void {
			assertTrue("CompoundCommandMap has compoundCommandMap property", instance.compoundCommandMap is ICompoundCommandMap);
		}
		
	}
}