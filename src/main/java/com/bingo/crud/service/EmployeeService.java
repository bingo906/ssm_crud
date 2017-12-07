package com.bingo.crud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bingo.crud.bean.Employee;
import com.bingo.crud.bean.EmployeeExample;
import com.bingo.crud.bean.EmployeeExample.Criteria;
import com.bingo.crud.bean.Msg;
import com.bingo.crud.dao.EmployeeMapper;

@Service
public class EmployeeService {

	@Autowired
	EmployeeMapper employeeMapper;
	
	
	/**
	 * 查询所有员工
	 * @return
	 */
	public List<Employee> getAll() {
		return employeeMapper.selectByExampleWithDept(null);
	}

	//员工保存
	public void saveEmp(Employee employee) {
		employeeMapper.insertSelective(employee);
	}

	//用户名校验
	public boolean checkUser(String empName) {
		EmployeeExample example = new EmployeeExample();
        Criteria criteria = example.createCriteria();
		criteria.andEmpNameEqualTo(empName);
		long count = employeeMapper.countByExample(example);
		return count==0;
	}
	//通过ID获取员工信息
	public Employee getEmp(Integer id) {
		Employee employee =  employeeMapper.selectByPrimaryKeyWithDept(id);
		return employee;
	}
	//更新员工信息
	public void updateEmp(Employee employee) {
		employeeMapper.updateByPrimaryKeySelective(employee);
	}
	
	//单一删除员工
	public void delEmp(Integer empId) {
		employeeMapper.deleteByPrimaryKey(empId);
	}
	//单一或批量删除员工
	public void deEmpBatch(List<Integer> empIdList) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andEmpIdIn(empIdList);
		employeeMapper.deleteByExample(example);
	}

}
