trigger SanctionedAccount on account(before insert,before update) {
if (trigger.isInsert) {
    AccountTriggerHandler.handleBeforeInsert(trigger.new);
}
if(trigger.isUpdate){
     AccountTriggerHandler.handleBeforeUpdate(trigger.new);   
}
}