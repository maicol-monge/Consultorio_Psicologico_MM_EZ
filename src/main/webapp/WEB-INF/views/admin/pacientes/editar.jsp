<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../layout.jsp">
    <jsp:param name="title" value="Editar Paciente"/>
    <jsp:param name="content" value="/WEB-INF/views/admin/pacientes/form_content.jsp"/>
</jsp:include>