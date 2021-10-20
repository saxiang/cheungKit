//
//  FSPickerView.m
//  FengWatch
//
//  Created by ChanChinCheung on 2021/9/9.
//  Copyright © 2021 phoenixtv. All rights reserved.
//

#import "FSPickerView.h"

#import "STPickerSingle.h"
#import "STPickerMoreComponent.h"
#import "STPickerDate.h"
#import "STPickerArea.h"
#import "NSCalendar+STPicker.h"

@implementation FSPickerViewConfig

-(CGFloat)heightPicker {
    if(_heightPicker == 0) {
        _heightPicker = 326 ;
    }
    return _heightPicker;
}

-(UIFont *)font {
    if (_font == nil) {
        _font = [UIFont systemFontOfSize:20];
       }
    return _font;
}

-(UIColor *)borderButtonColor {
    if(_borderButtonColor == nil) {
        _borderButtonColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0];
    }
    return _borderButtonColor;
}

-(UIColor *)itemColor {
    if (_itemColor == nil) {
        _itemColor = [UIColor whiteColor];
    }
    return _itemColor;
}

-(UIColor *)titleColor {
    if (_titleColor == nil) {
        _titleColor = [UIColor darkGrayColor];
    }
    return _titleColor;
}

-(CGFloat)heightPickerComponent {
    if (_heightPickerComponent == 0) {
        _heightPickerComponent = 48;
    }
    return _heightPickerComponent;
}

-(CGFloat)widthPickerComponent {
    if (_widthPickerComponent == 0) {
        _widthPickerComponent = [UIScreen mainScreen].bounds.size.width;
    }
    return _widthPickerComponent;
}

-(UIColor *)leftBtnTitleColor {
    if (_leftBtnTitleColor == nil) {
        _leftBtnTitleColor = [UIColor blackColor];
    }
    return _leftBtnTitleColor;
}

-(UIColor *)rightBtnTitleColor {
    if (_rightBtnTitleColor == nil) {
        _rightBtnTitleColor = [UIColor redColor];
    }
    return _rightBtnTitleColor;
}

-(CGFloat)contentViewCornerRadius {
    if (_contentViewCornerRadius == 0) {
        _contentViewCornerRadius = 6;
    }
    return _contentViewCornerRadius;
}

@end

@interface FSPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>
//当前选择的row
@property (nonatomic, assign) NSInteger selectedRow;
//当前选择的component
@property (nonatomic, assign) NSInteger selectedComponent;
//-FSPickerViewStyle_single 选中的字符串 */
@property (nonatomic, strong, nullable)NSString *selectedTitle;
//-FSPickerViewStyle_multiple 选中的字符串 */
@property (nonatomic, strong) NSMutableArray *selectedDatas;

//-FSPickerViewStyle_area
/** 1.数据源数组 */
@property (nonatomic, strong, nullable)NSArray *areaDatas;
/** 2.当前省数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayProvince;
/** 3.当前城市数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayCity;
/** 4.当前地区数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayArea;
/** 5.当前选中数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arraySelected;
/** 6.省份 */
@property (nonatomic, strong, nullable)NSString *province;
/** 7.城市 */
@property (nonatomic, strong, nullable)NSString *city;
/** 8.地区 */
@property (nonatomic, strong, nullable)NSString *area;

//-FSPickerViewStyle_date
/** 1.年 */
@property (nonatomic, assign)NSInteger year;
/** 2.月 */
@property (nonatomic, assign)NSInteger month;
/** 3.日 */
@property (nonatomic, assign)NSInteger day;

@end

@implementation FSPickerView

-(instancetype)initWithCustomPickerViewWithDatas:(NSArray *)array andDoneHandler: (selectedDoneBlock)doneHandler {
    if (self == [super init]) {
        self.config = [[FSPickerViewConfig alloc] init];
        [self setupUIWithType:0];
        [self configCommonConfig];
        CGRect re = self.pickerView.frame;
        self.pickerView.frame = CGRectMake(self.contentView.frame.size.width *0.5 - self.contentView.frame.size.width *0.5, re.origin.y, [UIScreen mainScreen].bounds.size.width - 32 + 14, re.size.height);
        self.arrayData = array.copy;
        self.selectedDoneBlock = doneHandler;
    }
    return self;
}

