public class ProductFactory{
	public static List<Product_Table__c> createProducts(Integer amount){
		List<Product_Table__c> products = new List<Product_Table__c>();
		for (Integer counter = 0; counter < amount; ++counter){
			products.add(new Product_Table__c(Name = 'Test ' + counter, Units_Available__c = 200, Unit_Price__c = 1));
		}
		return products;
	}
}