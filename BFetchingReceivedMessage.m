//
//  FetchingReceivedMessage.m
//  vizzical
//
//  Created by RAMKRISHNA M BADDI on 15/10/14.
//  Copyright (c) 2014 TrinityInc. All rights reserved.
//

#import "BFetchingReceivedMessage.h"



static NSString *usn=@"vizzical2014@llc";
static NSString *pwd=@"2014vizzical@!?#";
@implementation BFetchingReceivedMessage
@synthesize prefs;

bool noreply;
bool popup;



-(NSString *) encryption :(NSString *) _secret
{
    
    
    
    NSString *key = @"0923674722jdkfgs"; // should be provided by a user
    //   NSLog( @"Original: %@\n", _secret );
    NSString *encryptedString = [_secret AES128EncryptWithKey:key];
    
    return encryptedString;
}


-(NSString *) decryption :(NSString *) secret

{
    NSString *key = @"0923674722jdkfgs";
    NSString *decryptedString = [secret AES128DecryptWithKey:key];
    NSLog( @"Decrypted : %@\n", decryptedString );
    return decryptedString;
}


-(void) GetReceivedMessage
{
    
    prefs=[[NSUserDefaults alloc]init];
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]stringForKey:@"preferenceName"];
    usn1=[self encryption:usn];
    pwd1=[self encryption:pwd];
    
    // NSString *ID = [self.prefs stringForKey:@"recentmessage"];
    NSString *A_ID = [self.prefs stringForKey:@"Androidrecentmessage"];
    NSString *FLAG = [self.prefs stringForKey:@"checkID"];
    NSString *bname=[self.prefs objectForKey:@"business_name"];
    NSString *B_ID= [self.prefs stringForKey:@"Businessrecentmsg"];

    
    NSString *Lock = [self.prefs stringForKey:@"Lock"];
    NSString *storestrt=[prefs objectForKey:@"startdatetime"];
    NSString *storeend=[prefs objectForKey:@"enddatetime"];
    if(Lock==NULL )
    {
        Lock=@"NO";
        [self.prefs
         setObject:Lock forKey:@"Lock"];
        [self.prefs synchronize];
        
    }
    
    
    if ([Lock isEqualToString:@"NO"]) {
        [self.prefs
         setObject:@"YES" forKey:@"Lock"];
        [self.prefs synchronize];
        
        if(FLAG==NULL )
        {
            FLAG=AndroidLast_ID;
            [self.prefs
             setObject:FLAG forKey:@"checkID"];
            [self.prefs synchronize];
            
        }
        
        
        if(A_ID==NULL )
        {
            A_ID=AndroidLast_ID;
            
            [self.prefs
             setObject:A_ID forKey:@"Androidrecentmessage"];
            [self.prefs synchronize];
            NSLog(@"id:%@",A_ID);
        }
        
        
        if (TRUE) {
            
            //  if (![FLAG isEqualToString:A_ID] || [A_ID isEqualToString:@"0"]) {
            
            
            [self.prefs setObject:A_ID forKey:@"checkID"];
            [self.prefs synchronize];
            
          
          // A_ID=@"3914";
            // http://54.208.215.200/smscalling/get_history_messages.php?contact_no=+917022042222&last_id=0&business_name=vizzical
            
            //  http://54.208.215.200/smscalling/business_received_message.php?contact=+918762731446&id=0
            
           NSString *URLString = [NSString stringWithFormat:@"%@get_history_messages.php?contact_no=%@&last_id=%@&business_name=%@",VIZZICAL_URL,savedValue,A_ID,bname];
              /*NSString *URLString = [NSString stringWithFormat:@"%@iphone_received_message.php?contact=%@&id=%@&android_id=%@&username=%@&password=%@&bid=%@",VIZZICAL_URL,savedValue,@"0",A_ID,usn,pwd,B_ID];*/
          //  NSLog(@"URLString:%@",URLString);
             NSString *encoded = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            // manager.responseSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            [manager POST:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                                NSLog(@"Json:%@",responseObject);
                
               NSArray *array = [responseObject objectForKey:@"data_log"];
              if([A_ID isEqualToString:@"0"])
               
              {
                  
                NSArray* reversedArray =  [[array reverseObjectEnumerator] allObjects];
                  if(array.count>=2)
                array = [reversedArray subarrayWithRange:NSMakeRange(0, 2)];
              }
             //   NSLog(@"@@@Array count :%lu",(unsigned long)array.count);
                // NSArray *iphone_array=[responseObject objectForKey:@"log_iphone"];
                NSMutableArray *tempArray=[[NSMutableArray alloc]init];
                for(NSDictionary *args in array)
                {
                    //NSArray *logarray=[args2 objectForKey:@"logs"];
                    
                    //for(NSDictionary *args in logarray)
                    //{
                      //  NSString *string = dic[@"array"];
                  
                    Template *temp=[Template alloc];
                                       //temp.image= [args objectForKey:@"image"];
                    //org.tobe used:message_images
                    
                    
                    temp.image=[NSString stringWithFormat:@"%@message_images/%@",VIZZICAL_URL,[args objectForKey:@"image"]];
                    temp.simage=[args objectForKey:@"image"];
                    
                    if([[args objectForKey:@"group_name"] isEqualToString:@""])
                    {
                        
                    }
                    else
                    {
                        temp.selected=[args objectForKey:@"group_name"];
                        if(![temp.selected isEqualToString:@"'"]&&temp.selected.length>1)
                        {
                            [prefs setObject:temp.selected forKey:@"groups"];
                            [prefs synchronize];
                            NSLog(@"groupname here:%@",[prefs objectForKey:@"groups"]);
                            
                        }
                    }
                    
                    if ([[args objectForKey:@"vir_type"]isEqualToString:@"1"]) {
                        
                        temp.virtype=[args objectForKey:@"vir_type"];
                         temp.groupmember=[args objectForKey:@"group_members"];
                        
                         if ([args objectForKey:@"connected"]!=NULL&&![[args objectForKey:@"connected"] isEqual:[NSNull null]])
                             
                         {
                            temp.message=[NSString stringWithFormat:@"Connected:+%@",[args objectForKey:@"connected"]];
                             
                             
                         }
                       else if([args objectForKey:@"connected_vm"]!=NULL&&![[args objectForKey:@"connected_vm"] isEqual:[NSNull null]])
                       {
                           
                           temp.message=[NSString stringWithFormat:@"Voicemail:+%@",[args objectForKey:@"connected_vm"]];

                          

                           
                }
                       
                        else
                        {
                            temp.message=@"Missed-Call";
                           
                        }
                       
                       
                        
                        
                    }
                    else
                    {
                    if ( [temp.message isEqual:[NSNull null]] ) {
                        temp.message=nil;
                        [prefs setObject:@"black" forKey:@"color"];
                        [prefs synchronize];
                    }
                    else
                    {
                        if(![[args objectForKey:@"message"] hasPrefix:@"#AUTO_REPLY#"])
                        {
                            temp.message=[args objectForKey:@"message"];
                            automsg=[args objectForKey:@"message"];
                        }
                        else
                        {
                            NSArray *tempArray = [[args objectForKey:@"message"] componentsSeparatedByString:@"#"];
                            NSString *str1 = [tempArray objectAtIndex:2];
                            
                            
                            automsg=[args objectForKey:@"message"];
                            
                            temp.message=str1;
                            noreply=YES;
                            
                            NSLog(@"sep:%@",str1);
                            
                        }
                        
                        
                        
                    }
                    }
                    NSLog(@"msg:%@",temp.message);
                    
                    
                    
                   
                         temp.type= [args objectForKey:@"type"];
                   
                  
                    
                    temp.date=[args objectForKey:@"added_date_time"];
                    // temp.date=[self getCurrentDateZoneInString:[NSDate date]];
                    double CurrentTime = CACurrentMediaTime();
                    NSLog(@"current time:%f ````````````````",CurrentTime);
                    
                    temp.stringToDate=[self getCurrentDateZone:temp.date];
                    NSString *reply_tono=[args objectForKey:@"reply_to_no"];
                   NSString *contactno=[args objectForKey:@"source_number"];
                    if(![reply_tono isEqualToString:contactno]&&reply_tono!=nil)
                    {
                        temp.contact= [args objectForKey:@"reply_to_no"];
                        temp.reply_to=[args objectForKey:@"reply_to_no"];
                       temp.reply_to=[temp.reply_to unformattedPhoneNumber];
                        temp.contact=[temp.contact unformattedPhoneNumber];
                        temp.message=[NSString stringWithFormat:@"%@",temp.message];
                    }
                    else
                    {
                        temp.contact= [args objectForKey:@"source_number"];
                        temp.contact=[temp.contact unformattedPhoneNumber];
                    }
                    
                    if(![temp.contact containsString:@"+"])
                    {
                        temp.contact=[NSString stringWithFormat:@"+%@",temp.contact];
                        
                    }
                    NSLog(@"displaying formatted:%@",temp.contact);
                   
                    
                    [tempArray addObject:temp];
                    if(![A_ID isEqualToString:@"0"])
                    {
                      /*
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BMain" bundle:nil];
                        UITabBarController *tabController = [storyboard instantiateInitialViewController];
                     //[self.window setRootViewController:tabController];
                        
                        UINavigationController *navigationController = [[tabController  viewControllers] objectAtIndex:2];
                        BRecentTableViewController *Controller = [[navigationController viewControllers] objectAtIndex:0];
                        [Controller Printformapp:temp];
                        */
                    // if([[args objectForKey:@"business_message_id"]isEqualToString:[responseObject objectForKey:@"last_id"]])
                      [self displaypopup:tempArray];
                        
                    }

                   
                    
                    
                }
                if(tempArray.count!=0)
                {
                    Template *obj=(Template *)[tempArray objectAtIndex:0];
                    
                    
                    NSDate *now = [NSDate date];
                    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                    dateFormatter2.dateFormat=@"dd/MM/yyyy HH:mm a";
                    
                    
                    [dateFormatter2 setTimeZone:[NSTimeZone systemTimeZone]];
                    NSLog(@"The Current Time is %@",[dateFormatter2 stringFromDate:now]);
                    if(storeend.length!=0&&storestrt.length!=0)
                    {
                        NSDate *strtdate=[[NSDate alloc]init];
                        NSDate *enddate=[[NSDate alloc]init];
                        NSDate *current=[[NSDate alloc]init];
                        NSLog(@"date string:%@ :%@",storestrt,storeend);
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm'Z'"];
                        
                        strtdate=(NSDate *)storestrt;
                        enddate=(NSDate *)storeend;
                        current=(NSDate *)[dateFormatter2 stringFromDate:now];
                        
                        // strtdate=[dateFormatter dateFromString:storestrt];
                        if(![automsg containsString:@"#AUTO_REPLY#"])
                            [self comparedates:strtdate :enddate :current :obj.contact];
                        
                        
                        
                    }
                    
                }
                                NSString *last_record=[responseObject objectForKey:@"last_id"];
                
                if (! [last_record isEqual:[NSNull null]] ) {
                    
                    
                    
                   // NSLog(@"@@@Array count :%lu",(unsigned long)tempArray.count);
                    
                    if(last_record!=NULL)
                    {
                        [self.prefs
                         setObject:last_record forKey:@"Androidrecentmessage"];
                        [self.prefs synchronize];
                    }

                    if (![last_record isEqualToString:A_ID]) {
                        
                        
                        if (tempArray.count>0) {
                            [self checkandSaveRecord:tempArray];
                             [tempArray removeAllObjects];
                        }
                       
                        
                    }
                    
                    
                }
                
                [self.prefs
                 setObject:@"NO" forKey:@"Lock"];
                [self.prefs synchronize];
                }
           // }
             
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSString *err=[error.userInfo objectForKey:NSLocalizedDescriptionKey];
                [self.prefs
                 setObject:@"NO" forKey:@"Lock"];
                [self.prefs synchronize];
            }];
            
        }
        
    }
}
-(void)displaypopup:(NSArray*)args
{
    
    NSArray *arr=[[NSArray alloc]init];
    arr=[arr arrayByAddingObject:[args lastObject]];
    
    for (Template *temp in arr) {
        
        NSLog(@"@@@Message :%@",temp.message);
        //   NSLog(<#NSString *format, ...#>)
        
        Template *     availableTemplate;
       
        
        TabAppDelegate *appDelegate=(TabAppDelegate *)[[UIApplication sharedApplication] delegate];
    
        availableTemplate=[database getTemplateFromMessage:temp.message];
        if (availableTemplate!=nil) {
            availableTemplate.contact=temp.contact;
            availableTemplate.message=temp.message;
            availableTemplate.type=temp.type;
            availableTemplate.date=temp.date;
            availableTemplate.selected=temp.selected;
            
            if(temp.virtype!=NULL)
            {
                availableTemplate.virtype=temp.virtype;
                availableTemplate.callstatus=temp.callstatus;
                availableTemplate.connectedstatus=temp.connectedstatus;
            }
                     // if ([appDelegate.ChatWindow isEqualToString:@"YES"]) {
            
            //NSDictionary *dictionary = [NSDictionary dictionaryWithObject:availableTemplate forKey:@"key"];
            //[[NSNotificationCenter defaultCenter] postNotificationName:MessagePushNotification object:self userInfo:dictionary];
            [appDelegate displayPopUp:temp :temp];
            
            // }
            
            
            
        }
        
        else if([temp.image isEqualToString:@""] || ([temp.image isEqualToString:[NSString stringWithFormat:@"%@message_images/ce841cc.jpg",VIZZICAL_URL]]) ){
            temp.image=@"";
            temp.thumbnail=@"";
            availableTemplate.selected=temp.selected;
            if(temp.virtype!=NULL)
            {
                availableTemplate.virtype=temp.virtype;
                availableTemplate.callstatus=temp.callstatus;
                availableTemplate.connectedstatus=temp.connectedstatus;
            }
           
            [appDelegate displayPopUp:temp :temp];
            
            
            
        }
        
        else
        {
            if(temp!=nil)
            [appDelegate displayPopUp:temp :temp];
            
            //}
            
            
            //  });
            
        }
        
        
        
        
    }

    }


