//
//  GoogleTTS.h
//  SampleTTS
//
//  Created by jonki on 13/01/02.
//  Copyright (c) 2013年 jonki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface GoogleTTS : NSObject

@property NSMutableData *downloadedData;
@property AVAudioPlayer *player;

- (void)convertTextToSpeech:(NSString *)searchString:(NSString *)lang;
- (void)receivedAudio:(NSMutableData *)data;

@end