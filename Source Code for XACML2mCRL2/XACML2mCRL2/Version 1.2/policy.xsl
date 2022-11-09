<xsl:stylesheet version = "1.0" xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" xmlns:xacml="urn:oasis:names:tc:xacml:3.0:core:schema:wd-17" > 
	<xsl:output method="text" indent="no"/>
      <xsl:strip-space elements="*"/>


<!-- A list of templates i.e., functions, are defined here. These functions are called in the main part of the code using <xsl:call-template name="NAME-OF-Function"/> -->  
  
<!-- This template (function) lists attibute names. This template (function) is called a few times using "<xsl:call-template name="ListAttributeNames"/>" -->
	<xsl:template name="ListAttributeNames">
			<xsl:param name="attname"/>
			<xsl:choose>
				<xsl:when test="position() != last()">
					<xsl:call-template name="getName">
						<xsl:with-param name="attname" select="translate(@AttributeId,'-','')"/>
					</xsl:call-template>
					<xsl:value-of select = "$attname"/>|
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="getName">
						<xsl:with-param name="attname" select="translate(@AttributeId,'-','')"/>
					</xsl:call-template>
					<xsl:value-of select = "$attname"/>
				</xsl:otherwise>
			</xsl:choose>	
	</xsl:template>
<!-- End of the template (function) for listing attibute names -->



<!-- This template (function) lists attibute values. This template (function) is called a few times using "<xsl:call-template name="ListAttributeValues"/>" -->
	<xsl:template name="ListAttributeValues">
	<xsl:param name="attname"/>
		<xsl:choose>
			<xsl:when test="position() != last()">
				<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>|
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
<!-- End of the template (function) for listing attibute values -->


  
<!-- This template (function) removes the namespace from the name of attributes. For example, "action-id" will be returned instead of "urn:oasis:names:tc:xacml:1.0:action:action-id"   -->
	<xsl:template name="getName">
		<xsl:param name="attname"/>
			<xsl:choose>
				<xsl:when test="contains($attname, ':')">
					<xsl:call-template name="getName">
						<xsl:with-param name="attname" select="substring-after($attname, ':')"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$attname"/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
<!-- End of the template (function) for trimming attribute names -->



<!-- This template (function) translates the Target of a Rule, a Policy, or a PolicySet. This template (function) is called a few times using "<xsl:call-template name="TargetFunction"/>" -->
	<xsl:template name="TargetFunction">
	<xsl:if test="(xacml:Target!='')">				
		(	
		<xsl:for-each select = "xacml:Target/xacml:AnyOf/xacml:AllOf">
			<xsl:choose>	
				<xsl:when test="position() != last()">
				(
					<xsl:call-template name="MatchFunction"/>
				)			
				||
				</xsl:when>
				<xsl:otherwise>
				(
					<xsl:call-template name="MatchFunction"/>
				)		
				</xsl:otherwise>
			</xsl:choose>			
		</xsl:for-each>
		)->				
	</xsl:if>
	</xsl:template>
<!-- End of the template (function) for translating Target) -->



<!-- This template (function) translates the Match part of a Rule, Policy, or PolicySt. This template (function) is called (re-used) in different parts of the code using "<xsl:call-template name="MatchFunction"/>" -->	
	<xsl:template name="MatchFunction">
		<xsl:param name="attname"/>
		<xsl:for-each select = "xacml:Match">
			<xsl:choose>	
				<xsl:when test="position() != last()">
					(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
					<xsl:call-template name="CategoryFunction"/> &amp;&amp;
				</xsl:when>	
				<xsl:otherwise>	
					(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>,<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
					<xsl:call-template name="CategoryFunction"/>
				</xsl:otherwise>	
			</xsl:choose>	
		</xsl:for-each>
	</xsl:template>
<!-- End of the template (function) for translating the Match part -->



<!-- This template (function) selects RS, RO, and RA, which represent sets of received subject attributes, object attributes, and action attributes, respectively. RS, RO, and RA will be selected based on the Category value in the AttributeDesignator element. This template (function) is called a few times using "<xsl:call-template name="CategoryFunction"/>" -->
	<xsl:template name="CategoryFunction">
		<xsl:choose>
			<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
				RA) 
			</xsl:when>
			<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
				RO) 
			</xsl:when>
			<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
				RS) 
			</xsl:when>
			<xsl:otherwise>
				RE) 
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
<!-- End of the template (function) for selecting RS, RO, and RA (i.e., CategoryFunction) -->



