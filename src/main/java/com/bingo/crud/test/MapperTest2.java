package com.bingo.crud.test;

import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.bingo.crud.bean.Department;
import com.bingo.crud.bean.Employee;
import com.bingo.crud.dao.DepartmentMapper;
import com.bingo.crud.dao.EmployeeMapper;

/**
 * ����dao��Ĺ���
 * @author 90601_000
 *�Ƽ�Spring����Ŀ�Ϳ���ʹ��Spring�ĵ�Ԫ����,�����Զ�ע��������Ҫ�����
 *1 ����SpringTestģ��
 *2 @ContextConfigurationָ��spring�����ļ���λ��
 *3 autowired
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"classpath:applicationContext.xml"})
public class MapperTest2 {
	@Autowired
	DepartmentMapper departmentMapper;
	
	@Autowired
	EmployeeMapper employeeMapper;
	
	@Autowired
	SqlSession sqlSesion;
	/**
	 * ����DepartmentMapper
	 * 
	 */
	@Test
	public void testCrud(){
		//System.out.println(departmentMapper);
		// 1 ���Ų���
		//departmentMapper.insertSelective(new Department(null, "��ά��"));
		//departmentMapper.insertSelective(new Department(null, "���²�"));
		// 2 Ա������
	//	employeeMapper.insertSelective(new Employee(null,"BI11111NGO","M","1528@qq.com",1));
		
		//3 �������� ����ʹ������������sqlSession
		/**for
		 * 	employeeMapper.insertSelective(new Employee(null,uudi,"M","1528@qq.com",1));
		 */
		EmployeeMapper mapper = sqlSesion.getMapper(EmployeeMapper.class);
		for(int i=0;i<1000;i++){
			String uid = UUID.randomUUID().toString().substring(0,5)+i;
			if(i%2==0){
				mapper.insertSelective(new Employee(null,uid,"M",uid+"@1528.com",1));
			}else{
				mapper.insertSelective(new Employee(null,uid,"F",uid+"@1528.com",2));
			}
		}
		System.out.println("�����ɹ�!");
	} 
}
