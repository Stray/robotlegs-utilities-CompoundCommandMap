package org.robotlegs.base {

	import asunit.framework.TestCase;
	import org.robotlegs.core.ICompoundCommandMap;
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.adapters.SwiftSuspendersReflector;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;

	import asunit.errors.AssertionFailedError;     

	import mockolate.prepare;
	import mockolate.nice;
	import mockolate.stub;
   	import mockolate.verify;
	import mockolate.errors.VerificationError;
	
	import org.hamcrest.core.anything;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.nullValue;
	import org.hamcrest.object.strictlyEqualTo;
	import org.hamcrest.object.hasPropertyWithValue;
	import org.hamcrest.collection.array;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import org.robotlegs.mvcs.IResultReceiver;
	import org.robotlegs.mvcs.events.SampleEventA;
	import org.robotlegs.mvcs.events.SampleEventB;
	import org.robotlegs.core.ICompoundCommandConfig;
	import org.robotlegs.mvcs.CommandWithNoInjections;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.mvcs.CommandWithInjections;
	import org.robotlegs.mvcs.CommandWithNamedInjections;
	
	

	public class CompoundCommandMapTest extends TestCase {
		private var compoundCommandMap:CompoundCommandMap;
		private var eventDispatcher:IEventDispatcher;
		private var injector:IInjector;
		private var resultReceiver:IResultReceiver;

		public function CompoundCommandMapTest(methodName:String=null) {
			super(methodName)
		}

		override public function run():void{
			var mockolateMaker:IEventDispatcher = prepare(IResultReceiver, IMediatorMap, ICommandMap);
			
			mockolateMaker.addEventListener(Event.COMPLETE, prepareCompleteHandler);
		}

		private function prepareCompleteHandler(e:Event):void{
			IEventDispatcher(e.target).removeEventListener(Event.COMPLETE, prepareCompleteHandler);
			super.run();
		}

		override protected function setUp():void {
			super.setUp();
			injector = new SwiftSuspendersInjector();
			var reflector:IReflector = new SwiftSuspendersReflector();  
			eventDispatcher = new EventDispatcher();
			resultReceiver = nice(IResultReceiver);
			injector.mapValue(IEventDispatcher, eventDispatcher);
			injector.mapValue(IResultReceiver, resultReceiver);
			injector.mapValue(DisplayObjectContainer, new Sprite());
			injector.mapValue(IMediatorMap, nice(IMediatorMap));
			injector.mapValue(ICommandMap, nice(ICommandMap));
			injector.mapValue(IInjector, injector);
			                                                   
			compoundCommandMap = new CompoundCommandMap(eventDispatcher, injector, reflector);
		}

		override protected function tearDown():void {
			super.tearDown();
			compoundCommandMap = null;
			eventDispatcher = null;
			injector = null;
			resultReceiver = null;
		}

		public function testInstantiated():void {
			assertTrue("compoundCommandMap is CompoundCommandMap", compoundCommandMap is CompoundCommandMap);
		}
		
		public function test_implements_ICompoundCommandMap():void {
			assertTrue("Implements ICompoundCommandMap", compoundCommandMap is ICompoundCommandMap);
		}
		

		public function testFailure():void {
			assertTrue("Failing test", true);
		}
		
		public function test_mapToEvents_returns_config_with_correct_mappings():void {
			
			var commandConfig:ICompoundCommandConfig = compoundCommandMap.mapToEvents(CommandWithNoInjections);
			
			assertEquals('initially no required events', 0, commandConfig.requiredEvents.length);
			assertEquals('initially no remaining required events', 0, commandConfig.remainingRequiredEvents.length);
			
		   commandConfig.addRequiredEvent(SampleEventA.SOMETHING_HAPPENED, SampleEventA);
		
		   assertEqualsArraysIgnoringOrder('first event requirement added correctly', [SampleEventA.SOMETHING_HAPPENED], commandConfig.requiredEvents);
		   assertEqualsArraysIgnoringOrder('first event remaining requirement added correctly', [SampleEventA.SOMETHING_HAPPENED], commandConfig.remainingRequiredEvents);
		
		   commandConfig.addRequiredEvent(SampleEventA.SOMETHING_ELSE_HAPPENED, SampleEventA);

		   assertEqualsArraysIgnoringOrder('second event requirement added correctly', [SampleEventA.SOMETHING_HAPPENED, SampleEventA.SOMETHING_ELSE_HAPPENED], commandConfig.requiredEvents);
		   assertEqualsArraysIgnoringOrder('second event remaining requirement added correctly', [SampleEventA.SOMETHING_HAPPENED, SampleEventA.SOMETHING_ELSE_HAPPENED], commandConfig.remainingRequiredEvents);

		   commandConfig.addRequiredEvent(SampleEventB.SOMETHING_HAPPENED, SampleEventB);

		   assertEqualsArraysIgnoringOrder('third event requirement added correctly', [SampleEventA.SOMETHING_HAPPENED, SampleEventA.SOMETHING_ELSE_HAPPENED, SampleEventB.SOMETHING_HAPPENED], commandConfig.requiredEvents);
		   assertEqualsArraysIgnoringOrder('third event remaining requirement added correctly', [SampleEventA.SOMETHING_HAPPENED, SampleEventA.SOMETHING_ELSE_HAPPENED, SampleEventB.SOMETHING_HAPPENED], commandConfig.remainingRequiredEvents);
		}
		
		
		public function test_command_fires_when_required_events_received():void {
			
			compoundCommandMap.mapToEvents(CommandWithNoInjections)
				.addRequiredEvent(SampleEventA.SOMETHING_HAPPENED, SampleEventA)
				.addRequiredEvent(SampleEventB.SOMETHING_HAPPENED, SampleEventB);
				
			eventDispatcher.dispatchEvent(new SampleEventB(SampleEventB.SOMETHING_HAPPENED));
			eventDispatcher.dispatchEvent(new SampleEventA(SampleEventA.SOMETHING_HAPPENED));
			
			verify(resultReceiver).method('verifyExecution');
		}
		
		public function test_unambiguous_injections_are_mapped():void {
			
			compoundCommandMap.mapToEvents(CommandWithInjections)
				.addRequiredEvent(SampleEventA.SOMETHING_HAPPENED, SampleEventA)
				.addRequiredEvent(SampleEventB.SOMETHING_HAPPENED, SampleEventB);
			
			var sampleEventA:SampleEventA = new SampleEventA(SampleEventA.SOMETHING_HAPPENED);
			var sampleEventB:SampleEventB = new SampleEventB(SampleEventB.SOMETHING_HAPPENED);
				
			eventDispatcher.dispatchEvent(sampleEventB);
			eventDispatcher.dispatchEvent(sampleEventA);
			
			verify(resultReceiver).method('verifyExecution').args(array(equalTo(sampleEventA), equalTo(sampleEventB)));
		}
		
		
		public function test_named_ambiguous_injections_are_mapped():void {
			
			compoundCommandMap.mapToEvents(CommandWithNamedInjections)
				.addRequiredEvent(SampleEventA.SOMETHING_HAPPENED, SampleEventA, 'sampleAsomething')
				.addRequiredEvent(SampleEventA.SOMETHING_ELSE_HAPPENED, SampleEventA, 'sampleAsomethingElse')
				.addRequiredEvent(SampleEventB.SOMETHING_HAPPENED, SampleEventB);
			
			var sampleEventA_something:SampleEventA = new SampleEventA(SampleEventA.SOMETHING_HAPPENED);
			var sampleEventA_somethingElse:SampleEventA = new SampleEventA(SampleEventA.SOMETHING_ELSE_HAPPENED);
			var sampleEventB:SampleEventB = new SampleEventB(SampleEventB.SOMETHING_HAPPENED);
				
			eventDispatcher.dispatchEvent(sampleEventB);
			eventDispatcher.dispatchEvent(sampleEventA_something);
			eventDispatcher.dispatchEvent(sampleEventA_somethingElse);
			
			verify(resultReceiver).method('verifyExecution').args(array(equalTo(sampleEventA_something), equalTo(sampleEventA_somethingElse), equalTo(sampleEventB)));
		}
		
		public function test_one_shot_command_only_fires_once():void {
			
			compoundCommandMap.mapToEvents(CommandWithInjections, true)
				.addRequiredEvent(SampleEventA.SOMETHING_HAPPENED, SampleEventA)
				.addRequiredEvent(SampleEventB.SOMETHING_HAPPENED, SampleEventB);
			
			var sampleEventA:SampleEventA = new SampleEventA(SampleEventA.SOMETHING_HAPPENED);
			var sampleEventB:SampleEventB = new SampleEventB(SampleEventB.SOMETHING_HAPPENED);
				
			eventDispatcher.dispatchEvent(sampleEventB);
			eventDispatcher.dispatchEvent(sampleEventA);
			                                                
			eventDispatcher.dispatchEvent(sampleEventB);
			eventDispatcher.dispatchEvent(sampleEventA);
			
			verify(resultReceiver).method('verifyExecution').once(); 
			
			assertFalse("Has compound command no longer true for command that has been mapped", compoundCommandMap.hasCompoundCommand(CommandWithInjections));
		}
		
		public function test_non_one_shot_command_fires_repeatedly():void {
			
			compoundCommandMap.mapToEvents(CommandWithInjections)
				.addRequiredEvent(SampleEventA.SOMETHING_HAPPENED, SampleEventA)
				.addRequiredEvent(SampleEventB.SOMETHING_HAPPENED, SampleEventB);
			
			var sampleEventA:SampleEventA = new SampleEventA(SampleEventA.SOMETHING_HAPPENED);
			var sampleEventB:SampleEventB = new SampleEventB(SampleEventB.SOMETHING_HAPPENED);
				
			eventDispatcher.dispatchEvent(sampleEventB);
			eventDispatcher.dispatchEvent(sampleEventA);
			                                                
			eventDispatcher.dispatchEvent(sampleEventB);
			eventDispatcher.dispatchEvent(sampleEventA);
			                                             
			eventDispatcher.dispatchEvent(sampleEventB);
			eventDispatcher.dispatchEvent(sampleEventA);
			
			verify(resultReceiver).method('verifyExecution').thrice();
			
			assertTrue("Has compound command still true for command that has been mapped", compoundCommandMap.hasCompoundCommand(CommandWithInjections));
		}
		
		public function test_required_in_order_does_not_fire_until_events_received_in_order():void {
			
			compoundCommandMap.mapToEvents(CommandWithInjections, false, true)
				.addRequiredEvent(SampleEventA.SOMETHING_HAPPENED, SampleEventA)
				.addRequiredEvent(SampleEventB.SOMETHING_HAPPENED, SampleEventB);
			
			var sampleEventA:SampleEventA = new SampleEventA(SampleEventA.SOMETHING_HAPPENED);
			var sampleEventB:SampleEventB = new SampleEventB(SampleEventB.SOMETHING_HAPPENED);
				
			eventDispatcher.dispatchEvent(sampleEventB);
			eventDispatcher.dispatchEvent(sampleEventA);

			try {
				verify(resultReceiver).method('verifyExecution');
				assertTrue("The command should not have executed yet", false);
			}
			catch(verificationError:VerificationError) {
				// great - this is what we were hoping for
			} 

			eventDispatcher.dispatchEvent(sampleEventB);
			verify(resultReceiver).method('verifyExecution').once();
		}
		
		public function test_has_compound_command():void { 
			compoundCommandMap.mapToEvents(CommandWithInjections);
			assertTrue("Has compound command true for command that has been mapped", compoundCommandMap.hasCompoundCommand(CommandWithInjections));
			assertFalse("Has compound command false for command that has not been mapped", compoundCommandMap.hasCompoundCommand(CommandWithNamedInjections));
		}
		
		
		
	}
}