/*
@Author : Praneeth
@CreatedDate : 05th Sep 2021
@Description : Test Data factory for test Classes.
*/

@isTest
public class TestDataFactory {
    
    public static TriggerSetting__c CreateCustomSetting (string triggerName, boolean isActive){
        TriggerSetting__c cs = new TriggerSetting__c();      //Insert Custom setting
        cs.Name = triggerName;
        cs.IsActive__c = isActive;
        insert cs;
        return cs;
    }
    
    public static List<Account> createAccountsWithIntance(Integer numAccts, Integer numIntsPerAcct) {
        List<Account> accts = new List<Account>();
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i);
            accts.add(a);
        }
        insert accts;
        
        List<Instance__c> intslst = new List<Instance__c>();
        for (Integer j=0;j<numAccts;j++) {
            Account acct = accts[j]; 
            // For each account just inserted, add Instances
            for (Integer k=0;k<numIntsPerAcct;k++) {
                intslst.add(new Instance__c(Name=acct.Name + ' Test ' + k,
                                            type__c = 'Standard',
                                            Account__c = acct.Id,
                                            Licenses__c = 4
                                           ));
            }
        }
        // Insert all Instances for all accounts.
        insert intslst;
        return accts;
    }
}