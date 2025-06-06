---
sidebar_position: 11
title: Strapi 相关
---

## 使用须知

1. User 表中的 email 字段可以相同，但 username 字段不能相同。

## 上传文件并关联至某张表中的指定字段

根据 [documentId and refId of /api/upload](https://github.com/strapi/strapi/issues/21427) 这个 Strapi issue 讨论得出的最终结果，用下面的代码，可以实现上传文件后关联至某个表中指定字段的需求。

```js
  const file = await blobFrom(`./images/${filename}`, 'image/jpg')
  const form = new FormData()
  form.append('files', file, filename)
  const uploadResp = await axios.post('http://127.0.0.1:1338/api/upload', form);
  const linkResp = await axios.put(`http://127.0.0.1:1338/api/someResource/${someItem.documentId}`, {
    data: {
      images: {
        connect: [uploadResp.data[0].id]
      }
    }
  })
```

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

### 设置角色

出于安全考虑，Strapi 禁止在调用注册接口时设置用户角色，不然普通用户在注册时把自己设置成管理员就乱套了。

但是可以在用户账户创建完成之后，为用户分配指定角色：

```js
await strapi.documents('plugin::users-permissions.user').update({
  documentId: userDocumentId,
  data: {
    role: {
      id: someRole.id,
      documentId: someRole.documentId,
    },
  },
})
```

## 使表的 ID 字段从 1 开始

用 TRUNCATE 命令清空表之后，新的纪录 ID 会从 1 开始。

## 配置接口的限流策略

### 参考资料

关键词：`strapi ratelimit`。

- [Admin panel configuration](https://docs.strapi.io/dev-docs/configurations/admin-panel)：提到了 `rateLimit` 相关的选项。
- [Limit Number of Requests for an IP in Strapi](https://stackoverflow.com/a/76510152/2667665)：介绍了如何实现全局级别的或者接口级别的限流。

### 实现步骤
