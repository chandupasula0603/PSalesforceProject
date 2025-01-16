/*public class RegistrationEmailHandler {
    
    
    @InvocableMethod(label='Update Emails in Event' description='Update emails in the event object')
    public static list<String> updatePhone(List<String> emailList){
        
        system.debug(emailList);
        List<String> result = new List<String>();
        string emailTest = emailList + 'end';
        result.add(emailTest);
        
        return result;
        
        
        
    }

}



public class RegistrationEmailHandler {
    @InvocableMethod(label='Check Non-Salesforce Emails' description='Returns emails not associated with Salesforce users')
    public static List<String> updateEmails(List<String> emailList) {
        String nonSalesforceEmails = '';  // Variable to hold non-Salesforce emails

        // Iterate through the input list (typically has one element, the input string)
        for (String emailString : emailList) {
            // Split the semicolon-separated emails into individual emails
            List<String> individualEmails = emailString.split(';');

            // Process each email
            for (String email : individualEmails) {
                email = email.trim().toLowerCase();  // Remove extra spaces and make case-insensitive

                // Query matching users based on the email
                List<User> matchedUsers = [
                    SELECT Id 
                    FROM User 
                    WHERE Email = :email
                ];

                // Debug the matched users
                System.debug('Matched Users for ' + email + ': ' + matchedUsers);

                // If no match found, add to non-Salesforce-user emails
                if (matchedUsers.isEmpty()) {
                    if (nonSalesforceEmails == '') {  // Check if the string is empty
                        nonSalesforceEmails = email;
                    } else {
                        nonSalesforceEmails += ';' + email;
                    }
                }
            }
        }

        // Return the result as a single-element list for Flow compatibility
        return new List<String>{nonSalesforceEmails};
    }
}*/






public class RegistrationEmailHandler {
    @InvocableMethod(label='Check Non-Salesforce Emails' description='Returns emails not associated with Salesforce users')
    public static List<String> updateEmails(List<String> emailList) {
        String nonSalesforceEmails = '';  // Variable to hold non-Salesforce emails

        // Step 1: Collect all unique emails from the input list and prepare the query
        Set<String> emailSet = new Set<String>();
        String sample = emailList[0];
        List<String> individualEmails = sample.split(';');
        system.debug(sample);
            for (String email : individualEmails) {
                emailSet.add(email.trim().toLowerCase());  // Collect unique emails
            }
        

        // Step 2: Query all users whose email addresses are in the emailSet
        List<User> matchedUsers = [
            SELECT Email 
            FROM User 
            WHERE Email IN :emailSet
        ];
         system.debug(matchedUsers);

        // Step 3: Create a Set for quick look-up of Salesforce user emails
        Set<String> matchedEmailSet = new Set<String>();
        for (User u : matchedUsers) {
            matchedEmailSet.add(u.Email.toLowerCase());  // Store emails in a set (case-insensitive)
        }

        // Step 4: Check each email in the original list to see if it is not a Salesforce user
        for (String email : emailSet) {
            if (!matchedEmailSet.contains(email)) {
                if (nonSalesforceEmails == '') {  // Check if the string is empty
                    nonSalesforceEmails = email;
                } else {
                    nonSalesforceEmails += ';' + email;
                }
            }
        }
         system.debug(nonSalesforceEmails);

        // Step 5: Return the result as a single-element list for Flow compatibility
        return new List<String>{nonSalesforceEmails};
    }
}