//
//  FSTestCompoent.m
//  cheungKit
//
//  Created by ChanChinCheung on 2021/10/20.
//

#import "FSTestCompoent.h"
#import "UIImage+common.h"

@implementation FSTestCompoent
+(void)prinWithString:(NSString *)hello {
    NSLog(@"print:%@\n",hello);
}

+(void)showImageInView:(UIView *)view withFrame:(CGRect)frame {
//** UIImage *img = [UIImage imageNamed:@"kaws_temp"]; //这里取的是mianbunld 所以取不到资源
    
    UIImage *testImg = [UIImage fs_imagePathWithName:@"shareMenu_icon_817" bundle:@"cheungKit" targetClass:[self class]];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:testImg];
    imgView.frame = frame;
    [view addSubview:imgView];
}
@end
