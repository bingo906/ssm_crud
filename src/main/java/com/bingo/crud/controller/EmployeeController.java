package com.bingo.crud.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bingo.crud.bean.Employee;
import com.bingo.crud.bean.Msg;
import com.bingo.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;


/**
 * 处理员工CRUD请求
 * @author 90601_000
 *
 */
@Controller
public class EmployeeController {
	
	@Autowired
	EmployeeService employeeService;
	
	/**
	 * 单一或批量删除员工
	 * @param empIds
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/emp/{empIds}",method=RequestMethod.DELETE)
	public Msg delEmp(@PathVariable("empIds")String empIds){
		List<Integer> empIdList = new ArrayList<Integer>();
		if(empIds.contains(",")){
			String[] empIdArray = empIds.split(",");
			for(String empId:empIdArray){
				empIdList.add(Integer.parseInt(empId));
			}
		}else {
			empIdList.add(Integer.parseInt(empIds));
		}
		employeeService.deEmpBatch(empIdList);
		return Msg.success();
	}
	
	/**
	 * 单一删除员工
	 * @param empId
	 * @return
	 */
	/*@ResponseBody
	@RequestMapping(value="/emp/{id}",method=RequestMethod.DELETE)
	public Msg delEmpById(@PathVariable("id")Integer empId){
		employeeService.delEmp(empId);
		return Msg.success();
	}*/
	
	@ResponseBody
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	public Msg updateEmp(Employee employee){
		System.out.println("将要更新的员工信息:"+employee.toString());
		employeeService.updateEmp(employee);
		return Msg.success();
	}
		
	@ResponseBody
	@RequestMapping(value="/emp/{id}",method=RequestMethod.GET)
	public Msg getEmp(@PathVariable("id")Integer id){
		Employee employee =  employeeService.getEmp(id);
		return Msg.success().add("emp",employee);
	}
	
	@ResponseBody
	@RequestMapping("/checkUser")
	public Msg chechUser(@RequestParam("empName")String empName){
		//判断用户名格式是否合法
		String regName = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
		if(!empName.matches(regName)){
			return Msg.fail().add("va_msg", "用户名需为2-5位中文及6-16字母与数字组合");
		}
		boolean flag = employeeService.checkUser(empName);
		if(flag){
			return Msg.success();
		}else {
			return Msg.fail().add("va_msg", "用户名不可用");
		}
	}
	
	/**
	 * 员工保存
	 * @return
	 */
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	@ResponseBody
	public Msg saveEmp(@Valid Employee employee,BindingResult result){
		Map<String, String> map = new HashMap<String, String>();
		if(result.hasErrors()){
			List<FieldError> list =  result.getFieldErrors();
			for(FieldError fieldError : list){
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			//校验失败,模态框中显示校验失败信息
			return Msg.fail().add("errorFields", map);
		}else{
			employeeService.saveEmp(employee);
			return Msg.success();
		}
	}
	
	/**
	 * 导入jackson包
	 * @param pn
	 * @return
	 */
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value="pn",defaultValue="1")Integer pn){
		//非分页查
		//引入分页插件
		//查询前调用,传入页码,一级每页的大小
		PageHelper.startPage(pn,5);
		//startPage后面紧跟的查询就是一个分页查询
		List<Employee> emps = employeeService.getAll();
		//使用PageInfo包装查询后的结果,只需要将pageInfo交给页面即可
		//封装了详细的分页信息,包括有查询数据 连续显示5页
		PageInfo page = new PageInfo(emps,5);
		
		return Msg.success().add("pageInfo", page);
	}
	
	
	
	/**
	 * 查询员工数据(分页查询)
	 * 原方法 返回至list界面
	 * @return
	 */
	//@RequestMapping("/emps")
	public String getEmps(@RequestParam(value="pn",defaultValue="1")Integer pn,Model model){
		//非分页查
		//引入分页插件
		//查询前调用,传入页码,一级每页的大小
		System.out.println(pn+"================");
		PageHelper.startPage(pn,5);
		//startPage后面紧跟的查询就是一个分页查询
		List<Employee> emps = employeeService.getAll();
		//使用PageInfo包装查询后的结果,只需要将pageInfo交给页面即可
		//封装了详细的分页信息,包括有查询数据 连续显示5页
		PageInfo page = new PageInfo(emps,5);
		model.addAttribute("pageInfo", page);
		return "list";
	}
}
