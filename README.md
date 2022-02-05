# XACML2mCRL2
This repository contains the code related to a paper entitled XXXX.
#######################################################################

The following shows the XACML policies and corresponsing mCRL2 specifications of the Examples used in the paper. 

**The XACML policy related to Example 1**

```xml
<PolicySet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:oasis:names:tc:xacml:3.0:core:schema:wd-17 http://docs.oasis-open.org/xacml/3.0/xacml-core-v3-schema-wd-17.xsd" PolicySetId="root" Version="1" PolicyCombiningAlgId="urn:oasis:names:tc:xacml:3.0:policy-combining-algorithm:permit-overrides">
<Target/>
<Policy xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:oasis:names:tc:xacml:3.0:core:schema:wd-17 http://docs.oasis-open.org/xacml/3.0/xacml-core-v3-schema-wd-17.xsd" PolicyId="Policy1" Version="1.0" RuleCombiningAlgId="urn:oasis:names:tc:xacml:3.0:rule-combining-algorithm:permit-overrides">
<Target/>
<Rule RuleId= "Rule1" Effect="Permit">
	<Target>
		<AnyOf>
			<AllOf>
				<Match MatchId="urn:oasis:names:tc:xacml:1.0:function:string-equal">
					<AttributeValue DataType="http://www.w3.org/2001/XMLSchema#string">HealthData</AttributeValue>
					<AttributeDesignator MustBePresent="false" Category="urn:oasis:names:tc:xacml:3.0:attribute-category:resource" AttributeId="resource-id" DataType="http://www.w3.org/2001/XMLSchema#string"/>					
				</Match>
				<Match MatchId="urn:oasis:names:tc:xacml:1.0:function:string-equal">
					<AttributeValue DataType="http://www.w3.org/2001/XMLSchema#string">Read</AttributeValue>
					<AttributeDesignator MustBePresent="false" Category="urn:oasis:names:tc:xacml:3.0:attribute-category:action" AttributeId="action-id" DataType="http://www.w3.org/2001/XMLSchema#string"/>
				</Match>
			</AllOf>
		</AnyOf>
	</Target>
	<Condition>
        <Apply FunctionId="urn:oasis:names:tc:xacml:1.0:function:string-equal">
		<Apply FunctionId="urn:oasis:names:tc:xacml:1.0:function:string-one-and-only">
				<AttributeValue DataType="http://www.w3.org/2001/XMLSchema#string">Doctor</AttributeValue>
			</Apply>
			<AttributeDesignator MustBePresent="false" Category="urn:oasis:names:tc:xacml:1.0:subject-category:access-subject" AttributeId="subject-id" DataType="http://www.w3.org/2001/XMLSchema#string"/>
		</Apply>
	</Condition>
</Rule>
</Policy>
</PolicySet>
```
*********************************************
**The mCRL2 specification related to Example 1**

sort SAtt = struct attribute(name:SAttName, value:SAttValue);
sort SAttName = struct subjectid;
sort SAttValue = struct CareGiverA|Doctor;
sort OAtt = struct attribute(name:OAttName, value:OAttValue);
sort OAttName = struct resourceid;
sort OAttValue = struct HealthData;
sort AAtt = struct attribute(name:AAttName, value:AAttValue);
sort AAttName = struct actionid;
sort AAttValue = struct Release;
sort Decision = struct Permit | Deny;
sort ObgID = struct email | log;
**act**
   Request:FSet(SAtt)#FSet(OAtt)#FSet(AAtt);
   Obligation:FSet(SAtt)#FSet(OAtt)#FSet(AAtt)#ObgID;
   Response:FSet(SAtt)#FSet(OAtt)#FSet(AAtt)#Decision;		   
**proc**		
     PolicySet_root(RS:FSet(SAtt), RO:FSet(OAtt), RA:FSet(AAtt)) = Request(RS,RO,RA).Policy_Policy1(RS,RO,RA);			
	
     Policy_Policy1(RS:FSet(SAtt), RO:FSet(OAtt), RA:FSet(AAtt))=				
     (	
	(attribute(resourceid,HealthData) in RO) && (attribute(actionid,Release) in RA) 							
     )->Rule_Rule1(RS,RO,RA);					

    Rule_Rule1(RS:FSet(SAtt), RO:FSet(OAtt), RA:FSet(AAtt))= (attribute(subjectid,Doctor) in RS)-> Response(RS,RO,RA,Permit);		
    
**init** **sum** RS:FSet(SAtt).sum RO:FSet(OAtt).sum RA:FSet(AAtt).(RS !={} && RO !={} && RA !={})->PolicySet_root(RS,RO,RA);

***************************************
