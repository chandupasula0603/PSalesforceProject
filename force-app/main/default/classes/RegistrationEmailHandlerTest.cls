@isTest
public class RegistrationEmailHandlerTest {
    @isTest
    static void testUpdateEmails() {
        // Step 1: Set up test data
        List<User> testUsers = new List<User>{
            new User(
                FirstName = 'Test',
                LastName = 'User1',
                Email = 'user1@salesforce.com',
                Username = 'user1@salesforce.com.test',
                Alias = 'user1',
                CommunityNickname = 'user1',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
                LanguageLocaleKey = 'en_US'
            ),
            new User(
                FirstName = 'Test',
                LastName = 'User2',
                Email = 'user2@salesforce.com',
                Username = 'user2@salesforce.com.test',
                Alias = 'user2',
                CommunityNickname = 'user2',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
                LanguageLocaleKey = 'en_US'
            )
        };
        insert testUsers;

        // Step 2: Define the input email list
        List<String> inputEmails = new List<String>{
            'user1@salesforce.com;user2@salesforce.com;nonuser@gmail.com;test@example.com'
        };

        // Step 3: Call the method
        Test.startTest();
        List<String> result = RegistrationEmailHandler.updateEmails(inputEmails);
        Test.stopTest();

        // Step 4: Validate the results
        System.assertEquals(1, result.size(), 'There should be one result returned');
        System.assert(result[0].contains('nonuser@gmail.com'), 'The result should contain non-Salesforce emails');
        System.assert(result[0].contains('test@example.com'), 'The result should contain non-Salesforce emails');
        System.assert(!result[0].contains('user1@salesforce.com'), 'The result should not contain Salesforce emails');
        System.assert(!result[0].contains('user2@salesforce.com'), 'The result should not contain Salesforce emails');
    }
}