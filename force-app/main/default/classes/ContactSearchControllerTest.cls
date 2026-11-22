@IsTest
private class ContactSearchControllerTest {

    @TestSetup
    static void setup() {
        Account acme = new Account(Name = 'Acme Rockets');
        insert acme;
        insert new List<Contact>{
            new Contact(FirstName = 'Priya', LastName = 'Sharma', Email = 'priya@acme.test', AccountId = acme.Id),
            new Contact(FirstName = 'John', LastName = 'Doe', Email = 'jdoe@globex.test', Phone = '5551234567'),
            new Contact(FirstName = 'Maria', LastName = 'Lopez', Email = 'maria@initech.test')
        };
    }

    @IsTest
    static void findsByName() {
        List<Contact> r = ContactSearchController.searchContacts('priya');
        Assert.areEqual(1, r.size());
        Assert.areEqual('Priya Sharma', r[0].Name);
    }

    @IsTest
    static void findsByEmailPhoneAndAccount() {
        Assert.areEqual(1, ContactSearchController.searchContacts('globex').size(), 'email match');
        Assert.areEqual(1, ContactSearchController.searchContacts('555123').size(), 'phone match');
        Assert.areEqual(1, ContactSearchController.searchContacts('Acme').size(), 'account match');
    }

    @IsTest
    static void shortOrBlankTermReturnsNothing() {
        Assert.isTrue(ContactSearchController.searchContacts('a').isEmpty());
        Assert.isTrue(ContactSearchController.searchContacts('   ').isEmpty());
        Assert.isTrue(ContactSearchController.searchContacts(null).isEmpty());
    }

    @IsTest
    static void quotesDoNotBreakQuery() {
        // Bind variables make injection attempts harmless
        Assert.isTrue(ContactSearchController.searchContacts('\' OR Name != \'').isEmpty());
    }
}