<!-- This template (function) translates the Condition of a Rule. This template (function) is called a few times using "<xsl:call-template name="ConditionFunction"/>" -->
	<xsl:template name="ConditionFunction">	
	<xsl:param name="attname"/>	
		<!-- Check if there exists a Condition -->
		<xsl:if test="(xacml:Condition!='')">    
			
			<xsl:choose>
			
				<!-- If there exists one of the logical functions, i.e., NOT, AND, and OR, in the Condition -->   
				<xsl:when test="not(xacml:Condition/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@AttributeId)">
					<xsl:choose>						
						<!-- Check and translate if there is a NOT in the Condition--> 
						<xsl:when test="(xacml:Condition/xacml:Apply/@FunctionId='urn:oasis:names:tc:xacml:1.0:function:not')">
								<xsl:call-template name="NOTinCondition"/>
						</xsl:when>

						<!-- Check and translate if there is an AND in the Condition--> 
						<xsl:when test="(xacml:Condition/xacml:Apply/@FunctionId='urn:oasis:names:tc:xacml:1.0:function:and')">
							<xsl:call-template name="ANDinCondition"/>
						</xsl:when>
							
						<!-- Check and translate if there is an OR in the Condition--> 
						<xsl:when test="(xacml:Condition/xacml:Apply/@FunctionId='urn:oasis:names:tc:xacml:1.0:function:or')">
							<xsl:call-template name="ORinCondition"/>
						</xsl:when>							
					</xsl:choose>				
				</xsl:when>	
					
				<!-- There is no NOT, AND, and OR. There exists only one attribute in the Condition part of the Rule --> 
				<xsl:when test="(xacml:Condition/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@AttributeId)">
					(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:Condition/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(xacml:Condition/xacml:Apply/xacml:AttributeValue,'- :/.','')"/>) in 
					<xsl:for-each select="xacml:Condition/xacml:Apply/xacml:Apply">
						<xsl:call-template name="CategoryFunction"/> ->  
					</xsl:for-each>
				</xsl:when>    

			</xsl:choose>        
		</xsl:if>	
	</xsl:template>
<!-- End of the template (function) for translating the Condition part of a Rule -->
	
	
	
<!-- This template (function) translates the AND part in the Condition part of a Rule. This template (function) is called a few times using "<xsl:call-template name="ANDinCondition"/>" -->
	<xsl:template name="ANDinCondition">
	<xsl:param name="attname"/>	
		(
		<xsl:for-each select = "xacml:Condition/xacml:Apply/xacml:Apply/xacml:Apply">        
			<xsl:if test="position() != last()">
				(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(../xacml:AttributeValue,'- :/.','')"/>) in 
				<xsl:call-template name="CategoryFunction"/> &amp;&amp;
			</xsl:if>
			<xsl:if test="position() = last()">
				(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(../xacml:AttributeValue,'- :/.','')"/>) in 
				<xsl:call-template name="CategoryFunction"/>
			</xsl:if>
		</xsl:for-each>    
		)->
	</xsl:template>
<!-- End of the template (function) for translating AND part in Condition of a Rule -->
	
	
	
<!-- This template (function) translates the OR part in the Condition part of a Rule. This template (function) is called a few times using "<xsl:call-template name="ORinCondition"/>" -->
	<xsl:template name="ORinCondition">
	<xsl:param name="attname"/>	
		(
		<xsl:for-each select = "xacml:Condition/xacml:Apply/xacml:Apply/xacml:Apply">        
			<xsl:if test="position() != last()">
				(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(../xacml:AttributeValue,'- :/.','')"/>) in 
				<xsl:call-template name="CategoryFunction"/> ||
			</xsl:if>
			<xsl:if test="position() = last()">
				(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(../xacml:AttributeValue,'- :/.','')"/>) in 
				<xsl:call-template name="CategoryFunction"/> 
			</xsl:if>
		</xsl:for-each>    
		)->
	</xsl:template>
<!-- End of the template (function) for translating OR part in Condition of a Rule -->



<!-- This template (function) translates the NOT part in the Condition part of a Rule. This template (function) is called a few times using "<xsl:call-template name="NOTinCondition"/>" -->
	<xsl:template name="NOTinCondition">	
	<xsl:param name="attname"/>	
		
		<xsl:for-each select = "xacml:Condition/xacml:Apply/xacml:Apply/xacml:Apply">        
		(
		<xsl:if test="xacml:AttributeDesignator/@AttributeId !=''">
			!(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(../xacml:AttributeValue,'- :/.','')"/>) in 
			<xsl:call-template name="CategoryFunction"/>   
		</xsl:if>
		)->
		</xsl:for-each>    		
	</xsl:template>
<!-- End of the template (function) for translating NOT part in Condition of a Rule -->



<!-- This template (function) translates the obligation expressions attached to a Rule. This template (function) is called a few times using "<xsl:call-template name="RuleObligations"/>" -->
	<xsl:template name="RuleObligations">
	<xsl:param name="attname"/>		
		<xsl:if test="((xacml:ObligationExpressions/xacml:ObligationExpression/@ObligationId!='') and (@Effect =xacml:ObligationExpressions/xacml:ObligationExpression/@FulfillOn))">
			<xsl:for-each select = "xacml:ObligationExpressions/xacml:ObligationExpression">	
				Obligation(RS,RO,RA,<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@ObligationId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>).
			</xsl:for-each>	
		</xsl:if>
	</xsl:template>
<!-- End of the template (function) for translating obligation expressions attached to a Rule -->



<!-- This template (function) moves the obligation expressions applicable to a Rule from the parent Policy. This template (function) is called a few times using "<xsl:call-template name="PolicyObligations"/>" -->
	<xsl:template name="PolicyObligations">
	<xsl:param name="attname"/>	
		<xsl:if test="((../xacml:ObligationExpressions/xacml:ObligationExpression/@ObligationId!='') and (@Effect =../xacml:ObligationExpressions/xacml:ObligationExpression/@FulfillOn))">
			<xsl:for-each select = "../xacml:ObligationExpressions/xacml:ObligationExpression">	
				Obligation(RS,RO,RA,<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@ObligationId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>).
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
<!-- End of the template (function) for moving and translating obligation expressions from the Parent Policy -->



<!-- This template (function) moves the obligation expressions applicable to the Rule from the parent PolicySet. This template (function) is called a few times using "<xsl:call-template name="PolicySetObligations"/>" -->
	<xsl:template name="PolicySetObligations">
	<xsl:param name="attname"/>		
		<xsl:if test="((../../xacml:ObligationExpressions/xacml:ObligationExpression/@ObligationId!='') and (@Effect =../../xacml:ObligationExpressions/xacml:ObligationExpression/@FulfillOn))">
			<xsl:for-each select = "../../xacml:ObligationExpressions/xacml:ObligationExpression">	
				Obligation(RS,RO,RA,<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@ObligationId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>).
			</xsl:for-each>
		</xsl:if>		
	</xsl:template>
<!--  End of the template (function) for moving and translating obligation expressions from the Parent PolicySet. -->


<!-- End of declaration of templates (functions)/> -->  




<xsl:template match = "/">	  
<xsl:param name="attname"/>

<!-- Constructing the DECLARATION part of the mCRL2 specifications. This part declares the required sorts (data types) and actions for the mCRL2 processes -->	

	<!-- This is constant for all inputs, and it defines a datatype for subject attributes   -->	
	sort SAtt = struct attribute(name:SAttName, value:SAttValue);
	<!-- End of the definition of the datatype for subject attributes  -->

	
	<!-- Defining a datatype for NAMES of subject attributes (this datatype will be populated with all names for subject attributes that exist in the input policy )-->	
	<xsl:if test="descendant::*/xacml:AttributeDesignator[not(@AttributeId=../preceding::*/xacml:AttributeDesignator/@AttributeId) and (@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')]">
		sort SAttName = struct 
		<xsl:for-each select = "descendant::*/xacml:AttributeDesignator[not(@AttributeId=../preceding::*/xacml:AttributeDesignator/@AttributeId) and (@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')]">
			<xsl:call-template name="ListAttributeNames"/>
		</xsl:for-each>;
	</xsl:if>
	<!-- End of the definition of the datatype for NAMES of subject attributes  -->


	<!-- Defining a datatype for VALUES of subject attributes (this datatype will be populated with all values for subject attributes that exist in the input policy )-->			
	<xsl:if test = "(descendant::*/xacml:Match[not(AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')])|(descendant::*/xacml:Apply[not(AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:Apply/xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')])">
		sort SAttValue = struct 
		<xsl:for-each select = "(descendant::*/xacml:Match[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')])|(descendant::*/xacml:Apply[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:Apply/xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')])">
			<xsl:call-template name="ListAttributeValues"/>
		</xsl:for-each>;
	</xsl:if>
	<!-- End of the definition of the datatype for VALUES of subject attributes  -->


	<!-- This is constant for all inputs, and it defines a datatype for object attributes   -->		
	sort OAtt = struct attribute(name:OAttName, value:OAttValue);
	<!-- End of the definition of the datatype for object attributes  -->


	<!-- Defining a datatype for NAMES of object attributes (this datatype will be populated with all names for object attributes that exist in the input policy )-->			
	<xsl:if test="descendant::*/xacml:AttributeDesignator[not(@AttributeId=../preceding::*/xacml:AttributeDesignator/@AttributeId) and (@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')]">
		sort OAttName = struct 
		<xsl:for-each select = "descendant::*/xacml:AttributeDesignator[not(@AttributeId=../preceding::*/xacml:AttributeDesignator/@AttributeId) and (@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')]">
			<xsl:call-template name="ListAttributeNames"/>
		</xsl:for-each>;
	</xsl:if>		
	<!-- End of the definition of the datatype for NAMES of object attributes  -->


	<!-- Defining a datatype for VALUES of object attributes (this datatype will be populated with all values for object attributes that exist in the input policy )-->			
	<xsl:if test = "(descendant::*/xacml:Match[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')])|(descendant::*/xacml:Apply[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:Apply/xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')])">
		sort OAttValue = struct 
		<xsl:for-each select = "(descendant::*/xacml:Match[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')])|(descendant::*/xacml:Apply[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:Apply/xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')])">
			<xsl:call-template name="ListAttributeValues"/>
		</xsl:for-each>;
	</xsl:if>
	<!-- End of the definition of the datatype for VALUES of object attributes  -->


	<!-- This is constant for all inputs, and it defines a datatype for action attributes   -->				
	sort AAtt = struct attribute(name:AAttName, value:AAttValue);
	<!-- End of the definition of the datatype for action attributes  -->


	<!-- Defining a datatype for NAMES of action attributes (this datatype will be populated with all names for action attributes that exist in the input policy )-->			
	<xsl:if test="descendant::*/xacml:AttributeDesignator[not(@AttributeId=../preceding::*/xacml:AttributeDesignator/@AttributeId) and (@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')]">
		sort AAttName = struct 
		<xsl:for-each select = "descendant::*/xacml:AttributeDesignator[not(@AttributeId=../preceding::*/xacml:AttributeDesignator/@AttributeId) and (@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')]">
			<xsl:call-template name="ListAttributeNames"/>
		</xsl:for-each>;
	</xsl:if>		
	<!-- End of the definition of the datatype for NAMES of action attributes  -->


	<!-- Defining a datatype for VALUES of action attributes (this datatype will be populated with all values for action attributes that exist in the input policy )-->				
	<xsl:if test = "(descendant::*/xacml:Match[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:3.0:attribute-category:action')])|(descendant::*/xacml:Apply[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:Apply/xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:3.0:attribute-category:action')])">
		sort AAttValue = struct 
		<xsl:for-each select = "(descendant::*/xacml:Match[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:3.0:attribute-category:action')])|(descendant::*/xacml:Apply[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:Apply/xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:3.0:attribute-category:action')])">
			<xsl:call-template name="ListAttributeValues"/>
		</xsl:for-each>;
	</xsl:if>
	<!-- End of the definition of the datatype for VALUES of action attributes  -->


	<!-- This is constant for all inputs, and it defines a datatype for Decisions   -->						
	sort Decision = struct Permit | Deny;
	<!-- End of the definition of the datatype for Decisions  -->


	<!-- Defining a datatype for Obligations (this datatype will be populated with all Obligation IDs that exist in the input policy )-->						
	<xsl:if test="descendant::*/xacml:ObligationExpression/@ObligationId">
		sort ObgID = struct 
		<xsl:for-each select="descendant::*/xacml:ObligationExpression">
			<xsl:choose>
				<xsl:when test="position() != last()">
					<xsl:call-template name="getName">
						<xsl:with-param name="attname" select="translate(@ObligationId,'-','')"/>
					</xsl:call-template>
					<xsl:value-of select = "$attname"/>|
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="getName">
						<xsl:with-param name="attname" select="translate(@ObligationId,'-','')"/>
					</xsl:call-template>
					<xsl:value-of select = "$attname"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>;
		</xsl:if>		
	<!-- End of the definition of the datatype for Obligations  -->


		
	<!-- Defining a actions. Request and Response actions will be created for all inputs. But the Obligation action will be created only for those inputs that have at least one obligation expression.)-->						
	act
		Request:FSet(SAtt)#FSet(OAtt)#FSet(AAtt);
		<xsl:if test="descendant::*/xacml:ObligationExpression/@ObligationId">
		Obligation:FSet(SAtt)#FSet(OAtt)#FSet(AAtt)#ObgID;
		</xsl:if>		
		Response:FSet(SAtt)#FSet(OAtt)#FSet(AAtt)#Decision;
	<!-- End of the definition of actions  -->


<!-- End of DECLARATION part of the mCRL2 specifications. -->	



		
<!-- Defining PolicySet, Policy, and Rule processes.)-->	
	proc	
	
	<xsl:choose>	
		<!-- If the input has PolicySet, Policy and Rule according to the XACML standard)-->	
		<xsl:when test="(xacml:PolicySet!='')">
			PolicySet_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:PolicySet/@PolicySetId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS:FSet(SAtt), RO:FSet(OAtt), RA:FSet(AAtt)) = 


			<!-- If the policyset has a target, the Target will be translated into an mCRL2 condition in the PolicySet process CHECK this hamed you may specify PolicSet in the select-->		
			<xsl:call-template name="TargetFunction"/> 
			<!-- End of checking/translating the Target of the PolicySet -->
	

			<!-- For every Policy in the PolicySet -->		
			<xsl:for-each select="xacml:PolicySet/xacml:Policy">
				
				<!-- If a Policy in a PolicySet has a target, then the Target of the Policy will be translated into an mCRL2 condition in the parent PolicySet before calling the Policy process -->		
				<xsl:call-template name="TargetFunction"/> 				
			
				<!-- Calling the policies inside a PolicySet -->
				<xsl:if test="position() != last()">			
					Policy_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@PolicyId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS,RO,RA)+	
				</xsl:if>
				<xsl:if test="position() = last()">	
					Policy_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@PolicyId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS,RO,RA);	
				</xsl:if>
			</xsl:for-each>
			
		<!-- End of the definition of the PolicySet process -->
			
			
			
		<!-- Defining a new process for each Policy -->
		<xsl:for-each select = "xacml:PolicySet/xacml:Policy">
		
			Policy_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@PolicyId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS:FSet(SAtt), RO:FSet(OAtt), RA:FSet(AAtt))=	
			
			<!-- For every Rule in the Policy -->		
			<xsl:for-each select = "xacml:Rule">
				
				<!-- If a Rule inside the Policy has a Target, then the Target of the Rule will be translated into an mCRL2 Condition in the parent Policy -->		
				<xsl:call-template name="TargetFunction"/> 
				
			
			<!-- Call Rules inside the parent Policy after their Targets  -->	
				<xsl:if test="position() != last()">
					Rule_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@RuleId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS,RO,RA)+
				</xsl:if> 	
				<xsl:if test="position() = last()">	
					Rule_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@RuleId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS,RO,RA);
				</xsl:if> 
			</xsl:for-each>
		</xsl:for-each>	
		<!-- End of definition of the Policy processes -->
	
	
	
		<!-- Defining a new process for each Rule -->
		<xsl:for-each select = "xacml:PolicySet/xacml:Policy/xacml:Rule">	
		
			Rule_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@RuleId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS:FSet(SAtt), RO:FSet(OAtt), RA:FSet(AAtt))=
			
			<!-- If a Rule has a Condition, then its condition will be translated into an mCRL2 condition inside the Rule process -->
			<xsl:call-template name="ConditionFunction"/>
			
			
			<!-- Adding an mCRL2 action for every obligation expression (if any) of the Rule. -->
			<xsl:call-template name="RuleObligations"/>
			
			<!-- Moving applicable Obligations (if any) from the parent Policy to the Rule. Applicable obligation means Obligation.FulfillOn == Rule.Effect-->
			<xsl:call-template name="PolicyObligations"/>
			
			<!-- Moving applicable Obligations (if any) from the parent PolicySet to the Rule. Applicable obligation means Obligation.FulfillOn == Rule.Effect -->
			<xsl:call-template name="PolicySetObligations"/>
			
			
			Response(RS,RO,RA,<xsl:value-of select="@Effect"/>);
		</xsl:for-each>
		<!-- End of definition of the Rule processes-->



