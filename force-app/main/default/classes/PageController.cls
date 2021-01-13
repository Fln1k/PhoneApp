public class PageController extends Product{
	public OrderController orderController;
	public PageController(OrderController orderController){
		this.orderController = orderController;
	}

	public PageController(){
	}

	public PageReference showDetailPage(){
		PageReference page = new PageReference('/apex/Product_Page?id=' + productId + 
												'&retURL=' + Apexpages.currentPage().getUrl());
		page.setRedirect(true);
		return page;
	}

	public PageReference showProductList(){
		PageReference page = new PageReference('/apex/Product_List?retURL=' + Apexpages.currentPage().getUrl());
		page.setRedirect(true);
		return page;
	}

	public PageReference createOrderPage(){
		PageReference page = new PageReference('/apex/Create_Order_Page?id=' + productId + 
												'&retURL=' + Apexpages.currentPage().getUrl());
		page.setRedirect(true);
		return page;
	}

	public PageReference returnToPreviousPage(){
		String previousPageUrl = ApexPages.currentPage().getParameters().get('retURL');
		String productId = ApexPages.currentPage().getParameters().get('id').escapeHtml4();
		String currentPageUrl = previousPageUrl.split('\\?')[0]+'?id=' + productId + '&retURL=' + Apexpages.currentPage().getUrl().escapeHtml4();
		PageReference page = new PageReference(currentPageUrl);
		page.setRedirect(true);
		return page;
	}
}