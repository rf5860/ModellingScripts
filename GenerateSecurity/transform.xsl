<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:variable name="outermostElementName" select="name(/*)" />
<xsl:output method="text" encoding="ascii"/>

<xsl:template match="/">
  <xsl:text>SET DEFINE OFF;&#xa;</xsl:text>
  <xsl:apply-templates select="//row" />
</xsl:template>

<xsl:template match="row">
  <xsl:text>INSERT INTO </xsl:text>
  <xsl:value-of select="$outermostElementName"/>
  <xsl:text>(</xsl:text>
  <xsl:for-each select="*">
    <xsl:value-of select="name()"/>
    <xsl:choose>
      <xsl:when test="position()!=last()">
        <xsl:text>,</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>,last_mod_date,last_mod_time,last_mod_user</xsl:text>
	<xsl:if test="string($outermostElementName)='msf02p'">
	  <xsl:text>,district_related</xsl:text>
	</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:text>) VALUES (</xsl:text>
  <xsl:for-each select="*">
    <xsl:text>'</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>'</xsl:text>
    <xsl:choose>
      <xsl:when test="position()!=last()">
        <xsl:text>,</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>,(select to_char(current_date, 'YYYYMMDD') from dual),(select to_char(current_date, 'HHMISS') from dual),'UML2SEC'</xsl:text>
	<xsl:if test="string($outermostElementName)='msf02p'">
	  <xsl:text>,'n'</xsl:text>
	</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:text>);&#xa;</xsl:text>
</xsl:template>

</xsl:stylesheet>
