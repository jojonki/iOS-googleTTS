//
//  JPlayerViewController.m
//  JPlayer
//
//  Created by jonki on 12/12/26.
//  Copyright (c) 2012年 jonki. All rights reserved.
//

#import "JPlayerViewController.h"

@interface JPlayerViewController ()

@end

@implementation JPlayerViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _player = [MPMusicPlayerController iPodMusicPlayer];
    if (MPMusicPlaybackStatePlaying == [_player playbackState]) {
        [_playOrStopButton setTitle:@"Ⅱ" forState:UIControlStateNormal];
    } else if ( MPMusicPlaybackStatePaused == [_player playbackState]) {
        [_playOrStopButton setTitle:@"▷" forState:UIControlStateNormal];
    }
    
    // 音楽プレイヤーに関するNotificationの設定
    _ncenter = [NSNotificationCenter defaultCenter];
    [_ncenter addObserver:self
              selector: @selector(handle_PlaybackStateChanged)
              name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
              object:_player];
    [_ncenter addObserver:self
              selector:@selector(handle_NowPlayingItemChanged)
              name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
              object:_player];
    [_ncenter addObserver:self
                 selector:@selector(handle_VolumeChanged)
                     name:MPMusicPlayerControllerVolumeDidChangeNotification
                   object:_player];
    [_player beginGeneratingPlaybackNotifications];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                                    object:nil];
    
    
    // 音声入力に関するNotificationの設定
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dictationRecordingDidEnd:)
                                                 name:DictationRecordingDidEndNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dictationRecognitionSucceeded:)
                                                 name:DictationRecognitionSucceededNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(dictationRecognitionFailed:)
                                               name:DictationRecognitionFailedNotification object:nil];
    
    _startTime = [[NSDate alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![_voiceInputView isFirstResponder]) {
        [_voiceInputView becomeFirstResponder];
    }
    _dictationController =
                [NSClassFromString(@"UIDictationController") performSelector:@selector(sharedInstance)];
    
    _lastState = [_player playbackState];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    // Notificationの解除
    [_ncenter removeObserver:self];
    [_player endGeneratingPlaybackNotifications];
    
    [self setNextButton:nil];
    [self setPrevButton:nil];
    [self setPlayOrStopButton:nil];
    [self setSongInfoLabel:nil];
    [self setArtistInfoLabel:nil];
    [self setArtworkImage:nil];
    [self setVoiceInputView:nil];
    [self setDebugLabel:nil];
    [super viewDidUnload];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    if (![_voiceInputView isFirstResponder]) {
        [_voiceInputView becomeFirstResponder];
    }

    if (MPMusicPlaybackStatePlaying == [_player playbackState]) {
        [_playOrStopButton setTitle:@"Ⅱ" forState:UIControlStateNormal];
    } else if ( MPMusicPlaybackStatePaused == [_player playbackState]) {
        [_playOrStopButton setTitle:@"▷" forState:UIControlStateNormal];
    }
    
    _lastState = [_player playbackState];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self cancelDictation];
    [_voiceInputView resignFirstResponder];
}

#pragma mark 音楽ののNotificationハンドラ
- (void)handle_PlaybackStateChanged {
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:_startTime];
//    NSLog(@"%f", time);
    
    if (MPMusicPlaybackStatePlaying == [_player playbackState]
       && MPMusicPlaybackStatePaused == _lastState
       && time < 0.8f)
    {
        NSLog(@"call startDictation");
        _isPushedArtistButton = YES;
        _isPushedSongButton = NO;
        [self startDictation];
    }
    
    _startTime = [NSDate date];
    _lastState = [_player playbackState];
}

- (void)handle_NowPlayingItemChanged {
    NSLog(@"NowPlayingItemChanged");
    
    MPMediaItem *nowPlayingItem = [_player nowPlayingItem];
    NSString *artist = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
    NSString *title  = [nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];

    _songInfoLabel.text = title;
    _artistInfoLabel.text = artist;

    MPMediaItemArtwork *artwork = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *image = [artwork imageWithSize:CGSizeMake(140.0f, 140.0f)];
    [_artworkImage setImage:image];
}

- (void)handle_VolumeChanged {
}

#pragma mark 音楽の操作

- (IBAction)pushNextButton:(id)sender {
    [_player skipToNextItem];
}


- (IBAction)pushPlayOrStopButton:(id)sender {
    if (MPMusicPlaybackStatePlaying == [_player playbackState]) {
        [_player pause];
        [_playOrStopButton setTitle:@"▷" forState:UIControlStateNormal];
    } else {//if ( MPMusicPlaybackStatePaused == [_player playbackState]) {
        [_player play];
        [_playOrStopButton setTitle:@"Ⅱ" forState:UIControlStateNormal];
    }
}

- (IBAction)pushPrevButton:(id)sender {
    [_player skipToPreviousItem];
}

- (void)playSongWithArtistName: (NSString *)artistName {
    MPMediaPropertyPredicate *artistNamePredicate =
            [                       MPMediaPropertyPredicate predicateWithValue:artistName
                                    forProperty:MPMediaItemPropertyArtist];
    MPMediaQuery *query = [MPMediaQuery artistsQuery];
    [query addFilterPredicate:artistNamePredicate];
    
    if (0 != [[query items] count]) {
        [_player setQueueWithQuery:nil];
        [_player setQueueWithQuery:query];  // 検索してヒットしたアーティストの曲を再生キューにセット
        [_player setShuffleMode:MPMusicShuffleModeSongs]; // セットしたキューをシャッフル
        [_player play]; // 再生する
    }
}

