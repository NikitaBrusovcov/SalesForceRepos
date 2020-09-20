public with sharing class FutureTask {

    @Future
    public static void firstFutureMethod(){
        List<Contact> contacts = new List<Contact>();
        for(Account account : [
                SELECT BillingAddress, (SELECT Id, Is_Synced__c, Processed_By_Future__c FROM Contacts)
                FROM Account
                LIMIT 150
        ]){
            if (account.BillingAddress != null){
                contacts.add(account.Contacts);
            }
        }
        if (!contacts.isEmpty()){
            for(Contact contact : contacts){
                contact.Is_Synced__c = false;
                contact.Processed_By_Future__c = true;
            }
            update contacts;
        }
    }
}