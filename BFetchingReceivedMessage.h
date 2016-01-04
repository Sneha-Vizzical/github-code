//
//  FetchingReceivedMessage.h
//  vizzical
//
//  Created by RAMKRISHNA M BADDI on 15/10/14.
//  Copyright (c) 2014 TrinityInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "TabAppDelegate.h"
#import "Template.h"
#import "BDatabaseAdatper.h"
#import "LoadImage.h"
@interface BFetchingReceivedMessage : NSObject{
    
    NSString *android_ID, *iphone_ID;
    NSString *automsg,*usn1,*pwd1,*grp_name;
    DatabaseAdatper *database;
}
@property(nonatomic,retain) NSUserDefaults *prefs;


@property (nonatomic) Reachability *hostReachability;


-(void) GetReceivedMessage;

@end
