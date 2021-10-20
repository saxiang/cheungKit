//
//  STPickerMoreComponent.m
//  FengWatch
//
//  Created by yejingtao on 2021/5/27.
//  Copyright © 2021 phoenixtv. All rights reserved.
//

#import "STPickerMoreComponent.h"

@interface STPickerMoreComponent()<UIPickerViewDataSource, UIPickerViewDelegate>
/** 1.选中的字符串 */
@property (nonatomic, strong, nullable)NSString *selectedTitle;
@property (nonatomic, strong) NSMutableArray *selectedDatas;
@end

@implementation STPickerMoreComponent

#pragma mark - --- init 视图初始化 ---
- (void)setupUI
{
    [super setupUI];

    _titleUnit = @"";
    _arrayData = @[@[]].mutableCopy;
    _heightPickerComponent = 44;
    _widthPickerComponent = 32;

    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
}

#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.arrayData.count;
//    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([self.arrayData[component] isKindOfClass:[NSArray class]]) {
        NSArray *subArr = self.arrayData[component];
        return subArr.count;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if([self.arrayData[component] isKindOfClass:[NSArray class]]){
        NSArray *subArr = self.arrayData[component];
        if (subArr.count) {
            return self.widthPickerComponent;
        }
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.selectedDatas replaceObjectAtIndex:component withObject:self.arrayData[component][row]];
    
//    self.selectedTitle = self.arrayData[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    //设置分割线的颜色
    [pickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.size.height <=1) {
            obj.backgroundColor = self.borderButtonColor;
        }
    }];
    
    UILabel *label = [[UILabel alloc]init];
    [label setTextColor: self.itemColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    if ([self.arrayData[component][row] isKindOfClass:[NSString class]]) {
        [label setText:self.arrayData[component][row] ?:@""];
    }
//    else if ([self.arrayData[component][row] isKindOfClass:[FWSubtitleInfo class]]) {
//        FWSubtitleInfo *info = (FWSubtitleInfo *)self.arrayData[component][row];
//        label.text = info.title;
//    }
    return label;
    
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
//    if ([self.delegate respondsToSelector:@selector(pickerSingle:selectedTitle:)]) {
//        [self.delegate pickerSingle:self selectedTitle:self.selectedTitle];
//    }
    if ([self.delegate respondsToSelector:@selector(pickerMoreCompontent:selectedDatas:)]) {
        [self.delegate pickerMoreCompontent:self selectedDatas:self.selectedDatas];
    }
    
    [super selectedOk];
}

#pragma mark - Action
-(void)setDefaultSelectedWithIndex:(NSInteger)index Component:(NSInteger)component{
    [self.pickerView selectRow:index inComponent:component animated:NO];
}

#pragma mark - --- setters 属性 ---

- (void)setArrayData:(NSMutableArray<NSArray *> *)arrayData{
    _arrayData = arrayData;
    self.selectedDatas = [NSMutableArray array];
    int component = 0;
    for (NSArray *objArr in arrayData) {
        if (objArr.count) {
            [self.selectedDatas addObject:objArr.firstObject];
            [self.pickerView selectRow:0 inComponent:component animated:NO];
        }
        component ++;
    }
    [self.pickerView reloadAllComponents];
}


- (void)setTitleUnit:(NSString *)titleUnit
{
    _titleUnit = titleUnit;
    [self.pickerView reloadAllComponents];
}

#pragma mark - --- getters 属性 ---

- (NSMutableArray *)selectedDatas{
    if (!_selectedDatas) {
        _selectedDatas = [NSMutableArray array];
    }
    return _selectedDatas;
}
@end
