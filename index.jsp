<%@ page language="java" contentType="text/html; charset=ISO-8859-1" 
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.Likhil.service.impl.*,com.Likhil.service.*,com.Likhil.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Tribal Handicrafts</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>

<!DOCTYPE LikhilIndexPageBgColor--- > 
<body style="background-color: #CCCCFF;">


	<%
	/* Checking the user credentials */
	String userName = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");
	String userType = (String) session.getAttribute("usertype");

	boolean isValidUser = true;

	if (userType == null || userName == null || password == null || !userType.equals("customer")) {

		isValidUser = false;
	}

	ProductServiceImpl prodDao = new ProductServiceImpl();
	List<ProductBean> products = new ArrayList<ProductBean>();

	String search = request.getParameter("search");
	String type = request.getParameter("type");
	String message = "All Products";
	if (search != null) {
		products = prodDao.searchAllProducts(search);
		message = "Showing Results for '" + search + "'";
	} else if (type != null) {
		products = prodDao.getAllProductsByType(type);
		message = "Showing Results for '" + type + "'";
	} else {
		products = prodDao.getAllProducts();
	}
	if (products.isEmpty()) {
		message = "No items found for the search '" + (search != null ? search : type) + "'";
		products = prodDao.getAllProducts();
	}
	%>
	
<!-- Bootstrap Carousel (Dynamic from Products List) -->
<div id="productCarousel" class="carousel slide" data-ride="carousel" style="margin-top: 30px;">
    <!-- Indicators -->
    <ol class="carousel-indicators">
        <%
        int i = 0;
        for (ProductBean product : products) {
        %>
            <li data-target="#productCarousel" data-slide-to="<%=i%>" class="<%= (i == 0) ? "active" : "" %>"></li>
        <%
            i++;
        }
        %>
    </ol>

    <!-- Wrapper for slides -->
    <div class="carousel-inner">
        <%
        int j = 0;
        for (ProductBean product : products) {
            String prodImage = "./ShowImage?pid=" + product.getProdId(); // Assuming this servlet returns the product image
            String buyNowLink = "./AddtoCart?uid=" + userName + "&pid=" + product.getProdId() + "&pqty=1";
        %>
            <div class="item <%= (j == 0) ? "active" : "" %>">
                <!-- Clickable image to redirect to 'Buy Now' page -->
                <a href="<%= buyNowLink %>">
                    <img src="<%= prodImage %>" alt="<%= product.getProdName() %>" style="width:100%; max-height: 600px; object-fit: contain;">
                </a>
                <div class="carousel-caption">
                    <h3><%= product.getProdName() %></h3>
                    <p><%= product.getProdInfo() %></p>
                    <!-- Button for "Buy Now" -->
                    <a href="<%= buyNowLink %>" class="btn btn-primary">Buy Now</a>
                </div>
            </div>
        <%
            j++;
        }
        %>
    </div>

    <!-- Left and right controls -->
    <a class="left carousel-control" href="#productCarousel" data-slide="prev">
        <span class="glyphicon glyphicon-chevron-left"></span>
        <span class="sr-only">Previous</span>
    </a>
    <a class="right carousel-control" href="#productCarousel" data-slide="next">
        <span class="glyphicon glyphicon-chevron-right"></span>
        <span class="sr-only">Next</span>
    </a>
</div>

	

	<jsp:include page="header.jsp" />
	
	
	
	
	
	
	<!-- Start of Product Items List -->
	<div class="container">
		<div class="row text-center">

			<%
			for (ProductBean product : products) {
				int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId());
			%>
			<div class="col-sm-4" style='height: 350px;'>
				<div class="thumbnail">
					<img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product"
						style="height: 150px; max-width: 180px">
					<p class="productname"><%=product.getProdName()%>
					</p>
					<%
					String description = product.getProdInfo();
					description = description.substring(0, Math.min(description.length(), 100));
					%>
					<p class="productinfo"><%=description%>..
					</p>
					<p class="price">
						Rs
						<%=product.getProdPrice()%>
					</p>
					<form method="post">
						<%
						if (cartQty == 0) {
						%>
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1"
							class="btn btn-success">Add to Cart</button>
						&nbsp;&nbsp;&nbsp;
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1"
							class="btn btn-primary">Buy Now</button>
						<%
						} else {
						%>
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0"
							class="btn btn-danger">Remove From Cart</button>
						&nbsp;&nbsp;&nbsp;
						<button type="submit" formaction="cartDetails.jsp"
							class="btn btn-success">Checkout</button>
						<%
						}
						%>
					</form>
					<br />
				</div>
			</div>

			<%
			}
			%>

		</div>
	</div>
	<!-- ENd of Product Items List -->

	
	
	
	
	
	
	
	
	
	
	
	
	

	<%@ include file="footer.html"%>

</body>
</html>
