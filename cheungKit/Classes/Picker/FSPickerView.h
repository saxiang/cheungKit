//
//  FSPickerView.h
//  FengWatch
//
//  Created by ChanChinCheung on 2021/9/9.
//  Copyright © 2021 phoenixtv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPickerView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,FSPickerViewStyle)
{
    FSPickerViewStyleArea = 1, //地区
    FSPickerViewStyleDate = 2, //日期
};

@interface FSPickerViewConfig : NSObject

/*
 common property
*/
//字体,default is heading2
@property(null_resettable, nonatomic,strong) UIFont   *font;
//字体颜色，default is textColorPrimary
@property(null_resettable, nonatomic,strong) UIColor  *titleColor;
//按钮边框颜色颜色，default is RGB(205, 205, 205)
@property(null_resettable, nonatomic,strong) UIColor  *borderButtonColor;
//选择器的高度，default is 326 *myWidthScale
@property (nonatomic, assign)CGFloat heightPicker;
//视图的显示模式
@property (nonatomic, assign)STPickerContentMode contentMode;

@property(null_resettable, nonatomic,strong) UIColor *itemColor;
//中间选择框的高度，default is 44
@property (nonatomic, assign)CGFloat heightPickerComponent;
//左按钮title颜色 默认textColorPrimary
@property(null_resettable, nonatomic,strong) UIColor  *leftBtnTitleColor;
//右按钮title颜色 默认fengshowColor
@property(null_resettable, nonatomic,strong) UIColor  *rightBtnTitleColor;
//左按钮borderWith 默认0
@property (nonatomic, assign)CGFloat leftBtnBorderWith;
//右按钮borderWith 默认0
@property (nonatomic, assign)CGFloat rightBtnBorderWith;
//picker圆角//默认 6
@property (nonatomic, assign)CGFloat contentViewCornerRadius;
//中间选择框的宽度，default is 1列数据-FWScaleRealFloat(SCREENWIDTH *0.8)
@property (nonatomic, assign)CGFloat widthPickerComponent;

@end

@class FSPickerView;
@protocol FSPickerViewDelegate<NSObject>
//单选picker 代理
- (void)FSPickerViewSingle:(FSPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle andRow:(NSInteger)row andComponent:(NSInteger)component;
//多选picker 代理
- (void)FSPickerViewMultiple:(FSPickerView *)pickerView selectedDatas:(NSArray *)datas andIndexPath:(NSIndexPath *)indexpatch;
//地区picker 代理
- (void)FSPickerViewArea:(FSPickerView *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area;
//日期选择picker 代理
- (void)FSPickerViewDate:(FSPickerView *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

@end

typedef void(^selectedDoneBlock)(NSMutableArray *selectedValues);
@interface FSPickerView : STPickerView

@property (nonatomic, copy) selectedDoneBlock selectedDoneBlock;
//配置项
@property (nonatomic, strong) FSPickerViewConfig *config;

@property (nonatomic, assign)FSPickerViewStyle pickerViewStyle;

@property (nonatomic, weak) id<FSPickerViewDelegate> delegate;

//设置字符串数据数组
//multiple stlye多列数据结构参考:
//NSArray *multipleAssociatedData = @[// 数组
//                                    @[@"交通工具", @"食品", @"游戏"], //这是第一列  --- 数组
//                                     @{   /*key- 第一列中的   value(数组) --> 对应的第二类的数据 */
//                                         @"交通工具": @[@"陆地", @"空中", @"水上"],//字典
//                                         @"食品": @[@"健康食品", @"垃圾食品"],
//                                         @"游戏": @[@"益智游戏", @"角色游戏"]
//                                     },
//                                     @{ /*key- 第二列中的   value(数组) --> 对应的第三类的数据 */
//                                          @"陆地": @[@"公交车", @"小轿车", @"自行车"],
//                                          @"空中": @[@"飞机"],
//                                          @"水上": @[@"轮船"],
//                                          @"健康食品": @[@"蔬菜", @"水果"],
//                                          @"垃圾食品": @[@"辣条", @"狗屎"],
//                                          @"益智游戏": @[@"消消乐", @"消灭星星"],
//                                          @"角色游戏": @[@"lol", @"cf"]
//                                     }
// .......
//                                  ];
@property (nonatomic, strong)NSMutableArray *arrayData;
//设置字符串数据数组 子array中可以是NSString和FWBaseinfo //multiple stlye
//@property (nonatomic, strong)NSMutableArray *multipleArrayData;
//设置单位标题
@property (nonatomic, strong)NSString *titleUnit;

/*
 FSPickerStyle_date property
*/
//最小的年份，default is 1900
@property (nonatomic, assign)NSInteger yearLeast;
//显示年份数量，default is 200
@property (nonatomic, assign)NSInteger yearSum;

/*
 FSPickerStyle_area property
*/
//保存之前的选择地址，default is YES
@property(nonatomic, assign, getter=isSaveHistory)BOOL saveHistory;

/// 构造通用pickerView
/// @param array 数据 数据结构参考 - arrayData属性
/// @param doneHandler 点击确定回调
-(instancetype)initWithCustomPickerViewWithDatas:(NSArray *)array andDoneHandler: (selectedDoneBlock)doneHandler;

/// 构造通用pickerView
/// @param array 数据 数据结构参考 - arrayData属性
/// @param delegator 代理
-(instancetype)initWithCustomPickerViewWithDatas:(NSArray *)array andDelegate:(id)delegator;

/// 通过指定样式配置构造pickerView
/// @param type picker类型 FSPickerViewStyleArea & FSPickerViewStyleDate
/// @param config 样式配置  传nil则使用默认配置
/// @param delegator 代理对象
-(instancetype)initWithType:(FSPickerViewStyle)type andConfig:(FSPickerViewConfig *_Nullable)config andDelegate:(id)delegator;

/// 用于构造自定义省市区数据的Area picker
/// @param datas 省市区数据源 数据结构
/// @[
///   @{
///     @"state" : @"省", @"cities : @[
///                           @{
///                              @"city" : @"市", @"area" : @[
///                                                    @"区"
///                                                   ]
///                            }
///                           ]
///    }
///   ]
/// @param config 样式配置 传nil则使用默认配置
/// @param delegator 代理对象
-(instancetype)initAreaPickerWithAreaDatas:(NSArray *)datas andConfig:(FSPickerViewConfig *_Nullable)config andDelegate:(id)delegator;

/// 设置默认选中
/// @param index index
/// @param component component
-(void)setDefaultSelectedWithIndex:(NSInteger)index Component:(NSInteger)component;

/*
 FSPickerStyle_date
*/
/// 显示默认日期
/// @param year 年份
/// @param month 月份
/// @param day 日
-(void)setDefaultDateWithYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day;

@end

NS_ASSUME_NONNULL_END
