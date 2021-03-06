//
//  Tweet.m
//  bootcamp-twitter
//
//  Created by Prashant Khanduri - Hearsay on 10/20/13.
//  Copyright (c) 2013 KDeal. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

+ (NSArray *)tweetsFromDataDict:(NSDictionary *)dataObject{
    
    NSMutableArray * tweets = [[NSMutableArray alloc] init];
    
    for (id object in dataObject){
        [tweets addObject:[Tweet tweetFromObjectDict:object]];
    }
    
    return [[NSArray alloc] initWithArray:tweets];
}

+ (Tweet *)tweetFromObjectDict:(NSDictionary *)tweetObject {
    Tweet * tweet = [[Tweet alloc] init];
    
    tweet.tweetId = [tweetObject objectForKey:@"id_str"];
    tweet.text = (NSString * )[tweetObject objectForKey:@"text"];
    tweet.timestamp = (NSString * )[tweetObject objectForKey:@"created_at"];
    
    NSDictionary * userData =[tweetObject objectForKey:@"user"];
    
    tweet.username = (NSString * )[userData objectForKey:@"name"];
    tweet.screenname = (NSString * )[userData objectForKey:@"screen_name"];
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [userData objectForKey:@"profile_image_url"]]];
    tweet.profileImage = [UIImage imageWithData: imageData];
    
    UIImageView * temp = [[UIImageView alloc] init];
    [temp setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: [userData objectForKey:@"profile_image_url"]]] placeholderImage:nil success:^(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image){
        
        tweet.profileImage = image;
    } failure:^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error){
        NSLog(@"Unable to fetch the twitter image! ERROR: %@", [error localizedDescription]);
    }];
    
    
    return tweet;
}

@end
