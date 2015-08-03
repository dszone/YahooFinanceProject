<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Yahoo Finance System</title>
<link href='http://fonts.googleapis.com/css?family=Oxygen' rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=Orbitron' rel='stylesheet' type='text/css'>
<link href="css/bootstrap.css" rel="stylesheet">
<link href="css/bootstrap-theme.min.css" rel="stylesheet">

<style type="text/css">

.alert {
	color: red;
	line-height: 16px;
	position: relative;
	right: 0px;
}

.yahoo {
	color: green;
	font-size: 36px;
	letter-spacing: 3px;
	font-family: 'Orbitron', sans-serif;
	font-weight: 700;
}

.finance {
	color: #D00000;
	font-size: 36px;
	letter-spacing: 3px;
	font-family: 'Orbitron', sans-serif;
	font-weight: 700;
}

footer {
	text-align: center;
	background-color: #d0e4fe;
	padding: 10px;
}

.item{
    background: #333;    
    text-align: center;
    height: 320px !important;
}
.carousel{
    margin-top: -18px;
}
.slide_pic{
	margin-left: 55px;
	margin-right: 55px;
	margin-bottom:20px;
}
#well{
	margin-left: 40px;
	margin-right: 40px;
}
input.ng-invalid.ng-dirty{
	border: 2px solid #FF6666;
}
.col-md-4 {
	color: red;
}
body,html {
	height:100%;
	width:100%;
	overflow-x: hidden;
}
</style>
<script
	src="js/jquery.min.js">
</script>
<script src= "js/angular.min.js"></script>
<script src="js/angular-resource.min.js"></script><!-- angularJS Ajax call: http call -->
<script src="js/bootstrap.js"></script>
<script src="js/script.js"></script>

<script>
	$(document).ready(function() {
		if ("<c:out value='${param.login_error}'/>" != "") {
			$('#wrongCredentials').show();
			//Auto fade out alert block
			window.setTimeout(function() {
				$('#wrongCredentials').fadeTo(1500, 0).slideUp(500);
			}, 2000);
		}
		
 		<c:if test="${isUserExist}">
	    	//alert("This user already exist!");
	    	$("#userExist").show();
			$("#signup").trigger("click");
		</c:if>
		<c:if test="${registerResult}">
			alert("Registration success\nCheck your email to complete your registration");
		</c:if>	
		
		$("#signin").on("click", loginValidation);
		
	});
	function loginValidation() {
		$("#usernameAndPasswordReq").hide();
		$("#usernameReq").hide();
		$("#passwordReq").hide();
		$("#wrongCredentials").hide();
		if ($("#j_username").val().length == 0
				&& $("#j_password").val().length == 0) {
			$("#usernameAndPasswordReq").show();
			//Auto fade out alert block
			window.setTimeout(function() {
				$('#usernameAndPasswordReq').fadeTo(1500, 0).slideUp(500);
			}, 2000);
			return false;
		} else if ($("#j_username").val().length == 0) {
			$('#usernameReq').show();
	 		//Auto fade out alert block
	 		window.setTimeout(function() {
				$('#usernameReq').fadeTo(1500, 0).slideUp(500);
			}, 2000);
			return false;
		} else if ($("#j_password").val().length == 0) {
			$("#passwordReq").show();
			//Auto fade out alert block
			window.setTimeout(function() {
				$('#passwordReq').fadeTo(1500, 0).slideUp(500);
			}, 2000);
			return false;
		} else {
			return true;
		}
	}

</script>

<script>
	var app = angular.module('MyApp', []);

	app.controller('appCtrl', function($scope, $http) {
		$scope.user = {
			username : "",
			password : "",

		};
		$scope.users = [];

	});

	app.directive("passwordVerify", function() {
		return {
			require : "ngModel",
			scope : {
				passwordVerify : '='
			},
			link : function(scope, element, attrs, ctrl) {
				scope.$watch(
						function() {
							var combined;

							if (scope.passwordVerify || ctrl.$viewValue) {
								combined = scope.passwordVerify + '_'
										+ ctrl.$viewValue;
							}
							return combined;
						}, function(value) {
							if (value) {
								ctrl.$parsers.unshift(function(viewValue) {
									var origin = scope.passwordVerify;
									if (origin !== viewValue) {
										ctrl.$setValidity("passwordVerify",
												false);
										return undefined;
									} else {
										ctrl.$setValidity("passwordVerify",
												true);
										return viewValue;
									}
								});
							}
						});
			}
		};
	});

	var md5Encrypt = function(form) {
		$("#r_password").val((md5($("#r_password").val())));
		return true;
	}
	var loginEncrypt = function(form) {
		$("#j_password").val(md5($("#j_password").val()));
		return true;
	}
