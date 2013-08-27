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

#import "ConciseKit/ConciseKit.h"

#import "WSDLProxy.h"
#import "WSDLProxy_Private.h"
#import "WSDLSchema.h"
#import "WSDLElement.h"

static NSString *soap11NamespaceUri = @"http://schemas.xmlsoap.org/wsdl/soap/";
static NSString *soap12NamespaceUri = @"http://schemas.xmlsoap.org/wsdl/soap12/";
static NSString *wsdlNamespaceUri = @"http://schemas.xmlsoap.org/wsdl/";

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
    self.namespaces = [[NSMutableDictionary alloc] init];
    self.schemas = [[NSMutableDictionary alloc] init];
    self.currentXMLNamespaceStack = [[NSMutableArray alloc] init];
    @autoreleasepool {
        self.xmlParser = [[NSXMLParser alloc]
                          initWithData:[self.sourceContents
                                       dataUsingEncoding:NSUTF8StringEncoding]];
        [self.xmlParser setDelegate:self];
        [self.xmlParser setShouldProcessNamespaces:YES];
        [self.xmlParser setShouldReportNamespacePrefixes:YES];
        self.isValidXML = [self.xmlParser parse];
    }
}

#pragma mark - NSXMLParserDelegate

-        (void)parser:(NSXMLParser *)parser
didStartMappingPrefix:(NSString *)prefix
                toURI:(NSString *)namespaceURI
{
    if (prefix.length > 0)
        [self.namespaces $obj:namespaceURI for:prefix];
}

-  (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributeDict
{
    if ($eql(namespaceURI, wsdlNamespaceUri) &&
        $eql(elementName, @"definitions") &&
        [attributeDict objectForKey:@"targetNamespace"])
    {
        [self.namespaces $obj:[attributeDict objectForKey:@"targetNamespace"]
                          for:@"targetNamespace"];
    }
    else if ($eql(namespaceURI, wsdlNamespaceUri) &&
             $eql(elementName, @"types"))
    {
        [self.currentXMLNamespaceStack $push:wsdlNamespaceUri];
    } // wsdl:types
    else if ($eql([self.currentXMLNamespaceStack $last], wsdlNamespaceUri) &&
             $eql(elementName, @"schema"))
    {
        NSString *namespace = [attributeDict $for:@"targetNamespace"];
        self.currentSchema = [[WSDLSchema alloc] init:namespace
                                           namespaces:self.namespaces];
    } // wsdl:types -> schema
    else if ($eql([self.currentXMLNamespaceStack $last], wsdlNamespaceUri) &&
             $eql(elementName, @"element"))
    {
        NSString *name = [attributeDict $for:@"name"];
        NSString *targetNamespace = self.currentSchema.targetNamespace;
        if (self.currentElement)
        {
            NSString *minOccurs = [attributeDict $for:@"minOccurs"];
            NSString *maxOccurs = [attributeDict $for:@"maxOccurs"];
            NSString *type = [attributeDict $for:@"type"];
            WSDLElement *element = [[WSDLElement alloc] init:name
                                                        type:type
                                                    minOccurs:minOccurs
                                                    maxOccurs:maxOccurs
                                             targetNamespace:targetNamespace
                                                  namespaces:self.namespaces];
            [self.currentElement.childElements $obj:element
                                                for:element.name];
        }
        else
        {
            WSDLElement *element = [[WSDLElement alloc] init:name
                                       targetNamespace:targetNamespace
                                            namespaces:self.namespaces];
            self.currentElement = element;
        }
    } // wsdl:types -> schema -> element
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ($eql(namespaceURI, wsdlNamespaceUri) &&
        $eql(elementName, @"types"))
    {
        [self.currentXMLNamespaceStack $pop];
    }
    else if ($eql([self.currentXMLNamespaceStack $last], wsdlNamespaceUri) &&
             $eql(elementName, @"schema"))
    {
        [self.schemas $obj:self.currentSchema
                       for:self.currentSchema.targetNamespace];
        self.currentSchema = nil;
    }
    else if ($eql([self.currentXMLNamespaceStack $last], wsdlNamespaceUri) &&
             $eql(elementName, @"element"))
    {
        if (self.currentElement && (!self.currentElement.type))
        {
            [self.currentSchema.elements $obj:self.currentElement
                                          for:self.currentElement.name];
            self.currentElement = nil;
        }
    }
}

@end
