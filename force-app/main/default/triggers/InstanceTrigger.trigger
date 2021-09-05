/*
@Author : Praneeth
@CreatedDate : 05th Sep 2021
@Description : Instance Object Trigger.
*/
trigger InstanceTrigger on Instance__c(before insert, after insert, before update, after update, before delete, after delete, after unDelete) {
    TriggerDispatcher.run(new InstanceTriggerHandler(), 'InstanceTrigger');
}