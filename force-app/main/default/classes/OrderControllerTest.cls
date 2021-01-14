@isTest
public class OrderControllerTest{
	@testSetup
	static void setup(){
		insert ProductFactory.createProducts(200);
	}
	
	@isTest
	static OrderController prepareOrderController(Contact testContact){
		Product_Table__c product = [SELECT Id, Name, Units_Available__c
		                           FROM Product_Table__c
		                           LIMIT 1];
		ApexPages.currentPage().getParameters().put('id', product.Id);
		OrderController orderController = new OrderController();
		orderController.userEmail = testContact.Email;
		orderController.userFirstName = testContact.FirstName;
		orderController.userLastName = testContact.LastName;
		orderController.productCount = 1;

		return OrderController;
	}

	@isTest
	static void findContact(){
		Contact testContact = ContactFactory.createContacts(1)[0];
		insert testContact;
		OrderController orderController = prepareOrderController(testContact);

		Contact contactFind = orderController.createOrFindContact();

		System.assertEquals(testContact.Email, contactFind.Email, 'wrong email');
	}

	@isTest
	static void createContactWhenNotFind(){
		Contact testContact = ContactFactory.createContacts(1)[0];
		OrderController orderController = prepareOrderController(testContact);

		System.assertEquals(0, [SELECT count()
		                        FROM Contact
		                        Where Email = :testContact.Email
		                        LIMIT 1], 'initial contacts count not 0');

								orderController.createOrFindContact();

		Contact newContact = [SELECT Email
		                       FROM Contact
		                       Where Email = :testContact.Email
		                       LIMIT 1];

		System.assertEquals(testContact.Email, newContact.Email, 'wrong email');
	}

	@isTest
	static void updateContact(){
		Contact testContact = ContactFactory.createContacts(1)[0];
		OrderController orderController = prepareOrderController(testContact);
		String prefix = '_test';

		Contact contactBeforeNameChange = orderController.createOrFindContact();
		orderController.userLastName = testContact.LastName + prefix;
		Contact contactAfterNameChange = orderController.createOrFindContact();

		System.assertEquals(contactBeforeNameChange.LastName + prefix, contactAfterNameChange.LastName, 'wrong contact info after update contact');
	}

	@isTest
	static void createOrderWithValidParams(){
		Contact testContact = ContactFactory.createContacts(1)[0];
		OrderController orderController = prepareOrderController(testContact);

		orderController.recalculateTotalAmount();
		orderController.createOrder();

		System.assertEquals(199, orderController.GetProduct().Units_Available__c, 'wrong number of available products after creating order');
	}

	@isTest
	static void dontcreateOrderWithNotValidParams(){
		Contact testContact = ContactFactory.createContacts(1)[0];
		OrderController orderController = prepareOrderController(testContact);
		orderController.productCount = 201;

		orderController.recalculateTotalAmount();
		orderController.createOrder();

		System.assertEquals(200, orderController.GetProduct().Units_Available__c, 'wrong number of available products after cancel order creation');
	}
}