-(NSDate *) getCurrentDateZone:(NSString *) dateString
{
    NSDateFormatter *dtFormatter1 = [[NSDateFormatter alloc] init];
    [dtFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date1 = [dtFormatter1 dateFromString:dateString];
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:date1];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:date1];
    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    
    NSDate *destinationDate = [[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:date1];
    NSLog(@"Receiving the date:%@",destinationDate);
    
    return destinationDate;
}

-(void)comparedates :(NSDate *)strtdate :(NSDate *)enddate :(NSDate *)currentdate :(NSString *)phone
{
    NSString *tempmsg=[prefs objectForKey:@"tempmsg"];
    
    NSLog(@"Disp dates s:%@ e:%@ c:%@",strtdate,enddate,currentdate);
    
    if([strtdate compare:currentdate]==NSOrderedAscending&&[enddate compare:currentdate]==NSOrderedDescending)
    {
        NSString *setmsg=[NSString stringWithFormat:@"#AUTO_REPLY#%@",tempmsg];
        NSArray *tempArray = [setmsg componentsSeparatedByString:@"#"];
        NSString *str1 = [tempArray objectAtIndex:1];
        
        NSLog(@"str1:%@",str1);
        
        
        //        if(phone!=nil) {
        //
        //                NSString *phoneNumber=phone;
        //                //  [self callMethod:phoneNumber];
        //            phoneNumber=[phoneNumber unformattedPhoneNumber];
        //                [self uplodToServer:@"1" :phoneNumber :setmsg :nil :nil:nil:@"0"];
        //
        //
        //            }
        //            else if(phone.length>=10)
        //            {
        //                //  [self callMethod:contactNumberField.text];
        
        NSString *phoneNumber =phone;
        [self uplodToServer:@"1" :phoneNumber :setmsg :nil :nil :nil:@"0"];
        // }
        
        
        //                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Phone Number !.."
        //                                                                    message:@"Please valid phone number "
        //                                                                   delegate:nil
        //                                                          cancelButtonTitle:@"Ok"
        //                                                          otherButtonTitles:nil];
        //                [alertView show];
        //
        
        
        //    }
        
        
        
        
        
    }
    else
    {
        NSLog(@"Time out");
        [prefs setBool:YES forKey:@"switchoff"];
        [prefs synchronize];
        
    }
    
    
}

