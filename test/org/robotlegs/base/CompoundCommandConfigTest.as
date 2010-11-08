package org.robotlegs.base {

	import asunit.framework.TestCase;

	public class CompoundCommandConfigTest extends TestCase {
		private var instance:CompoundCommandConfig;

		public function CompoundCommandConfigTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new CompoundCommandConfig();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is CompoundCommandConfig", instance is CompoundCommandConfig);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}