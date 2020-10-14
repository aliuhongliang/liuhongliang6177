//
//  Note.h
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/14.
//  Copyright © 2020 刘宏亮. All rights reserved.
/*
 
 1.新建一个空项目，在Link Binary With Libraries 里添加静态库如下
 libz.tbd
 libbz2.tbd
 libiconv.tbd
 CoreMedia.framework
 VideoToolbox.framework
 AVFoundation.framework
 AudioToolbox.framework
 
 2.导入FFmepg库文件
 
 3.设置 Header Search Paths 路径，指向项目中include目录
    $(PROJECT_DIR)/FFmpeg-liuhongliang/FFmpeg-iOS/include
 
 4.然后导入#import "avformat.h" 在代码中 写 av_register_all() 然后进行编译，如果没有报错，代表编译成功。(注意要用真机运行)
 
 
 iOS运行 FFmpeg Tool
 1.把所需文件拖入项目中如下
 ffmpeg.c
 ffmpeg.h
 ffmpeg_opt.c
 ffmpeg_filter.c
 cmdutils.c
 cmdutils.h
 ffmpeg_hw.c
 ffmpeg_videotoolbox.c
 等文件在ffmpeg-4.2.1文件夹下📂
 config.h 文件 (在scratch文件夹📂下四个文件都有随意找一个就行了)
 
 2.ffmpeg.c cmdutils.c ffmpeg_filter.c需注释掉以下无关代码
 [#include "compat/va_copy.h"
 #include "libavresample/avresample.h"
 #include "libpostproc/postprocess.h"
 #include "libavutil/libm.h"
 #include "libavutil/time_internal.h"
 #include "libavutil/internal.h"
 #include "libavutil/libm.h"
 #include "libavformat/network.h"
 #include "libavcodec/mathops.h"
 #include "libavformat/os_support.h"
 #include "libavutil/thread.h"]
 
 3.ffmpeg.c函数调用注释掉
 [nb0_frames = nb_frames = mid_pred(ost->last_nb0_frames[0],
                                           ost->last_nb0_frames[1],
                                           ost->last_nb0_frames[2]);

 ff_dlog(NULL, "force_key_frame: n:%f n_forced:%f prev_forced_n:%f t:%f prev_forced_t:%f -> res:%f\n",
                     ost->forced_keyframes_expr_const_values[FKF_N],
                     ost->forced_keyframes_expr_const_values[FKF_N_FORCED],
                     ost->forced_keyframes_expr_const_values[FKF_PREV_FORCED_N],
                     ost->forced_keyframes_expr_const_values[FKF_T],
                     ost->forced_keyframes_expr_const_values[FKF_PREV_FORCED_T],
                     res);]
 
 4.cmdutils.c文件里print_all_libs_info函数以下两行注释掉也可以全部注释掉
 PRINT_LIB_INFO(avresample, AVRESAMPLE, flags, level);
 PRINT_LIB_INFO(postproc, POSTPROC, flags, level);
 
 //static void print_all_libs_info(int flags, int level) {
    里面的代码注释掉
 //}
 
 5.其它ffmpeg_opt.c文件里以下两行注释掉
 { "videotoolbox_pixfmt", HAS_ARG | OPT_STRING | OPT_EXPERT, { &videotoolbox_pixfmt}, "" },

 { "videotoolbox",   videotoolbox_init,   HWACCEL_VIDEOTOOLBOX,   AV_PIX_FMT_VIDEOTOOLBOX },
 
 6.pthread错误，可在头部导入#include "pthread.h"
 
 7.解决main函数重复问题
 把ffmpeg.c里面的main改成如下 ffmpeg_main
 
 
 优化集成后的问题
 1.计数器置零问题 （ffmpeg.c的代码中会访问空属性导致程序崩溃）
 找到ffmpeg.c中的ffmpeg_cleanup函数改成如下
 nb_filtergraphs=0;
 nb_output_files=0;
 nb_output_streams=0;
 nb_input_files=0;
 nb_input_streams=0;
 
 上面置0代码写在 term_exit();函数之前
 
 
 命令执行结束崩溃问题
在cmdutils.c中的exit_program函数改成如下
 
 void exit_program(int ret) {
    if (program_exit)
        program_exit(ret);
 
    exit(ret); ==> pthread_exit(NULL); 替换
 }
 */


