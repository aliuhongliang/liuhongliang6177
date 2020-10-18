//
//  HomeViewController.m
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/13.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import "HomeViewController.h"
#import "LLPlayerHeader.h"
extern "C" {
#import "avformat.h"
#include "ffmpeg.h"

int ffmpeg_main(int argc, char * argv[]);
}

#define DocumentDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define BundlePath(res) [[NSBundle mainBundle] pathForResource:res ofType:nil]
#define DocumentPath(res) [DocumentDir stringByAppendingPathComponent:res]



@interface HomeViewController ()
@property (nonatomic, strong) LLPlayer *player;
@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    LLOpenFileThread *thread = [[LLOpenFileThread alloc] init];
    [thread start];
    
    NSString *str = [[NSBundle mainBundle] pathForResource:@"liu_ffmpeg" ofType:@"mov"];
    
    _player = [LLPlayer new];
    [_player open:str];
    
//    avformat_network_init();
//
//
//    NSThread *th = [[NSThread alloc] initWithBlock:^{
//        NSString *imageStr = BundlePath(@"1.jpg");
//        NSString *videoStr = BundlePath(@"video.mp4");
//        NSString *outStr = DocumentPath(@"filter.mp4");
//
//        NSString *command_str = [NSString stringWithFormat:@"ffmpeg -i %@ -i %@ -filter_complex [1:v]scale=544:960[b];[0:v]scale=iw*min(1080/iw\\,1920/ih):ih*min(1080/iw\\,1920/ih),pad=1080:1920:(1080-iw)/2:(1920-ih)/2[a];[a][b]overlay=(W-w)/2:(H-h)/2 -b:v 2500k -s 1920x1080 -aspect 9:16 -y %@",imageStr,videoStr,outStr];
//
//        NSMutableArray  *argv_array  = [command_str componentsSeparatedByString:(@" ")].mutableCopy;
//        int argc = (int)argv_array.count;
//        char **argv = (char **)calloc(argc, sizeof(char*));
//
//        for(int i=0; i<argc; i++)
//        {
//          NSString *codeStr = argv_array[i];
//          argv_array[i]     = codeStr;
//          argv[i]      = (char *)[codeStr UTF8String];
//        }
//
//        ffmpeg_main(argc, argv);
//    }];
//
//    [th start];
}


@end
