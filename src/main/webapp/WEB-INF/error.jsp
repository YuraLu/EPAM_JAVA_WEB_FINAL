<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setBundle basename="text"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Required meta tags -->
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <title>404 - mistake </title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>

    <!-- Custom styles for this template -->
    <link rel="stylesheet" href="css/sticky-footer-navbar.css">
</head>
<body>

<!-- Begin page content -->

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

<div class="container">
    <div class="col m-auto">
        <a href="controller?command=viewIndex"><fmt:message key="button.go_home"/></a>
        <p>
            <fmt:message key="${errorMessage}"/>
        </p>
    </div>
</div>

<footer class="footer">
    <div class="container">
        <span class="text-muted"><fmt:message key="footer.copyRight"/></span>
    </div>
</footer>
<!-- Optional JavaScript -->
<!-- jQuery first, then Popper.js, then Bootstrap JS -->

<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="js/jquery.slim.js"></script>
<script src="bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
