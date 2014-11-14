//
//  Setting.h
//  pronama
//
//  Created by 大翼 on 2012/09/30.
//
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

#define LOGIN_URL @"https://secure.nicovideo.jp/secure/login?site=nicoiphone"
#define LOGIN_URL2 @"http://i.nicovideo.jp/v3/login?ticket=%@"
#define LOGIN_URL3 @"https://secure.nicovideo.jp/secure/login?site=niconico"
#define LOGIN_URL4 @"www.nicovideo.jp"

@interface Setting : NSObject

- (id)init;
- (void)dealloc;

+ (NSString *)getMailAddr;
+ (NSString *)getPassword;
+ (NSString *)getCommunityId;
+ (NSString *)getHashTag;
+ (NSString *)getSessionKey;

+ (void)setMailAddr:(NSString *)str;
+ (void)setPassword:(NSString *)str;
+ (void)setCommunityId:(NSString *)str;
+ (void)setHashTag:(NSString *)str;
+ (void)setSessionKey:(NSString *)str;

+ (BOOL)lightLogin;
+ (BOOL)deepLogin;

@end
