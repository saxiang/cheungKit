//
//  FSTestCompoent.m
//  cheungKit
//
//  Created by ChanChinCheung on 2021/10/20.
//

#import "FSTestCompoent.h"

@implementation FSTestCompoent
+(void)prinWithString:(NSString *)hello {
    NSLog(@"print:%@\n",hello);
}

+(void)showImageInView:(UIView *)view {
//** UIImage *img = [UIImage imageNamed:@"kaws_temp"]; //这里取的是mianbunld 所以取不到资源
    
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSInteger scale = [[UIScreen mainScreen] scale];
    NSString *imgName = [NSString stringWithFormat:@"shareMenu_icon_816@%zdx.png",scale];
    NSString *path = [currentBundle pathForResource:imgName ofType:nil inDirectory:@"cheungKit.bundle"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
    imgView.frame = CGRectMake(150, 200, 120, 120);
    [view addSubview:imgView];
}
@end
