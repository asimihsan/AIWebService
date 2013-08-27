// =============================================================================
//    WSDLElement.m
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

#import "WSDLElement.h"
#import "ConciseKit/ConciseKit.h"

static NSString *xsdNamespaceUri = @"http://www.w3.org/2001/XMLSchema";
static NSDictionary *xsdToObjC;

@interface WSDLElement ()

- (void)initializeType:(NSString *)type;

@end

@implementation WSDLElement

- (NSString *)description
{
    return $str(@"{WSDLElement. name=%@, type=%@, minOccurs=%@, maxOccurs=%@, targetNamespace=%@, childElements: %@}",
                self.name, self.type, self.minOccurs, self.maxOccurs, self.targetNamespace, self.childElements);
}

-      (id)init:(NSString *)name
targetNamespace:(NSString *)targetNamespace
     namespaces:(NSDictionary *)namespaces
{
    return [self init:name
                 type:nil
            minOccurs:nil
            maxOccurs:nil
      targetNamespace:targetNamespace
           namespaces:namespaces];
}

-      (id)init:(NSString *)name
           type:(NSString *)type
      minOccurs:(NSString *)minOccurs
      maxOccurs:(NSString *)maxOccurs
targetNamespace:(NSString *)targetNamespace
     namespaces:(NSDictionary *)namespaces
{
    if (!(self = [super init]))
        return nil;
    self.name = name;
    self.targetNamespace = targetNamespace;
    self.minOccurs = minOccurs;
    self.maxOccurs = maxOccurs;
    self.namespaces = namespaces;
    self.childElements = [[NSMutableDictionary alloc] init];
    if (!xsdToObjC)
        xsdToObjC = $dict(
            [NSString class], @"string",
            [NSNumber class], @"int"
        );
    [self initializeType:type];
    return self;
}

- (void)initializeType:(NSString *)type
{
    if (type)
    {
        NSString *typeString;
        NSArray *elems = [type $split:@":"];
        if (elems.count == 1)
        {
            self.typeNamespaceUri = xsdNamespaceUri;
            typeString = type;
        }
        else
        {
            assert(elems.count == 2);
            NSString *namespace = [elems $at:0];
            self.typeNamespaceUri = [self.namespaces $for:namespace];
            typeString = [elems $at:1];
        }
        assert($eql(self.typeNamespaceUri, xsdNamespaceUri));
        self.type = [xsdToObjC $for:typeString];
    }
}

@end
