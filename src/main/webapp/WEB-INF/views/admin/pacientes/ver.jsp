<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/templates/layout_admin.jsp">
    <jsp:param name="title" value="Detalle de Paciente"/>
    <jsp:param name="activeMenu" value="pacientes"/>
    <jsp:param name="content" value="/WEB-INF/views/admin/pacientes/ver_content.jsp"/>
</jsp:include>
