// =============================================================================
//    WSDLProxyTests.m
//
//    Project: AIWebService
// =============================================================================
//    Created by Asim Ihsan on 2013-08-26.
//    Version 0.1
//
//    Copyright 2013 Asim Ihsan
//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
// =============================================================================

#import "WSDLProxyTests.h"
#import "WSDLProxy.h"
#import "WSDLProxy_Private.h"

@interface WSDLProxyTests ()

@property (nonatomic, copy) NSString *helloWSDLContents;

@end

@implementation WSDLProxyTests

#pragma mark - Public methods

- (void)setUp
{
    NSString *helloFilePath = [[NSBundle bundleForClass:[self class]]
                               pathForResource:@"Hello" ofType:@"wsdl"];
    self.helloWSDLContents = [NSString stringWithContentsOfFile:helloFilePath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    [super setUp];
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

- (void)testLoadFromString
{
    WSDLProxy *helloWSDLProxy = [[WSDLProxy alloc] initWithString:self.helloWSDLContents];
    STAssertNotNil(helloWSDLProxy, @"Could not create WSDLProxy instance.");
}

@end
