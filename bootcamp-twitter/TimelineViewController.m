//
//  TimelineViewController.m
//  bootcamp-twitter
//
//  Created by Prashant Khanduri - Hearsay on 10/17/13.
//  Copyright (c) 2013 KDeal. All rights reserved.
//

#import "TimelineViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "TweetDetailViewController.h"

@interface TimelineViewController ()
- (IBAction)showMenu:(id)sender;
- (IBAction)compose:(id)sender;

@property (strong, nonatomic) NSArray * tweets;

@end

@implementation TimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UINib * tweetNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:tweetNib forCellReuseIdentifier:@"TweetCellID"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[TwitterClient instance] homeTimelineWithCount:20 success:^(NSDictionary * data){
        
        self.tweets = [Tweet tweetsFromDataDict:data];

        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
    } failure:^(NSError * error) {
        NSLog(@"Error:  %@", [error localizedDescription]);
    }];
    
    UIImage *image = [UIImage imageNamed: @"Icon-Small-50.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    
    self.navigationItem.titleView = imageView;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
}

- (IBAction)compose:(id)sender {
    [[TwitterClient instance] composeTweetInViewController: self];
}

////////////////////////////////////////
////////    UITableViewDataSource
////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return self.tweets.count;
}

////////////////////////////////////////
////////    UITableViewDelegate
////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCellID"];
    
    if (cell==nil) {
        cell = [[TweetCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TweetCellID"];
    }
    
    cell.tweet = (Tweet * ) self.tweets[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Tweet *tweet = self.tweets[indexPath.item];
    
    CGRect rect = [tweet.text boundingRectWithSize:CGSizeMake(230, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil];
    
    return rect.size.height + 40;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetDetailViewController * tweetDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tweetDetailViewController"];
    
    [tweetDetailVC setTweet:self.tweets[indexPath.row]];
    
    [[self navigationController] pushViewController:tweetDetailVC animated:YES];
    
}



@end
