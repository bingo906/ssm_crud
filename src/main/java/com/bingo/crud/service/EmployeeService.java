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
	 * ��ѯ����Ա��
	 * @return
	 */
	public List<Employee> getAll() {
		return employeeMapper.selectByExampleWithDept(null);
	}

	//Ա������
	public void saveEmp(Employee employee) {
		employeeMapper.insertSelective(employee);
	}

	//�û���У��
	public boolean checkUser(String empName) {
		EmployeeExample example = new EmployeeExample();
        Criteria criteria = example.createCriteria();
		criteria.andEmpNameEqualTo(empName);
		long count = employeeMapper.countByExample(example);
		return count==0;
	}
	//ͨ��ID��ȡԱ����Ϣ
	public Employee getEmp(Integer id) {
		Employee employee =  employeeMapper.selectByPrimaryKeyWithDept(id);
		return employee;
	}
	//����Ա����Ϣ
	public void updateEmp(Employee employee) {
		employeeMapper.updateByPrimaryKeySelective(employee);
	}
	
	//��һɾ��Ա��
	public void delEmp(Integer empId) {
		employeeMapper.deleteByPrimaryKey(empId);
	}
	//��һ������ɾ��Ա��
	public void deEmpBatch(List<Integer> empIdList) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andEmpIdIn(empIdList);
		employeeMapper.deleteByExample(example);
	}

}
