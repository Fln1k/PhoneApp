@isTest
public class ProductTest{
	@testSetup
	static void setup(){
		insert ProductFactory.createProducts(200);
	}

	@isTest
	static void getProductsTest(){
		PageController pageController = new PageController();

		System.assertEquals(100, pageController.GetProducts().size(), 'wrong product count');
		System.assertEquals(200, [SELECT count()
								  FROM Product_Table__c],
								  'wrong product count');
	}

	@isTest
	static void getProductTest(){
		PageController pageController = new PageController();
		Product_Table__c product = [SELECT Id, Name
		                           FROM Product_Table__c
		                           LIMIT 1];

		PageReference prodPage = Page.Product_Page;
		Test.setCurrentPage(prodPage);
		ApexPages.currentPage().getParameters().put('id', product.Id);

		System.assertEquals(product.Name, pageController.getProduct().Name,'wrong product name');
	}
}