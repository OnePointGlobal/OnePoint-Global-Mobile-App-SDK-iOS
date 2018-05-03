<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="sBackgroundColor"/>
    <xsl:param name="sPercentage"/>
    <xsl:param name="sLabel"/>
    <xsl:param name="sAction"/>
    <xsl:param name="bShowBar" select="true()"/>
    <xsl:param name="bShowCount" select="true()"/>
    
    
    <xsl:template match="*">
        <ProgressBar>
            <xsl:if test="$bShowBar">
                <xsl:choose>
                    <xsl:when test="$sAction = 'Table'">
                        <xsl:call-template name="NavBarDefinition"/>
                    </xsl:when>
                    <xsl:when test="$sAction = 'Div'">
                        <xsl:call-template name="DivNavBarDefinition"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="NavBarDefinition"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="not($bShowBar) and $bShowCount">
                <xsl:element name="span">
                    <xsl:attribute name="class">mrProgressText</xsl:attribute>
                    <xsl:value-of select="$sLabel"/>
                </xsl:element>
            </xsl:if>
        </ProgressBar>
    </xsl:template>
    
    <xsl:template name="NavBarDefinition">
        <xsl:element name="table">
            <xsl:attribute name="style">
                <xsl:text>height: 100%; width: 100%;</xsl:text>
            </xsl:attribute>
            <xsl:element name="tr">
                <xsl:element name="td">
                    <xsl:attribute name="style">width:<xsl:value-of select="$sPercentage"/>%; background-color:<xsl:value-of select="$sBackgroundColor"/>;</xsl:attribute>
                </xsl:element>
                <xsl:if test="$bShowCount">
                    <xsl:element name="td">
                        <xsl:attribute name="class">mrProgressText</xsl:attribute>
                        <xsl:value-of select="$sLabel"/>
                    </xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="DivNavBarDefinition">
        <xsl:element name="div">
            <xsl:attribute name="data-role">progressbar</xsl:attribute>
            <xsl:attribute name="style">width:<xsl:value-of select="$sPercentage"/>%; background-color:<xsl:value-of select="$sBackgroundColor"/></xsl:attribute>
            <xsl:if test="$bShowCount">
                <xsl:value-of select="$sLabel"/>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
