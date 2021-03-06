<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/include.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>AbleSky代码发布系统</title>
<%@ include file="../include/includeCss.jsp" %>
<style>
.title {
	text-align: center;
	font-family: 微软雅黑;
}
.list-wrapper {
	width: 1250px; margin: -10px auto 20px;
}
.list-wrapper .table {
	width: 100%;
}
.list-wrapper th, .list-wrapper td {
	text-align: center;
}
.create-btn-wrapper {
	text-align: center;
	margin: 10px auto 10px;
}
.create-btn-wrapper .btn {
	width: 80px;
}
#J_pageBar {
	margin-top: 10px;
	margin-bottom: 0px;
}
.query-form-wrapper {
	width: 700px; margin: 20px auto 10px;
}
.query-form-wrapper form {
	margin-bottom: 0px;
}
.query-form-wrapper table {
	width: 100%; margin: 0px auto;
}
.query-form-wrapper .label-wrapper {
	text-align: right; width: 20%;
}
.query-form-wrapper .input-wrapper {
	width: 20%;
}
.query-form-wrapper select {
	width: 165px;
}
.query-form-wrapper .btn-wrapper {
	text-align: center;
}
.query-form-wrapper .btn {
	width: 82px;
}
</style>
</head>
<body>
<%@ include file="../include/header.jsp" %>

<div class="wrapper">
	<h2 class="title">补丁组列表</h2>
	
	<div class="query-form-wrapper">
		<form id="J_patchGroupQueryForm" action="${ctx_path}/patchGroup/list" method="GET">
			<input type="hidden" id="J_start" name="start" value="" />
			<input type="hidden" id="J_limit" name="limit" value="" />
			<table>
				<tr>
					<td class="label-wrapper">
						<label for="J_creatorName">
							<strong>创建者:&nbsp;</strong>
						</label>
					</td>
					<td class="input-wrapper">	
						<input id="J_creatorName" name="creatorName" type="text" class="input-medium" value="${param.creatorName}" />
					</td>
					<td class="label-wrapper">
						<label for="J_patchGroupName">
							<strong>补丁组名:&nbsp;</strong>
						</label>
					</td>
					<td>
						<input id="J_patchGroupName" name="patchGroupName" type="text" class="input-medium" value="${param.patchGroupName}" />
					</td>
				</tr>
				<tr>
					<td class="label-wrapper">
						<label for="J_projectSel">
							<strong>工程:&nbsp;</strong>
						</label>
					</td>
					<td>
						<select id="J_projectSel" name="projectId" class="input-medium">
							<option value="0">全部</option>
							<c:forEach var="project" items="${projectList}">
								<option value="${project.id}" <c:if test="${param.projectId == project.id}">selected="selected"</c:if>>${project.name}</option>
							</c:forEach>
						</select>
					</td>
					<td class="label-wrapper">
						<label for="J_status">
							<strong>状态:&nbsp;</strong>
						</label>
					</td>
					<td>
						<select id="J_status" name="status" class="input-medium">
							<option value="">全部</option>
							<option value="testing" <c:if test="${param.status == 'testing'}">selected="selected"</c:if>>测试中</option>
							<option value="finished" <c:if test="${param.status == 'finished'}">selected="selected"</c:if>>已完成</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="btn-wrapper" colspan="4">
						<button id="J_queryBtn" class="btn btn-primary">&nbsp;查&nbsp;&nbsp;询&nbsp;</button>
						<div class="btn-sep">&nbsp;</div>
						<button id="J_clearBtn" class="btn">清除条件</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<hr/>
	<div class="list-wrapper">
		<div class="row-fluid">
			<div class="span2 create-btn-wrapper">
				<button id="J_createBtn" class="btn btn-primary pull-left">新&nbsp;&nbsp;增</button>
			</div>
			<div class="span10">
				<div id="J_pageBar" style="height: 30px;" class="pagination"></div>
			</div>
		</div>
		<table class="table table-bordered table-condensed table-hover">
			<thead>
				<tr>
					<th width="40">id</th>
					<th width="120">工程名称</th>
					<th width="220">补丁组名称</th>
					<th width="200">标识码</th>
					<th width="100">创建者</th>
					<th width="180">创建时间</th>
					<th width="180">完成时间</th>
					<th width="100">状态</th>
					<th width="110">操作</th>
				</tr>
			</thead>
			<tbody id="J_tbody">
				<c:forEach items="${page.list}" var="patchGroup">
					<tr>
						<td>${patchGroup.id}</td>
						<td>${patchGroup.project.warName }</td>
						<td>${patchGroup.name}</td>
						<td>${patchGroup.checkCode}</td>
						<td>${patchGroup.creator.username}</td>
						<td><fmt:formatDate value="${patchGroup.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
						<td><fmt:formatDate value="${patchGroup.finishTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
						<td>
							<c:choose>
								<c:when test="${patchGroup.status == 'testing'}"><span class="badge badge-info">测试中</span></c:when>
								<c:when test="${patchGroup.status == 'finished'}"><span class="badge badge-success">已完成</span></c:when>
							</c:choose>
						</td>
						<td>
							<a class="detail-btn" href="${ctx_path}/patchGroup/detail/${patchGroup.id}" target="_blank">详情</a>
							<c:if test="${isSuperAdmin || patchGroup.creator.id == currentUser.id}">
							&nbsp;&nbsp;
							<a class="edit-btn" href="javascript:void(0);" data-id="${patchGroup.id}">修改</a>
							</c:if>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>
<input type="hidden" id="J_pageStart" value="${page.start}"/>
<input type="hidden" id="J_pageLimit" value="${page.limit}"/>
<input type="hidden" id="J_pageCount" value="${page.count}"/>
</body>
<%@ include file="../include/includeJs.jsp" %>
<script>
seajs.use('app/patchGroup/list', function(list){
	list.init();
});
</script>
</html>