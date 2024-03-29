<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%--
  Created by IntelliJ IDEA.
  User: ryan.c.harper
  Date: 12/17/2018
  Time: 12:01 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <jsp:include page="/WEB-INF/views/partials/header.jsp">
        <jsp:param name="title" value="${user.username}'s Profile"/>
    </jsp:include>
</head>

<body ng-app="myApp" ng-controller="editUserController as ctrl">
<jsp:include page="/WEB-INF/views/partials/navbar.jsp"/>

<div class="container" ng-init="initMe(${user.id})"> <!-- moved ng-controller to body for now? -->

    <div class="alert alert-success alert-dismissible" role="alert" ng-model="successfulUpdateMessage"
         ng-show="successfulUpdateMessage">
        <strong>You have successfully updated your profile.</strong>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>

    <h3>{{jsonUser.username}}'s profile</h3>
    <h4>Joined: {{jsonUser.formatDate}}</h4>
    <h4>Bio: {{jsonUser.bio}}</h4>

    <c:if test="${sessionScope.user.id == user.id}">
        <h3>You are currently logged in. <a href="/posts/create">Create a post.</a></h3>
    </c:if>

    <ul class="nav nav-tabs">
        <li class="nav active"><a data-toggle="tab" href="#posts">Posts</a></li>
        <li class="nav"><a data-toggle="tab" href="#comments">Comments</a></li>
        <c:if test="${sessionScope.user.id == user.id}">
            <li class="nav"><a data-toggle="tab" href="#settings">Account Settings</a></li>
        </c:if>
    </ul>

    <div class="tab-content">

        <div class="tab-pane fade in active" id="posts">

            <div ng-if="jsonUser.posts === undefined || jsonUser.posts.length == 0">Posts are empty</div>

            <div ng-repeat="post in jsonUser.posts | orderBy:'$index':true"> <%--<jsp:include page="/WEB-INF/views/partials/postAngular.jsp" />--%>
                <a href="/posts/{{post.id}}/{{post.title}}"><h3 ng-bind-html="post.htmlTitle">{{post.title}}</h3>
                </a> <%-- use ng-bind-html for parsing the markdown to html--%>
                <h4 ng-bind-html="post.htmlSubtitle">{{post.subtitle}}</h4>
                <span class="margin-right-lt">{{post.hoursMinutes}}</span><span
                        class="margin-right">{{post.formatDate}}</span>
                <i class="fas fa-thumbs-up margin-right-lt"></i><span>{{post.voteCount}}</span>
                <a href="/posts/{{post.id}}/{{post.title}}">
                    <div id="profile-post-image" ng-bind-html="post.htmlLeadImage">{{post.leadImage}}</div>
                </a>

                <c:if test="${sessionScope.user.id == user.id}">
                    <div class="dropdown-container">
                        <i class="fas fa-ellipsis-h fa-lg options-ellipsis dropdown-toggle"
                           data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        </i>
                        <div class="dropdown-menu edit-delete-dropdown" aria-labelledby="dropdownMenu">
                            <div>
                                <a href="/posts/{{post.id}}/edit" class="dropdown-edit-btn">
                                    <i class="far fa-edit"></i> edit
                                </a>
                            </div>
                            <div>
                                <a ng-click="deletePost(post)" class="dropdown-delete-btn">
                                    <i class="fas fa-trash-alt"></i> delete
                                </a>
                            </div>
                        </div>
                    </div>
                </c:if>

            </div>

        </div>

        <div class="tab-pane fade" id="comments">
            <div ng-if="jsonUser.comments === undefined || jsonUser.comments.length == 0">Comments are empty</div>
        </div>

        <div class="tab-pane fade" id="settings">

            <div class="container">
                <button class="btn" ng-click="toggleEditUserForm()">
                    Edit Account
                </button>

                <button class="btn" ng-click="toggleEditPasswordForm()">
                    Change Password
                </button>
            </div>

            <form class="form-horizontal" ng-submit="saveUser()" ng-model="editUserForm" ng-show="editUserForm">

                <h3>Edit User:</h3>
                <div class="container form-group">

                    <input type="hidden" name="id" ng-model="originalUser.id" ng-init="originalUser.id='${user.id}'">

                    <label for="userEditName">Username:</label>
                    <input id="userEditName" class="form-control" type="text" name="username"
                           ng-model="originalUser.username" ng-init="originalUser.username='${user.username}'" required>

                    <label for="userEditEmail">Email:</label>
                    <input id="userEditEmail" class="form-control" type="text" name="email"
                           ng-model="originalUser.email" ng-init="originalUser.email='${user.email}'" required>

                    <label for="userEditBio">Bio:</label>
                    <textarea id="userEditBio" class="form-control" name="bio" ng-model="originalUser.bio"
                              ng-init="originalUser.bio='${user.bio}'" style="resize:none">{{jsonUser.bio}}</textarea>
                </div>
                <button class="btn btn-success">
                    Save Changes
                </button>

            </form>

            <form action="/deleteUser/ + ${user.id}" method="post" ng-model="deleteUserForm" ng-show="deleteUserForm">
                <input type="hidden" name="id" value="${user.id}"/>
                <h2>Danger Zone:</h2>
                <button class="btn btn-danger">
                    <%--ng-click="deleteUser()"--%>
                    Delete Your Account
                </button>
            </form>
        </div>

    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp"/>
