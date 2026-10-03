trigger PolicyTrigger on Insurance_Policy__c (
    before insert,
    before update,
    after insert,
    after update
) {
    PolicyTriggerHandler.handle(
        Trigger.new,
        Trigger.oldMap,
        Trigger.isInsert,
        Trigger.isUpdate,
        Trigger.isBefore,
        Trigger.isAfter
    );
}
