<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="locale"
       value="${not empty param.locale ? param.locale : not empty locale ? locale : pageContext.request.locale}"
       scope="session"/>
<fmt:setLocale value="${locale}"/>

<fmt:setBundle basename="text"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Required meta tags -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <title>
        <fmt:message key="title.signIn_page"/>
    </title>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="css/signIn.css"/>
    <script src="js/alert.js"></script>
</head>
<body>
<div class="container-fluid">
    <div class="row no-gutter">
        <div class="d-none d-md-flex col-md-4 col-lg-6 bg-image">
        </div>
        <div class="col-md-8 col-lg-6">

            <div id="localeDiv" class="input-group mb-3 justify-content-end">
                <c:import url="/WEB-INF/jsp/common/localeDiv.jsp">
                    <c:param name="paramRedirect" value="viewSignIn"/>
                </c:import>
            </div>

            <div class="login d-flex align-items-center py-5">
                <div class="container">
                    <div class="row">
                        <div class="col-md-9 col-lg-8 mx-auto">
                            <h3 class="login-heading mb-4"><fmt:message key="signIn_page.welcome"/></h3>
                            <form action="controller" method="post" >
                                <div class="form-label-group">
                                    <input type="text" id="inputLogin" name="login" class="form-control"
                                           placeholder="Login" required autofocus  aria-describedby="loginHelpBlock">
                                    <label for="inputLogin">
                                        <fmt:message key="registration.enter_login_message"/>
                                    </label>

                                    <div class="invalid-feedback">
                                        <fmt:message key="login.login_pattern"/>
                                    </div>

                                </div>
                                <div class="form-label-group">
                                    <input type="password" id="inputPassword" name="password" class="form-control"
                                           placeholder="Password" required aria-describedby="passwordHelpBlock">
                                    <label for="inputPassword">
                                        <fmt:message key="registration.enter_password_message"/>
                                    </label>
                                    <div class="invalid-feedback">
                                        <fmt:message key="login.pass_pattern"/>
                                    </div>

                                </div>
                                <button class="btn btn-lg btn-primary btn-block btn-login
                                                    text-uppercase font-weight-bold mb-2"
                                        type="submit" name="command" value="signIn">
                                    <fmt:message key="button.signIn"/>
                                </button>
                                <div class="text-center">
                                    <a class="small" href="controller?command=viewSignUp">
                                        <fmt:message key="button.signUp"/>
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<c:if test="${errorMessage != null}">
    <script>
        showAlert("<fmt:message key="${errorMessage}"/>");
    </script>

    <c:if test="${errorMessage == 'message.successful_login'}">
        <c:remove var="errorMessage"/>
        <c:redirect url="controller?command=viewUserCabinet"/>
    </c:if>
</c:if>
<c:remove var="errorMessage"/>

<!-- Optional JavaScript -->
<!-- jQuery first, then Popper.js, then Bootstrap JS -->
<script src="js/jquery-3.4.1.min.js"></script>
<script src="bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>