<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="">
    <Question>
      <xsl:apply-templates select="Question"/>
    </Question>
  </xsl:template>

  <xsl:template match="Question">
    <xsl:param name="bWithinTable" select="false()"/>

    <xsl:if test="Style/@ElementAlign = 'NewLine'">
      <xsl:choose>
        <xsl:when test="position() != 1 and not($bWithinTable)">
          <div>
            <br />
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div></div>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:element name="span">
      <!--- Set style -->
    </xsl:stylesheet>
