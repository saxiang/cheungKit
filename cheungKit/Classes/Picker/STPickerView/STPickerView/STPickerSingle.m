//
//  STPickerSingle.m
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/16.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import "STPickerSingle.h"

@interface STPickerSingle()<UIPickerViewDataSource, UIPickerViewDelegate>
/** 1.选中的字符串 */
@property (nonatomic, strong, nullable)NSString *selectedTitle;

@end

@implementation STPickerSingle

#pragma mark - --- init 视图初始化 ---
- (void)setupUI
{
    [super setupUI];

    _titleUnit = @"";
    _arrayData = @[].mutableCopy;
    _heightPickerComponent = 44;
    _widthPickerComponent = 32;

    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
}

#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 1;
    }else if (component == 1){
        return self.arrayData.count;
    }else {
        return 1;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    if (component == 0) {
        return 0;
//        return (self.st_width-self.widthPickerComponent)/2; // 不居中 注释掉
    }else if (component == 1){
        return self.widthPickerComponent;
    }else {
        return 0;
//        return (self.st_width-self.widthPickerComponent)/2; // 不居中 注释掉
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedTitle = self.arrayData[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    //设置分割线的颜色
    [pickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.size.height <=1) {
            obj.backgroundColor = self.borderButtonColor;
        }
    }];
    
    if (component == 0) {
		UILabel *label = (UILabel *)view;
		if (!label) {
			label = [[UILabel alloc]init];
			label.backgroundColor = [UIColor clearColor];
			label.textAlignment = NSTextAlignmentCenter;
			label.textColor = self.itemColor;
			// 字体自适应属性
			label.adjustsFontSizeToFitWidth = YES;
			// 自适应最小字体缩放比例
			label.minimumScaleFactor = 0.5f;
		}
		return label;
    }else if (component == 1){
        UILabel *label = [[UILabel alloc]init];
		[label setTextColor: self.itemColor];
        label.font = [UIFont systemFontOfSize:20];
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
		[label setTextColor: self.itemColor];
        [label setText:self.titleUnit];
        [label setTextAlignment:NSTextAlignmentLeft];
        return label;
    }
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    if ([self.delegate respondsToSelector:@selector(pickerSingle:selectedTitle:)]) {
        [self.delegate pickerSingle:self selectedTitle:self.selectedTitle];
    }
    
    [super selectedOk];
}

#pragma mark - Action
//czx 20191121 默认选中
-(void)setDefaultSelectedWithIndex:(NSInteger)index {
    [self.pickerView selectRow:index inComponent:1 animated:NO];
    if (index < self.arrayData.count) {
        self.selectedTitle = self.arrayData[index];
    }
}

#pragma mark - --- setters 属性 ---

- (void)setArrayData:(NSMutableArray<NSString *> *)arrayData
{
    _arrayData = arrayData;
    _selectedTitle = arrayData.firstObject;
    [self.pickerView reloadAllComponents];
}

- (void)setTitleUnit:(NSString *)titleUnit
{
    _titleUnit = titleUnit;
    [self.pickerView reloadAllComponents];
}

#pragma mark - --- getters 属性 ---
@end

