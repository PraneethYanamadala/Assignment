/*
@Author : Praneeth
@CreatedDate : 05th Sep 2021
@Description : Instance Object Trigger Handler.
*/
public class InstanceTriggerHandler implements ITriggerHandler{
    
    //Use this variable to disable this trigger from transaction
    public static Boolean TriggerDisabled = false;
    
    //check if the trigger is disabled from transaction
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
    
    public void beforeInsert(List<sObject> newList) {
        
    }
    
    public void afterInsert(List<sObject> newList , Map<Id, sObject> newMap) {
        list<Instance__c> newlst = newList; // new Instances list
        Set<Id> accountIds = new Set<Id>();
        for(Instance__c objInt : newlst) {
            
            accountIds.add(objInt.Account__c);
            
        }
        
        Map<Id,Account> accountMapToUpdate = new Map<Id,Account>();  
        if(accountIds.size()>0){  
            //Using Aggregate functions in SOQL, to Count(), SUM() and MAX(), for roll up and summarize data in a query.  
            for(AggregateResult aggr:[SELECT
                                      Account__c,
                                      SUM(Licenses__c)amt  
                                      FROM
                                      Instance__c
                                      WHERE
                                      Account__c IN:accountIds AND type__c = 'Standard'
                                      GROUP
                                      BY
                                      Account__c]){
                                          
                                          Account account = new Account();  
                                          account.Total_Licenses__c = (Decimal)aggr.get('amt');  
                                          account.Id = (Id)aggr.get('Account__c');  
                                          accountMapToUpdate.put(account.Id, account);                
                                      }  
        }    
        try{  
            update accountMapToUpdate.values();  
        }catch(Exception e){  
            System.debug('Exception Message'+e.getMessage()+'Line No. >>'+e.getLineNumber());  
        }  
    }
    
    public void beforeUpdate(List<sObject> newList, Map<Id, sObject> newMap, List<sObject> oldList, Map<Id, sObject> oldMap) {
        
    }
    
    public void afterUpdate(List<sObject> newList, Map<Id, sObject> newMap,  List<sObject> oldList, Map<Id, sObject> oldMap) {
        
        list<Instance__c> newlst = newList; // new Instances list
        Set<Id> accountIds = new Set<Id>();
        for(Instance__c objInt : newlst) {
            
            accountIds.add(objInt.Account__c);
            
        }
        
        Map<Id,Account> accountMapToUpdate = new Map<Id,Account>();  
        if(accountIds.size()>0){  
            //Using Aggregate functions in SOQL, to Count(), SUM() and MAX(), for roll up and summarize data in a query.  
            for(AggregateResult aggr:[SELECT
                                      Account__c,
                                      SUM(Licenses__c)amt  
                                      FROM
                                      Instance__c
                                      WHERE
                                      Account__c IN:accountIds AND type__c = 'Standard'
                                      GROUP
                                      BY
                                      Account__c]){
                                          
                                          Account account = new Account();  
                                          account.Total_Licenses__c = (Decimal)aggr.get('amt');  
                                          account.Id = (Id)aggr.get('Account__c');  
                                          accountMapToUpdate.put(account.Id, account);                
                                      }  
        }    
        try{  
            update accountMapToUpdate.values();  
        }catch(Exception e){  
            System.debug('Exception Message'+e.getMessage()+'Line No. >>'+e.getLineNumber());  
        }
        
        list<Instance__c> oldlst = oldList; // new Instances list
        map< Id, Id > accIdmap = new map< Id, Id >();
        for(Instance__c newInt : newlst) {
            accIdmap.put(newInt.Id,newInt.Account__c);
        }
        Set<Id> oldAccIds = new Set<Id>();
        for(Instance__c objInt : oldlst) {
            if(objInt.Account__c != accIdmap.get(objInt.Id)) {
                oldAccIds.add(objInt.Account__c);
            }
        }
        
        Map<Id,Account> oldaccMap = new Map<Id,Account>();  
        if(oldAccIds.size()>0){  
            //Using Aggregate functions in SOQL, to Count(), SUM() and MAX(), for roll up and summarize data in a query.
            list< AggregateResult > aggresult = [SELECT
                                                 Account__c,
                                                 SUM(Licenses__c)amt  
                                                 FROM
                                                 Instance__c
                                                 WHERE
                                                 Account__c IN:oldAccIds AND type__c = 'Standard'
                                                 GROUP
                                                 BY
                                                 Account__c];
            if(aggresult.size()>0){
                for( AggregateResult aggr : aggresult ) {
                    Account account = new Account();  
                    account.Total_Licenses__c = (Decimal)aggr.get('amt');  
                    account.Id = (Id)aggr.get('Account__c');  
                    oldaccMap.put(account.Id, account);
                }
                update oldaccMap.values();
                
            }else {
                list<account> accsToUpdate = new list<account>();
                list<Account> accslst = [Select Id,Total_Licenses__c From Account Where Id In:oldAccIds];
                for(Account a : accslst) {
                    a.Total_Licenses__c = 0;
                    accsToUpdate.add(a);
                }
                update accsToUpdate;
            }
        }
    }
    
    public void beforeDelete(List<sObject> oldList , Map<Id, sObject> oldMap) {
        
    }
    
    public void afterDelete(List<sObject> oldList , Map<Id, sObject> oldMap) {
        
        list<Instance__c> oldLst = oldList; // new Instances list
        Set<Id> accountIds = new Set<Id>();
        for(Instance__c objInt : oldLst) {
            
            accountIds.add(objInt.Account__c);
            
        }
        
        Map<Id,Account> accountMapToUpdate = new Map<Id,Account>();  
        if(accountIds.size()>0){
            //Using Aggregate functions in SOQL, to Count(), SUM() and MAX(), for roll up and summarize data in a query.
            list< AggregateResult > aggresult = [SELECT
                                                 Account__c,
                                                 SUM(Licenses__c)amt  
                                                 FROM
                                                 Instance__c
                                                 WHERE
                                                 Account__c IN:accountIds AND type__c = 'Standard'
                                                 GROUP
                                                 BY
                                                 Account__c];
            //Using Aggregate functions in SOQL, to Count(), SUM() and MAX(), for roll up and summarize data in a query.  
            if(aggresult.size()>0){
                for( AggregateResult aggr : aggresult ) {
                    Account account = new Account();  
                    account.Total_Licenses__c = (Decimal)aggr.get('amt');  
                    account.Id = (Id)aggr.get('Account__c');  
                    accountMapToUpdate.put(account.Id, account);
                }
                update accountMapToUpdate.values();
                
            }else {
                list<account> accsToUpdate = new list<account>();
                list<Account> accslst = [Select Id,Total_Licenses__c From Account Where Id In:accountIds];
                for(Account a : accslst) {
                    a.Total_Licenses__c = 0;
                    accsToUpdate.add(a);
                }
                update accsToUpdate;
            }
        }
    }
    
    public void afterUnDelete(List<sObject> newList, Map<Id, sObject> newMap) {
        
    }
}