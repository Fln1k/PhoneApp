public abstract with sharing class Product{
	public String productId{ get; set; }

	public List<Product_Table__c> getProducts(){
		return [SELECT Id, Name, Image_Url__c, Product_Description__c, Unit_Price__c
				FROM Product_Table__c
				WITH SECURITY_ENFORCED
		        LIMIT 100];
	}

	public Product_Table__c getProduct(){
		String productId = apexpages.currentpage().getparameters().get('id');
		return [Select Id, Name, Image_Url__c, Product_Description__c, Unit_Price__c, Units_Available__c
		        FROM Product_Table__c
				Where Id = :productId
				WITH SECURITY_ENFORCED
		        Limit 1];
	}
}