-(instancetype)initWithCustomPickerViewWithDatas:(NSArray *)array andDelegate:(id)delegator {
    if (self == [super init]) {
        self.delegate = delegator;
        self.config = [[FSPickerViewConfig alloc] init];
        [self setupUIWithType:0];
        [self configCommonConfig];
        CGRect re = self.pickerView.frame;
        self.pickerView.frame = CGRectMake(self.contentView.frame.size.width *0.5 - self.contentView.frame.size.width *0.5, re.origin.y, [UIScreen mainScreen].bounds.size.width - 32 + 14, re.size.height);
        self.arrayData = array.copy;
    }
    return self;
}

-(instancetype)initWithType:(FSPickerViewStyle)type andConfig:(FSPickerViewConfig *)config andDelegate:(id)delegator {
    if (self == [super init]) {
        self.delegate = delegator;
        self.pickerViewStyle = type;
        if(!config) {
            config = [[FSPickerViewConfig alloc] init];
        }
        self.config = config;
        [self setupUIWithType:type];
        [self configCommonConfig];
        CGRect re = self.pickerView.frame;
        self.pickerView.frame = CGRectMake(self.contentView.frame.size.width *0.5 - self.contentView.frame.size.width *0.5, re.origin.y, [UIScreen mainScreen].bounds.size.width - 32 + 14, re.size.height);
        //默认YES
        self.saveHistory = YES;
    }
    return self;
}

-(instancetype)initAreaPickerWithAreaDatas:(NSArray *)datas andConfig:(FSPickerViewConfig *)config andDelegate:(id)delegator {
    if (self == [super init]) {
        self.delegate = delegator;
        _areaDatas = datas;
        if(!config) {
            config = [[FSPickerViewConfig alloc] init];
        }
        self.config = config;
        self.pickerViewStyle = FSPickerViewStyleArea;
        [self setupUIWithType:self.pickerViewStyle];
        [self configCommonConfig];
        CGRect re = self.pickerView.frame;
        self.pickerView.frame = CGRectMake(self.contentView.frame.size.width *0.5 - self.contentView.frame.size.width *0.5, re.origin.y, [UIScreen mainScreen].bounds.size.width - 32 + 14, re.size.height);
        
        //默认YES
        self.saveHistory = YES;
    }
    return self;
}

-(void)configCommonConfig {
    //设置通用配置
    self.commonFont = self.config.font;
    self.titleColor = self.config.titleColor;
    self.borderButtonColor = self.config.borderButtonColor;
    self.heightPicker = self.config.heightPicker;
    self.contentMode = self.config.contentMode;
    self.itemColor = self.config.itemColor;
    [self.buttonLeft setTitleColor:self.config.leftBtnTitleColor forState:UIControlStateNormal];
    [self.buttonRight setTitleColor:self.config.rightBtnTitleColor forState:UIControlStateNormal];
    self.buttonLeft.layer.borderWidth = self.config.leftBtnBorderWith;
    self.buttonRight.layer.borderWidth = self.config.rightBtnBorderWith;
    self.contentView.layer.cornerRadius = self.config.contentViewCornerRadius;
    self.contentView.layer.masksToBounds = YES;
}

-(void)setupUIWithType:(FSPickerViewStyle)type {
    if(type == 0) {
        _titleUnit = @"";
        _arrayData = @[].mutableCopy;
    }
    
    if(type == FSPickerViewStyleArea) {
        self.config.widthPickerComponent = ([UIScreen mainScreen].bounds.size.width - 32) / 3;
        // 1.获取数据
        [self.areaDatas enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayProvince addObject:obj[@"state"]];
        }];

        NSMutableArray *citys = [NSMutableArray arrayWithArray:[self.areaDatas firstObject][@"cities"]];
        [citys enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayCity addObject:obj[@"city"]];
        }];

        self.arrayArea = [citys firstObject][@"area"];

        self.province = self.arrayProvince[0];
        self.city = self.arrayCity[0];
        if (self.arrayArea.count != 0) {
            self.area = self.arrayArea[0];
        }else{
            self.area = @"";
        }
        [self setTitle:@"请选择城市地区"];
    }
    else if(type == FSPickerViewStyleDate) {
        self.config.widthPickerComponent = ([UIScreen mainScreen].bounds.size.width - 32) / 3;
        self.title = @"请选择日期";
        _yearLeast = 1900;
        _yearSum   = 200;
        _year  = [NSCalendar currentYear];
        _month = [NSCalendar currentMonth];
        _day   = [NSCalendar currentDay];
    }
    
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
}

