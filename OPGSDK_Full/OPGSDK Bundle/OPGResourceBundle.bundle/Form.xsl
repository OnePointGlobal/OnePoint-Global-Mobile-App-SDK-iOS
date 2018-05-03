<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes"/>
<xsl:param name="sAction"/>

<xsl:template match="*">
<Page>
<xsl:call-template name="FormDefinition" />
</Page>
</xsl:template>

<xsl:template name="FormDefinition">
<xsl:element name="Form">
<xsl:attribute name="name">mrForm</xsl:attribute>
<xsl:attribute name="id">mrForm</xsl:attribute>
<xsl:attribute name="action"><xsl:value-of select="$sAction"/></xsl:attribute>
<xsl:attribute name="method">post</xsl:attribute>
<xsl:call-template name="HiddenFields" />
</xsl:element>
</xsl:template>

<xsl:template name="HiddenFields">
<xsl:for-each select="/Page/@*">
<xsl:choose>
<xsl:when test="name() = 'SavePoint'">
<xsl:call-template name="HiddenField"/>
</xsl:when>
<xsl:when test="name() = 'Project'">
<xsl:call-template name="HiddenField"/>
</xsl:when>
<xsl:when test="name() = 'Renderer'">
<xsl:call-template name="HiddenField"/>
</xsl:when>
<xsl:when test="name() = 'SessionToken'">
<xsl:call-template name="HiddenField"/>
</xsl:when>
<xsl:when test="name() = 'Locale'">
<xsl:call-template name="HiddenField"/>
</xsl:when>
<xsl:when test="name() = 'Language'">
<xsl:call-template name="HiddenField"/>
</xsl:when>
</xsl:choose>
</xsl:for-each>
</xsl:template>

<xsl:template name="HiddenField">
<xsl:element name="input">
<xsl:attribute name="type">hidden</xsl:attribute>
<xsl:attribute name="name">I.<xsl:value-of select="name()"/>
</xsl:attribute>
<xsl:attribute name="value">
<xsl:value-of select="."/>
</xsl:attribute>
</xsl:element>
</xsl:template>
</xsl:stylesheet>
