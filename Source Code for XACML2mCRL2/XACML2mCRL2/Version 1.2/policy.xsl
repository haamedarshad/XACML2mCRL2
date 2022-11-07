<xsl:stylesheet version = "1.0" xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" xmlns:xacml="urn:oasis:names:tc:xacml:3.0:core:schema:wd-17" > 
	<xsl:output method="text" indent="no"/>
      <xsl:strip-space elements="*"/>
  
<!-- This block removes the unnecessary part of attribute names. For example, "actionid" will be returned instead of "urn:oasis:names:tc:xacml:1.0:action:action-id"   -->
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
<!-- End of the block for trimming attribute names -->
			
	<xsl:template match = "/">	  

	<xsl:param name="attname"/>

<!-- This is constant for all inputs, and it defines a datatype for subject attributes   -->	
		sort SAtt = struct attribute(name:SAttName, value:SAttValue);
<!-- End of the definition of the datatype for subject attributes  -->

<!-- Defining a datatype for NAMES of subject attributes (this datatype will be populated with all names for subject attributes that exist in the input policy )-->	
		<xsl:if test="descendant::*/xacml:AttributeDesignator[not(@AttributeId=../preceding::*/xacml:AttributeDesignator/@AttributeId) and (@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')]">
		sort SAttName = struct 
		<xsl:for-each select = "descendant::*/xacml:AttributeDesignator[not(@AttributeId=../preceding::*/xacml:AttributeDesignator/@AttributeId) and (@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')]">
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
		</xsl:for-each>;
		</xsl:if>
<!-- End of the definition of the datatype for NAMES of subject attributes  -->

<!-- Defining a datatype for VALUES of subject attributes (this datatype will be populated with all values for subject attributes that exist in the input policy )-->			
		<xsl:if test = "(descendant::*/xacml:Match[not(AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')])|(descendant::*/xacml:Apply[not(AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:Apply/xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')])">
		sort SAttValue = struct 
		<xsl:for-each select = "(descendant::*/xacml:Match[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')])|(descendant::*/xacml:Apply[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:Apply/xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')])">
			<xsl:choose>
				<xsl:when test="position() != last()">
					<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>|
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>
				</xsl:otherwise>
			</xsl:choose>
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
		</xsl:for-each>;
		</xsl:if>		
<!-- End of the definition of the datatype for NAMES of object attributes  -->

<!-- Defining a datatype for VALUES of object attributes (this datatype will be populated with all values for object attributes that exist in the input policy )-->			
		<xsl:if test = "(descendant::*/xacml:Match[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')])|(descendant::*/xacml:Apply[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:Apply/xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')])">
		sort OAttValue = struct 
		<xsl:for-each select = "(descendant::*/xacml:Match[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')])|(descendant::*/xacml:Apply[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:Apply/xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')])">
			<xsl:choose>
				<xsl:when test="position() != last()">
					<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>|
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>
				</xsl:otherwise>
			</xsl:choose>
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
		</xsl:for-each>;
		</xsl:if>		
<!-- End of the definition of the datatype for NAMES of action attributes  -->

<!-- Defining a datatype for VALUES of action attributes (this datatype will be populated with all values for action attributes that exist in the input policy )-->				
		<xsl:if test = "(descendant::*/xacml:Match[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:3.0:attribute-category:action')])|(descendant::*/xacml:Apply[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:Apply/xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:3.0:attribute-category:action')])">
		sort AAttValue = struct 
		<xsl:for-each select = "(descendant::*/xacml:Match[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:3.0:attribute-category:action')])|(descendant::*/xacml:Apply[not(xacml:AttributeValue=preceding::*/xacml:AttributeValue) and (xacml:Apply/xacml:AttributeDesignator/@Category ='urn:oasis:names:tc:xacml:3.0:attribute-category:action')])">
			<xsl:choose>
				<xsl:when test="position() != last()">
					<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>|
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>
				</xsl:otherwise>
			</xsl:choose>
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
		
