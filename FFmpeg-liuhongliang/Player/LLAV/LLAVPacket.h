//
//  LLAVPacket.h
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "avformat.h"

@interface LLAVPacket : NSObject
@property (nonatomic) AVPacket *pkt;
@property (nonatomic, assign) NSInteger streamIndex;
@end