- (void)playSongWithSongName: (NSString *)titleName {
    MPMediaPropertyPredicate *titleNamePredicate =
                                    [MPMediaPropertyPredicate predicateWithValue:titleName
                                     forProperty:MPMediaItemPropertyTitle];
    MPMediaQuery *query = [MPMediaQuery artistsQuery];
    [query addFilterPredicate:titleNamePredicate];
    
    if (0 != [[query items] count]) {
        [_player setQueueWithQuery:query];  // 検索してヒットした曲を再生キューにセット
        [_player setShuffleMode:MPMusicShuffleModeSongs]; // セットしたキューをシャッフル
        [_player play]; // 再生する
    }
}

#pragma mark 音声入力
- (void)startDictation {
    [_dictationController performSelector:@selector(startDictation)];
    _debugLabel.text = @"start dictation";
    _timer = [NSTimer scheduledTimerWithTimeInterval:4.75
                                              target:self
                                            selector:@selector(timerDidEnd)
                                            userInfo:nil
                                             repeats:NO];
}

- (void)timerDidEnd {
    NSLog(@"call stopDictation, timerDidEnd");
    [self stopDictation];
}

- (void)stopDictation {
    NSLog(@"In stopDictation");
    [_dictationController performSelector:@selector(stopDictation)];
}

- (void)cancelDictation {
    [_dictationController performSelector:@selector(cancelDictation)];
    _debugLabel.text = @"";
}

- (void)dictationRecordingDidEnd:(NSNotification *)notification {
    NSLog(@"dictationRecordingDidEnd");
    _debugLabel.text = @"";
}

- (void)dictationRecognitionSucceeded:(NSNotification *)notification {
    NSLog(@"dictationRecognitionSucceeded");
    NSDictionary *userInfo = notification.userInfo;
    NSArray *dictationResult = [userInfo objectForKey:DictationResultKey];
    NSString *text = [self wholeTestWithDictationResult:dictationResult];
    NSLog(@"%@", text);
    _debugLabel.text = text;

    if (_isPushedArtistButton) {
        [self playSongWithArtistName:text];
    } else if (_isPushedSongButton) {
        [self playSongWithSongName:text];
    }
}

- (void)dictationRecognitionFailed:(NSNotification *)notification {
    NSLog(@"dictationRecognitionFailed");
    _debugLabel.text = @"Failed";
}

- (NSString *)wholeTestWithDictationResult:(NSArray *)dictationResult {
    NSMutableString *text = [NSMutableString string];
    for (UIDictationPhrase *phrase in dictationResult) {
        [text appendString:phrase.text];
    }
    
    return text;
}

- (IBAction)pushDownSongVoiceInputButton:(id)sender {
    if (![_voiceInputView isFirstResponder]) {
        NSLog(@"not firstResponder Song");
    }
    _isPushedArtistButton = NO;
    _isPushedSongButton = YES;
    [self startDictation];
}

- (IBAction)pushUpSongVoiceInputButton:(id)sender {
    [self stopDictation];
}

- (IBAction)pushDownArtistVoiceInputButton:(id)sender {
    _isPushedArtistButton = YES;
    _isPushedSongButton = NO;
    [self startDictation];
}

- (IBAction)pushUpArtistVoiceInputButton:(id)sender {
    [self stopDictation];
}

#pragma mark iPod用のデバッグプリント
- (void)showNowPlayingSongInfo {
    NSLog(@"現在再生中の曲情報を表示する");
    MPMediaItem *nowPlayingItem = [_player nowPlayingItem];
    NSLog(@"Genre       = %@", [nowPlayingItem valueForProperty:MPMediaItemPropertyGenre]);
    NSLog(@"Album Title = %@", [nowPlayingItem valueForProperty:MPMediaItemPropertyAlbumTitle]);
    NSLog(@"Artist      = %@", [nowPlayingItem valueForProperty:MPMediaItemPropertyArtist]);
    NSLog(@"Title       = %@", [nowPlayingItem valueForProperty:MPMediaItemPropertyTitle]);
}

- (void)showSongInfoWithSongQuery {
    NSLog(@"曲名でソートして、全曲リストを表示する");
    MPMediaQuery *query = [MPMediaQuery songsQuery];
    int counter = 0;
    for( MPMediaItem *item in [query items])
    {
        NSLog(@"%@", [item valueForProperty:MPMediaItemPropertyTitle]);
        ++counter;
        if(counter > 4) break; // 全部出すと多いのでこの辺でbreak
    }
}

- (void)showSongInfoWithArtistQuery {
    NSLog(@"アーティスト名でソートして、全曲リストを表示する");
    MPMediaQuery *query = [MPMediaQuery artistsQuery];
    int counter = 0;
    for( MPMediaItem *item in [query items])
    {
        NSLog(@"%@", [item valueForProperty:MPMediaItemPropertyArtist]);
        ++counter;
        if(counter > 4) break; // 全部出すと多いのでこの辺でbreak
    }
}

- (void)showPlaylistInfo {
    NSLog(@"プレイリストを表示する");
    MPMediaQuery *query = [MPMediaQuery playlistsQuery];
    for( MPMediaPlaylist *plist in [query collections] )
    {
        NSLog(@"%@", [plist valueForProperty:MPMediaPlaylistPropertyName]);
    }
}

- (IBAction)pushDebug:(id)sender {
    [self startDictation];
    [self cancelDictation];
    [self stopDictation];
    
//    [_dictationController performSelector:@selector(releaseConnection)];
}
@end
