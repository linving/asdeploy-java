<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="./include/include.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="ctx_path" value="${pageContext.request.contextPath}"></c:set>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>AbleSky代码发布系统</title>
<%@ include file="./include/includeCss.jsp" %>
</head>
<body>
<%@ include file="./include/header.jsp" %>
<div style="width: 1000px; margin: 200px auto;">
	<h2 class="title">没有权限访问当前页面!</h2>
	<div style="margin-top: 20px;"></div>
	<h2 class="title"><a href="/main">请返回首页</a></h2>
</div>
</body>
</html>