#pragma mark - --- public methods 公开方法 ---
// 默认选中
-(void)setDefaultSelectedWithIndex:(NSInteger)index Component:(NSInteger)component {
    NSInteger cp = component;
    //单列
    if ([self returnPickerViewCompoentCount] == 1) {
        cp = 1;
        if (index < self.arrayData.count) {
            self.selectedTitle = self.arrayData[index];
        }
    }
    
    //多列
    if ([self returnPickerViewCompoentCount] > 1) {
        if (component == 0) {
            NSArray *tempArray = self.arrayData[0];
            [self.selectedDatas replaceObjectAtIndex:component withObject:tempArray[index]];
        }
        else {
            NSDictionary *tempDic = (NSDictionary *)self.arrayData[component];
            NSString *key = self.selectedDatas[component-1];//上一列选中值
            NSArray *titlesArray = tempDic[key];
            if (titlesArray) {
                [self.selectedDatas replaceObjectAtIndex:component withObject:titlesArray[index]];
            }
        }
    }
    [self.pickerView selectRow:index inComponent:cp animated:NO];
}

-(void)setDefaultDateWithYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day {
    self.year = year;
    self.month = month;
    [self.pickerView selectRow:(year - _yearLeast) inComponent:0 animated:NO];
    [self.pickerView selectRow:(month - 1) inComponent:1 animated:NO];
    [self.pickerView selectRow:(day - 1) inComponent:2 animated:NO];
    [self.pickerView reloadAllComponents];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    NSInteger index0 = [self.pickerView selectedRowInComponent:0];
    NSInteger index1 = [self.pickerView selectedRowInComponent:1];
    NSInteger index2 = [self.pickerView selectedRowInComponent:2];
    self.province = self.arrayProvince[index0];
    self.city = self.arrayCity[index1];
    if (self.arrayArea.count != 0) {
        self.area = self.arrayArea[index2];
    }else{
        self.area = @"";
    }
    
    NSString *title = [NSString stringWithFormat:@"%@ %@ %@", self.province, self.city, self.area];
    [self setTitle:title];
}

/// 验证设置的默认值
- (void)configDefaultValues {
    if (_selectedDatas.count < _arrayData.count) { // 默认值的个数<列的个数时
        
        while (_selectedDatas.count < _arrayData.count) {// 补全默认值为空
            [_selectedDatas addObject:@""];
        }
    }
    else if (_selectedDatas.count > _arrayData.count) {// 移除多余的
        
        NSInteger index = _arrayData.count;
        while (_arrayData.count < _selectedDatas.count) {
            [_selectedDatas removeObjectAtIndex:index];
        }
    }
    
    NSArray *tempDefaultValues = [_selectedDatas copy];
    // 个数相同的时候, 判断每一个下标是否合法
    [tempDefaultValues enumerateObjectsUsingBlock:^(NSString   * _Nonnull obj, NSUInteger component, BOOL * _Nonnull stop) {
        
        if (component == 0) { // 数组
            NSArray *tempArray = (NSArray *)_arrayData[0];
            if (![tempArray containsObject:obj]) {
                // 如果这一列设置的默认值不存在
                [_selectedDatas replaceObjectAtIndex:0 withObject:tempArray[0]];
                
            }
        }
        else { // 字典
            NSDictionary *tempDic = (NSDictionary *)_arrayData[component];
            NSString *key = _selectedDatas[component-1];//上一列选中值
            NSArray *titlesArray = tempDic[key]; //  上一列选中值对应的这一列的数据
            if (![titlesArray containsObject:obj]) {

                if (titlesArray && titlesArray.count != 0) {
                    // 如果这一列设置的默认值不存在
                    [_selectedDatas replaceObjectAtIndex:component withObject:titlesArray[0]];
                }
            }
        }
        
    }];
}

