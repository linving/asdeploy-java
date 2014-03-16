package com.ablesky.asdeploy.dao;

import java.sql.Timestamp;
import java.util.Collections;

import static org.junit.Assert.*;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.ui.ModelMap;

import com.ablesky.asdeploy.pojo.User;
import com.ablesky.asdeploy.test.SpringTransactionalTestCase;
import com.ablesky.asdeploy.util.AuthUtil;

@ContextConfiguration(locations = {"/applicationContext.xml"})
public class UserDaoTest extends SpringTransactionalTestCase {

	@Autowired
	private IUserDao userDao;
	
	@Test
	public void getById() {
		assertEquals(1L, userDao.getById(1L).getId().longValue());
	}
	
	@Test
	public void count() {
		assertEquals(4L, userDao.count(Collections.<String, Object>emptyMap()));
	}
	
	@Test
	public void saveOrUpdate() {
		Timestamp ts = new Timestamp(System.currentTimeMillis());
		User user = new User("lhe", AuthUtil.hashPassword("lhe", "1234"), ts, ts);
		userDao.saveOrUpdate(user);
		assertNotNull(user.getId());
	}
	
	@Test
	public void deleteById() {
		userDao.deleteById(1L);
		assertNull(userDao.getById(1L));
	}
	
	@Test
	public void delete() {
		User user = new User();
		user.setId(1L);
		userDao.delete(user);
		assertNull(userDao.getById(1L));
	}
	
	@Test
	public void first() {
		Long userId = userDao.first(new ModelMap().addAttribute("id__ge", 2L)).getId();
		assertEquals(2L, userId.longValue());
	}
	
	@Test
	public void unique() {
		assertEquals(1L, userDao.unique(new ModelMap().addAttribute("id__lt", 2L)).getId().longValue());
	}
	
	@Test(expected=IllegalStateException.class)
	public void uniqueFailed() {
		userDao.unique(Collections.<String, Object>emptyMap());
	}
	
}
