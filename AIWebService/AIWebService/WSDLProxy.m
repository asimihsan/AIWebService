// =============================================================================
//    WSDLProxy.m
//    Proxy requests from Objective-C to a web service using a Web Service
//    Description Language (WSDL) file.
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

#import "WSDLProxy.h"
#import "WSDLProxy_Private.h"

@implementation WSDLProxy

- (id)initWithString:(NSString *)sourceContents
{
    if (!(self = [super init]))
        return nil;
    self.sourceContents = sourceContents;
    [self initialize];
    return self;
}

#pragma mark - Private methods

- (void)initialize
{
    self.xmlParser = [[NSXMLParser alloc] initWithData:[self.sourceContents
                                       dataUsingEncoding:NSUTF8StringEncoding]];
    [self.xmlParser setDelegate:self];
    [self.xmlParser setShouldProcessNamespaces:YES];
    [self.xmlParser setShouldReportNamespacePrefixes:YES];
    [self.xmlParser setShouldResolveExternalEntities:YES];
    self.isValidXML = [self.xmlParser parse];
}

@end