<!-- Defining PolicySet, Policy, and Rule processes.)-->	
<!--	<xsl:template match="xacml:PolicySet"> -->
		proc	
		<xsl:choose>	
		<xsl:when test="(xacml:PolicySet!='')">
			PolicySet_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:PolicySet/@PolicySetId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS:FSet(SAtt), RO:FSet(OAtt), RA:FSet(AAtt)) = 
		<!-- If the policyset has a target, the Target will be translated into an mCRL2 condition in the PolicySet process -->		
		<xsl:if test="(xacml:PolicySet/xacml:Target!='')">
			(
			<xsl:for-each select = "xacml:PolicySet/xacml:Target/xacml:AnyOf/xacml:AllOf">
			<xsl:choose>	
			<xsl:when test="position() != last()">
				<xsl:for-each select = "xacml:Match">
					<xsl:choose>	
					<xsl:when test="position() != last()">
						(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
						<xsl:choose>
							<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
								RA) &amp;&amp;
							</xsl:when>
							<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
								RO) &amp;&amp;
							</xsl:when>
							<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
								RS) &amp;&amp;
							</xsl:when>
							<xsl:otherwise>
								RE) &amp;&amp;
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>	
					<xsl:otherwise>	
						(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>,<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
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
					</xsl:otherwise>	
					</xsl:choose>	
				</xsl:for-each>
				||
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select = "xacml:Match">
					<xsl:choose>	
						<xsl:when test="position() != last()">
							(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>,<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
							<xsl:choose>
								<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
									RA) &amp;&amp;
								</xsl:when>
								<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
									RO) &amp;&amp;
								</xsl:when>
								<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
									RS) &amp;&amp;
								</xsl:when>
								<xsl:otherwise>
									RE) &amp;&amp;
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>	
						<xsl:otherwise>	
							(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>,<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
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
						</xsl:otherwise>	
					</xsl:choose>	
				</xsl:for-each>
			</xsl:otherwise>
			</xsl:choose>			
			</xsl:for-each>			
			)->	
		</xsl:if> 
		<!-- End of checking/translating the Target of the PolicySet -->
	
		<xsl:for-each select="xacml:PolicySet/xacml:Policy">
		<!-- If a Policy in a PolicySet has a target, then the Target of the Policy will be translated into an mCRL2 condition in the parent PolicySet before calling the Policy process -->		
			<xsl:if test="(xacml:Target!='')">
			(
			<xsl:for-each select = "xacml:Target/xacml:AnyOf/xacml:AllOf">
			<xsl:choose>	
			<xsl:when test="position() != last()">
			(
				<xsl:for-each select = "xacml:Match">
					<xsl:choose>	
					<xsl:when test="position() != last()">
						(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
						<xsl:choose>
							<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
								RA) &amp;&amp;
							</xsl:when>
							<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
								RO) &amp;&amp;
							</xsl:when>
							<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
								RS) &amp;&amp;
							</xsl:when>
							<xsl:otherwise>
								RE) &amp;&amp;
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>	
					<xsl:otherwise>	
						(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>,<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
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
					</xsl:otherwise>	
					</xsl:choose>		
				</xsl:for-each>
			)	
				||
			</xsl:when>
			<xsl:otherwise>
			(
				<xsl:for-each select = "xacml:Match">
					<xsl:choose>	
						<xsl:when test="position() != last()">
							(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>,<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
							<xsl:choose>
								<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
									RA) &amp;&amp;
								</xsl:when>
								<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
									RO) &amp;&amp;
								</xsl:when>
								<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
									RS) &amp;&amp;
								</xsl:when>
								<xsl:otherwise>
									RE) &amp;&amp;
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>	
						<xsl:otherwise>	
							(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>,<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
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
						</xsl:otherwise>	
					</xsl:choose>	
				</xsl:for-each>
			)	
			</xsl:otherwise>
			</xsl:choose>			
			</xsl:for-each>
			)->	
			</xsl:if>	
		<!-- End of checking/translating the Target of the Policy  -->
		<!-- Calling the policies inside a PolicySet -->
			<xsl:if test="position() != last()">			
				Policy_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@PolicyId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS,RO,RA)+	
			</xsl:if>
			<xsl:if test="position() = last()">	
				Policy_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@PolicyId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS,RO,RA);	
			</xsl:if>
		</xsl:for-each>
		<!-- End of calling Policies inside a PolicySet -->
			
		<!-- Defining a new process for each Policy -->
		<xsl:for-each select = "xacml:PolicySet/xacml:Policy">
			Policy_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@PolicyId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS:FSet(SAtt), RO:FSet(OAtt), RA:FSet(AAtt))=	
			<xsl:for-each select = "xacml:Rule">
			<!-- If a Rule inside a Policy has a Target, then the Target of the Rule will be translated into an mCRL2 Condition in the parent Policy -->		
				<xsl:if test="(xacml:Target!='')">				
				(	
					<xsl:for-each select = "xacml:Target/xacml:AnyOf/xacml:AllOf">
						<xsl:choose>	
							<xsl:when test="position() != last()">
					(
								<xsl:for-each select = "xacml:Match">	
									<xsl:choose>
									<xsl:when test="position() != last()">	
										(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>,<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
										<xsl:choose>
										<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
											RA) &amp;&amp;
										</xsl:when>
										<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
											RO) &amp;&amp;
										</xsl:when>
										<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
											RS) &amp;&amp;
										</xsl:when>
										<xsl:otherwise>
											RE) &amp;&amp;
										</xsl:otherwise>
										</xsl:choose>
									</xsl:when>	
									<xsl:otherwise>	
										(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
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
									</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>	
						)			
							||
						</xsl:when>
						<xsl:otherwise>
						(
						<xsl:for-each select = "xacml:Match">	
									<xsl:choose>
									<xsl:when test="position() != last()">	
										(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>,<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
										<xsl:choose>
										<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
											RA) &amp;&amp;
										</xsl:when>
										<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
											RO) &amp;&amp;
										</xsl:when>
										<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
											RS) &amp;&amp;
										</xsl:when>
										<xsl:otherwise>
											RE) &amp;&amp;
										</xsl:otherwise>
										</xsl:choose>
									</xsl:when>	
									<xsl:otherwise>	
										(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>,<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
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
									</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
						)		
						</xsl:otherwise>
						</xsl:choose>			
					</xsl:for-each>
				)->				
				</xsl:if>
				<!-- End of translating the Target of Rules -->	
				<!-- Call Rules inside the parent Policy after their Targets  -->	
				<xsl:if test="position() != last()">
					Rule_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@RuleId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS,RO,RA)+
				</xsl:if> 	
				<xsl:if test="position() = last()">	
					Rule_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@RuleId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS,RO,RA);
				</xsl:if> 
				<!-- End of calling Rules inside the parent Policy after their Targets  -->					
			</xsl:for-each>
		</xsl:for-each>	
		<!-- End of definition of the Policy processes -->
	
		<!-- Defining a new process for each Rule -->
		<xsl:for-each select = "xacml:PolicySet/xacml:Policy/xacml:Rule">	
			Rule_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@RuleId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS:FSet(SAtt), RO:FSet(OAtt), RA:FSet(AAtt))=
			<!-- If a Rule has a Condition, then its condition will be translated into an mCRL2 condition inside the Rule process -->
			<xsl:if test="(xacml:Condition!='')">    
			<!-- There is a condition -->
				<xsl:choose>
					<xsl:when test="not(xacml:Condition/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@AttributeId)">
					<!-- There is a NOT, AND, OR  -->   
						<xsl:choose>
							<xsl:when test="(xacml:Condition/xacml:Apply/@FunctionId='urn:oasis:names:tc:xacml:1.0:function:not')">
							<!-- There is a NOT --> 
								<xsl:if test="xacml:Condition/xacml:Apply/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@AttributeId !=''">
									!(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:Condition/xacml:Apply/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@AttributeId,'- :/.','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(xacml:Condition/xacml:Apply/xacml:Apply/xacml:AttributeValue,'- :/.','')"/>) in 
									<xsl:choose>
										<xsl:when test="(xacml:Condition/xacml:Apply/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
											RA)->
										</xsl:when>
										<xsl:when test="(xacml:Condition/xacml:Apply/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
											RO)-> 
										</xsl:when>
										<xsl:when test="(xacml:Condition/xacml:Apply/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
											RS)-> 
										</xsl:when>
										<xsl:otherwise>
											RE)-> 
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:when>
							<xsl:when test="(xacml:Condition/xacml:Apply/@FunctionId='urn:oasis:names:tc:xacml:1.0:function:and')">
							<!-- There is an AND --> 
								(
								<xsl:for-each select = "xacml:Condition/xacml:Apply/xacml:Apply/xacml:Apply/xacml:AttributeDesignator">        
									<xsl:if test="position() != last()">
										(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(../../xacml:AttributeValue,'- :/.','')"/>) in 
										<xsl:choose>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
												RA) &amp;&amp;
											</xsl:when>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
												RO) &amp;&amp;
											</xsl:when>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
												RS) &amp;&amp;
											</xsl:when>
											<xsl:otherwise>
												RE) &amp;&amp;
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
									<xsl:if test="position() = last()">
										(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(../../xacml:AttributeValue,'- :/.','')"/>) in 
										<xsl:choose>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
												RA) 
											</xsl:when>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
												RO) 
											</xsl:when>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
												RS) 
											</xsl:when>
											<xsl:otherwise>
												RE) 
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:for-each>    
								)->
							</xsl:when>
							<!-- End of AND Condition --> 
							<xsl:when test="(xacml:Condition/xacml:Apply/@FunctionId='urn:oasis:names:tc:xacml:1.0:function:or')">
							<!-- There is an OR --> 
								(
								<xsl:for-each select = "xacml:Condition/xacml:Apply/xacml:Apply/xacml:Apply/xacml:AttributeDesignator">        
									<xsl:if test="position() != last()">
										(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(../../xacml:AttributeValue,'- :/.','')"/>) in 
										<xsl:choose>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
												RA) ||
											</xsl:when>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
												RO) ||
											</xsl:when>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
												RS) ||
											</xsl:when>
											<xsl:otherwise>
												RE) ||
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
									<xsl:if test="position() = last()">
										(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(../../xacml:AttributeValue,'- :/.','')"/>) in 
										<xsl:choose>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
												RA) 
											</xsl:when>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
												RO) 
											</xsl:when>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
												RS) 
											</xsl:when>
											<xsl:otherwise>
												RE) 
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:for-each>    
								)->
							</xsl:when>
							<!-- End of OR Condition --> 
						</xsl:choose>
						<!-- End of "There is a NOT, AND, OR" -->   
					</xsl:when>	
					<xsl:when test="(xacml:Condition/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@AttributeId)">
					<!-- There is no NOT, AND, and OR. There exists only one attribute in the Condition part of the Rule --> 
						(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:Condition/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(xacml:Condition/xacml:Apply/xacml:AttributeValue,'- :/.','')"/>) in 
						<xsl:choose>
							<xsl:when test="(xacml:Condition/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
								RA)->
							</xsl:when>
							<xsl:when test="(xacml:Condition/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
								RO)->
							</xsl:when>
							<xsl:when test="(xacml:Condition/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
								RS)->
							</xsl:when>
							<xsl:otherwise>
								RE)->
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>    
					<!-- End of "There is only one attribute in the Condition part of the Rule" -->   
				</xsl:choose>        
			</xsl:if>
			<!-- End of translating the CONDITION part of each Rule -->
			<!-- Cehcking and translating the Obligations inside a PolicySet. Obligations will be moved to the applicable Rules (i.e., Obligation.FulfillOn == Rule.Effect) from the PolicySet and Policy levels. I.e., An mCRL2 action will be generated for every Obligation  -->
			<xsl:choose>
				<!-- Moving applicable Obligations (i.e., Obligation.FulfillOn == Rule.Effect) from the parent PolicySet to the Rule. -->
				<xsl:when test="((../../xacml:ObligationExpressions/xacml:ObligationExpression/@ObligationId!='') and (@Effect =../../xacml:ObligationExpressions/xacml:ObligationExpression/@FulfillOn))">
					<xsl:for-each select = "../../xacml:ObligationExpressions/xacml:ObligationExpression">	
					Obligation(RS,RO,RA,<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@ObligationId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>).
					</xsl:for-each>
				</xsl:when>
				<!-- End of moving applicable Obligations from the parent PolicySet to the Rule. -->
				<!-- Moving applicable Obligations from the parent Policy to the Rule. -->
				<xsl:when test="((../xacml:ObligationExpressions/xacml:ObligationExpression/@ObligationId!='') and (@Effect =../xacml:ObligationExpressions/xacml:ObligationExpression/@FulfillOn))">
					<xsl:for-each select = "../xacml:ObligationExpressions/xacml:ObligationExpression">	
						Obligation(RS,RO,RA,<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@ObligationId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>).
					</xsl:for-each>
				</xsl:when>
				<!-- End of moving applicable Obligations from the parent Policy to the Rule. -->
				<!-- Adding an mCRL2 action for Obligations of the Rule. -->
				<xsl:when test="((xacml:ObligationExpressions/xacml:ObligationExpression/@ObligationId!='') and (@Effect =xacml:ObligationExpressions/xacml:ObligationExpression/@FulfillOn))">
					<xsl:for-each select = "xacml:ObligationExpressions/xacml:ObligationExpression">	
						Obligation(RS,RO,RA,<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@ObligationId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>).
					</xsl:for-each>	
				</xsl:when>
				<!-- End of adding obligation actions inside Rule. -->
			</xsl:choose>
			<!-- End of Cehcking and translating the Obligations inside a PolicySet -->
			Response(RS,RO,RA,<xsl:value-of select="@Effect"/>);
		</xsl:for-each>
		<!-- End of definition of the Rule processes-->

		<!-- End of definition of PolicySet, Policy, and Rule processes.)-->
		<!-- Initialization of the mCRL2 model with different Requests based on different combinations of the attributes that exist in the policies )-->
		init sum RS:FSet(SAtt).sum RO:FSet(OAtt).sum RA:FSet(AAtt).(RS !={} &amp;&amp; RO !={} &amp;&amp; RA !={})-> Request(RS,RO,RA).PolicySet_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:PolicySet/@PolicySetId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS,RO,RA);
	</xsl:when>

