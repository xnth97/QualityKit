# QualityKit
计算机实习的大作业

# 简介

基于 iOS 平台进行控制图绘制与过程能力分析的软件。

* 语言：Objective-C, C++, C
* 平台：iOS
* 数据库：Realm

## 可执行文件

Release 里的 HQSQualityKit.ipa。将其通过 iTunes 部署到 iPad 上即可运行。

## 源代码

项目使用 Xcode 6.3.1 在 OS X 10.10.3 下进行开发，源代码可直接 Clone 到本地。初次部署工程需在目录下执行`pod install`命令，使用生成的 xcworkspace 进行开发。如尚未安装 cocoapods，需执行`sudo gem install cocoapods`。

编译工程使用终端进入目录，执行`xcodebuild -target QualityKit -configuration Release`进行编译。

## 示例数据

将 SampleData 文件夹中的数据复制到沙盒的 Documents 文件夹下即可使用。

# Model

模型，用于处理逻辑、数据统计分析计算、文件与数据库 IO 操作、数据模型等的部分。主要处于后台进程运行。

## QKDef

各种宏定义以及一些统计常数。

## QKDataAnalyzer

根据特定质量管理控制图规则对数据进行处理的模块。类方法在头文件中有详细描述。

```objc
/**
 *  获取数组的统计学特征数据
 *
 *  @param dataArr  原数据数组
 *  @param rulesArr 对数据进行检测所应用的规则
 *  @param type     数据统计类型，如 C 图，XBar-R等
 *  @param block    回调 block，回调 UCL 值、LCL 值、CL 值、画图数组、出错点在画图数组中下标的数组及错误描述
 */
+ (void)getStatisticalValuesOfDoubleArray:(NSArray *)dataArr checkRulesArray:(NSArray *)rulesArr controlChartType:(NSString *)type withBlock:(void(^)(id UCLValue, id LCLValue, float CLValue, NSArray *plotArr, NSArray *indexesOfErrorPoints, NSString *errorDescription))block;

/**
 *  对数据进行计算
 *
 *  @param dataArray 原数据数组
 *  @param type      控制图类型
 *  @param block     回调 block，回调 UCL 值、LCL 值、CL 值、画图数组
 */
+ (void)calculateControlLineValuesOfData:(NSArray *)dataArray controlChartType:(NSString *)type block:(void(^)(id UCLValue, id LCLValue, float CLValue, NSArray *plotArr))block;

/**
 *  对绘图点数组进行检验
 *
 *  @param plotArray 绘图点数组
 *  @param UCL       UCL 值
 *  @param LCL       LCL 值
 *  @param CL        CL 值
 *  @param checkRule 检验规则，定义在 QKDef 里
 *  @param block     回调 block，回调出错点在绘图数组中的坐标、出错信息
 */
+ (void)checkData:(NSArray *)plotArray UCLValue:(id)UCL LCLValue:(id)LCL CLValue:(float)CL rule:(NSString *)checkRule block:(void(^)(NSArray *indexesOfErrorPoints, NSString *errorDescription))block;

/**
 *  对出错点进行修正。初始出错点数组个数不能为 0
 *
 *  @param dataArr            原始数据
 *  @param indexesOfErrorRows 出错点个数，即原始数据出错行数
 *  @param rulesArr           应用检测规则，定义在 QualityKitDef 里
 *  @param type               控制图类型
 *  @param block              回调 block，回调 UCL 值、LCL 值、CL 值、画图数组、出错点在画图数组中下标的数组及错误描述
 */
+ (void)fixData:(NSArray *)dataArr indexesOfErrorRows:(NSArray *)indexesOfErrorRows checkRules:(NSArray *)rulesArr controlChartType:(NSString *)type block:(void(^)(id UCLValue, id LCLValue, float CLValue, NSArray *plotArr, NSArray *indexesOfErrorPoints, NSString *errorDescription))block;

/**
 *  对数据使用已保存的控制图
 *
 *  @param dataArr  原始数据数组
 *  @param UCLValue UCL 值
 *  @param LCLValue LCL 值
 *  @param CLValue  CL 值
 *  @param rulesArr 应用检测规则数组
 *  @param type     控制图类型
 *  @param block    回调 block
 */
+ (void)getStatisticalValuesUsingSavedControlChartFromData:(NSArray *)dataArr UCL:(id)UCLValue LCL:(id)LCLValue CL:(float)CLValue checkRulesArray:(NSArray *)rulesArr controlChartType:(NSString *)type withBlock:(void(^)(NSArray *plotArr, NSArray *indexesOfErrorPoints, NSString *errorDescription))block;
```

