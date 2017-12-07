<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>员工列表</title>
<!-- web路径:
	不以/开始的相对路径,找资源,以当前资源为基准,经常容易出现问题
	以/开始的相对路径,找资源,以服务器的路径为标准
 -->
 <%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<script type="text/javascript"
	src="static/js/jquery-1.12.4.min.js"></script>
<link
	href="static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>
	<!-- 搭建显示页面 -->
	<div class="container">
		<!-- 显示标题 -->
		<div class="row">
			<div class="col-md-12">
				<h1>SSM_CRUDT</h1>
			</div>
		</div>
		<!-- 显示按钮 -->
		<div class="row">
			<div class="col-md-4 col-md-offset-8">
				<button class="btn btn-success btn-lg">新增</button>
				<button class="btn btn-danger btn-lg">删除</button>
			</div>
		</div>
		<br>
		<!-- 显示表格数据 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover">
					<tr>
						<th>#</th>
						<th>empName</th>
						<th>gender</th>
						<th>email</th>
						<th>deptName</th>
						<th>操作</th>
					</tr>
					<c:forEach items="${pageInfo.list }" var="emp">
					<tr>
						<th>${emp.empId }</th>
						<th>${emp.empName }</th>
						<th>${emp.gender=="M"?"男":"女" }</th>
						<th>${emp.email }</th>
						<th>${emp.department.deptName }</th>
						<th>
							<button class="btn btn-success ">
								 <span class="glyphicon glyphicon-pencil btn-xs" aria-hidden="true">编辑</span>
							</button>
							<button class="btn btn-danger">
								<span class="glyphicon glyphicon-remove btn-xs" aria-hidden="true">删除</span>
							</button>
						</th>
					</tr>
					</c:forEach>
				</table>
			</div>
		</div>
		<!-- 显示分页栏 -->
		<div class="row">
			<div class="col-md-6">
				当前第<font color="red">${pageInfo.pageNum }</font>页,总数为<font color="red">${pageInfo.pages }</font>页,总共有<font color="red">${pageInfo.total }</font>条记录数.
			</div>
			<div class="col-md-6">
				<nav aria-label="Page navigation">
				  <ul class="pagination">
				    <li><a href="${APP_PATH }/emps?pn=1">首页</a></li>
				    <c:if test="${pageInfo.hasPreviousPage }">
					    <li>
					      <a href="${APP_PATH }/emps?pn=${pageInfo.pageNum-1 }" aria-label="Previous">
					        <span aria-hidden="true">&laquo;</span>
					      </a>
					    </li>
				    </c:if>
 
				   	<c:forEach items="${pageInfo.navigatepageNums }" var="page_num">
				   		<c:if test="${page_num==pageInfo.pageNum }">
				   			<li class="active"><a href="${APP_PATH }/emps?pn=${page_num }" >${page_num }</a></li>
				   		</c:if>
				   		<c:if test="${page_num!=pageInfo.pageNum }">
				   			<li class="disable"><a href="${APP_PATH }/emps?pn=${page_num }" >${page_num }</a></li>
				   		</c:if>
				   	</c:forEach>
				   	<c:if test="${pageInfo.hasNextPage }">
				   		<li>
					      <a href="${APP_PATH }/emps?pn=${pageInfo.pageNum+1 }" aria-label="Next">
					        <span aria-hidden="true">&raquo;</span>
					      </a>
				   	    </li>
				   	</c:if>
				    <li><a href="${APP_PATH }/emps?pn=${pageInfo.pages }">最后一页</a></li>
				  </ul>
				</nav>
			</div>
		</div>
	
	
	</div>
</body>
</html>