//判断列数
-(NSInteger)returnPickerViewCompoentCount {
    if (self.arrayData.count > 1 && [self.arrayData[1] isKindOfClass:[NSDictionary class]]) {
        //多列
        return self.arrayData.count;
    }
    else if (self.arrayData.count > 0){
        //单列
        return 1;
    }
    else {
        return 0;
    }
}

#pragma mark - --- event response 事件相应 ---

- (void)selectedOk {
    if ([self returnPickerViewCompoentCount] == 1) {
        if ([self.delegate respondsToSelector:@selector(FSPickerViewSingle:selectedTitle:andRow:andComponent:)]) {
            [self.delegate FSPickerViewSingle:self selectedTitle:self.selectedTitle andRow:self.selectedRow andComponent:1];
        }
    }
    
    if ([self returnPickerViewCompoentCount] > 1) {
        if ([self.delegate respondsToSelector:@selector(FSPickerViewMultiple:selectedDatas:andIndexPath:)]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedRow inSection:self.selectedComponent];
            [self.delegate FSPickerViewMultiple:self selectedDatas:self.selectedDatas andIndexPath:indexPath];
        }
    }
    
    if(self.pickerViewStyle == FSPickerViewStyleArea) {
        if (self.isSaveHistory) {
            NSDictionary *dicHistory = @{@"province":self.province, @"city":self.city, @"area":self.area};
            [[NSUserDefaults standardUserDefaults] setObject:dicHistory forKey:@"FSPickerArea"];
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"FSPickerArea"];
        }
        
        if ([self.delegate respondsToSelector:@selector(FSPickerViewArea:province:city:area:)]) {
            [self.delegate FSPickerViewArea:self province:self.province city:self.city area:self.area];
        }
        
        self.selectedDatas = @[self.province, self.city, self.area].mutableCopy;
    }
    
    if(self.pickerViewStyle == FSPickerViewStyleDate) {
        NSInteger day = [self.pickerView selectedRowInComponent:2] + 1;
        if ([self.delegate respondsToSelector:@selector(FSPickerViewDate:year:month:day:)]) {
            [self.delegate FSPickerViewDate:self year:self.year month:self.month day:day];
        }
        
        self.selectedDatas = @[@(self.year), @(self.month), @(day)].mutableCopy;
    }

    if (self.selectedDoneBlock) {
        self.selectedDoneBlock(self.selectedDatas);
    }
    [super selectedOk];
}

