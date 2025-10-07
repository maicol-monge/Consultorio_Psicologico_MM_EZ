<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/templates/layout.jsp">
  <jsp:param name="title" value="Expediente"/>
  <jsp:param name="activeMenu" value="pacientes"/>
  <jsp:param name="content" value="/WEB-INF/views/psico/pacientes/ver_content.jsp"/>
</jsp:include>