<!-- End of definition of PolicySet, Policy, and Rule processes for normal inputs that include PolicySet, Policy, and Rule)-->

		
<!-- Initialization of the mCRL2 model with different Requests based on different combinations of the attributes that exist in the policies )-->
	init sum RS:FSet(SAtt).sum RO:FSet(OAtt).sum RA:FSet(AAtt).(RS !={} &amp;&amp; RO !={} &amp;&amp; RA !={})-> Request(RS,RO,RA).PolicySet_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:PolicySet/@PolicySetId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS,RO,RA);
	
	</xsl:when>
	
	
<!-- If the input has only Policy and Rule, and does not include a PolicySet)-->
	<xsl:otherwise>
	Policy_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:Policy/@PolicyId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS:FSet(SAtt), RO:FSet(OAtt), RA:FSet(AAtt)) = 
	
	<!-- If a Policy has a target, then the Target of the Policy will be translated into an mCRL2 condition -->		
	<xsl:call-template name="TargetFunction"/>	
	
	
	<!-- For every Rule inside the Policy -->
	<xsl:for-each select = "xacml:Policy/xacml:Rule">
	
		<!-- If a Rule inside the Policy has a Target, then the Target of the Rule will be translated into an mCRL2 Condition in the parent Policy -->		
		<xsl:call-template name="TargetFunction"/>
		
		
		<!-- Call Rules inside the parent Policy after their Targets  -->	
		<xsl:if test="position() != last()">
			Rule_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@RuleId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS,RO,RA)+
		</xsl:if> 	
		<xsl:if test="position() = last()">	
			Rule_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@RuleId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS,RO,RA);
		</xsl:if> 
	</xsl:for-each>	
	<!-- End of definition of the Policy processes -->	

		
		
	<!-- Defining a new process for each Rule -->
	<xsl:for-each select = "xacml:Policy/xacml:Rule">	
	
		Rule_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@RuleId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS:FSet(SAtt), RO:FSet(OAtt), RA:FSet(AAtt))=
		
		<!-- If a Rule has a Condition, then its condition will be translated into an mCRL2 condition inside the Rule process -->
		<xsl:call-template name="ConditionFunction"/>
		

		<!-- Adding an mCRL2 action for every obligation expression of the Rule. -->
		<xsl:call-template name="RuleObligations"/>
		
		<!-- Moving applicable Obligations from the parent Policy to the Rule. -->
		<xsl:call-template name="PolicyObligations"/>
		

		Response(RS,RO,RA,<xsl:value-of select="@Effect"/>);
	</xsl:for-each>
	<!-- End of definition of the Rule processes-->

<!-- End of definition of PolicySet, Policy, and Rule processes for inputs that do not include a PolicySet)-->
		
		
		
<!-- Initialization of the mCRL2 model with different Requests based on different combinations of the attributes that exist in the policies. This is for inputs that do not include a PolicySet )-->
	init sum RS:FSet(SAtt).sum RO:FSet(OAtt).sum RA:FSet(AAtt).(RS !={} &amp;&amp; RO !={} &amp;&amp; RA !={})-> Request(RS,RO,RA).Policy_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:Policy/@PolicyId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS,RO,RA);
	</xsl:otherwise>
	</xsl:choose>
	<!-- End of "If the input has only Policy and Rule, and does not include a PolicySet" -->

<!-- End of defining PolicySet, Policy, and Rule processes.)-->	

</xsl:template>
</xsl:stylesheet>