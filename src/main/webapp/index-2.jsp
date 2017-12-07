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
	src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<link
	href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>
	<!-- 员工编辑的模块框Modal -->
	<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">员工编辑</h4>
	      </div>
	      <div class="modal-body">
	       <form class="form-horizontal">
			  <div class="form-group">
			    <label class="col-sm-2 control-label">empName</label>
			    <div class="col-sm-10">
			      <p class="form-control-static" id="empName_update_static"></p>
			    </div>
			  </div>
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">email</label>
			    <div class="col-sm-10">
			      <input name="email" type="text" class="form-control" id="email_update_static" placeholder="email">
			       <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">gender</label>
			    <div class="col-sm-10">
			      <label class="checkbox-inline">
				 	 <input name="gender" type="radio" id="gender1" value="M"  checked="checked"> 男
				 </label>
				 <label class="checkbox-inline">
					  <input name="gender"  type="radio" id="gender2" value="F"> 女
				 </label>
			    </div>
			  </div>
			    <div class="form-group">
			    <label  class="col-sm-2 control-label">deptName</label>
			    <div class="col-sm-4">
			    	<!-- 部门提交部门Id即可 -->
			     	<select class="form-control" name="dId" id="dept_select">
					</select>
			    </div>
			  </div>
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
	      </div>
	    </div>
	  </div>
	</div>


		<!-- 员工添加的模块框Modal -->
	<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">员工添加</h4>
	      </div>
	      <div class="modal-body">
	       <form class="form-horizontal">
			  <div class="form-group">
			    <label class="col-sm-2 control-label">empName</label>
			    <div class="col-sm-10">
			      <input name="empName" type="text" class="form-control" id="empName_add_input" placeholder="empName">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">email</label>
			    <div class="col-sm-10">
			      <input name="email" type="text" class="form-control" id="email_add_input" placeholder="email">
			       <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">gender</label>
			    <div class="col-sm-10">
			      <label class="checkbox-inline">
				 	 <input name="gender" type="radio" id="gender1" value="M" checked="checked"> 男
				 </label>
				 <label class="checkbox-inline">
					  <input name="gender"  type="radio" id="gender2" value="F"> 女
				 </label>
			    </div>
			  </div>
			    <div class="form-group">
			    <label  class="col-sm-2 control-label">deptName</label>
			    <div class="col-sm-4">
			    	<!-- 部门提交部门Id即可 -->
			     	<select class="form-control" name="dId" id="dept_select">
					</select>
			    </div>
			  </div>
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="emp_save_button">保存</button>
	      </div>
	    </div>
	  </div>
	</div>
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
				<button class="btn btn-success btn-lg" id="emp_add_modal_btn">新增</button>
				<button class="btn btn-danger btn-lg" id="emp_delete_all_btn">删除</button>
			</div>
		</div>
		<br>
		<!-- 显示表格数据 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover" id="emp_table">
					<thead>
						<tr>
							<th>
								<input type="checkbox" id="check_all"/>
							</th>
							<th>#</th>
							<th>empName</th>
							<th>gender</th>
							<th>email</th>
							<th>deptName</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					
					</tbody>
				</table>
			</div>
		</div>
		<!-- 显示分页栏 -->
		<div class="row">
			<div class="col-md-6" id="page_info_area">
