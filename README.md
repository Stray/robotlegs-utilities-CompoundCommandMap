Robotlegs utility, tested against robotlegs v1.0 thru 1.4

Full test coverage is provided with asunit 3.

No swc as you should compile from source to ensure it extends the same version of robotlegs as the rest of your project.

**Usage:**

	// params: command, isOneShot, requireInOrder
	compoundCommandMap.mapToEvents(SomeAwesomeCommand, true, true)
    	.addRequiredEvent(SomeEvent.SOMETHING_HAPPENED, SomeEvent);
    	.addRequiredEvent(SomeOtherEvent.SOMETHING_ELSE_HAPPENED, SomeOtherEvent, 'somethingElseHappened');
    	.addRequiredEvent(SomeOtherEvent.STUFF_HAPPENED, SomeOtherEvent, 'stuffHappened');

    // in the command itself

	[Inject]
	public var someEvent:SomeEvent;

	[Inject(name='somethingElseHappened')]
	public var somethingElseEvent:SomeOtherEvent;

	[Inject(name='stuffHappened')]
	public var stuffHappenedEvent:SomeOtherEvent;

etc - but there's a common use case where you'd only be interested in the fact that all 3 signals have fired and wouldn't need the events at all, or would only need the last one.  

See tests/org/robotlegs/base/CompoundCommandMapTest for full usage examples.
                      