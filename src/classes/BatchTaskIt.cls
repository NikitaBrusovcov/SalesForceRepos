public with sharing class BatchTaskIt implements Database.Batchable<sObject> {
    public Iterable<SObject> start(Database.BatchableContext batchableContext) {
        System.debug('Begin!');
        return [
                SELECT Id,
                        AccountId,
                        account.BillingAddress,
                        account.BillingCountry,
                        account.BillingCity,
                        account.BillingPostalCode,
                        account.BillingStreet,
                        account.BillingState
                FROM Contact
                WHERE Is_Synced__c = FALSE
        ];
    }

    public void execute(Database.BatchableContext batchableContext, List<Contact> contacts) {
        System.debug('Execute');
        List<Account> accounts = new List<Account>();
        for (Contact contact : contacts) {
            Account account = contact.Account;
            contact.MailingCountry = account.BillingCountry;
            contact.MailingCity = account.BillingCity;
            contact.MailingPostalCode = account.BillingPostalCode;
            contact.MailingStreet = account.BillingStreet;
            contact.MailingState = account.BillingState;
            contact.Is_Synced__c = true;
            account.Updated_By_Contact__c = true;
            accounts.add(account);
        }
        update contacts;
        update accounts;

    }

    public void finish(Database.BatchableContext batchableContext) {
        System.debug('End!');
    }
}