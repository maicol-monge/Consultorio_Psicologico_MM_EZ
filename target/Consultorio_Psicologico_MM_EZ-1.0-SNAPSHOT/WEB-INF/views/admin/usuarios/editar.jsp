<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/templates/layout_admin.jsp">
    <jsp:param name="title" value="Editar Usuario"/>
    <jsp:param name="content" value="/WEB-INF/views/admin/usuarios/form_content.jsp"/>
</jsp:include>