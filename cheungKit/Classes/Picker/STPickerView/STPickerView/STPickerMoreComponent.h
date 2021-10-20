//
//  STPickerMoreComponent.h
//  FengWatch
//
//  Created by yejingtao on 2021/5/27.
//  Copyright © 2021 phoenixtv. All rights reserved.
//

#import "STPickerView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol  STPickerMoreComponentDelegate<NSObject>
//datas的子數組中 會有NString 和 FWBaseInfo及其子類
- (void)pickerMoreCompontent:(STPickerView *)pickerView selectedDatas:(NSArray<NSArray*>*)datas;
@end
@interface STPickerMoreComponent : STPickerView
/** 1.设置字符串数据数组 子array中可以是NSString和FWBaseinfo */
@property (nonatomic, strong)NSMutableArray<NSArray *> *arrayData;
/** 2.设置单位标题 */
@property (nonatomic, strong)NSString *titleUnit;
/** 3.中间选择框的高度，default is 44*/
@property (nonatomic, assign)CGFloat heightPickerComponent;
/** 4.中间选择框的宽度，default is 32*/
@property (nonatomic, assign)CGFloat widthPickerComponent;
@property(nonatomic, weak)id <STPickerMoreComponentDelegate>delegate;

-(void)setDefaultSelectedWithIndex:(NSInteger)index Component:(NSInteger)component;
@end

NS_ASSUME_NONNULL_END
