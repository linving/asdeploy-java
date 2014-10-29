package com.ablesky.asdeploy.security;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.ldap.JndiLdapContextFactory;
import org.apache.shiro.realm.ldap.JndiLdapRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.SimplePrincipalCollection;
import org.springframework.beans.factory.annotation.Autowired;

import com.ablesky.asdeploy.pojo.Role;
import com.ablesky.asdeploy.pojo.User;
import com.ablesky.asdeploy.service.IAuthorityService;
import com.ablesky.asdeploy.service.IUserService;

public class ShiroLdapRealm extends JndiLdapRealm {
	
	@Autowired
	private IUserService userService;
	@Autowired
	private IAuthorityService authorityService;
	
	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
		// 如果系统变量中未配置ldap的url，则自动跳过此realm，详见applicationContext-shiro.xml
		String ldapUrl = ((JndiLdapContextFactory)getContextFactory()).getUrl();
		if(StringUtils.isBlank(ldapUrl) || !ldapUrl.startsWith("ldap://")) {
			return null;
		}
		AuthenticationInfo info = super.doGetAuthenticationInfo(token);
		if (info == null || org.apache.shiro.util.CollectionUtils.isEmpty(info.getPrincipals())) {
			return info;
		}
		SimplePrincipalCollection principals = (SimplePrincipalCollection) info.getPrincipals();
		String username = (String) principals.getPrimaryPrincipal();
		User user = userService.getUserByUsername(username);
		if (user == null) {
			// 如果用户是第一次通过ldap登录，则根据用户名在数据库中生成一条用户记录，相当于注册
			user = userService.createNewUser(username, new String((char[])token.getCredentials()));
		}
		principals.add(user, getName());
		return info;
	}

	/**
	 * 授权查询回调函数, 进行鉴权但缓存中无用户的授权信息时调用.
	 */
	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
		SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
		User user = principals.oneByType(User.class);
		if (user != null) {
			List<Role> roleList = authorityService.getRoleListResultByUserId(user.getId());
			for (Role role : roleList) {
				info.addRole(role.getName());
			}
		}
		return info;
	}

}
