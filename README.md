无法正常显示进度.
cell在storyboard中初始化,初始化LoopProgressView重载`drawRect:`方法.
在tableView中加载cell过程中,涉及到重载机制,导致`drawRect:`不再被调用,导致无法执行绘制进度通道的方法.
### 优化问题
重写progress属性的setter方法,在setter方法中调用通道绘制操作.

