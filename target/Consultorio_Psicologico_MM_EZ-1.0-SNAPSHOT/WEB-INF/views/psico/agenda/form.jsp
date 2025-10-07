<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/templates/layout.jsp">
  <jsp:param name="title" value="Nueva Cita"/>
  <jsp:param name="activeMenu" value="agenda"/>
  <jsp:param name="content" value="/WEB-INF/views/psico/agenda/form_content.jsp"/>
</jsp:include>
