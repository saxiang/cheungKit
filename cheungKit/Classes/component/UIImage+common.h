//
//  UIImage+common.h
//  cheungKit-cheungKit
//
//  Created by ChanChinCheung on 2021/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (common)
+ (instancetype)fs_imagePathWithName:(NSString *)imageName bundle:(NSString *)bundle targetClass:(Class)targetClass;
@end

NS_ASSUME_NONNULL_END