<!-- If the input has only Policy Rule and does not include a PolicySet)-->
	<xsl:otherwise>

Policy_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:Policy/@PolicyId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS:FSet(SAtt), RO:FSet(OAtt), RA:FSet(AAtt)) = 
		
		<!-- If a Policy has a target, then the Target of the Policy will be translated into an mCRL2 condition -->		
			<xsl:if test="(xacml:Target!='')">
			(
			<xsl:for-each select = "xacml:Target/xacml:AnyOf/xacml:AllOf">
			<xsl:choose>	
			<xsl:when test="position() != last()">
			(
				<xsl:for-each select = "xacml:Match">
					<xsl:choose>	
					<xsl:when test="position() != last()">
						(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
						<xsl:choose>
							<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
								RA) &amp;&amp;
							</xsl:when>
							<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
								RO) &amp;&amp;
							</xsl:when>
							<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
								RS) &amp;&amp;
							</xsl:when>
							<xsl:otherwise>
								RE) &amp;&amp;
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>	
					<xsl:otherwise>	
						(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>,<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
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
					</xsl:otherwise>	
					</xsl:choose>		
				</xsl:for-each>
			)	
				||
			</xsl:when>
			<xsl:otherwise>
			(
				<xsl:for-each select = "xacml:Match">
					<xsl:choose>	
						<xsl:when test="position() != last()">
							(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>,<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
							<xsl:choose>
								<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
									RA) &amp;&amp;
								</xsl:when>
								<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
									RO) &amp;&amp;
								</xsl:when>
								<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
									RS) &amp;&amp;
								</xsl:when>
								<xsl:otherwise>
									RE) &amp;&amp;
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>	
						<xsl:otherwise>	
							(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>,<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
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
						</xsl:otherwise>	
					</xsl:choose>	
				</xsl:for-each>
			)	
			</xsl:otherwise>
			</xsl:choose>			
			</xsl:for-each>
			)->	
			</xsl:if>	
		<!-- End of checking/translating the Target of the Policy  -->
		<!-- Calling the policies inside a PolicySet -->
		<xsl:for-each select = "xacml:Policy/xacml:Rule">
			<!-- If a Rule inside a Policy has a Target, then the Target of the Rule will be translated into an mCRL2 Condition in the parent Policy -->		
				<xsl:if test="(xacml:Target!='')">				
				(	
					<xsl:for-each select = "xacml:Target/xacml:AnyOf/xacml:AllOf">
						<xsl:choose>	
							<xsl:when test="position() != last()">
					(
								<xsl:for-each select = "xacml:Match">	
									<xsl:choose>
									<xsl:when test="position() != last()">	
										(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>,<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
										<xsl:choose>
										<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
											RA) &amp;&amp;
										</xsl:when>
										<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
											RO) &amp;&amp;
										</xsl:when>
										<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
											RS) &amp;&amp;
										</xsl:when>
										<xsl:otherwise>
											RE) &amp;&amp;
										</xsl:otherwise>
										</xsl:choose>
									</xsl:when>	
									<xsl:otherwise>	
										(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
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
									</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>	
						)			
							||
						</xsl:when>
						<xsl:otherwise>
						(
						<xsl:for-each select = "xacml:Match">	
									<xsl:choose>
									<xsl:when test="position() != last()">	
										(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>,<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
										<xsl:choose>
										<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
											RA) &amp;&amp;
										</xsl:when>
										<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
											RO) &amp;&amp;
										</xsl:when>
										<xsl:when test="(xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
											RS) &amp;&amp;
										</xsl:when>
										<xsl:otherwise>
											RE) &amp;&amp;
										</xsl:otherwise>
										</xsl:choose>
									</xsl:when>	
									<xsl:otherwise>	
										(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>,<xsl:value-of select = "translate(xacml:AttributeValue,'- :/.','')"/>) in 
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
									</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
						)		
						</xsl:otherwise>
						</xsl:choose>			
					</xsl:for-each>
				)->				
				</xsl:if>
				<!-- End of translating the Target of Rules -->	
				<!-- Call Rules inside the parent Policy after their Targets  -->	
				<xsl:if test="position() != last()">
					Rule_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@RuleId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS,RO,RA)+
				</xsl:if> 	
				<xsl:if test="position() = last()">	
					Rule_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@RuleId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS,RO,RA);
				</xsl:if> 
				<!-- End of calling Rules inside the parent Policy after their Targets  -->					
			</xsl:for-each>

	
		<!-- Defining a new process for each Rule -->
		<xsl:for-each select = "xacml:Policy/xacml:Rule">	
			Rule_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@RuleId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS:FSet(SAtt), RO:FSet(OAtt), RA:FSet(AAtt))=
			<!-- If a Rule has a Condition, then its condition will be translated into an mCRL2 condition inside the Rule process -->
			<xsl:if test="(xacml:Condition!='')">    
			<!-- There is a condition -->
				<xsl:choose>
					<xsl:when test="not(xacml:Condition/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@AttributeId)">
					<!-- There is a NOT, AND, OR  -->   
						<xsl:choose>
							<xsl:when test="(xacml:Condition/xacml:Apply/@FunctionId='urn:oasis:names:tc:xacml:1.0:function:not')">
							<!-- There is a NOT --> 
								<xsl:if test="xacml:Condition/xacml:Apply/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@AttributeId !=''">
									!(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:Condition/xacml:Apply/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(xacml:Condition/xacml:Apply/xacml:Apply/xacml:AttributeValue,'- :/.','')"/>) in 
									<xsl:choose>
										<xsl:when test="(xacml:Condition/xacml:Apply/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
											RA)->
										</xsl:when>
										<xsl:when test="(xacml:Condition/xacml:Apply/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
											RO)-> 
										</xsl:when>
										<xsl:when test="(xacml:Condition/xacml:Apply/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
											RS)-> 
										</xsl:when>
										<xsl:otherwise>
											RE)-> 
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:when>
							<xsl:when test="(xacml:Condition/xacml:Apply/@FunctionId='urn:oasis:names:tc:xacml:1.0:function:and')">
							<!-- There is an AND --> 
								(
								<xsl:for-each select = "xacml:Condition/xacml:Apply/xacml:Apply/xacml:Apply/xacml:AttributeDesignator">        
									<xsl:if test="position() != last()">
										(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(../../xacml:AttributeValue,'- :/.','')"/>) in 
										<xsl:choose>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
												RA) &amp;&amp;
											</xsl:when>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
												RO) &amp;&amp;
											</xsl:when>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
												RS) &amp;&amp;
											</xsl:when>
											<xsl:otherwise>
												RE) &amp;&amp;
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
									<xsl:if test="position() = last()">
										(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(../../xacml:AttributeValue,'- :/.','')"/>) in 
										<xsl:choose>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
												RA) 
											</xsl:when>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
												RO) 
											</xsl:when>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
												RS) 
											</xsl:when>
											<xsl:otherwise>
												RE) 
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:for-each>    
								)->
							</xsl:when>
							<!-- End of AND Condition --> 
							<xsl:when test="(xacml:Condition/xacml:Apply/@FunctionId='urn:oasis:names:tc:xacml:1.0:function:or')">
							<!-- There is an OR --> 
								(
								<xsl:for-each select = "xacml:Condition/xacml:Apply/xacml:Apply/xacml:Apply/xacml:AttributeDesignator">        
									<xsl:if test="position() != last()">
										(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(../../xacml:AttributeValue,'- :/.','')"/>) in 
										<xsl:choose>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
												RA) ||
											</xsl:when>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
												RO) ||
											</xsl:when>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
												RS) ||
											</xsl:when>
											<xsl:otherwise>
												RE) ||
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
									<xsl:if test="position() = last()">
										(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(../../xacml:AttributeValue,'- :/.','')"/>) in 
										<xsl:choose>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
												RA) 
											</xsl:when>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
												RO) 
											</xsl:when>
											<xsl:when test="(@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
												RS) 
											</xsl:when>
											<xsl:otherwise>
												RE) 
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:for-each>    
								)->
							</xsl:when>
							<!-- End of OR Condition --> 
						</xsl:choose>
						<!-- End of "There is a NOT, AND, OR" -->   
					</xsl:when>	
					<xsl:when test="(xacml:Condition/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@AttributeId)">
					<!-- There is no NOT, AND, and OR. There exists only one attribute in the Condition part of the Rule --> 
						(attribute(<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:Condition/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@AttributeId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>, <xsl:value-of select = "translate(xacml:Condition/xacml:Apply/xacml:AttributeValue,'- :/.','')"/>) in 
						<xsl:choose>
							<xsl:when test="(xacml:Condition/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:action')">
								RA)->
							</xsl:when>
							<xsl:when test="(xacml:Condition/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:3.0:attribute-category:resource')">
								RO)->
							</xsl:when>
							<xsl:when test="(xacml:Condition/xacml:Apply/xacml:Apply/xacml:AttributeDesignator/@Category='urn:oasis:names:tc:xacml:1.0:subject-category:access-subject')">
								RS)->
							</xsl:when>
							<xsl:otherwise>
								RE)->
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>    
					<!-- End of "There is only one attribute in the Condition part of the Rule" -->   
				</xsl:choose>        
			</xsl:if>
			<!-- End of translating the CONDITION part of each Rule -->
			<!-- Cehcking and translating the Obligations inside a PolicySet. Obligations will be moved to the applicable Rules (i.e., Obligation.FulfillOn == Rule.Effect) from the PolicySet and Policy levels. I.e., An mCRL2 action will be generated for every Obligation  -->
			<xsl:choose>
				<!-- Moving applicable Obligations from the parent Policy to the Rule. -->
				<xsl:when test="((../xacml:ObligationExpressions/xacml:ObligationExpression/@ObligationId!='') and (@Effect =../xacml:ObligationExpressions/xacml:ObligationExpression/@FulfillOn))">
					<xsl:for-each select = "../xacml:ObligationExpressions/xacml:ObligationExpression">	
						Obligation(RS,RO,RA,<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@ObligationId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>).
					</xsl:for-each>
				</xsl:when>
				<!-- End of moving applicable Obligations from the parent Policy to the Rule. -->
				<!-- Adding an mCRL2 action for Obligations of the Rule. -->
				<xsl:when test="((xacml:ObligationExpressions/xacml:ObligationExpression/@ObligationId!='') and (@Effect =xacml:ObligationExpressions/xacml:ObligationExpression/@FulfillOn))">
					<xsl:for-each select = "xacml:ObligationExpressions/xacml:ObligationExpression">	
						Obligation(RS,RO,RA,<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(@ObligationId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>).
					</xsl:for-each>	
				</xsl:when>
				<!-- End of adding obligation actions inside Rule. -->
			</xsl:choose>
			<!-- End of Cehcking and translating the Obligations inside a PolicySet -->
			Response(RS,RO,RA,<xsl:value-of select="@Effect"/>);
		</xsl:for-each>
		<!-- End of definition of the Rule processes-->

		<!-- End of definition of PolicySet, Policy, and Rule processes.)-->
		<!-- Initialization of the mCRL2 model with different Requests based on different combinations of the attributes that exist in the policies )-->
		init sum RS:FSet(SAtt).sum RO:FSet(OAtt).sum RA:FSet(AAtt).(RS !={} &amp;&amp; RO !={} &amp;&amp; RA !={})-> Request(RS,RO,RA).Policy_<xsl:call-template name="getName"><xsl:with-param name="attname" select="translate(xacml:Policy/@PolicyId,'-','')"/></xsl:call-template><xsl:value-of select = "$attname"/>(RS,RO,RA);
	</xsl:otherwise>
	</xsl:choose>

	</xsl:template>
</xsl:stylesheet>