<!-- 				当前第<font color="red"></font>页,总数为<font color="red"></font>页,总共有<font color="red"></font>条记录数. -->

			</div>
			<div class="col-md-6" id="page_nav_area">
				
			</div>
		</div>
	</div>
	 <script >
		var totalRecord,currentPage;
		//1、页面加载完成以后，直接去发送ajax请求,要到分页数据
		$(function(){
			//去首页
			to_page(1);
		});
	
		/* $(function(){
			$.ajax({
				url:"${APP_PATH}/emps",
				data:"pn=1",
				type:"GET",
				success:function(result){
					//1.显示列表数据
					build_emp_table(result);
					//2.显示分页信息
					build_page_info(result);
					//3.分页条数据
					build_page_nav(result);
				}
			})
		}); */
		function to_page(pn){
			$.ajax({
				url:"${APP_PATH}/emps",
				data:"pn="+pn,
				type:"GET",
				success:function(result){
					debugger;
					//console.log(result);
					//1、解析并显示员工数据
					build_emps_table(result);
					//2、解析并显示分页信息
					build_page_info(result);
					//3、解析显示分页条数据
					build_page_nav(result);
				}
			});
		}
		
		function build_emps_table(result){
			//清空table
			$("#emp_table tbody").empty();
			var emp = result.extend.pageInfo.list;
			debugger;
			$.each(emp,function(index,item){
				var checkbox = $("<td><input type='checkbox' class='check_item' /></td>");
				var empId = $("<td></td>").append(item.empId);
				var empName = $("<td></td>").append(item.empName);
				var gender = $("<td></td>").append(item.gender=="M"?"男":"女");
				var email = $("<td></td>").append(item.email);
				var deptName = $("<td></td>").append(item.department.deptName);
				
				/* 
				<button class="btn btn-success ">
					 <span class="glyphicon glyphicon-pencil btn-xs" aria-hidden="true">编辑</span>
				</button>
				<button class="btn btn-danger">
					<span class="glyphicon glyphicon-remove btn-xs" aria-hidden="true">删除</span>
				</button>
				 */
				 var editButton = $("<button></button>").addClass("btn btn-success  edit_btn")
				 	.append($("<span></span").addClass("glyphicon glyphicon-pencil btn-xs").append("编辑"));
				 //为编辑按钮绑定员工id
				 editButton.attr("edit-id",item.empId);
				 var delButton = $("<button></button>").addClass("btn btn-danger delete_btn")
				 	.append($("<span></span").addClass("glyphicon glyphicon-remove btn-xs").append("删除"));
				 //为删除按钮绑定员工id
				 delButton.attr("delete-id",item.empId);
				 var btnTd = $("<td></td>").append(editButton).append(" ").append(delButton);
				$("<tr></tr>").append(checkbox)
					.append(empId).append(empName)
					.append(gender).append(email)
					.append(deptName).append(btnTd)
					.appendTo("#emp_table tbody");
				
			})
		}
		function build_page_info(result){
			$("#page_info_area").empty();
			$("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页,总共"+
					result.extend.pageInfo.pages+"页,总记录数为"+
					result.extend.pageInfo.total+"条");
			totalRecord = result.extend.pageInfo.total;
			currentPage = result.extend.pageInfo.pageNum;
		}
		//解析显示分页条，点击分页要能去下一页....
		function build_page_nav(result){
			//page_nav_area
			$("#page_nav_area").empty();
			var ul = $("<ul></ul>").addClass("pagination");
			
			//构建元素
			var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
			var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
			if(result.extend.pageInfo.hasPreviousPage == false){
				firstPageLi.addClass("disabled");
				prePageLi.addClass("disabled");
			}else{
				//为元素添加点击翻页的事件
				firstPageLi.click(function(){
					to_page(1);
				});
				prePageLi.click(function(){
					to_page(result.extend.pageInfo.pageNum -1);
				});
			}
			
			
			
			var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
			//末页
			var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
			if(result.extend.pageInfo.hasNextPage == false){
				nextPageLi.addClass("disabled");
				lastPageLi.addClass("disabled");
			}else{
				nextPageLi.click(function(){
					to_page(result.extend.pageInfo.pageNum +1);
				});
				lastPageLi.click(function(){
					to_page(result.extend.pageInfo.pages);
				});
			}
			
			
			
			//添加首页和前一页 的提示
			ul.append(firstPageLi).append(prePageLi);
			//1,2，3遍历给ul中添加页码提示
			$.each(result.extend.pageInfo.navigatepageNums,function(index,item){
				
				var numLi = $("<li></li>").append($("<a></a>").append(item));
				if(result.extend.pageInfo.pageNum == item){
					numLi.addClass("active");
				}
				numLi.click(function(){
					to_page(item);
				});
				ul.append(numLi);
			});
			//添加下一页和末页 的提示
			ul.append(nextPageLi).append(lastPageLi);
			
			//把ul加入到nav
			var navEle = $("<nav></nav>").append(ul);
			navEle.appendTo("#page_nav_area");
		}
		
		//清空表单样式及内容
		function reset_form(ele){
			$(ele)[0].reset();
			//清空表单样式
			$(ele).find("*").removeClass("has-error has-success");
			$(ele).find(".help-block").text("");
		}
		
		//点击新增事件
		$("#emp_add_modal_btn").click(function(){
			//清除表单数据（表单完整重置（表单的数据，表单的样式））
			reset_form("#empAddModal form");
			//s$("")[0].reset();
			//发送ajax请求，查出部门信息，显示在下拉列表中
			getDepts("#empAddModal select");
			$("#empAddModal").modal({
				backdrop:"static" 	
			});
		});
		//查出所有部门信息,显示在下拉列表中
		function getDepts(ele){
			$(ele).empty();
			$.ajax({
				url:"${APP_PATH}/depts",
				type:"GET",
				success:function(result){
					//{"code":100,"msg":"处理成功","extend":{"depts":[{"deptId":1,"deptName":"开发部"},
					//{"deptId":2,"deptName":"测试部"},{"deptId":3,"deptName":"运维部"},{"deptId":4,"deptName":"人事部"}]}}
					//console.log(result);
					//显示部门信息于下拉列表
					//$("#dept_select").append();
					$.each(result.extend.depts,function(){
						var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
						optionEle.appendTo(ele);
					});
				}
			});
		}
		
		//JS验证
		function validate_add_form(){
			// 拿到数据 使用js正则表达式进行校验
			var empName = $("#empName_add_input").val();
			var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
			if(!regName.test(empName)){
				show_validate_msg("#empName_add_input","error","用户名需为2-5位中文或6-16字母与数字组合");
				return false;
			}else{
				show_validate_msg("#empName_add_input","success","");
			}
			
			//邮箱验证
			var email = $("#email_add_input").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test(email)){
				show_validate_msg("#email_add_input","error","邮箱格式不正确!");
				return false;
			}else{
				show_validate_msg("#email_add_input","success","");   
			}
			return true;
		}
		//AJax去重验证
		$("#empName_add_input").change(function(){
			var empName = this.value;
			$.ajax({
				url:"${APP_PATH}/checkUser",
				data:"empName="+empName,
				type:"POST",
				success:function(result){
					if(result.code==100){
						show_validate_msg("#empName_add_input","success","用户名可用");
						$("#emp_save_button").attr("ajax-va","success");
					}else {
						show_validate_msg("#empName_add_input","error",result.extend.va_msg);
						$("#emp_save_button").attr("ajax-va","error");
					}
				}
			});
		});
		
		//ele 元素选择器
		function show_validate_msg(ele,status,msg){
			//清空这个元素之前的样式
			debugger;
			$(ele).parent().removeClass("has-success has-error");
			$(ele).next("span").text("");
			if(status=="success"){
				$(ele).parent().addClass("has-success");
				$(ele).next("span").text(msg);
			}else if(status=="error"){
				$(ele).parent().addClass("has-error");
				$(ele).next("span").text(msg);
			}
		}
		
		$("#emp_save_button").click(function(){
			//模态框中填写的表单数据提交给服务器保存	
			//1数据校验 对提交给服务器的数据进行校验
			if(!validate_add_form()){
				return false;
			}
			debugger;
			if($(this).attr("ajax-va")=="error"){
				return false;
			}
			//发送ajax请求保存员工
			$.ajax({
				url:"${APP_PATH}/emp",
				type:"POST",
				data:$("#empAddModal form").serialize(),
				success:function(result){
					//alert(result.msg);
					//员工保存成功 1 关闭模态框 2 回到最后一页查看数据
					if(result.code=="100"){
						$("#empAddModal").modal("hide");
						//2.来到最后一页查询新增数据
						to_page(totalRecord);
					}else{
						if(undefined != result.extend.errorFields.email){
							show_validate_msg("#email_add_input","error",result.extend.errorFields.email);	
						}
						if(undefined != result.extend.errorFields.empName){
							show_validate_msg("#empName_add_input","error",result.extend.errorFields.empName);	
						}
					}
				
				}
			})
		});
		
		$(document).on("click",".edit_btn",function(){
			//发送ajax请求，查出部门信息，显示在下拉列表中
			getDepts("#empUpdateModal select");
			//查询员工信息并显示
			//alert($(this).attr("edit-id"));
			 getEmp($(this).attr("edit-id"));
			 
			 //将员工的id传递给更新按钮
			 $("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"))
			//查出员工部门信息并显示
			$("#empUpdateModal").modal({
				backdrop:"static"
			})
			
		})
		function getEmp(id){
			//查询员工信息并显示
			$.ajax({
				url:"${APP_PATH}/emp/"+id,
				type:"GET",
				success:function(result){
					//console.log(result);
					var empData = result.extend.emp;
					$("#empName_update_static").text(empData.empName);
					$("#email_update_static").val(empData.email);
					$("#empUpdateModal input[name=gender]").val([empData.gender]);
					$("#empUpdateModal select").val(empData.dId);
				}
			});
		}
		//点击更新,更新员工信息
		$("#emp_update_btn").click(function(){
			//邮箱验证
			var email = $("#email_update_static").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test(email)){
				show_validate_msg("#email_update_input","error","邮箱格式不正确!");
				return false;
			}else{
				show_validate_msg("#email_update_input","success","");   
			}
			//发送更新信息的ajax
			$.ajax({
				url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
				//type:"POST",
				//data:$("#empUpdateModal form").serialize()+"&_method=PUT",
				type:"PUT",
				data:$("#empUpdateModal form").serialize(),
				success:function(result){
					$("#empUpdateModal").modal("hide");
					//2.重载当前页
					to_page(currentPage);
				}
			});
		});
		
		//单一删除按钮
		$(document).on("click",".delete_btn",function(){
			var empId = $(this).attr("delete-id");
			var empName = $(this).parents("tr").find("td:eq(2)").text();
			if(confirm("是否确认删除用户["+empName+"]?")){
				$.ajax({
					url:"${APP_PATH}/emp/"+empId,
					type:"DELETE",
					success:function(result){
						alert(result.msg);
						//2.重载当前页
						to_page(currentPage);
					}
				})
			}
		});
		$("#check_all").click(function(){
			$(".check_item").prop("checked",$(this).prop("checked"));
		});
		
		//单选全部后 主选项变为选择转态
		$(document).on("click",".check_item",function(){
			//alert($(".check_item:checked").length);
			var flag = $(".check_item:checked").length == $(".check_item").length;
			$("#check_all").prop("checked",flag);
		});
		
		$("#emp_delete_all_btn").click(function(){
			var empIds = "";
			var empNames = "";
			$.each($(".check_item:checked"),function(){
				empIds += $(this).parents("tr").find("td:eq(1)").text()+",";
				empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
			});
			empIds = empIds.substring(0,empIds.length-1);
			empNames = empNames.substring(0,empNames.length-1);
			if(confirm("是否确认删除用户["+empNames+"]?")){
				$.ajax({
					url:"${APP_PATH}/emp/"+empIds,
					type:"DELETE",
					success:function(result){
						alert(result.msg);
						to_page(currentPage);
					}
				});
			}
		});
	</script>
</body>
</html>