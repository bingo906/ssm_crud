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
 * ����Ա��CRUD����
 * @author 90601_000
 *
 */
@Controller
public class EmployeeController {
	
	@Autowired
	EmployeeService employeeService;
	
	/**
	 * ��һ������ɾ��Ա��
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
	 * ��һɾ��Ա��
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
		System.out.println("��Ҫ���µ�Ա����Ϣ:"+employee.toString());
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
		//�ж��û�����ʽ�Ƿ�Ϸ�
		String regName = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
		if(!empName.matches(regName)){
			return Msg.fail().add("va_msg", "�û�����Ϊ2-5λ���ļ�6-16��ĸ���������");
		}
		boolean flag = employeeService.checkUser(empName);
		if(flag){
			return Msg.success();
		}else {
			return Msg.fail().add("va_msg", "�û���������");
		}
	}
	
	/**
	 * Ա������
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
			//У��ʧ��,ģ̬������ʾУ��ʧ����Ϣ
			return Msg.fail().add("errorFields", map);
		}else{
			employeeService.saveEmp(employee);
			return Msg.success();
		}
	}
	
	/**
	 * ����jackson��
	 * @param pn
	 * @return
	 */
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value="pn",defaultValue="1")Integer pn){
		//�Ƿ�ҳ��
		//�����ҳ���
		//��ѯǰ����,����ҳ��,һ��ÿҳ�Ĵ�С
		PageHelper.startPage(pn,5);
		//startPage��������Ĳ�ѯ����һ����ҳ��ѯ
		List<Employee> emps = employeeService.getAll();
		//ʹ��PageInfo��װ��ѯ��Ľ��,ֻ��Ҫ��pageInfo����ҳ�漴��
		//��װ����ϸ�ķ�ҳ��Ϣ,�����в�ѯ���� ������ʾ5ҳ
		PageInfo page = new PageInfo(emps,5);
		
		return Msg.success().add("pageInfo", page);
	}
	
	
	
	/**
	 * ��ѯԱ������(��ҳ��ѯ)
	 * ԭ���� ������list����
	 * @return
	 */
	//@RequestMapping("/emps")
	public String getEmps(@RequestParam(value="pn",defaultValue="1")Integer pn,Model model){
		//�Ƿ�ҳ��
		//�����ҳ���
		//��ѯǰ����,����ҳ��,һ��ÿҳ�Ĵ�С
		System.out.println(pn+"================");
		PageHelper.startPage(pn,5);
		//startPage��������Ĳ�ѯ����һ����ҳ��ѯ
		List<Employee> emps = employeeService.getAll();
		//ʹ��PageInfo��װ��ѯ��Ľ��,ֻ��Ҫ��pageInfo����ҳ�漴��
		//��װ����ϸ�ķ�ҳ��Ϣ,�����в�ѯ���� ������ʾ5ҳ
		PageInfo page = new PageInfo(emps,5);
		model.addAttribute("pageInfo", page);
		return "list";
	}
}
