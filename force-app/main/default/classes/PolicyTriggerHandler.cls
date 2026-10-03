public class PolicyTriggerHandler {

    public static void handle(
        List<Insurance_Policy__c> newRecords,
        Map<Id, Insurance_Policy__c> oldMap,
        Boolean isInsert,
        Boolean isUpdate,
        Boolean isBefore,
        Boolean isAfter
    ) {

        if (isBefore && (isInsert || isUpdate)) {
            validatePolicyDates(newRecords);
            updatePolicyStatus(newRecords);
        }

        if (isAfter && isInsert) {
            System.debug('New insurance policies created: ' + newRecords.size());
        }

        if (isAfter && isUpdate) {
            System.debug('Insurance policies updated: ' + newRecords.size());
        }
    }


    private static void validatePolicyDates(
        List<Insurance_Policy__c> policies
    ) {

        for (Insurance_Policy__c policy : policies) {

            if (
                policy.Start_Date__c != null &&
                policy.End_Date__c != null &&
                policy.End_Date__c < policy.Start_Date__c
            ) {
                policy.addError(
                    'Policy End Date cannot be earlier than Start Date.'
                );
            }
        }
    }


    private static void updatePolicyStatus(
        List<Insurance_Policy__c> policies
    ) {

        Date todayDate = Date.today();

        for (Insurance_Policy__c policy : policies) {

            if (
                policy.Start_Date__c != null &&
                policy.End_Date__c != null
            ) {

                if (
                    todayDate >= policy.Start_Date__c &&
                    todayDate <= policy.End_Date__c
                ) {
                    policy.Policy_Status__c = 'Active';
                }
                else if (todayDate > policy.End_Date__c) {
                    policy.Policy_Status__c = 'Expired';
                }
            }
        }
    }
}