-(void)uplodToServer :(NSString *)_id :(NSString *)destination_no :(NSString *) message :(UIImage *) image  : (NSString *)imageURL :(NSString *)groupName :(NSString *)server_ID
{
    // customImage=nil;
    //[self.view sendSubviewToBack:self.bgview];
    
    [self executeTheOperationToServer:_id :destination_no :message :image :imageURL :groupName :server_ID];
    
    
    
}


-(void)executeTheOperationToServer :(NSString *)_id :(NSString *)destination_no :(NSString *) message :(UIImage *) image  : (NSString *)imageURL :(NSString *)groupName :(NSString *)server_ID
{
    
    
    //  UIDevice *deviceInfo = [UIDevice currentDevice];
    //   NSLog(@"Device name: %@", deviceInfo.name);
    
    //  NSString *name=[deviceInfo name];
    
    // name=[self encryption:name];
    
    NSArray *alldest= [destination_no componentsSeparatedByString:@","];
    NSUserDefaults *  defaults = [NSUserDefaults standardUserDefaults];
    NSString *usn=@"vizzical2014@llc";
    NSString *pwd=@"2014vizzical@!?#";
    usn=[self encryption:usn];
    pwd=[self encryption:pwd];
    Template *record;
    
    
    int connectionType = [defaults integerForKey:@"connection_type"];
    
    //  [SVProgressHUD showWithStatus:@"Sending Please Wait!.."];
    
    // 1=> SEND and 0 =>CALL
    NSString *remoteHostName = @"www.apple.com";
    self.hostReachability = [Reachability reachabilityForInternetConnection];
    
    // [self updateInterfaceWithReachability:self.hostReachability];
    NetworkStatus netStatus = [self.hostReachability currentReachabilityStatus];
    
    //BOOL connectionRequired = [reachability connectionRequired];
    destination_no=[destination_no formatToLocalPhoneNumber];
    NSString *source_no = [prefs stringForKey:@"preferenceName"];
    
    if (groupName!=nil) {
        
        record=[[Template alloc]init];
        record.contact=destination_no;
        record.message=message;
        record.image=imageURL;
        record.type= _id;
        record.secondNumber=destination_no;
        record.selected=groupName;
    }
    else
    {
        record=[[Template alloc]init];
        record.contact=destination_no;
        record.message=message;
        record.image=imageURL;
        record.type= _id;
        
    }
    
    if ((netStatus== ReachableViaWiFi)||(netStatus ==ReachableViaWWAN)) {
        //    [SVProgressHUD showSuccessWithStatus:@"Message Sending.."];
        
        //        CustomTableViewCell *templatecell = (CustomTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        //
        //        templatecell.templateMessage.text=@"";
        //        [templatecell.customBtn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        //        customImagePath=nil;
        
        
        
        NSMutableArray *VizzicalNumber=[[NSMutableArray alloc]init];
        BDatabaseAdatper *db=[BDatabaseAdatper alloc];
        VizzicalNumber=[db getVizzicall];
        TabAppDelegate *appDelegate = (TabAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        if (connectionType!=0) {
            
            
            //            if ([Vizzicall count]>0) {
            
            NSString *Dest_no=destination_no;
            
            NSString* requestURL = [NSString stringWithFormat:@"%@upload_iphone_image.php?username=%@&password=%@",VIZZICAL_URL,usn,pwd];
            
            NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
            
            source_no=[self encryption:source_no];
            Dest_no=[self encryption:Dest_no];
            message=[NSString stringWithFormat:@"%@",message];
            message=[self encryption:message];
            NSString *latitude=[self encryption:appDelegate.latitude];
            
            NSString *longitude=[self encryption:appDelegate.longitude];
            
            [_params setObject:[NSString stringWithFormat:@"%@",source_no] forKey:@"source_contact"];
            [_params setObject:[NSString stringWithFormat:@"%@",Dest_no] forKey:@"dest_contact"];
            //     message=  [self encryption:message];
            
            [_params setObject:[NSString stringWithFormat:@"%@",message] forKey:@"message"];
            
            [_params setObject:[NSString stringWithFormat:@"%@",_id] forKey:@"id"];
            [_params setObject:[NSString stringWithFormat:@"%@",server_ID] forKey:@"server_id"];
            [_params setObject:[NSString stringWithFormat:@"%@",latitude] forKey:@"latitude"];
            [_params setObject:[NSString stringWithFormat:@"%@",longitude] forKey:@"longitude"];
            
            
            NSLog(@"Source:%@ and Dest:%@ and message:%@ and id=%@ ",source_no,Dest_no,message,_id);
            
            NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
            
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            if(imageData!=nil){
                
                
                
                
                [manager POST:requestURL parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.png" mimeType:@"image/png"];
                    
                }  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    // do whatever you'd like here; for example, if you want to convert
                    // it to a string and log it, you might do something like:
                    
                    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    NSLog(@"%@", string);
                    record.stringToDate =[NSDate date];
                    [database insertSentRecord:record :@"sent"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:MessageRecentReload object:self userInfo:nil];
                    
                    //set the timer to perform selector (getMatchListWS:) repeatedly
                    
                    
                    
                    //                        if ([_id isEqualToString:@"0"]) {
                    //                            [self callMethod:phoneNumber];
                    //
                    //                        }
                    //
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    //    NSLog(@"Error: %@", error);
                    
                    
                    NSString *err=[error.userInfo objectForKey:NSLocalizedDescriptionKey];
                    
                    
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Sending Failed :%@",err]];
                    
                }];
                
                
            }
            
            else
            {
                [manager POST:requestURL parameters:_params  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    // do whatever you'd like here; for example, if you want to convert
                    // it to a string and log it, you might do something like:
                    
                    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    NSLog(@"%@", string);
                    
                    //            CustomTableViewCell *templatecell = (CustomTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    //
                    //            templatecell.templateMessage.text=@"";
                    
                    
                    record.image=@"";
                    record.stringToDate =[NSDate date];
                    [database insertSentRecord:record :@"sent"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:MessageRecentReload object:self userInfo:nil];
                    // [SVProgressHUD showSuccessWithStatus:@"Message Sent"];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    NSString *err=[error.userInfo objectForKey:NSLocalizedDescriptionKey];
                    
                    
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Sending Failed :%@",err]];
                }];
                
                
            }
        }
    }
    
    
    
}




