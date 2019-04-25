public with sharing class ValidateUNSCStatus {
    public  void ValidateUNSCStatusContact() {
   List<contact> conlist = [select id,firstname,lastname,Present_in_SanctionedList__c from contact ];
   for(contact con:conlist){
       integer  count_sanclist = [select count() from SanctionedList__c
                                  where (name = :con.firstname) AND
                                ((SECOND_NAME__c = :con.lastname) or
                                (third_NAME__c   = :con.lastName))];
         if (count_sanclist > 0 )
        {
            con.Present_in_SanctionedList__c  = 'Yes';
        } else {
            con.Present_in_SanctionedList__c  = 'No';
        }
        update con;
   }
     
    }
    public void ValidateUNSCStatusAccount() {
   List<account> acclist = [select id,name,Present_in_SanctionedList__c from account ];
   for(account acc:acclist){
       integer  count_sanclist = [select count() from SanctionedList__c
                                  where name = :acc.name]; /*AND
                                (Second_NAME__c = :acc.name or
                                third_NAME__c  = :acc.Name)];*/
         if (count_sanclist > 0 )
        {
            acc.Present_in_SanctionedList__c  = 'Yes';
        } else {
            acc.Present_in_SanctionedList__c  = 'No';
        }
        update acc;
   }
     
    }
}
