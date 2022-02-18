<xsl:stylesheet version = "1.0" xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"> 
	<xsl:output method="text"/>
	<xsl:template match = "/">
		sort SAttribute = struct attribute(name:SAttName, value:SAttValue);

		sort SAttName = struct subjectid;
		
		sort SAttValue = struct CareGiverA|Doctor;
		
		sort OAttribute = struct attribute(name:OAttName, value:OAttValue);

		sort OAttName = struct resourceid;
		
		sort OAttValue = struct HealthData;
		
		sort AAttribute = struct attribute(name:AAttName, value:AAttValue);

		sort AAttName = struct actionid;
		
		sort AAttValue = struct Read;
		
		sort Decision = struct Permit | Deny;
		
		sort ObgID = struct email | log;

		act
		Request:Set(SAttribute)#Set(OAttribute)#Set(AAttribute);
		Obligation:Set(SAttribute)#Set(OAttribute)#Set(AAttribute)#ObgID;
		Response:Set(SAttribute)#Set(OAttribute)#Set(AAttribute)#Decision;
		
		
		proc		
			PolicySet_<xsl:value-of select="PolicySet/@PolicySetId"/>(RS:Set(SAttribute), RO:Set(OAttribute), RA:Set(AAttribute)) = Request(RS,RO,RA).
		<xsl:if test="(PolicySet/Target!='')">
			(<xsl:value-of select = "PolicySet/Target"/>)->	
		</xsl:if> 
		<xsl:for-each select = "PolicySet/Policy">
		<!-- Check if the policy has a target -->		
			<xsl:if test="(Target!='')">
				(
			<xsl:for-each select = "Target/AnyOf/AllOf">
			<xsl:choose>	
			<xsl:when test="position() != last()">
				<xsl:for-each select = "Match">
					<xsl:choose>	
					<xsl:when test="position() != last()">
						(attribute(<xsl:value-of select = "translate(AttributeDesignator/@AttributeId,'-','')"/>,<xsl:value-of select = "AttributeValue"/>) in 
						<xsl:choose>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
								RA) &amp;&amp;
							</xsl:when>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
								RO) &amp;&amp;
							</xsl:when>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
								RS) &amp;&amp;
							</xsl:when>
							<xsl:otherwise>
								RE) &amp;&amp;
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>	
					<xsl:otherwise>	
						(attribute(<xsl:value-of select = "translate(AttributeDesignator/@AttributeId,'-','')"/>,<xsl:value-of select = "AttributeValue"/>) in 
						<xsl:choose>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
								RA)
							</xsl:when>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
								RO)
							</xsl:when>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
								RS)
							</xsl:when>
							<xsl:otherwise>
								RE)
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>	
					</xsl:choose>	
				</xsl:for-each>
				||
			</xsl:when>
			<xsl:otherwise>
			<xsl:for-each select = "Match">
					<xsl:choose>	
					<xsl:when test="position() != last()">
						(attribute(<xsl:value-of select = "translate(AttributeDesignator/@AttributeId,'-','')"/>,<xsl:value-of select = "AttributeValue"/>) in 
						<xsl:choose>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
								RA) &amp;&amp;
							</xsl:when>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
								RO) &amp;&amp;
							</xsl:when>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
								RS) &amp;&amp;
							</xsl:when>
							<xsl:otherwise>
								RE) &amp;&amp;
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>	
					<xsl:otherwise>	
						(attribute(<xsl:value-of select = "translate(AttributeDesignator/@AttributeId,'-','')"/>,<xsl:value-of select = "AttributeValue"/>) in 
						<xsl:choose>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
								RA)
							</xsl:when>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
								RO)
							</xsl:when>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
								RS)
							</xsl:when>
							<xsl:otherwise>
								RE)
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>	
					</xsl:choose>	
				</xsl:for-each>
			</xsl:otherwise>
			</xsl:choose>			
			</xsl:for-each>
				)->	
			</xsl:if>	
		<!-- End of checking if the policy has a target -->
		<!-- Calling the policies inside a policyset -->
			<xsl:if test="position() != last()">	
				Policy_<xsl:value-of select="@PolicyId"/>(RS,RO,RA)+	
			</xsl:if>
			<xsl:if test="position() = last()">	
				Policy_<xsl:value-of select="@PolicyId"/>(RS,RO,RA);	
			</xsl:if>
		</xsl:for-each>
		<!-- End of calling policies inside a policyset -->
			
		<!-- Defining a new process for each policy -->
		<xsl:for-each select = "PolicySet/Policy">
			Policy_<xsl:value-of select="@PolicyId"/>(RS:Set(SAttribute), RO:Set(OAttribute), RA:Set(AAttribute))=	
			<xsl:for-each select = "Rule">
			<!-- Check if the rule has a target -->		
				<xsl:if test="(Target!='')">				
				(	
			<xsl:for-each select = "Target/AnyOf/AllOf">
			<xsl:choose>	
			<xsl:when test="position() != last()">
				<xsl:for-each select = "Match">	
						<xsl:choose>
						<xsl:when test="position() != last()">	
							(attribute(<xsl:value-of select = "translate(AttributeDesignator/@AttributeId,'-','')"/>,<xsl:value-of select = "AttributeValue"/>) in 
							<xsl:choose>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
								RA) &amp;&amp;
							</xsl:when>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
								RO) &amp;&amp;
							</xsl:when>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
								RS) &amp;&amp;
							</xsl:when>
							<xsl:otherwise>
								RE) &amp;&amp;
							</xsl:otherwise>
							</xsl:choose>
						</xsl:when>	
						<xsl:otherwise>	
							(attribute(<xsl:value-of select = "translate(AttributeDesignator/@AttributeId,'-','')"/>,<xsl:value-of select = "AttributeValue"/>) in 
							<xsl:choose>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
								RA) 
							</xsl:when>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
								RO) 
							</xsl:when>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
								RS) 
							</xsl:when>
							<xsl:otherwise>
								RE) 
							</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>					
				||
			</xsl:when>
			<xsl:otherwise>
			<xsl:for-each select = "Match">	
						<xsl:choose>
						<xsl:when test="position() != last()">	
							(attribute(<xsl:value-of select = "translate(AttributeDesignator/@AttributeId,'-','')"/>,<xsl:value-of select = "AttributeValue"/>) in 
							<xsl:choose>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
								RA) &amp;&amp;
							</xsl:when>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
								RO) &amp;&amp;
							</xsl:when>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
								RS) &amp;&amp;
							</xsl:when>
							<xsl:otherwise>
								RE) &amp;&amp;
							</xsl:otherwise>
							</xsl:choose>
						</xsl:when>	
						<xsl:otherwise>	
							(attribute(<xsl:value-of select = "translate(AttributeDesignator/@AttributeId,'-','')"/>,<xsl:value-of select = "AttributeValue"/>) in 
							<xsl:choose>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
								RA) 
							</xsl:when>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
								RO) 
							</xsl:when>
							<xsl:when test="(AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
								RS) 
							</xsl:when>
							<xsl:otherwise>
								RE) 
							</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
			</xsl:otherwise>
			</xsl:choose>			
			</xsl:for-each>
				)->				
				</xsl:if>	
				<xsl:if test="position() != last()">
					Rule_<xsl:value-of select="@RuleId"/>(RS,RO,RA)+
				</xsl:if> 	
				<xsl:if test="position() = last()">	
					Rule_<xsl:value-of select="@RuleId"/>(RS,RO,RA);
				</xsl:if> 	
			</xsl:for-each>
		</xsl:for-each>	
			
		<!-- Defining a new process for each Rule -->
		<xsl:for-each select = "PolicySet/Policy/Rule">	
			Rule_<xsl:value-of select="@RuleId"/>(RS:Set(SAttribute), RO:Set(OAttribute), RA:Set(AAttribute))=
			<xsl:if test="(Condition!='')">	
				<xsl:choose>
					<xsl:when test="not(Condition/Apply/AttributeDesignator/@AttributeId)">
						<xsl:if test="(Condition/Apply/@FunctionId='urn:oasis:names:tc:xacml:1.0:function:not')">
							!(attribute(<xsl:value-of select = "translate(Condition/Apply/Apply/AttributeDesignator/@AttributeId,'-','')"/>,<xsl:value-of select = "Condition/Apply/Apply/Apply/AttributeValue"/>) in 
							<xsl:choose>
								<xsl:when test="(Condition/Apply/Apply/AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
								RA)->
								</xsl:when>
								<xsl:when test="(Condition/Apply/Apply/AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
								RO)-> 
								</xsl:when>
								<xsl:when test="(Condition/Apply/Apply/AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
								RS)-> 
								</xsl:when>
								<xsl:otherwise>
								RE)-> 
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
					(attribute(<xsl:value-of select = "translate(Condition/Apply/AttributeDesignator/@AttributeId,'-','')"/>,<xsl:value-of select = "Condition/Apply/Apply/AttributeValue"/>) in 
					<xsl:choose>
						<xsl:when test="(Condition/Apply/AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
						RA)->
						</xsl:when>
						<xsl:when test="(Condition/Apply/AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
						RO)-> 
						</xsl:when>
						<xsl:when test="(Condition/Apply/AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
						RS)-> 
						</xsl:when>
						<xsl:otherwise>
						RE)-> 
						</xsl:otherwise>
					</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="((../../ObligationExpressions/ObligationExpression/@ObligationId!='') and (@Effect =../../ObligationExpressions/ObligationExpression/@FulfillOn))">
					<xsl:for-each select = "../../ObligationExpressions/ObligationExpression">	
					Obligation(RS,RO,RA,<xsl:value-of select="@ObligationId"/>).
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="((../ObligationExpressions/ObligationExpression/@ObligationId!='') and (@Effect =../ObligationExpressions/ObligationExpression/@FulfillOn))">
					<xsl:for-each select = "../ObligationExpressions/ObligationExpression">	
						Obligation(RS,RO,RA,<xsl:value-of select="@ObligationId"/>).
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="((ObligationExpressions/ObligationExpression/@ObligationId!='') and (@Effect =ObligationExpressions/ObligationExpression/@FulfillOn))">
					<xsl:for-each select = "ObligationExpressions/ObligationExpression">	
						Obligation(RS,RO,RA,<xsl:value-of select="@ObligationId"/>).
					</xsl:for-each>	
				</xsl:when>
			</xsl:choose>
			Response(RS,RO,RA,<xsl:value-of select="@Effect"/>);
		</xsl:for-each>
			
		init sum RS:Set(SAttribute).sum RO:Set(OAttribute).sum RA:Set(AAttribute).(RS !={} &amp;&amp; RO !={} &amp;&amp; RA !={})->PolicySet_<xsl:value-of select="PolicySet/@PolicySetId"/>(RS,RO,RA);
	</xsl:template>
</xsl:stylesheet>