<script>

    let app = angular.module('myApp', ['ngSanitize']);

    app.controller('editUserController', function ($scope, $http) { //$http will be used for accessing the server side data

        $scope.originalUser = {};
        $scope.jsonUser = {};
        $scope.editUserForm = false;
        $scope.deleteUserForm = false;
        $scope.successfulUpdateMessage = false;

        $scope.toggleEditUserForm = function () {
            $scope.editUserForm = !$scope.editUserForm;
            $scope.deleteUserForm = !$scope.deleteUserForm;
        };

        $scope.initMe = function (userId) {
            $http({
                method: 'GET',
                url: '/getUser/' + userId
            }).then(function (response) {
                console.log("success");
                console.log("Get user username: " + response.data.user.username);
                // console.log(response.data);
                console.log(response.data.user);
                $scope.jsonUser = response.data.user;
                // $scope.jsonUser = response.data;
                // $scope.posts = response.data.user.posts;
                // $scope.postLimit = 3; | limitTo:postLimit
            }, function (error) {
                console.log("Get user error: " + error);
            });
        };

        $scope.saveUser = function () {
            let user = $scope.originalUser;
            let id = $scope.originalUser.id;
            $http({
                method: 'POST',
                url: '/editUser/' + id,
                data: JSON.stringify(user)
            }).then(function (response) {
                console.log("back from edit user");
                console.log(response.data);
                // $scope.jsonUser = response.data;
                $scope.initMe($scope.jsonUser.id);

                //this is acting weird. Works the first time, then works every other time.
                $scope.toggleEditUserForm();
                $scope.successfulUpdateMessage = !$scope.successfulUpdateMessage;
            }, function (error) {
                console.log("Save user error: " + error);
            })
        };

        $scope.deletePost = function (post) {
            // $scope.jsonUser.posts.splice($scope.jsonUser.posts.indexOf(post),1);
            $http({
                method: 'POST',
                url: '/deletePost/' + post.id
            }).then(function (response) {
                console.log(response);
                $scope.initMe($scope.jsonUser.id);
            }, function (error) {
                console.log("Delete post error: " + error);
            });
        };


        // <h3 class="alert alert-success alert-dismissible" ng-model="successfulDeleteMessage" ng-show="successfulDeleteMessage">Your account has been successfully deactivated.</h3>
        // $scope.successfulDeleteMessage = false;
        // $scope.toggleSuccessfulDeleteMessage = function() {
        //     $scope.successfulDeleteMessage = !$scope.successfulDeleteMessage;
        // };

        // $scope.deleteUser = function() {
        //     $http({
        //         method: 'POST',
        //         url: '/deleteUser/' + $scope.originalUser.id,
        //         data: JSON.stringify($scope.originalUser)
        //     }).then((response) => {
        //         console.log("delete user response:" + response);
        //         window.location.href = '/register';
        //         // $scope.toggleSuccessfulDeleteMessage();
        //
        //     }, (error) => {
        //         console.log("Delete user error: " + error);
        //     })
        // };

    });

</script>
</body>
</html>


<%--TODO--%>
<%--<button type="button" ng-click="deleteUser()" class="btn btn-danger">--%>
<%--Delete Account--%>
<%--</button>--%>

<%--TODO--%>
<%--<script src="<c:url value='/static/js/app.js' />"></script>--%>
<%--<script src="<c:url value='/static/js/service/user_service.js' />"></script>--%>
<%--<script src="<c:url value='/static/js/controller/user_controller.js' />"></script>--%>


<%--// $scope.getUser = function () {--%>
<%--//     $http({--%>
<%--//         method: 'GET',--%>
<%--//         url: '/getUser/' + id--%>
<%--//     }).then((function (response) {--%>
<%--//         console.log(response);--%>
<%--//         $scope.username = response.data.username;--%>
<%--//         $scope.email = response.data.email;--%>
<%--//     }))--%>
<%--// };--%>

<%--// let url = '/editUser/' + $scope.originalUser.id.toString();--%>
<%--// $scope.saveUser = function () {--%>
<%--//     $http.post(url, JSON.stringify($scope.originalUser)--%>
<%--//     ).then((function (response) {--%>
<%--//         console.log(response);--%>
<%--//         $scope.displayName = response.user.username;--%>
<%--//--%>
<%--//     }, function(error) {--%>
<%--//         console.log(error);--%>
<%--//     }))--%>
<%--// };--%>


<!-- Button trigger modal -->
<%--<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModal">--%>
<%--Edit Account--%>
<%--</button>--%>

<!-- Modal -->
<%--<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="modalLabel" aria-hidden="true">--%>
<%--<div class="modal-dialog" role="document">--%>
<%--<div class="modal-content">--%>
<%--<div class="modal-header" id="modal-header">--%>
<%--<h5 class="modal-title" id="modalLabel"></h5>--%>
<%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">--%>
<%--<span aria-hidden="true">&times;</span>--%>
<%--</button>--%>
<%--</div>--%>
<%--<div class="modal-body">--%>

<%--<div class="page">--%>
<%--<form>--%>

<%--</form>--%>

<%--</div>--%>
<%--</div>--%>

<%--<div class="modal-footer" id="modal-footer">--%>

<%--</div>--%>

<%--</div>--%>
<%--</div>--%>
<%--</div>--%>
<%--</div>--%>


