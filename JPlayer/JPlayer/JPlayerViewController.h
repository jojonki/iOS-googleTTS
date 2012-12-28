//
//  JPlayerViewController.h
//  JPlayer
//
//  Created by jonki on 12/12/26.
//  Copyright (c) 2012年 jonki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "VoiceInputView.h"


@interface JPlayerViewController : UIViewController

@property BOOL isPlaying;
@property MPMusicPlayerController *player;
@property NSNotificationCenter *ncenter;


// プレイヤー
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)pushedNextButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *playOrStopButton;
- (IBAction)pushedPlayOrStopBUtton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *prevButton;
- (IBAction)pushedPrevButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *songInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistInfoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *artworkImage;

// 音声入力
@property id dictationController;
@property (strong, nonatomic) IBOutlet VoiceInputView *textInputView;

- (IBAction)pushDownSongVoiceInputButton:(id)sender;
- (IBAction)pushUpSongVoiceInputButton:(id)sender;
- (IBAction)pushDownArtistVoiceInputButton:(id)sender;
- (IBAction)pushUpArtistVoiceInputButton:(id)sender;

@property BOOL isPushedArtistButton;
@property BOOL isPushedSongButton;

@end
