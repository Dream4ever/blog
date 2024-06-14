---
slug: develop-react-native-app-with-expo
title: 用 Expo 开发 React Native 应用
authors: HeWei
tags: [react,React Native,expo,Android,iOS,Android Studio]
---

## 前情提要

接手了一个应用，是别人用 React Native + Expo 开发的，现在需要在自己的电脑上继续开发。

一开始以为只需要用 pnpm 装一下依赖，然后运行 `npm start` 就可以了，结果项目虽然能跑起来，但是不知道怎么在电脑浏览器中调试。

项目运行起来之后，控制台显示一个二维码，说用 Android 上的 Expo Go 或者 iPhone 的摄像头扫这个二维码就可以。

结果用 iPhone 扫码并调起 Expo Go 之后，APP 里显示一大堆报错信息，那就上网先搜搜教程。

## 安装依赖

### 安装配置 React Native 环境

在 [React Native 基于Expo开发（一）项目搭建](https://juejin.cn/post/7102802785355169806) 这篇文章中，说先要配置 React Native 的环境。

于是安装文章中提供的 [搭建开发环境](https://www.react-native.cn/docs/environment-setup)，先把 Android Studio 装上了。

如果用 Google 到的国外地址，下载起来要么很慢，要么下载链接打不开。上网搜索了一下，还是在 V2EX 找到了好办法，就是去 Android Studio 的 [中国官网](https://developer.android.google.cn/studio?hl=zh-cn) 下载，速度飞快。

下载完成之后就[安装 Android Studio](https://www.react-native.cn/docs/environment-setup#1-%E5%AE%89%E8%A3%85-android-studio)，在安装前是可以配置 Proxy 的，配置好之后下载需要的 SDK、模拟器镜像什么的就不会卡住了。

然后就是 [安装 Android SDK](https://www.react-native.cn/docs/environment-setup#2-%E5%AE%89%E8%A3%85-android-sdk)，不过如果在前一步安装好 Android Studio 之后按照提示安装过了 SDK，就不用再安装了。

最后是 [配置 ANDROID_HOME 环境变量](https://www.react-native.cn/docs/environment-setup#3-%E9%85%8D%E7%BD%AE-android_home-%E7%8E%AF%E5%A2%83%E5%8F%98%E9%87%8F)，以及 [把一些工具目录添加到环境变量 Path](https://www.react-native.cn/docs/environment-setup#4-%E6%8A%8A%E4%B8%80%E4%BA%9B%E5%B7%A5%E5%85%B7%E7%9B%AE%E5%BD%95%E6%B7%BB%E5%8A%A0%E5%88%B0%E7%8E%AF%E5%A2%83%E5%8F%98%E9%87%8F-path)。

配置完成之后，启动 Android Studio，在 `More Action` 下拉菜单中，点击 `Virtual Device Manager`，能够看到已经安装的 Android 模拟器，这次默认安装的是 Pixel_3a_API_34（Android 14）。

运行模拟器里的 Chrome 浏览器，可以正常打开网站，说明模拟器没问题。

### 安装配置 Expo 项目

接着就是安装配置 Expo 项目了。

在 [Expo 官网](https://docs.expo.dev/get-started/installation/) 上，有详细的安装步骤。不过这次是 clone 的现有项目，所以流程不太一样。

把项目下载过来之后，先用 `yarn` 安装依赖。注意这里不要不要用 pnpm 安装依赖，，可能是软链接的原因，始终报错 `None of these files exist node_modules\expo\AppEntry node_modules\expo\AppEntry\index`。按照 [这里](https://stackoverflow.com/a/74725559/2667665) 的方法，用 `npx expo start --clear` 命令启动项目也还是报这个错误，最后想了想，删除了 `node_modules` 目录，再用 `yarn` 安装依赖，就没有问题了。

然后运行 `yarn start`，控制台会显示一个二维码，下面还有一些可用的命令。

因为这次是在模拟器上调试，所以用 `a` 命令启动 Android 模拟器，模拟器上会自动打开 Expo Go APP，并且加载项目。

在加载项目的过程中，还会下载一些依赖，所以 Android Studio 的 Proxy 配置不要关掉，保持开启即可。

## 功能开发

### 页面跳转

一开始照着现有的代码，新增了一个跳转语句，想着用户在点击按钮之后，直接跳转到自己要开发的页面。结果控制台报下面的错误：

```
The action 'NAVIGATE' with payload {"name":"Reward"} was not handled by any navigator.

Do you have a screen named 'Reward'?
```

又看了一下 [React Native 基于Expo开发（三）路由，跳转](https://juejin.cn/post/7105415240472330270) 这篇文章，发现 `MainStackScreen.js` 这个文件里有 `import stacks from './index'` 这么一条语句，从 `index` 文件里引入了项目用到的所有页面。

再查看自己本地的项目，`index.js` 里下面两句应该是注册了整个程序，类似于 Vue 的初始化。

```js
import App from "./App";
registerRootComponent(App);
```

再打开 `App.tsx` 文件，发现 `import Navigations from './src/navigations/Navigations';` 这句引入了 `Navigations` 文件。

再打开 `Navigations.tsx` 文件，发现这里面引入了所有页面，然后用 `createStackNavigator` 创建了一个 `Stack`，在 Stack 里注册了所有页面，包括页面的名称和一些其他参数。

比如有 `<Stack.Screen name="EmailLogin" options={{ headerShown: false }}>` 这么一个页面定义，那么就可以用 `navigation.navigate('EmailLogin')` 来跳转到这个页面了。