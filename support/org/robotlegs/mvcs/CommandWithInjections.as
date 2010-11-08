package org.robotlegs.mvcs {
	                                 
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.mvcs.events.SampleEventA;
	import org.robotlegs.mvcs.IResultReceiver;
	import org.robotlegs.mvcs.events.SampleEventB;
	
	public class CommandWithInjections extends Command {
		
		[Inject]
		public var resultReceiver:IResultReceiver;
		
		[Inject]
		public var sampleEventA:SampleEventA;
		
		[Inject]
		public var sampleEventB:SampleEventB;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		override public function execute():void
		{
		    trace("CommandWithInjections::execute()");
			resultReceiver.verifyExecution([sampleEventA, sampleEventB]);
		}
		
	}
}