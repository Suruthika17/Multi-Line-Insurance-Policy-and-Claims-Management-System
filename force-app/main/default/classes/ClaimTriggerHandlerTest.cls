@IsTest
private class ClaimTriggerHandlerTest {

    private static Insurance_Policy__c createTestPolicy() {

        Customer__c customer = new Customer__c(
            Name = 'Claim Test Customer',
            Email__c = 'claimtest@example.com',
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
            Name = 'Claim Test Policy',
            Policy_Number__c = 'POL-CLAIM-001',
            Customer__c = customer.Id,
            Policy_Type__c = policyType.Id,
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addYears(1),
            Premium_Amount__c = 15000,
            Coverage_Amount__c = 500000,
            Policy_Status__c = 'Active',
            Payment_Frequency__c = 'Yearly'
        );

        insert policy;

        return policy;
    }


    @IsTest
    static void testValidClaim() {

        Insurance_Policy__c policy = createTestPolicy();


        Claim__c claim = new Claim__c(
            Name = 'Medical Claim',
            Claim_Number__c = 'CLM-TEST-001',
            Customer__c = policy.Customer__c,
            Insurance_Policy__c = policy.Id,
            Claim_Type__c = 'Medical',
            Claim_Date__c = Date.today(),
            Claim_Amount__c = 100000,
            Approved_Amount__c = 80000,
            Claim_Status__c = 'Approved',
            Claim_Description__c = 'Medical treatment claim'
        );


        Test.startTest();

        insert claim;

        Test.stopTest();


        Claim__c savedClaim = [
            SELECT Id,
                   Claim_Number__c,
                   Claim_Status__c,
                   Approved_Amount__c
            FROM Claim__c
            WHERE Id = :claim.Id
        ];


        System.assertEquals(
            'CLM-TEST-001',
            savedClaim.Claim_Number__c
        );

        System.assertEquals(
            'Approved',
            savedClaim.Claim_Status__c
        );

        System.assertEquals(
            80000,
            savedClaim.Approved_Amount__c
        );
    }


    @IsTest
    static void testInvalidApprovedAmount() {

        Insurance_Policy__c policy = createTestPolicy();


        Claim__c claim = new Claim__c(
            Name = 'Invalid Claim',
            Claim_Number__c = 'CLM-TEST-002',
            Customer__c = policy.Customer__c,
            Insurance_Policy__c = policy.Id,
            Claim_Type__c = 'Medical',
            Claim_Date__c = Date.today(),
            Claim_Amount__c = 50000,
            Approved_Amount__c = 70000,
            Claim_Status__c = 'Approved'
        );


        Test.startTest();

        try {

            insert claim;

            System.assert(
                false,
                'Expected approved amount validation error.'
            );

        } catch (DmlException e) {

            System.assert(
                e.getMessage().contains(
                    'Approved Amount cannot be greater than Claim Amount.'
                )
            );
        }

        Test.stopTest();
    }


    @IsTest
    static void testRejectedClaimRequiresReason() {

        Insurance_Policy__c policy = createTestPolicy();


        Claim__c claim = new Claim__c(
            Name = 'Rejected Claim',
            Claim_Number__c = 'CLM-TEST-003',
            Customer__c = policy.Customer__c,
            Insurance_Policy__c = policy.Id,
            Claim_Type__c = 'Accident',
            Claim_Date__c = Date.today(),
            Claim_Amount__c = 50000,
            Claim_Status__c = 'Rejected'
        );


        Test.startTest();

        try {

            insert claim;

            System.assert(
                false,
                'Expected rejection reason validation error.'
            );

        } catch (DmlException e) {

            System.assert(
                e.getMessage().contains(
                    'Rejection Reason is required'
                )
            );
        }

        Test.stopTest();
    }
}
