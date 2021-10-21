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
+(void)showImageInView:(UIView *)view withFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
