//
//  TwitterTLManager.m
//  Twitter
//
//  Created by Marian PAUL on 09/04/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "TwitterTLManager.h"
#import "Tweet.h"

@implementation TwitterTLManager
@synthesize arrayOfTweets = _arrayOfTweets;
@synthesize delegate = _delegate;

- (id) init {
    self = [super init];
    if (self) {
        self.arrayOfTweets = [NSMutableArray array];
        _account = nil;
        if ([TWTweetComposeViewController canSendTweet]) 
        {
            _store = [[ACAccountStore alloc] init];
            ACAccountType *twitterType = [_store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

            [_store requestAccessToAccountsWithType:twitterType
                              withCompletionHandler:^(BOOL granted, NSError *error) {
                                  if (granted) {
                                      // Nous sommes authorisés à accéder aux comptes twitter
                                      // On récupère tous les comptes. On pourrait demander à l'utilisateur le compte qu'il souhaite utiliser. On prend ici par défaut le premier.
                                      NSArray *twitterAccounts = [_store accountsWithAccountType:twitterType];
                                      if (twitterAccounts.count != 0) {
                                          _account = [twitterAccounts objectAtIndex:0];
                                          [self.delegate twitterTLManagerDidLoggedIn:self];
                                      }
                                  } 
                              }];
        }
        
    }
    return self;
}

- (void) loadNextTweets {
    
	++_currentTweetPage; 
	NSString *url =[NSString stringWithFormat:@"http://api.twitter.com/statuses/user_timeline/%@.json?page=%d&trim_user=t", @"iPuP_SARL", _currentTweetPage];
	
    if (_account) {
        // Initialisation de la requète
        TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:url]
                                                 parameters:nil 
                                              requestMethod:TWRequestMethodGET];
        request.account = _account;
        [self.delegate twitterTLManagerDidStartLoading:self];
        
        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {

            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"Erreur : %@", error);
                    [self.delegate twitterTLManager:self didFailToLoadTweetsWithError:error];
                }
                else
                {
                    NSError *jsonError = nil;
                    // Il va falloir parser les données !
                    // On récupère les données depuis le JSON
                    NSArray *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];      
                    
                    if (jsonError) {
                        NSLog(@"Erreur avec le JSON : %@", jsonError);
                        [self.delegate twitterTLManager:self didFailToLoadTweetsWithError:jsonError];
                        return ;
                    }
                    
                    // Construction d'un tableau temporaire pour stocker les nouveaux Tweets
                    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                    
                    // Gestion de la date
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    [df setDateFormat:@"EEE MMM dd HH:mm:ss ZZZ yyyy"];
                    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"US"]];
                    
                    // On parcourt tous les Tweets
                    for (NSDictionary *tweetJSON in json) {
                        // Récupération de la date
                        NSTimeInterval ti = [[df dateFromString:[tweetJSON objectForKey:@"created_at"]] timeIntervalSince1970] + [[NSTimeZone systemTimeZone] secondsFromGMT];
                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:ti];
                        
                        // Récupération de l'endroit où a été posté le Tweet s'il existe
                        NSString *placeTweet = @"";
                        NSDictionary *dic = [tweetJSON objectForKey:@"place"];
                        if ([dic isKindOfClass:[NSDictionary class]]) {
                            placeTweet = [NSString stringWithFormat:@"%@/%@", [dic objectForKey:@"name"], [dic objectForKey:@"country"]];
                        }
                        // Allocation d'un nouveau Tweet
                        Tweet *tweet = [[Tweet alloc] initWithId:[[tweetJSON objectForKey:@"id"] unsignedLongLongValue] textTweet:[tweetJSON objectForKey:@"text"] dateTweet:date andNumberOfRetweets:[[tweetJSON objectForKey:@"retweet_count"] integerValue] andTweetLocation:placeTweet andUserTweet:[[tweetJSON objectForKey:@"user"] objectForKey:@"name"] andScreenName:[[tweetJSON objectForKey:@"user"] objectForKey:@"screen_name"]];
                        [tempArray addObject:tweet];
                    }                    
                    // On ajoute les nouveaux Tweets au tableau de Tweets
                    [self.arrayOfTweets addObjectsFromArray:tempArray];
                    
                    // On avertit le delegate
                    [self.delegate twitterTLManager:self didLoadNewTweets:tempArray];
                }
            });
        }];
    }
}

- (void) loadTweetsFromBeginning {
	_currentTweetPage = 0;
	[self loadNextTweets];
}

#pragma mark - singleton
+ (TwitterTLManager*) shared
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

@end
