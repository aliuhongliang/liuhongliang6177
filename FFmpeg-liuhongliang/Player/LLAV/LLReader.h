//
//  LLReader.h
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLAVPacket.h"
#import "LLAVStream.h"

@interface LLReader : NSObject
@property (nonatomic, assign) NSInteger streamCount;

- (int)open:(NSString *)url;
- (int)close;
- (int)read:(LLAVPacket *)packet;
- (int)getStream:(LLAVStream *)stream streamId:(NSInteger)streamId;
- (int)getVideoStreamIndex;
- (int)getAudioStreamIndex;
@end

