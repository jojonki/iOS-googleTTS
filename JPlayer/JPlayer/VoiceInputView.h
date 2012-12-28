//
//  VoiceInputView.h
//  JPlayer
//
//  Created by jonki on 12/12/28.
//  Copyright (c) 2012年 jonki. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString * const DictationRecordingDidEndNotification;
extern NSString * const DictationRecognitionSucceededNotification;
extern NSString * const DictationRecognitionFailedNotification;
extern NSString * const DictationResultKey;


@interface VoiceInputView : UIView<UITextInput>

@end