-(void)checkandSaveRecord:(NSArray*)args
{
   // NSLog(@"@@@Array count1 :%d",args.count);
    
    
    for (Template *temp in args) {
        
      //  NSLog(@"@@@Message :%@",temp.message);
        //   NSLog(<#NSString *format, ...#>)
        
        Template *     availableTemplate;
        BDatabaseAdatper *database=[BDatabaseAdatper alloc];
        
        TabAppDelegate *appDelegate=(TabAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        LoadImage *insertRecord =[[LoadImage alloc]init];
        int RowID=0;
        [prefs setObject:temp.selected forKey:@"groupnames"];
        [prefs synchronize];
        
        availableTemplate=[database getTemplateFromMessage:temp.message];
        
        if (availableTemplate!=nil) {
            
            
            availableTemplate.contact=temp.contact;
            availableTemplate.message=temp.message;
            availableTemplate.type=temp.type;
            availableTemplate.date=temp.date;
            availableTemplate.selected=temp.selected;
          if(temp.reply_to!=nil&&temp.reply_to.length!=0)
          {
              availableTemplate.reply_to=temp.reply_to;
          }
            if(temp.virtype!=NULL)
            {
            availableTemplate.virtype=temp.virtype;
            availableTemplate.callstatus=temp.callstatus;
            availableTemplate.connectedstatus=temp.connectedstatus;
            }
            NSLog(@"vir type received:%@",availableTemplate.virtype);
            availableTemplate.stringToDate=temp.stringToDate;
            [prefs setBool:YES forKey:@"isgroup"];
            [prefs synchronize];
            
            RowID=  [database insertSentRecord:availableTemplate:@"receive"];
            availableTemplate.ID=[NSString stringWithFormat:@"%d",RowID];
            //[[NSNotificationCenter defaultCenter] postNotificationName:MessageRecentReload object:self userInfo:nil];
            
           // if ([appDelegate.ChatWindow isEqualToString:@"YES"]) {
                
                //NSDictionary *dictionary = [NSDictionary dictionaryWithObject:availableTemplate forKey:@"key"];
                //[[NSNotificationCenter defaultCenter] postNotificationName:MessagePushNotification object:self userInfo:dictionary];
              //  [appDelegate displayPopUp:availableTemplate :availableTemplate];
                
           // }
            
            
            
        }
        
        else if([temp.image isEqualToString:@""] || ([temp.image isEqualToString:[NSString stringWithFormat:@"%@message_images/ce841cc.jpg",VIZZICAL_URL]]) ){
            temp.image=@"";
            temp.thumbnail=@"";
            availableTemplate.selected=temp.selected;
            if(temp.virtype!=NULL)
            {
                availableTemplate.virtype=temp.virtype;
                availableTemplate.callstatus=temp.callstatus;
                availableTemplate.connectedstatus=temp.connectedstatus;
            }
            if(temp.reply_to!=nil&&temp.reply_to.length!=0)
            {
                availableTemplate.reply_to=temp.reply_to;
            }
            //NSLog(@"grp name received:%@",availableTemplate.selected);
            [prefs setBool:YES forKey:@"isgroup"];
            [prefs synchronize];
            RowID=[database insertSentRecord:temp :@"receive"];
            
            temp.ID=[NSString stringWithFormat:@"%d",RowID];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MessageRecentReload object:self userInfo:nil];
            
            //if ([appDelegate.ChatWindow isEqualToString:@"YES"]) {
                
//                NSDictionary *dictionary = [NSDictionary dictionaryWithObject:temp forKey:@"key"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:MessagePushNotification object:self userInfo:dictionary];
                //  [appDelegate displayPopUp:availableTemplate :availableTemplate];
                
            //}
            
        }
        
        
        else
        {
            [prefs setBool:YES forKey:@"isgroup"];
            [prefs synchronize];
            NSLog(@"inserted :grpname:%@",temp.selected);
         //   if(temp.simage!=nil&&temp.simage.length!=0)
            [insertRecord SaveImagefromPath:temp];
           // else
            //    RowID=[database insertSentRecord:temp :@"receive"];
            
           // if ([appDelegate.ChatWindow isEqualToString:@"YES"]) {
                
                //                NSDictionary *dictionary = [NSDictionary dictionaryWithObject:temp forKey:@"key"];
                //                [[NSNotificationCenter defaultCenter] postNotificationName:MessagePushNotification object:self userInfo:dictionary];
           // [appDelegate displayPopUp:temp :temp];
                
            //}


            //  });
            
        }
        
        
        
        
    }
}

@end
