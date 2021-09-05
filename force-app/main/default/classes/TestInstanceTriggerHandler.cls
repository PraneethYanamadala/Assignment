/*
@Author : Praneeth
@CreatedDate : 05th Sep 2021
@Description : Test class Instance Trigger.
*/

@isTest
private class TestInstanceTriggerHandler {
    
    // Test data setup
    @testSetup static void setup() {
        TestDataFactory.CreateCustomSetting('InstanceTrigger',true);
        Account[] accts = TestDataFactory.createAccountsWithIntance(1,1);  // Create one account with one Instance by calling a utility method
    }
    @isTest static void TestInstanceUpdate() {
        list<account> accounts = [SELECT
                                  Id, 
                                  Name
                                  FROM  
                                  Account];
        Set<Id> accIds = new set<Id>();
        for(account a : accounts) {
            accIds.add(a.Id);
        }
        
        list<Instance__c> instances = [SELECT
                                       Name,
                                       type__c,
                                       Account__c,
                                       Licenses__c
                                       FROM
                                       Instance__c
                                       Where
                                       account__c IN:accIds];
        list<Instance__c> intToUpdate = new list<Instance__c>();
        
        for(Instance__c instance : instances) {
            instance.Licenses__c = 5;
            intToUpdate.add(instance);
        }
        
        // Perform test
        Test.startTest();
        Database.saveResult[] result = Database.Update(intToUpdate, false);
        Test.stopTest();
        account acc = [SELECT Total_Licenses__c FROM Account WHERE ID IN:accIds limit 1];
        System.assertEquals(5,acc.Total_Licenses__c);
    }  
    
    @isTest static void TestInstanceAccountUpdate() {
        list<account> accounts = [SELECT
                                  Id,
                                  Name
                                  FROM  
                                  Account];
        Set<Id> accIds = new set<Id>();
        for(account a : accounts) {
            accIds.add(a.Id);
        }
        
        list<Instance__c> instances = [SELECT
                                       Name,
                                       type__c,
                                       Account__c,
                                       Licenses__c
                                       FROM
                                       Instance__c
                                       Where
                                       account__c IN:accIds];
        list<Instance__c> intToUpdate = new list<Instance__c>();
        Account[] accts = TestDataFactory.createAccountsWithIntance(1,1);  
        for(Instance__c instance : instances) {
            instance.Account__c = accts[0].Id;
            intToUpdate.add(instance);
        }
        
        // Perform test
        Test.startTest();
        Database.saveResult[] result = Database.Update(intToUpdate, false);
        Test.stopTest();
        account acc = [SELECT Total_Licenses__c FROM Account WHERE ID IN:accIds limit 1];
        System.assertEquals(0,acc.Total_Licenses__c);
    }  
    
    @isTest static void TestInstanceDelete() {
        list<account> accounts = [SELECT
                                  Id,
                                  Name
                                  FROM  
                                  Account];
        Set<Id> accIds = new set<Id>();
        for(account a : accounts) {
            accIds.add(a.Id);
        }
        
        list<Instance__c> instances = [SELECT
                                       Name,
                                       type__c,
                                       Account__c,
                                       Licenses__c
                                       FROM
                                       Instance__c
                                       Where
                                       account__c IN:accIds];
        
        // Perform test
        Test.startTest();
        Database.deleteResult [] result = Database.delete(instances, false);
        Test.stopTest();
        account acc = [SELECT Total_Licenses__c FROM Account WHERE ID IN:accIds limit 1];
        System.assertEquals(0,acc.Total_Licenses__c);
    }
    
    @isTest static void TestInstanceOnAccChange() {
        Account[] accts = TestDataFactory.createAccountsWithIntance(1,2);
        Account[] acctslst = TestDataFactory.createAccountsWithIntance(1,2);
        Set<Id> accIds = new set<Id>();
        for(account a : accts) {
            accIds.add(a.Id);
        }
        
        list<Instance__c> instances = [SELECT
                                       Name,
                                       type__c,
                                       Account__c,
                                       Licenses__c
                                       FROM
                                       Instance__c
                                       Where
                                       account__c IN:accIds];
        
        instances[0].Account__c = acctslst[0].Id;
        
        // Perform test
        Test.startTest();
        Database.saveResult  result = Database.update(instances[0], false);
        Test.stopTest();
        account acc = [SELECT Total_Licenses__c FROM Account WHERE ID IN:accIds limit 1];
        System.assertEquals(4,acc.Total_Licenses__c);
    }  
    
    @isTest static void TestOneInstanceDel() {
        Account[] accts = TestDataFactory.createAccountsWithIntance(1,2);
        Set<Id> accIds = new set<Id>();
        for(account a : accts) {
            accIds.add(a.Id);
        }
        
        list<Instance__c> instances = [SELECT
                                       Name,
                                       type__c,
                                       Account__c,
                                       Licenses__c
                                       FROM
                                       Instance__c
                                       Where
                                       account__c IN:accIds];
        
        // Perform test
        Test.startTest();
        Database.deleteResult  result = Database.delete(instances[0], false);
        Test.stopTest();
        account acc = [SELECT Total_Licenses__c FROM Account WHERE ID IN:accIds limit 1];
        System.assertEquals(4,acc.Total_Licenses__c);
    }          
}