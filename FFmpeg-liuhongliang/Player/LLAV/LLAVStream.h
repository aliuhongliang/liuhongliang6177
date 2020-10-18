//
//  LLAVStream.h
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "avformat.h"

@interface LLAVStream : NSObject
@property (nonatomic, assign) NSInteger streamIndex;
@property (nonatomic) AVCodecParameters *codecpar;
@end

