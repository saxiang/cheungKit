//
//  FSTestCompoent.m
//  cheungKit
//
//  Created by ChanChinCheung on 2021/10/20.
//

#import "FSTestCompoent.h"
#import "UIImage+common.h"
#import "AFNetworking.h"

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

+(void)dependencyVendor_AFN_weatherWithCity:(NSString *)city {
    NSDictionary *dict = @{@"city":city};
    [[AFHTTPSessionManager manager] GET:@"http://wthrcdn.etouch.cn/weather_mini" parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"downloadProgress:%@ ",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject:%@ ",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@ ",error);
    }];
}
@end
