//
//  Setting.m
//  pronama
//
//  Created by 大翼 on 2012/09/30.
//
//

#import "Setting.h"

@implementation Setting

static NSString *mail_addr, *password, *community_id, *hash_tag, *ticket, *session_key;
static NSUserDefaults *defaults;

- (id)init {
    if (self == [super init]) {
        session_key = [[NSString alloc] init];
        defaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void)dealloc {
    defaults = nil;
    mail_addr = nil;
    password = nil;
    community_id = nil;
    hash_tag = nil;
    ticket = nil;
    session_key = nil;
}

+ (NSString *)getMailAddr {
    if (!mail_addr)
        mail_addr = [defaults stringForKey:@"MAILADDR"];
    
    return mail_addr;
}

+ (NSString *)getPassword {
    if (!password)
        password = [defaults stringForKey:@"PASSWORD"];
    
    return password;
}

+ (NSString *)getCommunityId {
    if (!community_id)
        community_id = [defaults stringForKey:@"COMMUNITY"];
    
    return community_id;
}

+ (NSString *)getHashTag {
    if (!hash_tag)
        hash_tag = [defaults stringForKey:@"HASHTAG"];
    
    return hash_tag;
}

+ (NSString *)getSessionKey {
    return  session_key;
}

+ (void)setMailAddr:(NSString *)str {
    [defaults setObject:str forKey:@"MAILADDR"];
    mail_addr = str;
}

+ (void)setPassword:(NSString *)str {
    [defaults setObject:str forKey:@"PASSWORD"];
    password = str;
}

+ (void)setCommunityId:(NSString *)str {
    [defaults setObject:str forKey:@"COMMUNITY"];
    community_id = str;
}

+ (void)setHashTag:(NSString *)str {
    [defaults setObject:str forKey:@"HASHTAG"];
    hash_tag = str;
}

+ (void)setSessionKey:(NSString *)str {
    session_key = str;
}

+ (BOOL)lightLogin {
    BOOL login = false;
    
    if ([Setting getMailAddr] != nil && [Setting getPassword] != nil) {
        NSString *str = [[NSString alloc] initWithFormat:@"mail=%@&password=%@", [Setting getMailAddr], [Setting getPassword]];
        NSURL *url = [[NSURL alloc] initWithString:LOGIN_URL];
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
        [req setHTTPMethod:@"POST"];
        [req setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLResponse *res = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
        
        if (!error) {
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
            
            if (!error) {
                for (GDataXMLNode *item in [document nodesForXPath:@"//nicovideo_user_response/ticket" error:&error]) {
                    for (GDataXMLNode *child in [item children]) {
                        ticket = [child stringValue];
                        break;
                    }
                }
                
                document = nil;
            }
        }
        
        req = nil;
        res = nil;
        error = nil;
        data = nil;
        url = nil;
        str = nil;
        
        if (ticket != nil) {
            NSURL *url = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:LOGIN_URL2, ticket]];
            
            NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
            NSURLResponse *res = nil;
            NSError *error = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
            
            if (!error) {
                GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
                
                if (!error) {
                    for (GDataXMLNode *item in [document nodesForXPath:@"//nicovideo_user_response/user/session_id" error:&error]) {
                        for (GDataXMLNode *child in [item children]) {
                            session_key = [child stringValue];
                            login = true;
                        }
                    }
                }
                
                document = nil;
            }

            req = nil;
            res = nil;
            error = nil;
            data = nil;
            url = nil;
            str = nil;
        }
    }
    
    
    return login;
}

+ (BOOL)deepLogin {
    BOOL login = false;
    
    if ([Setting getMailAddr] != nil && [Setting getPassword] != nil) {
        NSString *str = [[NSString alloc] initWithFormat:@"mail=%@&password=%@", [Setting getMailAddr], [Setting getPassword]];
        NSURL *url = [[NSURL alloc] initWithString:LOGIN_URL3];
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
        [req setHTTPMethod:@"POST"];
        [req setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSHTTPURLResponse *res = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
        
        NSRange match = [res.URL.host rangeOfString:LOGIN_URL4];
        
        if (!error && match.location != NSNotFound) {

//        NSDictionary *dictionary = [res allHeaderFields];
//        NSEnumerator *enumerator = [dictionary keyEnumerator];
//        id key;
//        
//        while ((key = [enumerator nextObject])) {
//            /* code that uses the returned key */
//            NSLog(key);
//        }
            
            login = true;
        }
        
        req = nil;
        res = nil;
        error = nil;
        data = nil;
        url = nil;
        str = nil;
    }
    
    return login;
}



@end
