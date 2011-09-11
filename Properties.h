//
//  Properties.h
//  mobil-payment
//
//  Created by Torben Toepper on 27.08.11.
//  Copyright 2011 redrauscher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Properties : NSObject {
    NSUserDefaults *prefs;
}

@property (nonatomic, retain) NSUserDefaults *prefs;

-(NSString *)get:(NSString *)key;
-(void)store:(NSString *)key value:(NSString *)value;
-(BOOL)storeInDB:(NSDictionary *)properties;

@end
