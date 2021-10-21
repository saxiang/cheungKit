//
//  FSTestCompoent.h
//  cheungKit
//
//  Created by ChanChinCheung on 2021/10/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface FSTestCompoent : NSObject
+(void)prinWithString:(NSString *)hello;
//图片资源的加载方式
+(void)showImageInView:(UIView *)view withFrame:(CGRect)frame;
//依赖第三方库AFN
+(void)dependencyVendor_AFN_weatherWithCity:(NSString *)city;
@end

NS_ASSUME_NONNULL_END