## QKStatisticalFoundations

Objective-C 的统计学常用封装。类方法定义在头文件中，大多数不需要注释。

```objc
+ (float)sumValueOfArray:(NSArray *)array;
+ (float)averageValueOfArray:(NSArray *)array;
+ (float)maximumValueOfArray:(NSArray *)array;
+ (float)minimumValueOfArray:(NSArray *)array;
+ (float)standardDeviationValueOfArray:(NSArray *)array;
+ (float)rangeValueOfArray:(NSArray *)array;

/**
 *  重排序为递增数组
 *
 *  @param array 输入数组
 *
 *  @return 返回递增数组
 */
+ (NSArray *)ascendingArray:(NSArray *)array;

/**
 *  重排序为递减数组
 *
 *  @param array 输入数组
 *
 *  @return 返回递减数组
 */
+ (NSArray *)descendingArray:(NSArray *)array;

/**
 *  Shapiro-Wilk Normality Test
 *
 *  @param array The array to be tested.
 *
 *  @return BOOL value if the data is normally distributed.
 */
+ (BOOL)shapiroWilkTest:(NSArray *)array;
```

## QKProcessCapabilityAnalysis

用于进行过程能力分析的封装。

## QKDataManager

数据的读取、写入、编辑等封装。

## QKDataProcessor

数据模型转换器。涉及 Realm Object, NSArray, TSTableViewModel, QZWorkbook 等。

## QKExportManager

生成控制图的导出。

## Data Model

### QKData5

标准 XBar-R 等控制图的数据模型，Realm Object.

### QKSavedControlChart

用于存储控制图以使用控制图。数据结构如下：

* _name_: NSString
* _controlChartType_: NSString，基于 QKDef 的宏定义
* _UCLValue_: NSData，封装的 NSNumber 或 NSArray 的 UCL 值或数组
* _LCLValue_: NSData
* _CLValue_: float
* _subUCLValue_: NSData
* _subLCLValue_: NSData
* _subCLValue_: float

# View

视图，用于绘制直接出现在 UIWindow 上的 UIView，主要是控制图的绘制，在主线程运行。

## QKControlChartView

绘制控制图的类，直接继承 UIView。具有以下属性：

* _dataArr_: NSArray，原始数据数组
* _UCLValue_: id，UCL 值或数组，可能是 NSNumber 或 NSArray
* _LCLValue_: id
* _CLValue_: float
* _indexesOfErrorPoints_: NSArray，出错数据点的下标

## MsgDisplay

用于显示各种消息。

# Controller

控制器，响应 View 层的操作并传递到 Model 层处理，接收 Model 分析后的数据以及时更新 View 层。

## MainSplitViewController

项目的 RootViewController，管理左右分栏并初始化登录 view，负责相应逻辑判断与处理。

## MasterViewController

对 Excel 或 Realm 数据进行浏览、选择、新建与编辑。

## DetailViewController

显示或编辑已选中的数据。

## ControlChartViewController

根据选定类型及数据绘制控制图并导出控制图。主要属性：

* _chartType_: NSString，在 QKDef 中定义
* _dataArr_: NSArray，原始数据
* _savedControlChart_: QKSavedControlChart，如使用已保存的控制图则不为 nil
* _usingSavedControlChart_: Bool，是否使用已有控制图，其实赘余，不过为了方便

# RulesTableViewController

选择检验使用的规则、是否自动修正、Shapiro Wilk 检验显著性等。

## ProcessCapabilityViewController

进行过程能力分析，输入 USL 及 LSL 值并导出过程能力分析报告。

### 委托方法

* `- (void)pushPDFPreviewViewControllerWithFileName:(NSString *)fileName;`

## SelectControlChartViewController

通过框图选择合适的控制图类型。

### 委托方法

* `- (void)selectXBarRChart;`
* `- (void)selectXBarSChart;`
* `- (void)selectXMRChart;`
* `- (void)selectPChart;`
* `- (void)selectPnChart;`
* `- (void)selectCChart;`
* `- (void)selectUChart;`
* `- (void)generateChartWithSavedChart:(QKSavedControlChart *)savedChart;`

## SavedChartTableViewController

浏览与删除已保存的控制图。

# 致谢

本项目使用到的开源项目有：

* QZXLSReader
* JXLS
* TSUIKit
* SVProgressHUD
* ALActionBlocks
* Realm

在此致以感谢。
