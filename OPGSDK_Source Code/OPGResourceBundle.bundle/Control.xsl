<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="*">
    <xsl:element name="">
      <xsl:for-each select="@*">
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
        </xsl:choose>
      </xsl:for-each>
    </xsl:element>
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
