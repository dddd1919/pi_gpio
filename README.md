pi_gpio 控制器使用说明
=======
##概述
> pi_gpio 使用 [pi_piper](https://github.com/jwhitehorn/pi_piper)控制pi的GPIO输入输出和高低电压状态，控制部分参考了python编写的 [webiopi](https://github.com/ganadist/webiopi)

##使用说名

### 1.下载
> 首先下载控制程序 'git clone git@github.com:dddd1919/pi_gpio.git'

### 2.初始化
1. 安装ruby.本程序使用的是ruby 1.9.3, 其他版本可能不支持 pi_piper 这个gem.
2. 安装 bundle工具，使用命令 `bundle install`安装好所需gem

### 3.使用
- 运行服务，在程序根目录下执行命令 `thin start`. 由于pi上的权限问题（也可能是别的问题）局域网的其他ip可能无法访问，最好还是用 `sudo thin start`
- 浏览器访问地址 `localhost:3000` or 'RaspberryPi_ip:3000'

### 附
> GPIO图解 ![pin](http://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/turing-machine/pi_gpio.jpg)
> ###目前完成的功能：

- 针脚输出状态下的高低电平转换
- 重置所有针脚状态（到输出低电平）
- 刷新当前针脚状态
- 单独针脚输入输出状态切换控制
- 针脚输入状态下的实时监视
