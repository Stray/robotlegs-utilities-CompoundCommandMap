package org.robotlegs.mvcs {
	                                 
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.mvcs.IResultReceiver;
	import org.robotlegs.mvcs.events.SampleEventA;
	import org.robotlegs.mvcs.events.SampleEventB;
	
	public class CommandWithNamedInjections extends Command {
		
		[Inject]
		public var resultReceiver:IResultReceiver;
		
		[Inject(name='sampleAsomething')]
		public var sampleEventAsomething:SampleEventA;

		[Inject(name='sampleAsomethingElse')]
		public var sampleEventAsomethingElse:SampleEventA;
		
		[Inject]
		public var sampleEventB:SampleEventB;


		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		override public function execute():void
		{
		   resultReceiver.verifyExecution([sampleEventAsomething, sampleEventAsomethingElse, sampleEventB]);
		}
		
	}
}