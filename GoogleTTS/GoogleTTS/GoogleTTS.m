//
//  GoogleTTS.m
//  SampleTTS
//
//  Created by jonki on 13/01/02.
//  Copyright (c) 2013年 jonki. All rights reserved.
//

#import "GoogleTTS.h"

@implementation GoogleTTS

- (id)init {
    self = [super init];
    return self;
}

- (void)convertTextToSpeech:(NSString *)searchString:(NSString *)lang{
    _downloadedData = [[NSMutableData alloc] initWithLength:0];
    
    
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *search = [NSString stringWithFormat:@"http://translate.google.com/translate_tts?tl=%@&q=%@", lang, searchString];
    search = [search stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"Search: %@", search);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:search]];
    [request setValue:@"Mozilla/5.5" forHTTPHeaderField:@"User-Agent"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
	NSInteger statusCode = [res statusCode];
    NSLog(@"Status Code: %d", statusCode);
	[self.downloadedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.downloadedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Failure");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self receivedAudio:self.downloadedData];
}

- (void)receivedAudio:(NSMutableData *)data {
    _player = [[AVAudioPlayer alloc] initWithData:data error:nil];
    [_player play];
}

@end