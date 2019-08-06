//
//  AppDelegate.m
//  ProgrammingContests
//
//  Created by Kobe on 2019/8/2.
//  Copyright © 2019 KobeLuo. All rights reserved.
//

#import "AppDelegate.h"
#import "SortClass.h"
@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    [self testPower];
    [self testgcd];
//    testSort();
    [SortClass testSort];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)testPower {
    
    int a[5] = {1,2,3,4,5};
    for (int index = 0; index < sizeof(a)/sizeof(int); index ++) {
        
        int value = a[index];
        printf("value:%d,power:%.f\n",value,power(2, value));
        printf("value:%d,power:%.f\n",value,power_norecusive(2, value));
    }
}

- (void)testgcd {
    
    int a = 25,b = 35;
    printf("greaster common divisor: %d\n",gcd(a, b));
}

//Running time: O(logn) imp recusive
double power(double a, int n) {
    
    if (0 == n) return 1;
    if (1 == n) return a;
    double t = power(a, n/2);
    return t * t * power(a, n%2);
}
//You should understand how it works
/**
2^7 = 2^6 * 2               ret = 2,a=2,n=6
    = 4^3 * 2               ret = 2,a=4,n=3
    = 4^2 * 2 * 4           ret = 8,a=4,n=2
    = 16^1 * 2 * 4          ret = 8,a=16,n=1
    = 256^0 * 16 * 2 *4     ret = 128,a=256,n=0 out cycle.
 */
double power_norecusive(double a, int n) {
    
    double ret = 1;
    while(n) {
        
        if (n%2 == 1) ret *= a;
        a *= a; n /= 2;
    }
    return ret;
}
//greastest Common Divisor  gcd(a,b) = gcd(a,b-a),repeat use this.
//Running time: O(log(a+b))
int gcd(int a,int b) {
    /*
    int ret = 1;
    if (a == 0) ret = b;
    if (b == 0) ret = a;
    if (a == b) {ret = a; a = 0;}
    while (a*b) {

        if (a > b) {
            a = a - b;
        }else {
            b = b - a;
        }

        ret = gcd(a, b);
    }
    return ret;
    */
    while(a) { int ret = b%a; b = a; a = ret; }
    return b;
}

@end