/*
 
 参数    备注
 -i    输入要处理的视频文件路径
 -r    指定帧率，即1s内的帧数
 -s    指定分辨率
 -b:v 2500k    指定输出文件的视频比特率为 2500kbit/s
 -vf    指定视频过滤器
 -an    指定去除对音频的影响
 -vn    指定去除对视频的影响
 -sn    指定去除对字幕的影响
 -dn    指定去除对数据流的影响
 -y    覆盖输出
 -codec: copy    复制所有流而无需重新编码
 -ss    指定从什么时间开始
 -t    指定需要截取多长时间

 
 
 
 //水印字幕合成
 ffmpeg -i fromName -i fromOther -filter_complex [0:v][1:v]overlay=0:H-h:enable='between(t,0,1)'[tmp];[tmp][1:v]overlay=0:H-h:enable='between(t,3,4)' -t 7 -y -strict -2 toName
 //多路视频输出 四宫格
 ffmpeg -i /Users/mac/Desktop/1.mp4 -i /Users/mac/Desktop/2.mp4 -i /Users/mac/Desktop/3.mp4 -i /Users/mac/Desktop/4.mp4 -filter_complex "[0:v]pad=iw*2:ih*2[a];[a][1:v]overlay=w[b];[b][2:v]overlay=0:h[c];[c][3:v]overlay=w:h" /Users/mac/Desktop/out.mp4
 //图片转视频
 ffmpeg -r 15 -f image2 -loop 1 -i /Users/mac/Desktop/1.png -s 1920x1080 -t 3 -vcodec mpeg4 /Users/mac/Desktop/test.mp4
 //去掉视频中的音频
 ffmpeg -i input.mp4 -vcodec copy -an output.mp4
 //视频分解为图片
 ffmpeg –i test.mp4 –r 1 –f image2 image-%3d.jpg
 //视频拼接
 ffmpeg -f concat -i filelist.txt -c copy output.mp4
 // 旋转视频
 ffmpeg -i input.mp4 -vf rotate=PI/2 output.mp4
 // 缩放视频
 ffmpeg -i input.mp4 -vf scale=iw/2:-1 output.mp4
 //视频变速
 ffmpeg -i input.mp4 -filter:v setpts=0.5*PTS output.mp4
 //音频变速
 ffmpeg -i input.mp3 -filter:a atempo=2.0 output.mp3
 //视频添加水印(main_w-overlay_w-10 视频的宽度-水印的宽度-水印边距)
 ffmpeg -i input.mp4 -i logo.jpg -filter_complex [0:v][1:v]overlay=main_w-overlay_w-10:main_h-overlay_h-10[out] -map [out] -map 0:a -codec:a copy output.mp4
 //截取部分视频，从[80,60]的位置开始，截取宽200，高100的视频
 ffmpeg -i in.mp4 -filter:v "crop=80:60:200:100" -c:a copy out.mp4
 */


/*
 因FFmpeg 不支持asset-library://协议和file:// 协议故必须把需要处理的文件导入到沙盒中处理
 
 #import "ViewController.h"
 #import <AVFoundation/AVFoundation.h>
 #import <AVKit/AVKit.h>
 #import "FFmpegTool.h"

 #define DocumentDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
 #define BundlePath(res) [[NSBundle mainBundle] pathForResource:res ofType:nil]
 #define DocumentPath(res) [DocumentDir stringByAppendingPathComponent:res]

 extern int ffmpeg_main(int argc, char * argv[]);

 @interface ViewController ()
 @property (weak, nonatomic) IBOutlet UILabel *progressLabl;
 @property (nonatomic, strong) AVPlayerViewController *vc;
 @end

 @implementation ViewController

 - (void)viewDidLoad {
     [super viewDidLoad];
 }
 - (IBAction)click:(UIButton *)sender {
     self.progressLabl.text = @"合成中。。。";
     sender.userInteractionEnabled =  NO;
     dispatch_async(dispatch_get_global_queue(0, 0), ^{
         NSString *imageStr = BundlePath(@"1.jpg");
         NSString *videoStr = BundlePath(@"video.mp4");
         NSString *outStr = DocumentPath(@"filter.mp4");

         NSString *command_str = [NSString stringWithFormat:@"ffmpeg -i %@ -i %@ -filter_complex [1:v]scale=544:960[b];[0:v]scale=iw*min(1080/iw\\,1920/ih):ih*min(1080/iw\\,1920/ih),pad=1080:1920:(1080-iw)/2:(1920-ih)/2[a];[a][b]overlay=(W-w)/2:(H-h)/2 -b:v 2500k -s 1920x1080 -aspect 9:16 -y %@",imageStr,videoStr,outStr];
         
         NSMutableArray  *argv_array  = [command_str componentsSeparatedByString:(@" ")].mutableCopy;
         int argc = (int)argv_array.count;
         char **argv = calloc(argc, sizeof(char*));

         for(int i=0; i<argc; i++)
         {
           NSString *codeStr = argv_array[i];
           argv_array[i]     = codeStr;
           argv[i]      = (char *)[codeStr UTF8String];
         }
         ffmpeg_main(argc, argv);
         
         dispatch_async(dispatch_get_main_queue(), ^{
             sender.userInteractionEnabled = YES;
             self.progressLabl.text = @"合成成功";
             
             NSURL *webVideoUrl = [NSURL fileURLWithPath:outStr];
             self.vc= [[AVPlayerViewController alloc] init];
             self.vc.player = [[AVPlayer alloc] initWithURL:webVideoUrl];

             [self presentViewController:self.vc animated:YES completion:^{
                 [self.vc.player play];
             }];
         });
     });
 }
 @end
 */



/*
 git init
 git add README.md
 git commit -m "first commit"
 git branch -M master
 git remote add origin https://github.com/aliuhongliang/liuhongliang.git
 git push -u origin master
 
 
 如何使用GitHub LFS让git处理大文件
 brew install git-lfs
 
 进入本地仓库目录初始化LFS    git lfs install
 git lfs track "*.a" // [引号里面是具体的问题名]
 git add .gitattributes
 git commit -m "update"
 git push origin master  //  master 分支名
 */