</script>

</head>
<body ng-app="MyApp">
	<!-- navigation bar -->
	<div class="navbar navbar-default navbar-static-top">
		<!-- Login Form -->
		<div class="container">
			<a class="navbar-header" href="/YahooFinanceProject/login.html"><img src="images/dollar2.jpg" height="50" width="50"></a> 
			<a class="navbar-header" href="/YahooFinanceProject/login.html"> 
				<span class="yahoo">YAHOO</span> <span class="finance">FINANCE</span>
			</a>
				
			<form class="navbar-form navbar-right" name="f"
				action="<c:url value='j_spring_security_check'/>" method="POST"
				id="login-form">
				<!-- Alerts for missing form info  -->
				<div>
					<div class="alert alert-warning" style="display: none;" id="usernameAndPasswordReq">
						<p><strong>Warning!</strong> Username and password are required</p>
					</div>
					<div class="alert alert-warning" style="display: none;" id="usernameReq">
						<p><strong>Warning!</strong> Username is required</p>
					</div>
					<div class="alert alert-warning" style="display: none;" id="passwordReq">
						<p><strong>Warning!</strong> Password is required</p>
					</div>
					<div class="alert alert-warning" id="wrongCredentials" style="display: none;">
						<p><strong>Warning!</strong> The Username or Password you entered is incorrect.</p>
					</div>
				</div>
				
				<div class="form-group">
					<input class="form-control" value="" type="text" name="j_username" id="j_username" placeholder="Username" />
					<input class="form-control" value="" type="password" name="j_password" id="j_password" placeholder="Password" />
					<button type="reset" class="btn btn-success">Clear</button>
					<button id="signin" type="submit" class="btn btn-warning">
						<span class="glyphicon glyphicon-user"></span>Sign In
					</button>
				</div>
			</form>
		</div>
	</div>
	
	<div class="slide_pic">
    <div id="myCarousel" class="carousel slide" data-interval="3000" data-ride="carousel">
    	<!-- Carousel indicators -->
        <ol class="carousel-indicators">
            <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
            <li data-target="#myCarousel" data-slide-to="1"></li>
            <li data-target="#myCarousel" data-slide-to="2"></li>
        </ol>   
       <!-- Wrapper for carousel items -->
        <div class="carousel-inner">
            <div class="active item">
                <img id="bluestock" src="images/stock-blue.png" class="img-responsive">
                <div class="carousel-caption">
                  <h3>Watch the real-time market data</h3>
                  <p>Global finance market is under your control.</p>
                </div>
            </div>
            <div class="item">
                <img id="bluestock" src="images/stock-trade.jpg" class="img-responsive">
                <div class="carousel-caption">
                  <h3>Buy or sell stocks</h3>
                  <p>Buy or sell a stock can never be so eazy like this. </p>
                </div>
            </div>
            <div class="item">
                <img id="bluestock" src="images/stock-red.jpg" class="img-responsive">
                <div class="carousel-caption">
                  <h3>Visualize transaction history</h3>
                  <p>View the portfolio and transaction history in different visualization formats.</p>
                </div>
            </div>
        </div>
        <!-- Carousel controls -->
        <a class="carousel-control left" href="#myCarousel" data-slide="prev">
            <span class="glyphicon glyphicon-chevron-left"></span>
        </a>
        <a class="carousel-control right" href="#myCarousel" data-slide="next">
            <span class="glyphicon glyphicon-chevron-right"></span>
        </a>
    </div>