#pragma mark - --- delegate 视图委托 ---
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if([self returnPickerViewCompoentCount] == 1 || self.pickerViewStyle == FSPickerViewStyleDate || self.pickerViewStyle == FSPickerViewStyleArea) {
        return 3;
    }
    else  if ([self returnPickerViewCompoentCount] > 1) {
        return self.arrayData.count;
    }

    else if(self.pickerViewStyle == FSPickerViewStyleArea) {
        return self.arrayData.count;
    }
    else {
        return 0;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([self returnPickerViewCompoentCount] == 1) {
        if (component == 0) {
            return 1;
        }else if (component == 1){
            return self.arrayData.count;
        }else {
            return 1;
        }
    }
    
    if ([self returnPickerViewCompoentCount] > 1) {
        if (component == 0) {
            NSArray *tempArray = (NSArray *)self.arrayData[0];
            if (tempArray) {
                return tempArray.count;
            }
            return 0;
        }
        else {
            NSDictionary *tempDic = (NSDictionary *)self.arrayData[component];
            NSString *key = self.selectedDatas[component-1];//上一列选中值
            NSArray *titlesArray = tempDic[key];
            if (titlesArray) {
                return titlesArray.count;
            }
            return 0;
        }
    }
    
    if(self.pickerViewStyle == FSPickerViewStyleArea) {
        if (component == 0) {
            return self.arrayProvince.count;
        }else if (component == 1) {
            return self.arrayCity.count;
        }else{
            return self.arrayArea.count;
        }
    }
    
    if(self.pickerViewStyle == FSPickerViewStyleDate) {
        switch (component) {
            case 0:
                return self.yearSum;
                break;
            case 1:
                return 12;
                break;
            default:
                return [NSCalendar getDaysWithYear:self.year month:self.month];
                break;
        }
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if ([self returnPickerViewCompoentCount] == 1) {
        if (component == 0) {
            return 0;
    //        return (self.st_width-self.widthPickerComponent)/2; // 不居中 注释掉
        }else if (component == 1){
            return self.config.widthPickerComponent;
        }else {
            return 0;
    //        return (self.st_width-self.widthPickerComponent)/2; // 不居中 注释掉
        }
    }
    
    if ([self returnPickerViewCompoentCount] > 1) {
        if([self.arrayData[0] isKindOfClass:[NSArray class]]){
                return self.config.widthPickerComponent;
        }
        return 0;
    }
    
    return 344 / 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.config.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedRow = row;
    self.selectedComponent = component;
    
    if ([self returnPickerViewCompoentCount] == 1) {
        self.selectedTitle = self.arrayData[row];
        [self.selectedDatas removeAllObjects];
        [self.selectedDatas addObject:self.selectedTitle];
    }
    
    if ([self returnPickerViewCompoentCount] > 1) {
        
        if (component == 0) {

            NSArray *tempArray = (NSArray *)_arrayData[0];
            [_selectedDatas replaceObjectAtIndex:component withObject:tempArray[row]];
        }
        else {

            NSDictionary *tempDic = (NSDictionary *)_arrayData[component];
            NSString *key = _selectedDatas[component-1];//上一列选中值
            NSArray *titlesArray = tempDic[key];
            //修改本列选中值
            if (titlesArray && titlesArray.count != 0) { // 判断是否为0个元素, 是因为递归的时候 row = 0(越界)
                [_selectedDatas replaceObjectAtIndex:component withObject:titlesArray[row]];
            }
            else {// 说明当前选中的这一列没有下一列的关联数据, 将之后的全部设置为空
                NSInteger index = component;
                for (; index < _selectedDatas.count; index++) {
                    [_selectedDatas replaceObjectAtIndex:component withObject:@""];

                }
            }
        }
        
        if (component < _arrayData.count-1) {
            [pickerView reloadComponent:component+1];
            // 递归刷新下一列的数据
            [self pickerView:pickerView didSelectRow:0 inComponent:component+1];
            // 设置选中第一个
            [pickerView selectRow:0 inComponent:component+1 animated:YES];
        }
    }
    
    if(self.pickerViewStyle == FSPickerViewStyleDate) {
        switch (component) {
            case 0:{
                self.year = row + self.yearLeast;
                [pickerView reloadComponent:2];
            }break;
            case 1:{
                self.month = row + 1;
                [pickerView reloadComponent:2];
            }break;
            case 2:{
            }break;
        }
    }
    
    if(self.pickerViewStyle == FSPickerViewStyleArea) {
        if (component == 0) {
            self.arraySelected = self.areaDatas[row][@"cities"];

            [self.arrayCity removeAllObjects];
            [self.arraySelected enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.arrayCity addObject:obj[@"city"]];
            }];

            self.arrayArea = [NSMutableArray arrayWithArray:[self.arraySelected firstObject][@"areas"]];

            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];

        }else if (component == 1) {
            if (self.arraySelected.count == 0) {
                self.arraySelected = [self.areaDatas firstObject][@"cities"];
            }

            self.arrayArea = [NSMutableArray arrayWithArray:[self.arraySelected objectAtIndex:row][@"areas"]];

            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];

        }else{
        }

        [self reloadData];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    //设置分割线的颜色
    [pickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.size.height <=1) {
            obj.backgroundColor = self.config.borderButtonColor;
        }
    }];
    
    if ([self returnPickerViewCompoentCount] == 1) {
        if (component == 0) {
            UILabel *label = (UILabel *)view;
            if (!label) {
                label = [[UILabel alloc]init];
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = self.config.itemColor;
                // 字体自适应属性
                label.adjustsFontSizeToFitWidth = YES;
                // 自适应最小字体缩放比例
                label.minimumScaleFactor = 0.5f;
            }
            return label;
        }else if (component == 1){
            UILabel *label = [[UILabel alloc]init];
            [label setTextColor: self.config.itemColor];
            label.font = self.config.font;
            [label setText:self.arrayData[row]];
            if([label.text isEqualToString:@"超清"]) {

                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"超清"];
                //插入试用图片
                NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
                // 表情图片
                attchImage.image = [UIImage imageNamed:@"myCache_probation"];
                // 设置图片大小
                attchImage.bounds = CGRectMake(4, -2, 24, 16);
                NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
    //            [attributedString insertAttributedString:stringImage atIndex:2];
                [attributedString appendAttributedString:stringImage]; //添加到尾部
                label.attributedText = attributedString;
            }
            
            [label setTextAlignment:NSTextAlignmentCenter];
            return label;
        }else {
            UILabel *label = [[UILabel alloc]init];
            [label setTextColor: self.config.itemColor];
            [label setText:self.titleUnit];
            [label setTextAlignment:NSTextAlignmentLeft];
            return label;
        }
    }
    
    if ([self returnPickerViewCompoentCount] > 1) {
        UILabel *label = [[UILabel alloc]init];
        [label setTextColor: self.config.itemColor];
        label.font = self.config.font;
        label.textAlignment = NSTextAlignmentCenter;
        NSString *title = @"";
        if (component == 0) {//数组
            NSArray *tempArray = (NSArray *)_arrayData[0];
            title = tempArray[row];
        }
        else {//字典
            NSDictionary *tempDic = (NSDictionary *)_arrayData[component];
            NSString *key = _selectedDatas[component-1];//上一列选中值
            NSArray *titlesArray = tempDic[key];
            if (titlesArray && titlesArray.count != 0) {// 如果对应的值存在, 并且不为空
                title = titlesArray[row];
            }

        }
        label.text = title;
        return label;
    }
    
    if(self.pickerViewStyle == FSPickerViewStyleArea) {
        NSString *text;
        if (component == 0) {
            text =  self.arrayProvince[row];
        }else if (component == 1){
            text =  self.arrayCity[row];
        }else{
            if (self.arrayArea.count > 0) {
                text = self.arrayArea[row];
            }else{
                text =  @"";
            }
        }
        UILabel *label = [[UILabel alloc]init];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:self.config.font];
        [label setTextColor: self.config.itemColor];
        [label setText:text];
        return label;
    }
    
    if(self.pickerViewStyle == FSPickerViewStyleDate) {
        NSString *text;
        if (component == 0) {
            text =  [NSString stringWithFormat:@"%zd", row + self.yearLeast];
        }else if (component == 1){
            text =  [NSString stringWithFormat:@"%zd", row + 1];
        }else{
            text = [NSString stringWithFormat:@"%zd", row + 1];
        }
        UILabel *label = [[UILabel alloc]init];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:self.config.font];
        [label setTextColor: self.config.itemColor];
        [label setText:text];
        return label;
    }

    return nil;
}

