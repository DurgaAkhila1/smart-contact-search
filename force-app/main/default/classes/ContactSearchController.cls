/**
 * ContactSearchController
 * Search Contacts by name, email, phone or account name.
 * Uses bind variables (safe from SOQL injection) and USER_MODE
 * (respects sharing, object and field permissions).
 */
public with sharing class ContactSearchController {

    @TestVisible private static final Integer MIN_CHARS = 2;
    @TestVisible private static final Integer MAX_RESULTS = 50;

    @AuraEnabled(cacheable=true)
    public static List<Contact> searchContacts(String searchTerm) {
        String term = searchTerm == null ? '' : searchTerm.trim();
        if (term.length() < MIN_CHARS) {
            return new List<Contact>();
        }
        String pattern = '%' + term + '%';
        return [
            SELECT Id, Name, Title, Email, Phone, Account.Name
            FROM Contact
            WHERE Name LIKE :pattern
               OR Email LIKE :pattern
               OR Phone LIKE :pattern
               OR Account.Name LIKE :pattern
            WITH USER_MODE
            ORDER BY Name
            LIMIT :MAX_RESULTS
        ];
    }
}
