@isTest
public class PageControllerTest{
	@testSetup
	static void setup(){
		insert ProductFactory.createProducts(200);
	}

	@isTest
	static void createPageControllerObjectWithOrderControllerExtands(){
		String testEmail = 'test_email';
		Product_Table__c product = [SELECT Id, Name, Units_Available__c
		                           FROM Product_Table__c
		                           LIMIT 1];
		ApexPages.currentPage().getParameters().put('id', product.Id);
		OrderController orderController = new OrderController();
		orderController.userEmail = testEmail;

		PageController pageController = new PageController(orderController);

		system.assertEquals(testEmail, pageController.OrderController.userEmail, 'wrong order controller assign in product page controller');
	}

	@isTest
	static void showDetailPage(){
		PageController pageController = new PageController();
		Product_Table__c product = [SELECT Id, Name
		                           FROM Product_Table__c
		                           LIMIT 1];
		pageController.productId = product.id;

		pageReference detailPage = pageController.showDetailPage();

		System.assertEquals(product.id, detailPage.getParameters().get('id'), 'wrong product id on detail page');
	}

	@isTest
	static void showProductList(){
		PageController pageController = new PageController();

		pageReference productListPage = pageController.showProductList();

		System.assertEquals(productListPage.getUrl().substring(0, 18), '/apex/Product_List', 'wrong pruduct list link');
	}

	@isTest
	static void showcreateOrderPage(){
		PageController pageController = new PageController();
		Product_Table__c product = [SELECT Id, Name
		                           FROM Product_Table__c
		                           LIMIT 1];
		pageController.productId = product.id;

		pageReference createOrderPage = pageController.createOrderPage();

		System.assertEquals(product.id, createOrderPage.getParameters().get('id'), 'wrong product id on create order page');
	}

	@isTest
	static void redirectToPreviousPage(){
		PageController pageController = new PageController();
		Product_Table__c product = [SELECT Id, Name
		                           FROM Product_Table__c
		                           LIMIT 1];
		pageController.productId = product.id;
		Test.setCurrentPage(pageController.showDetailPage());
		Test.setCurrentPage(pageController.createOrderPage());

		pageReference previousPage = pageController.returnToPreviousPage();
		system.assertEquals('/apex/Product_Page', previousPage.getUrl().substring(0, 18), 'wrong previous page link');
	}
}