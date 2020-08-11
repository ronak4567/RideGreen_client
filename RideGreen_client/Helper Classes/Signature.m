//
//  Signature.m
//  GTMiPhone
//
//  Created by Asrar  ul hasan on 8/5/14.
//
//


#import <Foundation/NSString.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

// Google Toolbox for Mac is used for Base 64 encoding and decoding
// http://code.google.com/p/google-toolbox-for-mac/
// 1. Download sources with the following command:
//   $svn checkout http://google-toolbox-for-mac.googlecode.com/svn/trunk/ \
//     google-toolbox-for-mac-read-only
// 2. Add the "trunk" directory as a Framework in XCode
// 3. In the XCode "Targets" section, make sure only "urlsigner.m" and
//   "GTMStringEncoding.m" are compiled
#import "GTMStringEncoding.h"
#import "Signature.h"

@implementation Signature
///Users/us14/Desktop/clint's project/fiveStarLuxuryCars Main/FiveStarLuxuryCar_Driver/FiveStarLuxuryCar_Driver/Signature.m:29:13: Expected method body

// Sample code demonstrating Maps API URL signing in Objective-C.
//-(NSString*)generateSignature:(NSString *)url
-(NSString*)generateSignature:(NSMutableString *)url
{
    // Sets up the autorelease pool, for memory management.
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *key = @"Du6_XJs5J9H-jSedmuBLu3J-2-A=";
    NSString *clientId = @"&client=gme-fivestarluxurycars";
   // NSString *url =
   // @"/maps/api/geocode/json?address=New+York&sensor=false&client=gme-fivestarluxurycars";
    
    // Stores the url in a NSData.
    [url appendString:clientId];
    NSData *urlData = [url dataUsingEncoding: NSASCIIStringEncoding];
   // ////NSLog(@"urlData %@", [url dataUsingEncoding: NSASCIIStringEncoding]);
    // URL-safe Base64 coder/decoder.
    GTMStringEncoding *encoding =
    [GTMStringEncoding rfc4648Base64WebsafeStringEncoding];
    
    // Decodes the URL-safe Base64 key to binary.
    NSData *binaryKey = [encoding decode:key];
    
    // Signs the URL.
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1,
           [binaryKey bytes], [binaryKey length],
           [urlData bytes], [urlData length],
           &result);
    NSData *binarySignature =
    [NSData dataWithBytes:&result length:CC_SHA1_DIGEST_LENGTH];
    
    // Encodes the signature to URL-safe Base64.
    NSString *signature = [encoding encode:binarySignature];
    [url appendString:[NSString stringWithFormat:@"&signature=%@",signature]];
//    ////NSLog(@"The final URL is: http://maps.googleapis.com%@&signature=%@", url,
//          signature);
    
    // Clean up autoreleased objects.
    [pool release];
   // ////NSLog(@"%@",[NSString stringWithFormat:@"http://maps.googleapis.com%@",url]);
    return [NSString stringWithFormat:@"http://maps.googleapis.com%@",url];
    
}

@end

