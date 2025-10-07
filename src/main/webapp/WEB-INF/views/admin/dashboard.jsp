<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/templates/layout_admin.jsp">
    <jsp:param name="title" value="Dashboard Administrativo" />
    <jsp:param name="activeMenu" value="dashboard" />
    <jsp:param name="content" value="/WEB-INF/views/admin/dashboard_content.jsp" />
</jsp:include>