/**
 * index-2.jsp所用的js代码
 */
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
				 var editButton = $("<button></button>").addClass("btn btn-success")
				 	.append($("<span></span").addClass("glyphicon glyphicon-pencil btn-xs edit_btn").append("编辑"));
				 var delButton = $("<button></button>").addClass("btn btn-danger")
				 	.append($("<span></span").addClass("glyphicon glyphicon-remove btn-xs").append("删除"));
				 var btnTd = $("<td></td>").append(editButton).append(" ").append(delButton);
				$("<tr></tr>").append(empId).append(empName).append(gender)
					.append(email).append(deptName)
					.append(btnTd).appendTo("#emp_table tbody");
				
			})
		}
		function build_page_info(result){
			$("#page_info_area").empty();
			$("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页,总共"+
					result.extend.pageInfo.pages+"页,总记录数为"+
					result.extend.pageInfo.total+"条");
			totalRecord = result.extend.pageInfo.total;
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
			getDepts();
			$("#empAddModal").modal({
				backdrop:"static" 	
			});
		});
		//查出所有部门信息,显示在下拉列表中
		function getDepts(){
			//清空之前下拉列表的值
		
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
						optionEle.appendTo("#empAddModal select");
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
			//查出员工部门信息并显示
			$("#empUpdateModal").model({
				backdrop:"static"
			})
			
		})
		