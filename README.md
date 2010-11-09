Robotlegs utility, tested against robotlegs v1.0 thru 1.4

Full test coverage is provided with asunit 3.

No swc as you should compile from source to ensure it extends the same version of robotlegs as the rest of your project.

**Usage:**

In your context:
	
	// implement this interface:
	import org.robotlegs.core.ICompoundCommandContext;
	
	protected var _compoundCommandMap:ICompoundCommandMap;
	
	public function get compoundCommandMap():ICompoundCommandMap
    {
        return _compoundCommandMap || (_compoundCommandMap = new CompoundCommandMap(eventDispatcher, injector, reflector));
    }

    public function set compoundCommandMap(value:ICompoundCommandMap):void
    {
        _compoundCommandMap = value;
    }
	
	override protected function mapInjections():void
    {
        super.mapInjections();
        injector.mapValue(ICompoundCommandMap, compoundCommandMap);
    }
       

Where you want to map commands to multiple events:

	// params: command, isOneShot, requireInOrder
	compoundCommandMap.mapToEvents(SomeAwesomeCommand, true, true)
    	.addRequiredEvent(SomeEvent.SOMETHING_HAPPENED, SomeEvent);
    	.addRequiredEvent(SomeOtherEvent.SOMETHING_ELSE_HAPPENED, SomeOtherEvent, 'somethingElseHappened');
    	.addRequiredEvent(SomeOtherEvent.STUFF_HAPPENED, SomeOtherEvent, 'stuffHappened');
  

In the command itself - named injection only required where you have multiple events of the same event class:

	[Inject]
	public var someEvent:SomeEvent;

	[Inject(name='somethingElseHappened')]
	public var somethingElseEvent:SomeOtherEvent;

	[Inject(name='stuffHappened')]
	public var stuffHappenedEvent:SomeOtherEvent;

etc - but there's a common use case where you'd only be interested in the fact that all 3 events have fired and wouldn't need the events at all, or would only need the last one. 


ICompoundCommandMap has an API with 3 functions:

	function mapToEvents(commandClass:Class, oneshot:Boolean = false, requiredInOrder:Boolean = false):ICompoundCommandConfig;
	 
	function hasCompoundCommand(commandClass:Class):Boolean;
	
	function unmapCompoundCommand(commandClass:Class):ICompoundCommandConfig;
	
	
ICompoundCommandConfig - returned when mapping / unmapping - has the API:

	function addRequiredEvent(eventType:String, eventClass:Class = null, named:String = ""):ICompoundCommandConfig;
	
	function get requiredEvents():Array; 			// all events set using addRequiredEvent
		
	function get remainingRequiredEvents():Array; 	// events that have not yet fired
	
	function get requiredInOrder():Boolean; 		/* whether the events are only picked up in order - 
											   		ie event2 is ignored until after event1 is received */ 
	
    function get eventsAsPayloads():Array; 			/* returns an array of the events that have arrived so
 													   far as a strong typed IEventAsPayload with 3 properties:
											   		   the event, the event class and the event name,
													   if it was mapped with a name  */
	
	function get oneshot():Boolean;					// whether this command is unmapped after one execution	
	

See tests/org/robotlegs/base/CompoundCommandMapTest for full usage examples.
                      
