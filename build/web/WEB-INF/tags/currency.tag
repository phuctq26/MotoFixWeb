<%@ tag body-content="empty" %>
<%@ attribute name="value" required="true" type="java.lang.Number" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:formatNumber value="${value}" type="number" groupingUsed="true" /> d
