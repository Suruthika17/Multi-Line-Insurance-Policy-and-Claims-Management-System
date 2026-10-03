trigger ClaimTrigger on Claim__c (
    before insert,
    before update,
    after insert,
    after update
) {
    ClaimTriggerHandler.handle(
        Trigger.new,
        Trigger.oldMap,
        Trigger.isInsert,
        Trigger.isUpdate,
        Trigger.isBefore,
        Trigger.isAfter
    );
}
