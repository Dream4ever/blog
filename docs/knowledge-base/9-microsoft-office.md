---
sidebar_position: 9
title: Microsoft 相关问题
---

## 另存为 PDF 时内嵌的字体不显示

在检查部分 Office 文档另存为的 PDF 时，发现有些数字在 Office 文档中能正常显示，但是在嵌入了字体的 PDF 中显示为一个 ☒ 符号。

查看出问题的部分，发现字体为思源媒体。

上网搜索之后，发现是 `OTF 格式思源黑体` 这种字体特有的问题，卸载掉原有的字体，改为安装 TTF 格式的就没问题了。

Google 关键词：`ppt另存为PDF 嵌入字体 思源黑体不显示`。

参考文章：

- [思源字体无法嵌入 PPT 的解决方法](https://blog.jasongzy.com/source-ttf.html)
- [思源黑体、思源宋体的 TTF 版本](https://www.v2ex.com/t/399030)

最终使用的字体：[Pal3love / Source-Han-TrueType](https://github.com/Pal3love/Source-Han-TrueType)。
