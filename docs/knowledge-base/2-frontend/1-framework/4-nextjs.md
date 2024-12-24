---
sidebar_position: 4
title: Next.js 相关
---

## react-markdown 渲染 mermaid

1. 用 yarn 或者 pnpm 安装 mermaid 这个库。

2. 在 Next.js 项目的入口文件（通常是 pages/_app.js）中初始化 Mermaid。

```js
import { useEffect } from 'react';
import mermaid from 'mermaid';

function MyApp({ Component, pageProps }) {
  useEffect(() => {
    mermaid.initialize({
      theme: 'default',
      startOnLoad: false,
    });
  }, []);
}
```

3. 在页面文件中渲染 Mermaid。

```js
mermaid.init(undefined, '.language-mermaid');
```

## 结合 tailwindcss 实现深色/浅色模式的切换

参考资料：[TailwindCSS Dark Mode in Next.js with Tailwind Typography Prose Classes](https://egghead.io/blog/tailwindcss-dark-mode-nextjs-typography-prose)

关键代码：

```js
// tailwind.config.js
export const darkMode = "class";
```

```ts
// _app.tsx
import { ThemeProvider } from "next-themes";

...
  <ThemeProvider attribute="class">
    <main>
     ...
    </main>
  </ThemeProvider>
...
```

```ts
// 实现切换颜色模式的文件
import { useTheme } from "next-themes";

export const ToggleDarkModeButton = () => {
  const { theme, setTheme } = useTheme();

  return (
    <div onClick={() => setTheme(theme === "dark" ? "light" : "dark")}>
    </div>
  )
```

然后在其他地方正常地用 `dark:` 设置深色模式的样式即可。

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

## 使用 Google 字体的另一种方案

- [How to add google fonts to Tailwind CSS custom config (NextJS example)](https://www.mailslurp.com/blog/how-to-use-google-fonts-with-tailwind-css/)
- [Using Google Fonts in Next.js 13 with Tailwind CSS](https://blog.devgenius.io/using-google-fonts-in-next-js-13-with-tailwind-css-8fe966e31a39)

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
