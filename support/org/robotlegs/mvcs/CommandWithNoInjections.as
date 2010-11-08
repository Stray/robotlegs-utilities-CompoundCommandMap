package org.robotlegs.mvcs {
	                                 
	import org.robotlegs.mvcs.Command;
	
	public class CommandWithNoInjections extends Command {
		
		[Inject]
		public var resultReceiver:IResultReceiver;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		override public function execute():void
		{
			resultReceiver.verifyExecution([]);
		}
		
	}
}
