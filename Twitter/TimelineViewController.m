//
//  TimelineViewController.m
//  Twitter
//
//  Created by Marian PAUL on 09/04/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "TimelineViewController.h"
#import <Twitter/Twitter.h>
#import "Tweet.h"

@interface TimelineViewController ()

@end

@implementation TimelineViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([TWTweetComposeViewController canSendTweet]) {
        UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(postNewTweet:)];
        self.navigationItem.rightBarButtonItem = tweetButton;
    }
    
    [[TwitterTLManager shared] setDelegate:self];
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_activityIndicatorView];
    
    UIControl *loadMore = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:loadMore.bounds];
    label.text = @"Charger plus";
    label.textAlignment = UITextAlignmentCenter;
    [loadMore addSubview:label];
    
    [loadMore addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = loadMore;
}

- (void) viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    // Si nous sommes connectés, nous chargeons les Tweets
    [[TwitterTLManager shared] loadTweetsFromBeginning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) postNewTweet:(id)sender
{
    TWTweetComposeViewController *tweetCompose = [[TWTweetComposeViewController alloc] init];
    BOOL hasAddedText = [tweetCompose setInitialText:@"Mon premier #tweet. Grâce au livre de @iPuP_SARL !"];
    if (!hasAddedText) {
        // Erreur, vous avez surement dépassé les 140 caractères
        // Si vous mettez un texte dynamique, pensez à tester s'il dépasse 140 caractères.
        // Exemple :
        // if (text.length > 140) {
        //     text = [text substringWithRange:NSMakeRange(0, 140)];
        // }
    }
    // BOOL hasAddedImage = [tweetCompose addImage:image];
    // BOOL hasAddedURL = [tweetCompose addURL:url];
    
    // Ajouter une tâche à réaliser une fois le tweet envoyé ou annulé
    [tweetCompose setCompletionHandler:^(TWTweetComposeViewControllerResult result){
        if (result == TWTweetComposeViewControllerResultCancelled) {
            NSLog(@"Tweet annulé");
        }
        else {
            NSLog(@"Tweet envoyé");
        }
    }];
    
    [self presentModalViewController:tweetCompose animated:YES];
}

- (void) loadMore 
{
    [[TwitterTLManager shared] loadNextTweets];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[TwitterTLManager shared].arrayOfTweets count];
}

#define FONT [UIFont fontWithName:@"Helvetica" size:14.0]

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = [[TwitterTLManager shared].arrayOfTweets objectAtIndex:indexPath.row];
    // Retourne la hauteur du texte 
    return [tweet.textTweet sizeWithFont:FONT constrainedToSize:CGSizeMake(320.0, 2000.0)].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = FONT;
    }
    
    Tweet *tweet = [[TwitterTLManager shared].arrayOfTweets objectAtIndex:indexPath.row];
    cell.textLabel.text = tweet.textTweet;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - TwitterTLManager

- (void) twitterTLManagerDidLoggedIn:(TwitterTLManager *)twM
{
    NSLog(@"Logged in");
    // Nous venons de nous identifier, on charge les Tweets depuis le début
    [twM loadTweetsFromBeginning];
}
- (void) twitterTLManager:(TwitterTLManager *)twM didFailToLoadTweetsWithError:(NSError *)error
{
    NSLog(@"Oups erreur : %@", error);
    // On pourrait présenter une alerte à l'utilisateur
    [_activityIndicatorView stopAnimating];
}

- (void) twitterTLManager:(TwitterTLManager *)twM didLoadNewTweets:(NSMutableArray *)newTweets
{
    NSLog(@"Tweets %@", newTweets);
    // On recharge les données
    [self.tableView reloadData];
    [_activityIndicatorView stopAnimating];
}

- (void) twitterTLManagerDidStartLoading:(TwitterTLManager *)twM
{
    [_activityIndicatorView startAnimating];
}

@end
