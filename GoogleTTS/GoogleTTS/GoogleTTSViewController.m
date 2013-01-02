//
//  GoogleTTSViewController.m
//  GoogleTTS
//
//  Created by jonki on 13/01/02.
//  Copyright (c) 2013年 jonki. All rights reserved.
//

#import "GoogleTTSViewController.h"

@interface GoogleTTSViewController ()

@end

@implementation GoogleTTSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _tts = [[GoogleTTS alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didEndOnExitTextField:(id)sender {
    [_ttsTextField resignFirstResponder];
}

- (IBAction)pushSpeechButton:(id)sender {
    NSString *lang;
    if([_jpSwitch isOn]) {
        lang = @"ja";
    } else {
        lang = @"en";
    }
    [_tts convertTextToSpeech:_ttsTextField.text :lang];
}

- (void)viewDidUnload {
    [self setTtsTextField:nil];
    [self setJpSwitch:nil];
    [self setEnSwitch:nil];
    [super viewDidUnload];
}

- (IBAction)jpDidChange:(id)sender {
    if([_jpSwitch isOn]) {
        [_enSwitch setOn:NO animated:YES];
    } else {
        [_enSwitch setOn:YES animated:YES];
    }
}
- (IBAction)enDidChange:(id)sender {
    if([_enSwitch isOn]) {
        [_jpSwitch setOn:NO animated:YES];
    } else {
        [_jpSwitch setOn:YES animated:YES];
    }
}
@end
