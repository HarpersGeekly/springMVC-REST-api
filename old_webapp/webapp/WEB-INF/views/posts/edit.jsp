<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%--
  Created by IntelliJ IDEA.
  User: ryan.c.harper
  Date: 1/10/2019
  Time: 3:12 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <jsp:include page="/WEB-INF/views/partials/header.jsp">
        <jsp:param name="Edit a Post" value="trainingapp"/>
    </jsp:include>
</head>
<body>
<jsp:include page="/WEB-INF/views/partials/navbar.jsp"/>

<div class="container">

    <h1>Edit a post</h1>
    <hr>

    <form:form action="/posts/edit" method="POST" modelAttribute="post">

        <input type="hidden" name="id" value="${post.id}"/>
        <input type="hidden" name="id" value="${post.date}"/>

        <label for="editorTitle"><h3>Title:</h3></label>
        <textarea id="editorTitle" name="title">${post.title}</textarea>
        <spring:bind path="title">
            <div class="form-group ${status.error ? 'alert alert-danger alert-dismissible' : ''}" role="alert">
                <button type="button" class="close ${status.error ? 'show' : 'hidden'}" data-dismiss="alert"
                        aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <form:errors path="title"/>
            </div>
        </spring:bind>

        <label for="editorSubtitle"><h3>Subtitle:</h3></label>
        <textarea id="editorSubtitle" name="subtitle">${post.subtitle}</textarea>
        <spring:bind path="subtitle">
            <div class="form-group ${status.error ? 'alert alert-danger alert-dismissible' : ''}" role="alert">
                <button type="button" class="close ${status.error ? 'show' : 'hidden'}" data-dismiss="alert"
                        aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <form:errors path="subtitle"/>
            </div>
        </spring:bind>

        <label for="editorImage"><h3>Headline Image:</h3></label>
        <textarea id="editorImage" name="leadImage">${post.leadImage}</textarea>

        <label for="editorBody"><h3>Post Body:</h3></label>
        <textarea id="editorBody" name="body">${post.body}</textarea>
        <spring:bind path="body">
            <div class="form-group ${status.error ? 'alert alert-danger alert-dismissible' : ''}" role="alert">
                <button type="button" class="close ${status.error ? 'show' : 'hidden'}" data-dismiss="alert"
                        aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <form:errors path="body"/>
            </div>
        </spring:bind>

        <button>Update Post!</button>
    </form:form>

</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp"/>
<script>
    let simplemdeTitle = new SimpleMDE({
        element: document.getElementById("editorTitle"),
        toolbar: ["bold", "italic", "|", "guide", "|", "preview"],
    });
    let simplemdeSubtitle = new SimpleMDE({
        element: document.getElementById("editorSubtitle"),
        toolbar: ["bold", "italic", "|", "preview"],
    });
    let simplemdeImage = new SimpleMDE({
        element: document.getElementById("editorImage"),
        toolbar: ["image", "|", "preview"],
    });
    let simplemdeBody = new SimpleMDE({
        element: document.getElementById("editorBody")
    });

</script>
</body>
</html>