public with sharing class OrderController extends Product{
	public String userEmail{ get; set; }

	public String userFirstName{ get; set; }

	public String userLastName{ get; set; }

	public Integer productCount{ get; set; }

	public Double orderAmount{ get; set; }

	public Double price{ get; set; }

	public OrderController(){
		this.productCount = 1;
		this.price = GetProduct().Unit_Price__c;
		this.orderAmount = this.productCount * this.price;
	}

	public Contact createOrFindContact(){
		system.debug(userEmail);
		List<Contact> orderContact = [SELECT Id, Name, Email
		                              FROM Contact
									  Where Email = :userEmail
									  WITH SECURITY_ENFORCED
		                              LIMIT 1];
		Contact contact;
		if (orderContact.size() > 0){
			contact = orderContact[0];

			contact.FirstName = userFirstName;
			contact.LastName = userLastName;
		} else{
			contact = new Contact(FirstName = userFirstName, LastName = userLastName, Email = userEmail);
		}
		upsert contact;
		return contact;
	}

	public PageReference createOrder(){
		Savepoint savePointBeforeCreateOrder = Database.setSavepoint();
		try{
			Contact contact = createOrFindContact();
			Product_Table__c productTable = GetProduct();
			Order_Table__c order = new Order_Table__c(Contact__c = contact.Id, Units__c = productCount, Order_Amount__c = orderAmount, Product__c = productTable.Id);
			insert order;

			if (productTable.Units_Available__c - productCount >= 0 && productCount > 0){
				productTable.Units_Available__c = productTable.Units_Available__c - productCount;
				update productTable;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'order created successfuly'));
				return null;
			} else{
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'dont have too much available products'));
				Database.rollback(savePointBeforeCreateOrder);
				return null;
			}
		} catch (DmlException e){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
			return null;
		}
	}

	public PageReference recalculateTotalAmount(){
		this.orderAmount = productCount * Integer.valueOf(price);
		return null;
	}
}