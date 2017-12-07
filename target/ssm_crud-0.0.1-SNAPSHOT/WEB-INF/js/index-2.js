/**
 * index-2.jsp���õ�js����
 */
		var totalRecord,currentPage;
		//1��ҳ���������Ժ�ֱ��ȥ����ajax����,Ҫ����ҳ����
		$(function(){
			//ȥ��ҳ
			to_page(1);
		});
	
		/* $(function(){
			$.ajax({
				url:"${APP_PATH}/emps",
				data:"pn=1",
				type:"GET",
				success:function(result){
					//1.��ʾ�б�����
					build_emp_table(result);
					//2.��ʾ��ҳ��Ϣ
					build_page_info(result);
					//3.��ҳ������
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
					//1����������ʾԱ������
					build_emps_table(result);
					//2����������ʾ��ҳ��Ϣ
					build_page_info(result);
					//3��������ʾ��ҳ������
					build_page_nav(result);
				}
			});
		}
		
		function build_emps_table(result){
			//���table
			$("#emp_table tbody").empty();
			var emp = result.extend.pageInfo.list;
			debugger;
			$.each(emp,function(index,item){
				var empId = $("<td></td>").append(item.empId);
				var empName = $("<td></td>").append(item.empName);
				var gender = $("<td></td>").append(item.gender=="M"?"��":"Ů");
				var email = $("<td></td>").append(item.email);
				var deptName = $("<td></td>").append(item.department.deptName);
				
				/* 
				<button class="btn btn-success ">
					 <span class="glyphicon glyphicon-pencil btn-xs" aria-hidden="true">�༭</span>
				</button>
				<button class="btn btn-danger">
					<span class="glyphicon glyphicon-remove btn-xs" aria-hidden="true">ɾ��</span>
				</button>
				 */
				 var editButton = $("<button></button>").addClass("btn btn-success")
				 	.append($("<span></span").addClass("glyphicon glyphicon-pencil btn-xs edit_btn").append("�༭"));
				 var delButton = $("<button></button>").addClass("btn btn-danger")
				 	.append($("<span></span").addClass("glyphicon glyphicon-remove btn-xs").append("ɾ��"));
				 var btnTd = $("<td></td>").append(editButton).append(" ").append(delButton);
				$("<tr></tr>").append(empId).append(empName).append(gender)
					.append(email).append(deptName)
					.append(btnTd).appendTo("#emp_table tbody");
				
			})
		}
		function build_page_info(result){
			$("#page_info_area").empty();
			$("#page_info_area").append("��ǰ"+result.extend.pageInfo.pageNum+"ҳ,�ܹ�"+
					result.extend.pageInfo.pages+"ҳ,�ܼ�¼��Ϊ"+
					result.extend.pageInfo.total+"��");
			totalRecord = result.extend.pageInfo.total;
		}
		//������ʾ��ҳ���������ҳҪ��ȥ��һҳ....
		function build_page_nav(result){
			//page_nav_area
			$("#page_nav_area").empty();
			var ul = $("<ul></ul>").addClass("pagination");
			
			//����Ԫ��
			var firstPageLi = $("<li></li>").append($("<a></a>").append("��ҳ").attr("href","#"));
			var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
			if(result.extend.pageInfo.hasPreviousPage == false){
				firstPageLi.addClass("disabled");
				prePageLi.addClass("disabled");
			}else{
				//ΪԪ����ӵ����ҳ���¼�
				firstPageLi.click(function(){
					to_page(1);
				});
				prePageLi.click(function(){
					to_page(result.extend.pageInfo.pageNum -1);
				});
			}
			
			
			
			var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
			//ĩҳ
			var lastPageLi = $("<li></li>").append($("<a></a>").append("ĩҳ").attr("href","#"));
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
			
			
			
			//�����ҳ��ǰһҳ ����ʾ
			ul.append(firstPageLi).append(prePageLi);
			//1,2��3������ul�����ҳ����ʾ
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
			//�����һҳ��ĩҳ ����ʾ
			ul.append(nextPageLi).append(lastPageLi);
			
			//��ul���뵽nav
			var navEle = $("<nav></nav>").append(ul);
			navEle.appendTo("#page_nav_area");
		}
		
		//��ձ���ʽ������
		function reset_form(ele){
			$(ele)[0].reset();
			//��ձ���ʽ
			$(ele).find("*").removeClass("has-error has-success");
			$(ele).find(".help-block").text("");
		}
		
		//��������¼�
		$("#emp_add_modal_btn").click(function(){
			//��������ݣ����������ã��������ݣ�������ʽ����
			reset_form("#empAddModal form");
			//s$("")[0].reset();
			//����ajax���󣬲��������Ϣ����ʾ�������б���
			getDepts();
			$("#empAddModal").modal({
				backdrop:"static" 	
			});
		});
		//������в�����Ϣ,��ʾ�������б���
		function getDepts(){
			//���֮ǰ�����б��ֵ
		
			$.ajax({
				url:"${APP_PATH}/depts",
				type:"GET",
				success:function(result){
					//{"code":100,"msg":"����ɹ�","extend":{"depts":[{"deptId":1,"deptName":"������"},
					//{"deptId":2,"deptName":"���Բ�"},{"deptId":3,"deptName":"��ά��"},{"deptId":4,"deptName":"���²�"}]}}
					//console.log(result);
					//��ʾ������Ϣ�������б�
					//$("#dept_select").append();
					$.each(result.extend.depts,function(){
						var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
						optionEle.appendTo("#empAddModal select");
					});
				}
			});
		}
		
		//JS��֤
		function validate_add_form(){
			// �õ����� ʹ��js������ʽ����У��
			var empName = $("#empName_add_input").val();
			var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
			if(!regName.test(empName)){
				show_validate_msg("#empName_add_input","error","�û�����Ϊ2-5λ���Ļ�6-16��ĸ���������");
				return false;
			}else{
				show_validate_msg("#empName_add_input","success","");
			}
			var email = $("#email_add_input").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test(email)){
				show_validate_msg("#email_add_input","error","�����ʽ����ȷ!");
				return false;
			}else{
				show_validate_msg("#email_add_input","success","");   
			}
			return true;
		}
		//AJaxȥ����֤
		$("#empName_add_input").change(function(){
			var empName = this.value;
			$.ajax({
				url:"${APP_PATH}/checkUser",
				data:"empName="+empName,
				type:"POST",
				success:function(result){
					if(result.code==100){
						show_validate_msg("#empName_add_input","success","�û�������");
						$("#emp_save_button").attr("ajax-va","success");
					}else {
						show_validate_msg("#empName_add_input","error",result.extend.va_msg);
						$("#emp_save_button").attr("ajax-va","error");
					}
				}
			});
		});
		
		//ele Ԫ��ѡ����
		function show_validate_msg(ele,status,msg){
			//������Ԫ��֮ǰ����ʽ
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
			//ģ̬������д�ı������ύ������������	
			//1����У�� ���ύ�������������ݽ���У��
			if(!validate_add_form()){
				return false;
			}
			debugger;
			if($(this).attr("ajax-va")=="error"){
				return false;
			}
			//����ajax���󱣴�Ա��
			$.ajax({
				url:"${APP_PATH}/emp",
				type:"POST",
				data:$("#empAddModal form").serialize(),
				success:function(result){
					//alert(result.msg);
					//Ա������ɹ� 1 �ر�ģ̬�� 2 �ص����һҳ�鿴����
					if(result.code=="100"){
						$("#empAddModal").modal("hide");
						//2.�������һҳ��ѯ��������
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
			//���Ա��������Ϣ����ʾ
			$("#empUpdateModal").model({
				backdrop:"static"
			})
			
		})
		