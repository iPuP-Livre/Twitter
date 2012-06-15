//
//  TwitterTLManager.h
//  Twitter
//
//  Created by Marian PAUL on 09/04/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@protocol TwitterTLManagerDelegate;

@interface TwitterTLManager : NSObject
{
    NSInteger _currentTweetPage;

    ACAccountStore *_store;
    ACAccount *_account;
}
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (nonatomic, assign) id <TwitterTLManagerDelegate> delegate;

+ (TwitterTLManager*) shared;
- (void) loadTweetsFromBeginning;
- (void) loadNextTweets;
@end

@protocol TwitterTLManagerDelegate <NSObject>

- (void) twitterTLManagerDidLoggedIn:(TwitterTLManager*)twM;
- (void) twitterTLManagerDidStartLoading:(TwitterTLManager*)twM;
- (void) twitterTLManager:(TwitterTLManager*)twM didLoadNewTweets:(NSMutableArray*)newTweets;
- (void) twitterTLManager:(TwitterTLManager *)twM didFailToLoadTweetsWithError:(NSError*)error;

@end