//
//  DBManager.h
//  Contacts
//
//  Created by sundar on 04/06/14.
//  Copyright (c) 2014 Sundar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject{
    
    NSString *databasePath;
}
+(DBManager *)getSharedInstance;
- (BOOL) saveData:(NSString*)name address:(NSString*)address phoneNo:(NSString*)phoneno;
- (NSArray*) findByName:(NSString*)name;
@end
