//
//  GoogleTTSViewController.h
//  GoogleTTS
//
//  Created by jonki on 13/01/02.
//  Copyright (c) 2013年 jonki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleTTS.h"

@interface GoogleTTSViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *ttsTextField;
- (IBAction)didEndOnExitTextField:(id)sender;
- (IBAction)pushSpeechButton:(id)sender;

@property GoogleTTS *tts;

@property (strong, nonatomic) IBOutlet UISwitch *jpSwitch;
- (IBAction)jpDidChange:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *enSwitch;
- (IBAction)enDidChange:(id)sender;

@end
