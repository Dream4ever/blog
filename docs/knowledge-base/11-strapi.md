---
sidebar_position: 11
title: Strapi 相关
---

## 使用须知

1. User 表中的 email 字段可以相同，但 username 字段不能相同。

## 通过接口创建新用户

### 准备工作

1. 允许注册新用户：设置的 `USERS & PERMISSIONS PLUGIN` → `Advanced settings` 里面，`Enable sign-ups` 这一项设置为 `true`。
2. 如有需要，`Default role for authenticated users` 这一项中设置好注册时用户所需的默认角色。
3. `GLOBAL SETTINGS` 的 `API Tokens` 中，给指定的 Token 在 `Users-permissions` 分类下开启 `register` 权限。这样在调用用户注册接口时，带上这个 Token，就可以成功注册新用户了。

### 调用接口

完成上面的设置之后，就可以用下面的代码调用接口来注册新用户了。

```js
axios.post(`${process.env.STRAPI_URL}/auth/local/register`, {
  username: 'test',
  email: 'test@test.com',
  password: 'test123',
  }, {
    headers: {
      Authorization: `Bearer ${process.env.STRAPI_TOKEN}`,
    },
  })
```

### 注册时设置角色【不可行】

出于安全考虑，Strapi 禁止在调用注册接口时设置用户角色，不然普通用户在注册时把自己设置成管理员就乱套了。

## 配置接口的限流策略

### 参考资料

关键词：`strapi ratelimit`。

- [Admin panel configuration](https://docs.strapi.io/dev-docs/configurations/admin-panel)：提到了 `rateLimit` 相关的选项。
- [Limit Number of Requests for an IP in Strapi](https://stackoverflow.com/a/76510152/2667665)：介绍了如何实现全局级别的或者接口级别的限流。

### 实现步骤
