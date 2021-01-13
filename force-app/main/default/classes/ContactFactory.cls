public class ContactFactory{
	public static List<Contact> createContacts(Integer amount){
		List<Contact> contacts = new List<Contact>();
		for (Integer counter = 0; counter < amount; ++counter){
			contacts.add(new Contact(FirstName = 'name_' + counter, LastName = 'surname_' + counter, Email = 'example_' + counter + '@example.com'));
		}
		return contacts;
	}
}