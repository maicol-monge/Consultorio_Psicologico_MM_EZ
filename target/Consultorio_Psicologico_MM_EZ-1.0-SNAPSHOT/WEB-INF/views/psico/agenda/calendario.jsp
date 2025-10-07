<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/templates/layout.jsp">
  <jsp:param name="title" value="Mi Calendario"/>
  <jsp:param name="activeMenu" value="agenda"/>
  <jsp:param name="content" value="/WEB-INF/views/psico/agenda/calendario_content.jsp"/>
</jsp:include>
