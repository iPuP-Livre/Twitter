//
//  Tweet.m
//  Twitter
//
//  Created by Marian PAUL on 09/04/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet
@synthesize idTweet = _idTweet,
textTweet = _textTweet, 
dateTweet = _dateTweet, 
numberOfRetweets = _numberOfRetweets, 
tweetLocation = _tweetLocation,
userTweet = _userTweet,
screenName = _screenName;

- (Tweet *) initWithId:(unsigned long long)idTweet textTweet:(NSString *)textTweet dateTweet:(NSDate *)dateTweet andNumberOfRetweets:(NSInteger)retweets andTweetLocation:(NSString*)twLocation andUserTweet:(NSString*)userTweet andScreenName:(NSString *)screenName {
	self = [super init];
    if(self) {
		self.idTweet = idTweet;
		self.textTweet = textTweet;
		self.dateTweet = dateTweet;
        self.numberOfRetweets = retweets;
        self.tweetLocation = twLocation;
        self.userTweet = userTweet;
        self.screenName = screenName;
	}
	return self;	
}

- (NSString *) description {
	return [NSString stringWithFormat:@"id:%llu - message:%@ - date:%@", _idTweet, _textTweet, [_dateTweet description]];
}

@end
