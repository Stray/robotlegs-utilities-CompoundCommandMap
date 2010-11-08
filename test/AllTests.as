package {
	/**
	 * This file has been automatically created using
	 * #!/usr/bin/ruby script/generate suite
	 * If you modify it and run this script, your
	 * modifications will be lost!
	 */

	import asunit.framework.TestSuite;
//	import org.robotlegs.base.CompoundCommandConfigTest;
	import org.robotlegs.base.CompoundCommandMapTest;
//	import org.robotlegs.mvcs.CompoundCommandTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
//			addTest(new org.robotlegs.base.CompoundCommandConfigTest());
			addTest(new org.robotlegs.base.CompoundCommandMapTest());
//			addTest(new org.robotlegs.mvcs.CompoundCommandTest());
		}
	}
}