#pragma mark - --- getters 属性 ---
- (NSMutableArray *)selectedDatas{
    if (!_selectedDatas) {
        _selectedDatas = [NSMutableArray array];
    }
    return _selectedDatas;
}

- (NSArray *)areaDatas
{
    if (!_areaDatas) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
        _areaDatas = [[NSArray alloc]initWithContentsOfFile:path];
    }
    return _areaDatas;
}

- (NSMutableArray *)arrayProvince
{
    if (!_arrayProvince) {
        _arrayProvince = @[].mutableCopy;
    }
    return _arrayProvince;
}

- (NSMutableArray *)arrayCity
{
    if (!_arrayCity) {
        _arrayCity = @[].mutableCopy;
    }
    return _arrayCity;
}

- (NSMutableArray *)arrayArea
{
    if (!_arrayArea) {
        _arrayArea = @[].mutableCopy;
    }
    return _arrayArea;
}

- (NSMutableArray *)arraySelected
{
    if (!_arraySelected) {
        _arraySelected = @[].mutableCopy;
    }
    return _arraySelected;
}

#pragma mark - --- setters 属性 ---
- (void)setArrayData:(NSMutableArray *)arrayData {
    _arrayData = arrayData;
    _selectedTitle = arrayData.firstObject;
    
    if ([self returnPickerViewCompoentCount] > 1) {
        //计算列宽度
        self.config.widthPickerComponent = ([UIScreen mainScreen].bounds.size.width - 32) / arrayData.count;

        for (NSInteger i = 0; i < arrayData.count; i++) {
            if (i == 0) {
                NSArray *tempArray = arrayData[0];
                [self.selectedDatas addObject:tempArray[0]];
            }
            NSDictionary *tempDic = (NSDictionary *)arrayData[i];
            NSString *key = self.selectedDatas[i-1];//上一列选中值
            NSArray *titlesArray = tempDic[key];
            if (titlesArray) {
                [self.selectedDatas addObject:titlesArray[0]];
            }
        }
        [self configDefaultValues];
    }
    else if ([self returnPickerViewCompoentCount] == 1) {
        [self.selectedDatas addObject:arrayData.firstObject];
    }
    
    [self.pickerView reloadAllComponents];
}

