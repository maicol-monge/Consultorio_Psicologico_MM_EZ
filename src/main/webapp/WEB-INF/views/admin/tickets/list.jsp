<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/templates/layout_admin.jsp">
    <jsp:param name="title" value="Tickets"/>
    <jsp:param name="activeMenu" value="tickets"/>
    <jsp:param name="content" value="/WEB-INF/views/admin/tickets/list_content.jsp"/>
</jsp:include>
