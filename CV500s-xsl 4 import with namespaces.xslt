<?xml version="1.0" encoding="UTF-8" ?>    
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:nsCommon="http://www.joia.or.jp/standardized/namespaces/Common" 
	xmlns:nsSBJ="http://www.joia.or.jp/standardized/namespaces/SBJ"
	xmlns:nsKM="http://www.joia.or.jp/standardized/namespaces/KM"
	xsi:schemaLocation="http://www.joia.or.jp/standardized/namespaces/Common Common_schema.xsd http://www.joia.or.jp/standardized/namespaces/KM KM_schema.xsd http://www.joia.or.jp/standardized/namespaces/SBJ SBJ_schema.xsd" >
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

    
	<!-- Information to be able to map data to ODLink -->
	<!-- Element Type, attribute No 1 - is final data for the Rx -->
	<!--   if it is included the Sphere in Element ExamDistance, Attribute No 1 is subtracted    -->
	<!--      from the Sphere in Element Exam Distance, Attribue No 2 to get Rx add for each eye -->
	<!-- Element Type, attribute No 2 - is Subjectve data for the Rx                             -->
	<!--   Add is calculated the same way as for final data                                      -->
	<!-- Element Type, attribute No 3 - is Unaided data for eyes                                 -->
	<!--   Element ExamDistance, Attribute No 1 is Far visual acuitites, right, left and both    -->
	<!--   Element ExamDistance, Attribute No 1 is near visual acuities, right, left and both    -->
	<!-- Element Type, attribute No 4 - is AR data (objective data in xml)                       -->
	<!-- Element Type, attribute No 5 - is Lensometer (habitual) reading, (spectacles in xml)    -->
	<!-- There are other tests we can import if the data comes from the phoropter                -->
	
	<!-- default template for element and root nodes                                             -->
	<xsl:template match="*|/" >
		<xsl:apply-templates />
	</xsl:template>
	
    <!-- modified default template for text and attribute nodes                                  -->
	<xsl:template match="text()|@*">	
	</xsl:template>
	
	<!-- overide default template rule and filter out empty nodes   -->
	<xsl:template match= "*[not(*) and not( text() )]" >
	</xsl:template>
	
	<xsl:template match="nsCommon:Ophthalmology">
	
    	<FMPXMLRESULT xmlns:fm="http://www.filemaker.com/fmpxmlresult" exclude-result-prefixes="fm">
		<ERRORCODE>0</ERRORCODE>
		<PRODUCT NAME="FileMaker Pro" BUILD="" VERSION="" />
		<DATABASE NAME="" RECORDS="" DATEFORMAT="M/d/yyyy" TIMEFORMAT="h:mm:ss a" LAYOUT="" />
		<METADATA>

			<!-- Today's prescription aka Subjective, in xml data found under Type No=2 and ExamDistance No=2 -->
			<!--    But ... add values are calculated using sph data from ExamDistance No=1 too               -->
			<xsl:if test="//nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='2']" >
				<xsl:if test="//nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='2']//nsSBJ:R/nsSBJ:Sph[ node() ] ">
					<FIELD NAME="rs" TYPE="TEXT" />
				</xsl:if>
				<xsl:if test="//nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='1']//nsSBJ:R/nsSBJ:Sph/text() != 
								//nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='2']//nsSBJ:R/nsSBJ:Sph/text()" >
					<FIELD NAME="Todays add" TYPE="TEXT" />
				</xsl:if>
				<xsl:if test="//nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='2']//nsSBJ:R/nsSBJ:Cyl[ node() ]" >
					<FIELD NAME="rc" TYPE="TEXT" />				
				</xsl:if>
				<xsl:if test="//nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='2']//nsSBJ:R/nsSBJ:Axis[ node() ]" >
					<FIELD NAME="ra" TYPE="TEXT" />
				</xsl:if>
				<xsl:if test="//nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='2']//nsSBJ:R/nsSBJ:HPri/text()" >				
					<FIELD NAME="rhp" TYPE="TEXT" />
				</xsl:if>
				<xsl:if test="//nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='2']//nsSBJ:R/nsSBJ:VPri/text()" >					
					<FIELD NAME="rvp" TYPE="TEXT" />
				</xsl:if>
				<xsl:if test="//nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='2']//nsSBJ:L/nsSBJ:Sph[ node() ] ">				
					<FIELD NAME="ls" TYPE="TEXT" />
				</xsl:if>
				<xsl:if test="//nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='1']//nsSBJ:L/nsSBJ:Sph/text() != 
								//nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='2']//nsSBJ:L/nsSBJ:Sph/text()" >
					<FIELD NAME="Todays add L" TYPE="TEXT" />
				</xsl:if>				
				<xsl:if test="//nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='2']//nsSBJ:L/nsSBJ:Cyl[ node() ]" >				
					<FIELD NAME="lc" TYPE="TEXT" />
				</xsl:if>
				<xsl:if test="//nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='2']//nsSBJ:L/nsSBJ:Axis[ node() ]" >				
					<FIELD NAME="la" TYPE="TEXT" />
				</xsl:if>
				<xsl:if test="//nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='2']//nsSBJ:L/nsSBJ:HPri[ node() ]" >				
					<FIELD NAME="lhp" TYPE="TEXT" />
				</xsl:if>
				<xsl:if test="//nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='2']//nsSBJ:L/nsSBJ:VPri[ node() ]" >				
					<FIELD NAME="lvp" TYPE="TEXT" />
				</xsl:if>
			</xsl:if>
			
			<!-- Visual Acuity or Unaided Data -->
			<xsl:if test="//nsSBJ:Type[@No='3']">
				<xsl:if test="//nsSBJ:Type[@No='3']//nsSBJ:VA/nsSBJ:R[ node() ]" >
					<FIELD NAME="Entrance VA OD" TYPE="TEXT" />
				</xsl:if>
				<xsl:if test="//nsSBJ:Type[@No='3']//nsSBJ:VA/nsSBJ:L[ node() ]" >
					<FIELD NAME="Entrance VA OS" TYPE="TEXT" />	
				</xsl:if>
				<xsl:if test="//nsSBJ:Type[@No='3']//nsSBJ:VA/nsSBJ:B[ node() ]" >
					<FIELD NAME="OU Va uncorrected" TYPE="TEXT" />
				</xsl:if>
			</xsl:if>

			<!-- Autorefractor Data or Objective Data-->
			<xsl:if test="//nsSBJ:Type[@No='4']" >
				<FIELD NAME="rsauto" TYPE="TEXT" />
				<FIELD NAME="rcauto" TYPE="TEXT" />
				<FIELD NAME="raauto" TYPE="TEXT" />
				<FIELD NAME="lsauto" TYPE="TEXT" />
				<FIELD NAME="lcauto" TYPE="TEXT" />
				<FIELD NAME="laauto" TYPE="TEXT" />
			</xsl:if>
			
			<!-- Habitual Data or Last Prescription -->
			<xsl:if test="//nsSBJ:Type[@No='5']" >
				<FIELD NAME="Habit Rs" TYPE="TEXT" />
				<FIELD NAME="Habit Rc" TYPE="TEXT" />
				<FIELD NAME="Habit Ra" TYPE="TEXT" />	
				<FIELD NAME="hab rhp" TYPE="TEXT" />
				<FIELD NAME="hab rvp" TYPE="TEXT" />
				<FIELD NAME="Habit Ls" TYPE="TEXT" />
				<FIELD NAME="Habit Lc" TYPE="TEXT" />
				<FIELD NAME="Habit La" TYPE="TEXT" />
				<FIELD NAME="hab lhp" TYPE="TEXT" />
				<FIELD NAME="hab lvp" TYPE="TEXT" />
			</xsl:if>
			
			<!-- Keratometry Data -->
			<xsl:if test="//nsKM:KM">
				<FIELD NAME="rk1" TYPE="TEXT" />
				<FIELD NAME="rk2" TYPE="TEXT" />
				<FIELD NAME="rkax" TYPE="TEXT" />			
				<FIELD NAME="lk1" TYPE="TEXT" />
				<FIELD NAME="lk2" TYPE="TEXT" />
				<FIELD NAME="lkax" TYPE="TEXT" />
			</xsl:if>
						
    	</METADATA>
		<RESULTSET FOUND="">
			<ROW MODID="" RECORDID="">
				<xsl:apply-templates />
			</ROW>
		</RESULTSET>
		</FMPXMLRESULT>        
    </xsl:template>
	
	<!-- Today's Rx or Subjective Data found under Type No="2", ExamDistance No="2"  -->
	<xsl:template match="//nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='2']" >
		<xsl:apply-templates />
	</xsl:template>
	
	<!-- Unaided Data found under Type No. 3                                          -->	
    <xsl:template match="//nsSBJ:Type[@No='3']//nsSBJ:VA">
        <xsl:apply-templates select="node()" mode="RLB" />		
    </xsl:template>	
	
	<!-- Autorefractor Data found under Type No. 4                                    -->	
    <xsl:template match="//nsSBJ:Type[@No='4']">	
        <xsl:apply-templates />
    </xsl:template>
	
	<!-- Habitual Data found under Type No. 5                                          -->
	<xsl:template match="//nsSBJ:Type[@No='5']" >
		<xsl:apply-templates />
	</xsl:template>

	<!-- Text from TypeName element used to comment XML for debugging purposes         -->
	<xsl:template match="//nsSBJ:TypeName" >
		<xsl:text disable-output-escaping="yes">&#xD;&#xA;</xsl:text>	
		<xsl:comment><xsl:value-of select="text()" /></xsl:comment>
		<!-- xsl:text disable-output-escaping="yes">&#xD;&#xA;</xsl:text -->			
	</xsl:template>
	
	<xsl:template match="//nsSBJ:Sph">
		<xsl:text disable-output-escaping="yes">&#xD;&#xA;</xsl:text>
		<xsl:comment><xsl:value-of select="local-name()" /></xsl:comment>
		<xsl:text disable-output-escaping="yes">&#xD;&#xA;</xsl:text>
		
		<xsl:variable name="rightLeft" select="local-name(parent::*)"/>
		
		<xsl:comment>rightLeft = <xsl:value-of select="$rightLeft" /></xsl:comment>
		<xsl:text disable-output-escaping="yes">&#xD;&#xA;</xsl:text>		
		<xsl:if test="( local-name( parent::* ) = 'R' ) or ( local-name( parent::* ) = 'L' )" >		
			<COL>
			<!-- this code should work for the AR values in Type, No = 4.               -->
			<!--      In my experience AR values are never 0.00                         -->
			<xsl:choose>
			<xsl:when test="text() != '0.00' ">
				<DATA>
					<xsl:value-of select="normalize-space(text())" />
				</DATA>
			</xsl:when>
			<xsl:otherwise>
				<DATA>PL</DATA>
			</xsl:otherwise>
			</xsl:choose>
			</COL>
			<!-- This calculates the add for right and left eyes -->
			<!-- NOTE: xslt 1.0 won't allow xpath data to be stored in a variable        -->
			<!--   As a result, we have to hardcode the paths                            -->		
			<xsl:choose>
				<xsl:when test=" $rightLeft = 'R' and ancestor::nsSBJ:Type/@No ='2' " >
					<comment>Add <xsl:value-of select="$rightLeft" /></comment>					
					<xsl:variable name="sphFar" select=" //nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='1']//nsSBJ:R/nsSBJ:Sph/text() " />
					<xsl:variable name="sphNear" select=" //nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='2']//nsSBJ:R/nsSBJ:Sph/text() " />
					<xsl:variable name="sphAdd" select="number( $sphNear ) - number( $sphFar )" />
					<xsl:if test="$sphAdd != '0.00'" >
						<COL>
						<DATA>
							<xsl:value-of select="$sphAdd" />
						</DATA>
						</COL>
					</xsl:if>					
				</xsl:when>
				<xsl:when test=" $rightLeft = 'L' and ancestor::nsSBJ:Type/@No='2' ">
					<comment>Add <xsl:value-of select="$rightLeft" /></comment>	
					<xsl:variable name="sphFar" select=" //nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='1']//nsSBJ:L/nsSBJ:Sph/text() " />
					<xsl:variable name="sphNear" select=" //nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='2']//nsSBJ:L/nsSBJ:Sph/text() " />
					<xsl:variable name="sphAdd" select="number( $sphNear ) - number( $sphFar )" />
					<xsl:if test="$sphAdd != '0.00'" >
						<COL>
						<DATA>
							<xsl:value-of select="$sphAdd" />
						</DATA>
						</COL>
					</xsl:if>					
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="//nsSBJ:Cyl">
		<xsl:text disable-output-escaping="yes">&#xD;&#xA;</xsl:text>
		<xsl:comment><xsl:value-of select="local-name()" /></xsl:comment>
		<xsl:text disable-output-escaping="yes">&#xD;&#xA;</xsl:text>
		<xsl:if test="local-name( parent::* )='R' or 'L'" >		
			<COL>
			<xsl:choose>
			<xsl:when test="text() != '0.00' ">
				<DATA>
					<xsl:value-of select="normalize-space(text())" />
				</DATA>
			</xsl:when>
			<xsl:otherwise>
				<DATA>SPH</DATA>
			</xsl:otherwise>
			</xsl:choose>
			</COL>
		</xsl:if>
	</xsl:template>

	<!-- switch from local-name() to namespaces, to filter data not required             -->
	<xsl:template match="nsSBJ:Axis | nsKM:Axis[ parent::nsKM:Cylinder ]">
		<xsl:text disable-output-escaping="yes">&#xD;&#xA;</xsl:text>
		<xsl:comment><xsl:value-of select="local-name()" /></xsl:comment>
		<xsl:text disable-output-escaping="yes">&#xD;&#xA;</xsl:text>
		<COL>
		<!-- when axis is 0 		
		-->
		<xsl:choose>
		<xsl:when test="text() = '0' " >
			<DATA>
				<!-- and cylinder is 0 output blank                                      -->
				<xsl:choose>
				<xsl:when test="preceding-sibling::*[1] = '0.00' " >
				</xsl:when>
				<!-- and cylinder isn't 0 output 180                                     -->
				<xsl:otherwise>
					180
				</xsl:otherwise>
				</xsl:choose>
			</DATA>
		</xsl:when>
		<!-- when axis is not 0 output data sent                                         -->
		<xsl:otherwise>
			<DATA>
				<xsl:value-of select="text()" />
			</DATA>
		</xsl:otherwise>
		</xsl:choose>
		</COL>
	</xsl:template>
	
	<xsl:template match="//nsSBJ:HPri | nsSBJ:VPri | nsSBJ:Prism | nsSBJ:Angle" >
	</xsl:template>
	
	<!-- only process nodes with text -->
	<xsl:template match=" //nsSBJ:HBase[ node() ] | //nsSBJ:VBase[ node() ]" >
		<xsl:variable name="PrismVal" >
			<xsl:value-of select="preceding-sibling::*[1]" />
		</xsl:variable>
		<COL>
		<DATA>
			<xsl:value-of select="concat( $PrismVal,' ',text() )" />
		</DATA>
		</COL>		
	</xsl:template>

	<!-- visual acuity data -->
	<xsl:template match="*[ node() ]" mode="RLB" >
		<xsl:text disable-output-escaping="yes">&#xD;&#xA;</xsl:text>
		<xsl:comment><xsl:value-of select="local-name()" /></xsl:comment>
		<!-- xsl:text disable-output-escaping="yes">&#xD;&#xA;</xsl:text -->
		<COL>
		<DATA>
				<xsl:value-of select="text()" />
		</DATA>
		</COL>
	</xsl:template>
	
	<!--  Retrieves diopters from KM element                                            -->
	<xsl:template match="//nsKM:Power[ not( parent::nsKM:Cylinder ) ]">
		<xsl:text disable-output-escaping="yes">&#xD;&#xA;</xsl:text>
		<xsl:comment><xsl:value-of select="local-name()" /></xsl:comment>
		<xsl:text disable-output-escaping="yes">&#xD;&#xA;</xsl:text>		
		<COL>
			<DATA>
				<xsl:value-of select="text()" />
			</DATA>
		</COL>
	</xsl:template>	
	
	<!--  the templates below filter out data not required                             -->
    <xsl:template match="//nsSBJ:Type[@No='1' or @No='6' or @No='7' or @No='8' or @No='9']" >	
    </xsl:template>
	
	<xsl:template match="//nsSBJ:Type[@No='2']/nsSBJ:ExamDistance[@No='1']" >
	</xsl:template>
	
	<!--  Element = Measure, Attribute = Type=SBJ                                       -->
	<xsl:template match="//nsCommon:Common" />
	<xsl:template match="//nsSBJ:BinoVisionTest" />
	<xsl:template match="//nsSBJ:US21test" />
	<xsl:template match="//Sheard" />
	
	<xsl:template match="//nsSBJ:ContrastVA" />
		
	<!-- Element = Measure, Attribute = Type=KM                                         -->
	<xsl:template match="//nsKM:List" />
	<xsl:template match="//nsKM:Average" />	
	
</xsl:stylesheet>