- (void)setTitleUnit:(NSString *)titleUnit
{
    _titleUnit = titleUnit;
    [self.pickerView reloadAllComponents];
}

- (void)setYearLeast:(NSInteger)yearLeast
{
    if (yearLeast<=0) {
        return;
    }
    
    _yearLeast = yearLeast;
    [self.pickerView selectRow:(_year - _yearLeast) inComponent:0 animated:NO];
    [self.pickerView selectRow:(_month - 1) inComponent:1 animated:NO];
    [self.pickerView selectRow:(_day - 1) inComponent:2 animated:NO];
    [self.pickerView reloadAllComponents];
}

- (void)setYearSum:(NSInteger)yearSum{
    if (yearSum<=0) {
        return;
    }
    
    _yearSum = yearSum;
    [self.pickerView reloadAllComponents];
}

- (void)setSaveHistory:(BOOL)saveHistory{
    _saveHistory = saveHistory;
    if (self.pickerViewStyle != FSPickerViewStyleArea) {
        return;
    }
    
    if (saveHistory) {
        NSDictionary *dicHistory = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"FSPickerArea"];
        __block NSUInteger numberProvince = 0;
        __block NSUInteger numberCity = 0;
        __block NSUInteger numberArea = 0;
        
        if (dicHistory) {
            NSString *province = [NSString stringWithFormat:@"%@", dicHistory[@"province"]];
            NSString *city = [NSString stringWithFormat:@"%@", dicHistory[@"city"]];
            NSString *area = [NSString stringWithFormat:@"%@", dicHistory[@"area"]];
            
            [self.arrayProvince enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:province]) {
                    numberProvince = idx;
                }
            }];
            
            self.arraySelected = self.areaDatas[numberProvince][@"cities"];
            
            [self.arrayCity removeAllObjects];
            [self.arraySelected enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.arrayCity addObject:obj[@"city"]];
            }];
            
            [self.arrayCity enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:city]) {
                    numberCity = idx;
                }
            }];
            
            if (self.arraySelected.count == 0) {
                self.arraySelected = [self.areaDatas firstObject][@"cities"];
            }
            
            self.arrayArea = [NSMutableArray arrayWithArray:[self.arraySelected objectAtIndex:numberCity][@"areas"]];
            
            [self.arrayArea enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:area]) {
                    numberArea = idx;
                }
            }];
            
            [self.pickerView selectRow:numberProvince inComponent:0 animated:NO];
            [self.pickerView selectRow:numberCity inComponent:1 animated:NO];
            [self.pickerView selectRow:numberArea inComponent:2 animated:NO];
            [self.pickerView reloadAllComponents];
            [self reloadData];
        }
    }
}

@end
