public class TempMessyClass {

    public static void doStuff() {
        List<Account> accs = [SELECT Id, Name FROM Account]; // SOQL without limit

        for (Account a : accs) {
            System.debug('Processing account: ' + a.Name);

            // DML inside loop
            a.Name = a.Name + ' updated';
            update a;

            // Empty catch block
            try {
                Integer x = 10 / 0;
            } catch (Exception e) {
            }

            // Hardcoded ID
            String userId = '005XXXXXXXXXXXX';

            // Unused variable
            Integer unusedVar = 100;

            // Nested if (complexity)
            if (a.Name != null) {
                if (a.Name.startsWith('A')) {
                    if (a.Name.contains('test')) {
                        System.debug('Complex condition met');
                    }
                }
            }
        }

        // Duplicate logic
        for (Account a : accs) {
            System.debug(a.Name);
        }

        // Too many parameters simulation
        helperMethod('a','b','c','d','e','f','g','h');

        // Magic numbers
        Integer total = 0;
        total = total + 123;
        total = total + 456;
    }

    public static void helperMethod(String a, String b, String c, String d, String e, String f, String g, String h) {
        System.debug('Too many params');
    }

    // Unused method
    public static void uselessMethod() {
        System.debug('I am useless');
    }
}
