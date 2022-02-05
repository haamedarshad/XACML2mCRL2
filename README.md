# XACML2mCRL2
This repository contains the code related to a paper entitled XXXX.
#######################################################################

The following shows the XACML policies and corresponsing mCRL2 specifications of the Examples used in the paper. 


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
