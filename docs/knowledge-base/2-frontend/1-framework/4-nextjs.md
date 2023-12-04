---
sidebar_position: 4
title: Next.js 相关
---

## 离开页面前执行特定操作

关键词：`nextjc on route change`

参考资料：[Next.js Router - Listen to route (location) change with useRouter](https://jasonwatmore.com/nextjs-router-listen-to-route-location-change-with-userouter)

关键代码：

```js
import { useRouter } from "next/router";
const router = useRouter();

useEffect(() => {
  const onLeave = () => {};
  router.events.on("routeChangeStart", onLeave);

  return () => {
    router.events.off("routeChangeStart", onLeave);
  };
}, []);
```

## 使用 Google 可变字体并指定字号

关键词：`nextjs import variable font set font weight`

关键代码：

先定义并导出要用到的各个字体：

```js
// styles/fonts.ts
import { Inter, Lora, Source_Sans_Pro } from "next/font/google";
import localFont from "next/font/local";

// define your variable fonts
const inter = Inter();
const lora = Lora();
// define 2 weights of a non-variable font
const sourceCodePro400 = Source_Sans_Pro({ weight: "400" });
const sourceCodePro700 = Source_Sans_Pro({ weight: "700" });
// define a custom local font where GreatVibes-Regular.ttf is stored in the styles folder
const greatVibes = localFont({ src: "./GreatVibes-Regular.ttf" });

export { inter, lora, sourceCodePro400, sourceCodePro700, greatVibes };
```

然后在需要用到指定字体的地方导入并使用：

```js
import { sourceCodePro700 } from "../styles/fonts";

export default function Page() {
  return (
    <div>
      <p className={sourceCodePro700.className}>
        Hello world using Source_Sans_Pro font with weight 700
      </p>
    </div>
  );
}
```