</div>
	

	<!-- Modal -->  

  <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
      	<!-- modal header -->
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span></button>
          <h4 class="modal-title" id="myModalLabel">Forms</h4>
        </div>
        <!-- modal body -->
        <div class="modal-body">
          <form class="form-horizontal" name="registerform" onSubmit="md5Encrypt(this)" role="form" action="register.html" method="POST" id="register-form">
          <div class="well well-sm"><strong><span class="glyphicon glyphicon-asterisk"></span>Required Field</strong></div>
          	<!-- Username -->
          	<div class="form-group">
              <label for="r_username" class="col-sm-2 control-label">Username:</label>
              <span class="glyphicon glyphicon-asterisk"></span>
              
              <div class="col-sm-6">
                <input type="text" class="form-control" name="r_username" id="r_username" ng-model="user.username" placeholder="Username" required>
                <span class="col-md-4" ng-show="registerform.r_username.$dirty && registerform.r_username.$invalid">Required</span>
              </div>
           </div> 
         
            <div class="alert" style="display:none;" id="userExist" ng-hide="registerform.r_username.$dirty">
	        <p>The user already exists</p>
            </div>
          
          <div class="form-group">
              <label for="r_password" class="col-sm-2 control-label">Password:</label>
              <span class="glyphicon glyphicon-asterisk"></span>
              <div class="col-sm-6">
                <input type="password" class="form-control" name="r_password" ng-model="user.r_password" id="r_password" placeholder="Password must between 6 to 20" required ng-minlength="6" ng-maxlength="20">
                <span class="col-md-4" ng-show="registerform.r_password.$dirty && registerform.r_password.$error.required">Required</span>
                <span class="col-md-8" ng-show="(registerform.r_password.$dirty && registerform.r_password.$error.minlength) || (registerform.r_password.$dirty && registerform.r_password.$error.maxlength)">6-20 characters</span>
				<span class="col-md-8" ng-show="(registerform.r_password.$dirty && registerform.r_password.$error.passwordVerify)">Password does not match</span>
              </div>
            </div>


          <div class="form-group">
          	<label class="control-label col-sm-2" for="pwd1">Confirm Password:</label>
          	<span class="glyphicon glyphicon-asterisk"></span>
          	<div class="col-sm-6">          
          		<input type="password" class="form-control" name="r_r_password" id="r_r_password" ng-model="user.r_r_password" password-verify="user.r_password" placeholder="Re-enter password must between 6 to 20" required ng-minlength="6" ng-maxlength="20">
         		<span class="col-md-4" ng-show="registerform.r_r_password.$dirty && registerform.r_r_password.$error.required">Required</span>
         		<span class="col-md-6" ng-show="(registerform.r_r_password.$dirty && registerform.r_r_password.$error.minlength) || (registerform.r_r_password.$dirty && registerform.r_r_password.$error.maxlength)">6-20 characters</span>
         		<span class="col-md-8" ng-show="(registerform.r_r_password.$dirty && registerform.r_r_password.$error.passwordVerify) || (registerform.r_password.$dirty && registerform.r_password.$error.passwordVerify)">Password not match</span>
           		
          <!-- <button type="button" onclick="check()" value="Check">Check</button> -->
        	</div>
        </div>

            <div class="form-group">
              <label for="r_email" class="col-sm-2 control-label">Email:</label>
              <span class="glyphicon glyphicon-asterisk"></span>
              <div class="col-sm-6">
                <input type="email" class="form-control" name="r_email" id="r_email" ng-model="user.r_email" ng-pattern="/^[a-z]+[a-z0-9._]+@[a-z]+\.[a-z.]{2,5}$/"  placeholder="Email" required>
                    <span class="col-md-4" ng-show="registerform.r_email.$dirty && registerform.r_email.$error.required">Required</span>
                    <span class="col-md-4" ng-show="registerform.r_email.$dirty && registerform.r_email.$error.email">Invalid Email</span>
              </div>
            </div>
            

            <div class="form-group">
              <div class="col-sm-offset-2 col-sm-10">
                <button type="submit" class="btn btn-default" ng-disabled="registerform.r_password.$error.minlength 
                		|| registerform.r_password.$error.maxlength || registerform.r_r_password.$error.minlength 
                		|| registerform.r_r_password.$error.maxlength || registerform.r_password.$error.required
                		|| registerform.r_r_password.$error.required || registerform.r_email.$error.required 
                		|| registerform.r_email.$error.email || registerform.r_email.$error.pattern">Sign Up</button>
              </div>
            </div>
          </form>
        </div>

      </div>
    </div>
  </div>
	
	
	<div id="well" class="row">
		<div class="col-md-6" >
			<div class="well">
				<h3>Welcome to our website</h3>
            	<p>If you are a new trader, please click the button to sign up.</p>
            	<p><button id="signup" data-toggle="modal" data-target="#myModal" type="submit" class="btn btn-primary btn-lg">Sign Up</button></p>
            </div>
		</div>
		<div class="col-md-6">
			<div class="well">
				<h3><span class="glyphicon glyphicon-globe"></span>Global Market Data</h3>
            	<p>You can view the global market data in yahoo.com.</p>
            	<p><a href="http://finance.yahoo.com/market-overview/" target="_blank" class="btn btn-danger btn-lg">Show Data</a></p>
            </div>
		</div>
	</div>


	<div class="row">
		<div class="col-md-12">
			<footer>
				<p>&copy; Copyright 2015 Mercury Systems Inc</p>
			</footer>
		</div>
	</div>
</body>
</html>