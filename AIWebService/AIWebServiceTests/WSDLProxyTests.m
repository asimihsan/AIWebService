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
#import "ConciseKit/ConciseKit.h"

@interface WSDLProxyTests ()

@property (nonatomic, copy) NSString *helloWSDLContents;
@property (nonatomic, copy) NSString *aspDotNetContents;

- (NSString *)getFile:(NSString *)filename type:(NSString *)type;

- (void)_testLoadFromString:(WSDLProxy *)wsdlProxy;

@end

@implementation WSDLProxyTests

#pragma mark - Public methods

- (NSString *)getFile:(NSString *)filename type:(NSString *)type
{
    NSString *path = [[NSBundle bundleForClass:[self class]]
                                          pathForResource:filename ofType:type];
    return [NSString stringWithContentsOfFile:path
                                     encoding:NSUTF8StringEncoding
                                        error:nil];
}


- (void)setUp
{
    self.helloWSDLContents = [self getFile:@"Hello" type:@"wsdl"];
    self.aspDotNetContents = [self getFile:@"ASPdotNET" type:@"wsdl"];
    [super setUp];
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

#pragma mark - testLoadFromString

- (void)_testLoadFromString:(WSDLProxy *)wsdlProxy
{
    STAssertNotNil(wsdlProxy, @"Could not create WSDLProxy instance.");
    STAssertTrue(wsdlProxy.isValidXML, @"Valid XML is marked invalid.");
}

- (void)testHelloWSDLLoadFromString
{
    WSDLProxy *helloWSDLProxy = [[WSDLProxy alloc] initWithString:self.helloWSDLContents];
    [self _testLoadFromString:helloWSDLProxy];
}

- (void)testAspDotNetLoadFromString
{
    WSDLProxy *aspDotNetProxy = [[WSDLProxy alloc] initWithString:self.aspDotNetContents];
    [self _testLoadFromString:aspDotNetProxy];
}

#pragma mark - testNamespaces

- (void)testHelloWSDLNamespaces
{
    WSDLProxy *helloWSDLProxy = [[WSDLProxy alloc] initWithString:self.helloWSDLContents];
    NSDictionary *expectedNamespaces = $dict(@"http://schemas.xmlsoap.org/wsdl/soap/", @"wsdlsoap",
                                             @"http://xml.apache.org/xml-soap", @"apachesoap",
                                             @"http://ai.com", @"impl",
                                             @"http://schemas.xmlsoap.org/wsdl/", @"wsdl",
                                             @"http://www.w3.org/2001/XMLSchema", @"xsd",
                                             @"http://ai.com", @"intf",
                                             @"http://ai.com", @"targetNamespace");
    STAssertTrue($eql(helloWSDLProxy.namespaces, expectedNamespaces),
                 @"HelloWSDLProxy.namespaces not as expected: %@",
                 helloWSDLProxy.namespaces);
}

- (void)testAspDotNetNamespaces
{
    WSDLProxy *aspDotNet = [[WSDLProxy alloc] initWithString:self.aspDotNetContents];
    NSDictionary *expectedNamespaces = $dict(@"http://schemas.xmlsoap.org/wsdl/http/", @"http",
                                             @"http://schemas.xmlsoap.org/wsdl/mime/", @"mime",
                                             @"http://www.w3.org/2001/XMLSchema", @"s",
                                             @"http://schemas.xmlsoap.org/wsdl/soap/", @"soap",
                                             @"http://schemas.xmlsoap.org/wsdl/soap12/", @"soap12",
                                             @"http://schemas.xmlsoap.org/soap/encoding/", @"soapenc",
                                             @"http://foobar.com/", @"targetNamespace",
                                             @"http://microsoft.com/wsdl/mime/textMatching/", @"tm",
                                             @"http://foobar.com/", @"tns",
                                             @"http://schemas.xmlsoap.org/wsdl/", @"wsdl");
    STAssertTrue($eql(aspDotNet.namespaces, expectedNamespaces),
                 @"aspDotNet.namespaces not as expected: %@",
                 aspDotNet.namespaces);
}
    
@end
