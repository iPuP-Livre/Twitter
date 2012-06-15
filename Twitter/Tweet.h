//
//  Tweet.h
//  Twitter
//
//  Created by Marian PAUL on 09/04/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject
@property unsigned long long idTweet;
@property (nonatomic, strong) NSString *textTweet;
@property (nonatomic, strong) NSDate *dateTweet;
@property (nonatomic, assign) NSInteger numberOfRetweets;
@property (nonatomic, strong) NSString *tweetLocation;
@property (nonatomic, strong) NSString *userTweet;
@property (nonatomic, strong) NSString *screenName;

- (Tweet *) initWithId:(unsigned long long)idTweet textTweet:(NSString *)textTweet dateTweet:(NSDate *)dateTweet andNumberOfRetweets:(NSInteger)retweets andTweetLocation:(NSString*)twLocation andUserTweet:(NSString*)userTweet andScreenName:(NSString*)screenName;
@end
