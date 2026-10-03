@IsTest
private class PolicyTriggerHandlerTest {

    @IsTest
    static void testPolicyCreation() {

        Customer__c customer = new Customer__c(
            Name = 'Test Customer',
            Email__c = 'testcustomer@example.com',
            Phone__c = '9876543210',
            Customer_Status__c = 'Active'
        );

        insert customer;


        Policy_Type__c policyType = new Policy_Type__c(
            Name = 'Health Insurance',
            Description__c = 'Health insurance policy',
            Base_Premium__c = 15000,
            Coverage_Category__c = 'Health'
        );

        insert policyType;


        Insurance_Policy__c policy = new Insurance_Policy__c(
            Name = 'Test Health Policy',
            Policy_Number__c = 'POL-TEST-001',
            Customer__c = customer.Id,
            Policy_Type__c = policyType.Id,
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addYears(1),
            Premium_Amount__c = 15000,
            Coverage_Amount__c = 500000,
            Policy_Status__c = 'Draft',
            Payment_Frequency__c = 'Yearly'
        );

        Test.startTest();

        insert policy;

        Test.stopTest();


        Insurance_Policy__c savedPolicy = [
            SELECT Id,
                   Policy_Number__c,
                   Policy_Status__c,
                   Customer__c
            FROM Insurance_Policy__c
            WHERE Id = :policy.Id
        ];


        System.assertEquals(
            'POL-TEST-001',
            savedPolicy.Policy_Number__c
        );

        System.assertEquals(
            customer.Id,
            savedPolicy.Customer__c
        );

        System.assertEquals(
            'Active',
            savedPolicy.Policy_Status__c
        );
    }


    @IsTest
    static void testInvalidPolicyDates() {

        Customer__c customer = new Customer__c(
            Name = 'Invalid Date Customer',
            Email__c = 'invalid@example.com',
            Phone__c = '9999999999',
            Customer_Status__c = 'Active'
        );

        insert customer;


        Policy_Type__c policyType = new Policy_Type__c(
            Name = 'Motor Insurance',
            Description__c = 'Motor insurance policy',
            Base_Premium__c = 10000,
            Coverage_Category__c = 'Motor'
        );

        insert policyType;


        Insurance_Policy__c policy = new Insurance_Policy__c(
            Name = 'Invalid Policy',
            Policy_Number__c = 'POL-TEST-002',
            Customer__c = customer.Id,
            Policy_Type__c = policyType.Id,
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(-10),
            Premium_Amount__c = 10000,
            Coverage_Amount__c = 300000,
            Policy_Status__c = 'Draft',
            Payment_Frequency__c = 'Yearly'
        );


        Test.startTest();

        try {

            insert policy;

            System.assert(
                false,
                'Expected policy date validation error.'
            );

        } catch (DmlException e) {

            System.assert(
                e.getMessage().contains(
                    'Policy End Date cannot be earlier than Start Date.'
                )
            );
        }

        Test.stopTest();
    }
}
