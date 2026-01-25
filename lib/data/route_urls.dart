class RouteUrls{

/// Auth url


static final String loginURL = "user/login";
static final String signUPUrl ="user/register";
static const String storeDetails = "store/storeDetails";
static const String sendEmailOTP = "user/sendEmailOtp";
static const String verifyEmailOTP ="user/verifyEmailOTP";
static const String mobileOTP ="user/verifySmsOTP";
static const String storeCategory = "store/getAllStoreCategories";
static const String storeBusinessType = "api/adminStoreBusinessType/get";
static const String createStoreDetails = "store/create";
static const String addStoreUser = "api/storeAndStoreUserRegister";
static const String updateStoreDetails ="store/update";
static const String uploadDocuments = "store/upload";
static const String searchUser ="api/get-SUUsers";
static const String updateStoreUser = "api/update-storeAndStoreUser";
static const String getPharmacyStore = "api/item/get";
static const String addpharmacyUser = "store/storeDetails";
static const String postPharmacyUser ="api/item/add";
static const String SearchPharmacyUser ="api/item/";
static const String updatePharmacystore ="api/item/update";
static const String getRackManagement = "api/rack-order/";
static const String deleteUser = "rack-order/";
static const String purchaseReport = "purchase/report/get-purchase-invoice";
static const String salesReport = "sale/report/get-sale-invoice";
static const String searchInVoiceItem ="stock/get-distinct-itemName";
static const String searchInVoiceByName = "stock/get-itemCode-by-itemName-enhanced?itemName";
static const String searchManualStockByName = "api/item/search-by-itemname";
static const String getPriceMange = "stock/get-stock-report";
static const String addPriceManage ="api/item-offer/add";
static const String postsale = "sale/add";
static const String gstReport = "purchase/gst-sale-purchase-summary";
static const String customerManagement = "customerRegister";
static const String searchCustomerOrder ="get-orderId-by-search?";
static const String addPurchaseVoice ="purchase/add";
static const String fetchInvoiceData= "purchase/report/get-purchase-invoice-details";
static const String fetchSalesReport ="sale/report/get-sale-invoice-details";
static const String postDeliveryStatus = "api/delivery-ready/add";
static const String onlineOrder = "api/customer-store/customerstoreinfo-by-customer";


}
