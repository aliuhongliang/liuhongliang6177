//
//  LLPlayer.h
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLPlayer : NSObject
- (int)open:(NSString *)url;
- (int)play;
- (int)pause;
- (int)stop;
@end

