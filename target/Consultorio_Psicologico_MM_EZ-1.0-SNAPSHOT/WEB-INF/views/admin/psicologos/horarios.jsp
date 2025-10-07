<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/templates/layout_admin.jsp">
  <jsp:param name="title" value="Horarios de Psicólogos"/>
  <jsp:param name="activeMenu" value="psicologos"/>
  <jsp:param name="content" value="/WEB-INF/views/admin/psicologos/horarios_content.jsp"/>
</jsp:include>
