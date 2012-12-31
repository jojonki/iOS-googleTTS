//
//  VoiceInputView.m
//  VoiceNavigation
//
//  Created by jonki on 12/12/26.
//  Copyright (c) 2012 jonki. All rights reserved.
//

#import "VoiceInputView.h"

NSString * const DictationRecordingDidEndNotification = @"DictationRecordingDidEndNotification";
NSString * const DictationRecognitionSucceededNotification = @"DictationRecognitionSucceededNotification";
NSString * const DictationRecognitionFailedNotification = @"DictationRecognitionFailedNotification";
NSString * const DictationResultKey = @"DictationResultKey";

@implementation VoiceInputView

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)resignFirstResponder {
	return [super resignFirstResponder];
}

- (UIView *)inputView {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITextRange *)selectedTextRange {
    return nil;
}

- (UITextRange *)markedTextRange {
    return nil;
}

- (id<UITextInputDelegate>)inputDelegate {
    return nil;
}

- (void)setInputDelegate:(id<UITextInputDelegate>)inputDelegate {
}

- (id<UITextInputTokenizer>)tokenizer {
    return nil;
}

- (void)insertDictationResult:(NSArray *)dictationResult {
    NSLog(@"insertDictationResult");
    [
     [NSNotificationCenter defaultCenter]
     postNotificationName:DictationRecognitionSucceededNotification
     object:self
     userInfo:[NSDictionary dictionaryWithObject:dictationResult forKey:DictationResultKey]
    ];
}

- (void)dictationRecordingDidEnd {
    NSLog(@"dictationRecordingDidEnd");

    [
     [NSNotificationCenter defaultCenter]
     postNotificationName:DictationRecordingDidEndNotification
     object:self
    ];
}

- (void)dictationRecognitionFailed {
    NSLog(@"dictationRecognitionFailed");

    [
     [NSNotificationCenter defaultCenter]
     postNotificationName:DictationRecognitionFailedNotification
     object:self
    ];
}

@end
