import { LightningElement, wire } from 'lwc';

import getCustomerCount
    from '@salesforce/apex/InsuranceDashboardController.getCustomerCount';

import getPolicyCount
    from '@salesforce/apex/InsuranceDashboardController.getPolicyCount';

import getClaimCount
    from '@salesforce/apex/InsuranceDashboardController.getClaimCount';

import getPendingClaimCount
    from '@salesforce/apex/InsuranceDashboardController.getPendingClaimCount';

import getTotalPremium
    from '@salesforce/apex/InsuranceDashboardController.getTotalPremium';

import getTotalClaimAmount
    from '@salesforce/apex/InsuranceDashboardController.getTotalClaimAmount';


export default class InsuranceDashboard extends LightningElement {

    customerCount = 0;
    policyCount = 0;
    claimCount = 0;
    pendingClaimCount = 0;
    totalPremium = 0;
    totalClaimAmount = 0;


    @wire(getCustomerCount)
    customerResult({ data }) {
        if (data !== undefined) {
            this.customerCount = data;
        }
    }


    @wire(getPolicyCount)
    policyResult({ data }) {
        if (data !== undefined) {
            this.policyCount = data;
        }
    }


    @wire(getClaimCount)
    claimResult({ data }) {
        if (data !== undefined) {
            this.claimCount = data;
        }
    }


    @wire(getPendingClaimCount)
    pendingClaimResult({ data }) {
        if (data !== undefined) {
            this.pendingClaimCount = data;
        }
    }


    @wire(getTotalPremium)
    premiumResult({ data }) {
        if (data !== undefined) {
            this.totalPremium = data;
        }
    }


    @wire(getTotalClaimAmount)
    claimAmountResult({ data }) {
        if (data !== undefined) {
            this.totalClaimAmount = data;
        }
    }
}
