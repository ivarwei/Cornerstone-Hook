//
//  CornerstoneHook.m
//  Cornerstone
//
//  Created by bingwei5 on 2021/12/24.
//

#import "CornerstoneHook.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>

@implementation NSObject (CornerstoneHook)

+ (void)load {
    [self hookCredential];
    // [self hookTrialPeriod];
}

#pragma mark - ZLicenseCredential

+ (void)hookCredential {
    Class bundleClass = NSClassFromString(@"NSBundle");
    [bundleClass jr_swizzleMethod:NSSelectorFromString(@"preReleaseExpiryDate")
                       withMethod:NSSelectorFromString(@"iv_preReleaseExpiryDate")
                            error:nil];
    
    Class licenseWvc = NSClassFromString(@"ZLicenseWindowController");
    [licenseWvc jr_swizzleMethod:NSSelectorFromString(@"isRegistered")
                      withMethod:NSSelectorFromString(@"iv_isRegistered")
                           error:nil];
    [licenseWvc jr_swizzleMethod:NSSelectorFromString(@"reset:")
                      withMethod:NSSelectorFromString(@"iv_reset:")
                           error:nil];
    
    Class licenseCredential = NSClassFromString(@"ZLicenseCredential");
    [licenseCredential jr_swizzleMethod:NSSelectorFromString(@"authenticateWithPublicKey:")
                             withMethod:NSSelectorFromString(@"iv_authenticateWithPublicKey:")
                                  error:nil];
}

- (NSDate *)iv_preReleaseExpiryDate {
    NSInteger day = 60 * 60 * 24 * 365 * 2;
    return [NSDate dateWithTimeIntervalSinceNow:day];
}

- (BOOL)iv_isRegistered {
    return true;
}

- (void)iv_reset:(id)arg1 {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(@"close:") withObject:nil];
#pragma clang diagnostic pop
}

- (id)iv_authenticateWithPublicKey:(id)arg1 {
    return nil;
}

#pragma mark - ZTrialPeriod

+ (void)hookTrialPeriod {
    Class trialPeriodClass = NSClassFromString(@"ZTrialPeriod");
    [trialPeriodClass jr_swizzleMethod:NSSelectorFromString(@"hasExpired")
                            withMethod:NSSelectorFromString(@"iv_hasExpired")
                                 error:nil];
    [trialPeriodClass jr_swizzleMethod:NSSelectorFromString(@"remaining")
                            withMethod:NSSelectorFromString(@"iv_remaining")
                                 error:nil];
    
    Class policyClass = NSClassFromString(@"ZTrialPeriodLicensingPolicy");
    [policyClass jr_swizzleMethod:NSSelectorFromString(@"showWindow")
                       withMethod:NSSelectorFromString(@"iv_showWindow")
                            error:nil];
    [policyClass jr_swizzleMethod:NSSelectorFromString(@"showExpiryWindow")
                       withMethod:NSSelectorFromString(@"iv_showExpiryWindow")
                            error:nil];
}

- (BOOL)iv_hasExpired {
    return false;
}

- (unsigned long long)iv_remaining {
    return 3650;
}

- (BOOL)iv_showWindow {
    return true;
}

- (BOOL)iv_showExpiryWindow {
    return true;
}

@end
