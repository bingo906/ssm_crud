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
 * 测试dao层的工作
 * @author 90601_000
 *推荐Spring的项目就可以使用Spring的单元测试,可以自动注入我们需要的组件
 *1 导入SpringTest模块
 *2 @ContextConfiguration指定spring配置文件的位置
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
	 * 测试DepartmentMapper
	 * 
	 */
	@Test
	public void testCrud(){
		//System.out.println(departmentMapper);
		// 1 部门插入
		//departmentMapper.insertSelective(new Department(null, "运维部"));
		//departmentMapper.insertSelective(new Department(null, "人事部"));
		// 2 员工插入
	//	employeeMapper.insertSelective(new Employee(null,"BI11111NGO","M","1528@qq.com",1));
		
		//3 批量插入 可以使用批量操作的sqlSession
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
		System.out.println("批量成功!");
	} 
}
