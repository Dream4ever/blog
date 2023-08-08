---
sidebar_position: 10
title: Shopify 相关
---

## 第三方网站选择商品后跳转到 Shopify 购物车

### 参考资料

- [Cart - Use Permalinks To Pre-Load The Cart](https://community.shopify.com/c/shopify-design/cart-use-permalinks-to-pre-load-the-cart/td-p/613702#adding-a-buy-this-link-to-a-blog-post)：介绍了如何从第三方网站跳转到 checkout 页面，并且携带 shopify 网站上的商品信息。
- [Create cart permalinks](https://shopify.dev/docs/apps/checkout/cart-permalinks/cart-permalinks)：介绍如何创建购物车的永久链接（cart permalink）。
- [Find a variant ID](https://help.shopify.com/en/manual/products/variants/find-variant-id)：介绍如何查找商品的 variant ID，该 ID 在购物车的永久链接中会用到。

### 实现步骤

1. 在 Shopify 网站上创建一个商品，然后在该商品的编辑页面中找到 `Variant ID`，并记录下来。
2. 在第三方网站上创建一个链接，链接的地址为 `https://<shopify 网站的域名>/cart/<variant ID>:<数量>`，其中 `<shopify 网站的域名>` 为你的 Shopify 网站的域名，`<variant ID>` 为第一步中记录的 variant ID，`<数量>` 为商品的数量。
3. 在链接末尾加上 `?storefront=true`，就会跳转到购物车页面，而不是 checkout 页面。
