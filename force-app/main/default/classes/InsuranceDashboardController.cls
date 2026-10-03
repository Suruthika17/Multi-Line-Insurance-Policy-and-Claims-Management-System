public with sharing class InsuranceDashboardController {

    @AuraEnabled(cacheable=true)
    public static Integer getCustomerCount() {
        return [
            SELECT COUNT()
            FROM Customer__c
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Integer getPolicyCount() {
        return [
            SELECT COUNT()
            FROM Insurance_Policy__c
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Integer getClaimCount() {
        return [
            SELECT COUNT()
            FROM Claim__c
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Integer getPendingClaimCount() {
        return [
            SELECT COUNT()
            FROM Claim__c
            WHERE Claim_Status__c IN ('Submitted', 'Under Review')
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Decimal getTotalPremium() {

        AggregateResult result = [
            SELECT SUM(Premium_Amount__c) totalPremium
            FROM Insurance_Policy__c
        ];

        Decimal total = (Decimal) result.get('totalPremium');

        return total == null ? 0 : total;
    }

    @AuraEnabled(cacheable=true)
    public static Decimal getTotalClaimAmount() {

        AggregateResult result = [
            SELECT SUM(Claim_Amount__c) totalClaims
            FROM Claim__c
        ];

        Decimal total = (Decimal) result.get('totalClaims');

        return total == null ? 0 : total;
    }
}
