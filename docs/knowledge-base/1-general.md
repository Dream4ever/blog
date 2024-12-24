---
sidebar_position: 1
title: 通用部分
---

## 方法论

### 寻找 XXX 的最佳实践

**需求描述**

最近在做的这个项目，前端用的 Vue，后端用的 Express + MongoDB。因为之前写前端项目还算多一点，后端没怎么写过，所以这次的后端代码总感觉还有很大的提升空间，那么怎样能找到优质的代码，来学习借鉴呢？

**研究过程**

要找到优质的代码，在搜索关键词里可以加上 `best practice`。当然了，即使加上这组关键词，也要对搜索结果进行手动筛选。

就比如自己在研究 Express + Mongoose 的 API 怎样写才能更好的时候，用 `node mongodb crud best practice` 作为关键词来搜索，第一页的文章里，有借鉴价值的只有一篇，其它的文章都和 `best practice` 根本不沾边，只能算是 tutorial，入门指引。

但是即使用了上面的方法，也未必能如愿以偿，自己最后找到的比较满意的资源，是 FrontendMasters 上的一套收费课程，的开源代码：[api-design-node-v3](https://github.com/FrontendMasters/api-design-node-v3)。大致看了一下它的代码，个人认为已经完全可以拿来应用到生产项目中了。

这个开源项目是怎么找到的呢？是因为试了好几个关键字都没找到满意的结果，于是又用关键字 `design node api` 在 Google 上搜索，给出的第一个链接就是这个项目，点进去看了看，果然是个宝藏，哈哈。

看来即使是搜索这种看起来很简单的事，也得多花心思、多花功夫，像自己这次花了不少时间，总算找到自己满意的资源，还是相当值得的。

### 项目脚手架

#### 需求描述

不管是 Vue 还是 React，或者是后端 API 服务，初次上手的时候，都希望能有个现成的脚手架来提升自己的开发效率。

问题的关键不在于某个具体的项目，而是在于如何在 GitHub 上找到这种仓库。

#### 关键词

- scaffold
- boilerplate
- bootstrap
- create
- starter
- template
- stack

#### 参考项目

- [scaffold-eth/scaffold-eth](https://github.com/scaffold-eth/scaffold-eth)
🏗 forkable Ethereum dev stack focused on fast product iterations
- [vuejs/create-vue](https://github.com/vuejs/create-vue)
🛠️ Quickly scaffold a Vue project with `npm init vue@3`
- [vivekascoder/vite-vue-tailwind-jit](https://github.com/vivekascoder/vite-vue-tailwind-jit)
This template allows you to quickly scaffold a Vue project with Vue Router, VueX, TailwindCss with JIT Compiler and vite

### 项目架构梳理

#### Q

对于前后端分离的项目架构，有什么好的方法、工具可以进行梳理么？

画个时序图，倒是可以梳理整体流程上的架构。但是对于细节，感觉时序图这样的工具就无能为力了。

画个流程图的话，感觉画起来又很花时间。

所以有没有什么方法，能够既看到项目的整体架构，又看到项目的每处细节？是不是还得用时序图加别的什么图，搭配起来用？

#### A

多看 GitHub 开源项目的文档，要图文结合才能把设计说清楚。

写项目设计文档，其实就是写一份教程。如何把教程写得通俗易懂，也是一门学问。

## 兼容性数据统计

为了保证所研发的页面在各种电脑端、手机端上都能正常使用，就需要充分研究各类浏览器、手机系统的市场份额。

### PC 端 IE 份额统计

#### 友盟

- [2017上半年中国互联网发展趋势盘点](http://www.umeng.com/reports.html)
- [china_s_internet_development_trend_inventory_in_the_first_half_of_2017.pdf](http://tip.umeng.com/uploads/data_report/china_s_internet_development_trend_inventory_in_the_first_half_of_2017.pdf)

P13：PC端浏览器占比，2017年6月，IE系列26.5%。

#### Search1990

- [2017年12月，全球&国内浏览器市场份额排行榜](http://www.search1990.com/other/201611200936.html)

- IE9 8.80%
- IE8 6.56%
- IE7 2.38%

#### 百度统计流量研究院

链接：[https://tongji.baidu.com/data/browser](https://tongji.baidu.com/data/browser)

- IE9 8.42%
- IE8 7.41%
- IE7 2.66%

其它 15.56%，其中应当包含了 IE11 的份额。

#### StatCounter

[Desktop Browser Version Market Share China](http://gs.statcounter.com/browser-version-market-share/desktop/china/#monthly-201612-201712-bar)

- IE11 5.58%
- IE8 5.19%
- IE9 2.48%

#### 备注

- IE9：仅有部分OEM厂商在其出厂的电脑中预安装了IE9。
- IE7：预装于Vista及Server 2008中。

#### 总结

两大主流前端框架：React及Vue均原生支持IE9+。

React有兼容IE8的方案，但该框架较重，体量偏大，不适合于快速开发。

Vue则完全无法兼容IE8。类似的框架Avalon虽支持IE8，但实际应用中发现支持效果并不理想。

结合前面统计数据可知，IE9已经占据了相当程度的市场份额，且份额已经超越IE8。

IE8的份额仅占7%左右，视具体目标用户群体而定，该数量可能更低。

而为了兼容IE8，所需额外增加的工作量至少是一倍左右，有时甚至更多，因为除了上面JS框架的兼容性很差之外，IE8也几乎不支持HTML5、CSS3中的新特性。

因此，建议对IE8用户进行引导，建议其安装360等国产双核浏览器，既可保证用户可获得较好的用户体验，也不需要升级更新IE，以免产生新的问题。

#### 参考资料

- [Internet Explorer 9 - Wikipedia](https://en.wikipedia.org/wiki/Internet_Explorer_9)
- [Internet Explorer 7 - Wikipedia](https://en.wikipedia.org/wiki/Internet_Explorer_7)
- [CSS Compatibility in Internet Explorer](https://msdn.microsoft.com/en-us/library/hh781508%28v=vs.85%29.aspx?f=255&MSPPError=-2147217396)
- [Does IE8 support HTML5 and CSS3?](https://stackoverflow.com/questions/5497587/does-ie8-support-html5-and-css3)
- [Think you know the top web browsers?](https://medium.com/samsung-internet-dev/think-you-know-the-top-web-browsers-458a0a070175)

### 安卓版本统计

#### 关键字

- android version statistics
- 安卓 版本 统计
- google android version distribution

#### 参考链接

- [Google Chrome version history](https://ipfs.io/ipfs/QmXoypizjW3WknFiJnKLwHCnL72vedxjQkDDP1mXWo6uco/wiki/Google_Chrome_version_history.html)：列出了 Google Chrome 浏览器的各个版本，包含 Android 版。
- [Android version history](https://en.wikipedia.org/wiki/Android_version_history)：列出了 Android 的各个版本，并提到了搭配 Android 4.4 的 Chrome 最早版本为 30。
- [Android 操作系统分布 | 腾讯移动分析](https://mta.qq.com/mta/data/device/os)
- [Distribution dashboard  |  Android Developers](https://developer.android.com/about/dashboards/)：页面语言设置为英文，并且需要翻墙，才可显示统计数据
- [移动设备系统排名 | 百度统计 - 流量研究院](https://mtj.baidu.com/data/mobile/device)：无需 Flash，右上角系统版本选择 Android
- statcounter: [Mobile & Tablet Android Version Market Share China - 截止 18 年 5 月近一年的数据](http://gs.statcounter.com/android-version-market-share/mobile-tablet/china)
- Statistic: [Android operating system share worldwide by OS version from 2013 to 2018](https://www.statista.com/statistics/271774/share-of-android-platforms-on-mobile-devices-with-android-os/)

#### 结果统计

综合上面四个链接的统计数据，占一定市场份额的低版本安卓比例如下：

- 4.4：10% 左右
- 5.0：3% ~ 5%
- 5.1：18% 左右

### iOS 版本统计

#### 参考链接

- [移动设备系统排名 | 百度统计 - 流量研究院](https://mtj.baidu.com/data/mobile/device)：无需 Flash，右上角系统版本选择 iOS

#### 结果统计

根据上面的统计数据，iOS 11 用户为 65.62%，iOS 10 为 20.68%，iOS 9 为 8.29%，iOS 8 为 4.24%，总计 98.83%。

其余各低版本用户总计 1.17%，其中 iOS 7 0.93%。伴随着 2018 年 iOS 12 的发布，低版本用户比例将继续下降。

#### 实际数据分析

查看服务器上 IIS 的日志，访问页面的 UserAgent，Android 版本最低为 4.4.4，和测试机基本相同；iOS 版本最低为 8.3，比测试机还高一个大版本。

这样的话，以后业务开发就一定要用两台测试机做基础测试，通过之后再用其它较新设备测试。

### Vue 支持度统计

#### Vue 3.X

Google `vue3 chrome compatibility`。

看到这个 issue：[Minimum Browser versions supported by Vue library #1151](https://github.com/vuejs/docs/issues/1151)，提到在 [What browsers does Vue support?](https://vuejs.org/about/faq.html#what-browsers-does-vue-support) 中有说。

查看文档，说是 Vue 3 要正常使用，需要浏览器原生支持 `ECMAScript 2015 (ES6)`。

再查看 [Can I Use](https://caniuse.com/es6) 上面的数据，Chrome 系列浏览器从 51 开始就全面支持了，iOS Safari 从10 开始就全面支持了。

然后又查看 Google Analytics 上面 2022 年 6 月用户的 UserAgent 统计信息，Android 用户完全符合 Chrome >= 51 的标准，iOS Safari 的话，还是有少数用户（41 / 16327） iOS < 10。

这个用户数量很少，应该没什么影响，那以后新的前端项目就可以考虑直接用 Vue 3 + Vite 来创建了。

#### Vue 2.X

官方文档：

- iOS：10+
- Android：4.4+

用两个旧设备打开用 Vue.js 简单写的测试页面，都可以正常显示内容，iPhone 是 iOS 7，Android 是 4.4，那以后的页面开发就都用 Vue.js 了。

用真机 iOS 7 和 Android 4.4 测试，在 iOS 7 中检测 Vue.js 用到的特性 `Object.defineProperty` 和 `Object['__defineSetter__']`，结果都是支持的。

#### 参考资料

- [vue 兼容问题](https://segmentfault.com/q/1010000008190284)
- [Support for android 5 ? #6567](https://github.com/vuejs/vue/issues/6567): issue 中尤雨溪有回复，Android 最低支持到 4.4
- [How should I detect incompatible browsers? #770](https://github.com/vuejs/vue/issues/770)
- [IOS render issue #4183](https://github.com/vuejs/vue/issues/4183)
- [Vue does not render on older versions of IOS #6948](https://github.com/vuejs/vue/issues/6948)
