<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="bIncludeCSSStyles" select="true()"/>
    <xsl:param name="bIncludeElementIds" select="true()"/>
    <xsl:param name="sImageLocation"/>
    <xsl:param name="sLabelClass"/>

    <xsl:template match="*">
        <label>
            <xsl:choose>
                <xsl:when test="$bIncludeElementIds and @ElementId != ''">
                    <xsl:element name="label">
                        <xsl:attribute name="for">
                            <xsl:value-of select="@ElementId"/>
                        </xsl:attribute>
                        <xsl:call-template name="LabelBase"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="LabelBase"/>
                </xsl:otherwise>
            </xsl:choose>
        </label>
    </xsl:template>

    <xsl:template name="LabelBase">
        <xsl:if test="$sLabelClass!='mrBannerText'">
		    <xsl:if test="Style/@ElementAlign = 'NewLine'">
		        <xsl:element name="div">
		            <xsl:if test="$bIncludeCSSStyles">
		                <xsl:attribute name="class"><xsl:value-of select="$sLabelClass"/></xsl:attribute>
		            </xsl:if>
		            <xsl:attribute name="style">
		                <xsl:call-template name="LabelStyle"/>
		                <xsl:if test="Style/@Width or Style/@Height">
		                    <xsl:call-template name="SpanStyle"/>
		                </xsl:if>
		                <xsl:call-template name="BlockStyle"/>
		            </xsl:attribute>
		            <xsl:call-template name="Label"/>
		        </xsl:element>
		    </xsl:if>
		    <xsl:if test="Style/@ElementAlign != 'NewLine'">
		        <xsl:element name="span">
		            <xsl:if test="$bIncludeCSSStyles">
		                <xsl:attribute name="class"><xsl:value-of select="$sLabelClass"/></xsl:attribute>
		            </xsl:if>
		            <xsl:attribute name="style">
		                <xsl:call-template name="LabelStyle"/>
		                <xsl:if test="Style/@Width or Style/@Height">
		                    <xsl:call-template name="SpanStyle"/>
		                </xsl:if>
		                <xsl:call-template name="BlockStyle"/>
		            </xsl:attribute>
		            <xsl:call-template name="Label"/>
		        </xsl:element>
	        </xsl:if>
        </xsl:if>
        <xsl:if test="$sLabelClass='mrBannerText'">
          <xsl:if test="Style/@ElementAlign = 'NewLine'">
            <xsl:element name="div">
              <xsl:if test="$bIncludeCSSStyles">
                <xsl:attribute name="class">
                  <xsl:value-of select="$sLabelClass"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:attribute name="style">
                <xsl:call-template name="LabelStyle"/>
                <xsl:if test="Style/@Width or Style/@Height">
                  <xsl:call-template name="SpanStyle"/>
                </xsl:if>
                <xsl:call-template name="BlockStyle"/>
              </xsl:attribute>
              <xsl:call-template name="Label"/>
            </xsl:element>
          </xsl:if>
          <xsl:if test="Style/@ElementAlign != 'NewLine'">
            <xsl:element name="span">
              <xsl:if test="$bIncludeCSSStyles">
                <xsl:attribute name="class">
                  <xsl:value-of select="$sLabelClass"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:attribute name="style">
                <xsl:call-template name="LabelStyle"/>
                <xsl:if test="Style/@Width or Style/@Height">
                  <xsl:call-template name="SpanStyle"/>
                </xsl:if>
                <xsl:call-template name="BlockStyle"/>
              </xsl:attribute>
              <xsl:call-template name="Label"/>
            </xsl:element>
          </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="Label">
        <xsl:choose>
            <xsl:when test="Style/@Image != ''">
                <xsl:choose>
                    <xsl:when test="Style/@ImagePosition = 'Left' or not(Style/@ImagePosition)">
                        <xsl:element name="img">
                            <xsl:attribute name="src">
                                <xsl:if test="not((starts-with(Style/@Image, 'http:'))or(starts-with(Style/@Image, 'https:')))">
                                    <xsl:value-of select="$sImageLocation"/>
                                </xsl:if>
                                <xsl:value-of select="Style/@Image"/>
                            </xsl:attribute>
                            <xsl:attribute name="alt"/>
                        </xsl:element>
                        <xsl:call-template name="LabelText"/>
                    </xsl:when>
                    <xsl:when test="Style/@ImagePosition = 'Right'">
                        <xsl:call-template name="LabelText"/>
                        <xsl:element name="img">
                            <xsl:attribute name="src">
                                <xsl:if test="not((starts-with(Style/@Image, 'http:'))or(starts-with(Style/@Image, 'https:')))">
                                    <xsl:value-of select="$sImageLocation"/>
                                </xsl:if>
                                <xsl:value-of select="Style/@Image"/>
                            </xsl:attribute>
                            <xsl:attribute name="alt"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="Style/@ImagePosition = 'Top'">
                        <xsl:element name="div">
                            <xsl:element name="img">
                                <xsl:attribute name="src">
                                    <xsl:if test="not((starts-with(Style/@Image, 'http:'))or(starts-with(Style/@Image, 'https:')))">
                                        <xsl:value-of select="$sImageLocation"/>
                                    </xsl:if>
                                    <xsl:value-of select="Style/@Image"/>
                                </xsl:attribute>
                                <xsl:attribute name="alt"/>
                            </xsl:element>
                        </xsl:element>
                        <xsl:call-template name="LabelText"/>
                    </xsl:when>
                    <xsl:when test="Style/@ImagePosition = 'Bottom'">
                        <xsl:element name="div">
                            <xsl:call-template name="LabelText"/>
                        </xsl:element>
                        <xsl:element name="img">
                            <xsl:attribute name="src">
                                <xsl:if test="not((starts-with(Style/@Image, 'http:'))or(starts-with(Style/@Image, 'https:')))">
                                    <xsl:value-of select="$sImageLocation"/>
                                </xsl:if>
                                <xsl:value-of select="Style/@Image"/>
                            </xsl:attribute>
                            <xsl:attribute name="alt"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="Style/@ImagePosition = 'ImageOnly'">
                        <xsl:element name="img">
                            <xsl:attribute name="src">
                                <xsl:if test="not((starts-with(Style/@Image, 'http:'))or(starts-with(Style/@Image, 'https:')))">
                                    <xsl:value-of select="$sImageLocation"/>
                                </xsl:if>
                                <xsl:value-of select="Style/@Image"/>
                            </xsl:attribute>
                            <xsl:attribute name="alt">
                                <xsl:value-of select="Text"/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="LabelText"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="LabelText"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="LabelText">
        <xsl:choose>
            <xsl:when test="Text/@WellFormed = 'false'">
                <xsl:value-of select="Text"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of disable-output-escaping = "yes" select="Text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="LabelStyle">
        <!--- adds the label styles to a style attribute -->
        <xsl:if test="Style/@BgColor">background-color: <xsl:value-of select="Style/@BgColor"/>;</xsl:if>
        <xsl:if test="Style/@Color">color: <xsl:value-of select="Style/@Color"/>;</xsl:if>
        <xsl:if test="Style/@Indent">margin-left: <xsl:value-of select="Style/@Indent"/>em;</xsl:if>
        <xsl:if test="Style/@Width">width: <xsl:value-of select="Style/@Width"/>;</xsl:if>
        <xsl:if test="Style/@Height">height: <xsl:value-of select="Style/@Height"/>;</xsl:if>
        <xsl:if test="Style/@Hidden = 'true'">visibility: hidden;</xsl:if>
        <xsl:if test="Style/@ZIndex">z-index: <xsl:value-of select="Style/@ZIndex"/>;</xsl:if>
        <xsl:choose>
            <xsl:when test="Style/@Cursor = 'EResize'">cursor: e-resize;</xsl:when>
            <xsl:when test="Style/@Cursor = 'NEResize'">cursor: ne-resize;</xsl:when>
            <xsl:when test="Style/@Cursor = 'NResize'">cursor: n-resize;</xsl:when>
            <xsl:when test="Style/@Cursor = 'NWResize'">cursor: nw-resize;</xsl:when>
            <xsl:when test="Style/@Cursor = 'WResize'">cursor: w-resize;</xsl:when>
            <xsl:when test="Style/@Cursor = 'SWResize'">cursor: sw-resize;</xsl:when>
            <xsl:when test="Style/@Cursor = 'SResize'">cursor: s-resize;</xsl:when>
            <xsl:when test="Style/@Cursor = 'SEResize'">cursor: se-resize;</xsl:when>
            <xsl:when test="Style/@Cursor">cursor: <xsl:value-of select="Style/@Cursor"/>;</xsl:when>
        </xsl:choose>
        <xsl:if test="Style/Cell/@Wrap = 'false'">white-space: nowrap;</xsl:if>

        <xsl:if test="Style/Font/@Family">font-family: <xsl:value-of select="Style/Font/@Family"/>;</xsl:if>
        <xsl:if test="Style/Font/@Size">font-size: <xsl:value-of select="Style/Font/@Size"/>pt;</xsl:if>
        <xsl:if test="Style/Font/@IsUnderline = 'true'">text-decoration: underline;</xsl:if>
        <xsl:if test="Style/Font/@IsItalic = 'true'">font-style: italic;</xsl:if>
        <xsl:if test="Style/Font/@IsBold = 'true'">font-weight: bold;</xsl:if>
        <xsl:if test="Style/Font/@IsStrikethrough = 'true'">text-decoration: line-through;</xsl:if>
        <xsl:if test="Style/Font/@IsOverline = 'true'">text-decoration: overline;</xsl:if>
        <xsl:if test="Style/Font/@IsBlink = 'true'">text-decoration: blink;</xsl:if>
        <xsl:if test="Style/Font/@IsSubscript = 'true'">vertical-align: sub;</xsl:if>
        <xsl:if test="Style/Font/@IsSuperscript = 'true'">vertical-align: super;</xsl:if>
    </xsl:template>

    <xsl:template name="SpanStyle">
        <!--- adds span tag specific styles to a style attribute -->
        <xsl:text>display: inline-block;</xsl:text>
    </xsl:template>

    <xsl:template name="BlockStyle">
        <!--- adds the block styles to a style attribute -->
        <xsl:if test="Style/@Align">text-Align: <xsl:value-of select="Style/@Align"/>;</xsl:if>
        <xsl:choose>
            <xsl:when test="Style/@VerticalAlign = 'TextTop'">vertical-align: text-top;</xsl:when>
            <xsl:when test="Style/@VerticalAlign = 'TextBottom'">vertical-align: text-bottom;</xsl:when>
            <xsl:when test="Style/@VerticalAlign">vertical-align: <xsl:value-of select="Style/@VerticalAlign"/>;</xsl:when>
        </xsl:choose>
        <xsl:if test="Style/Cell/@BgColor">background-color: <xsl:value-of select="Style/Cell/@BgColor"/>;</xsl:if>
        <xsl:if test="Style/Cell/@Width">width: <xsl:value-of select="Style/Cell/@Width"/>;</xsl:if>
        <xsl:if test="Style/Cell/@Height">height: <xsl:value-of select="Style/Cell/@Height"/>;</xsl:if>
        <xsl:if test="Style/Cell/@Wrap = 'false'">white-space: nowrap;</xsl:if>
        <xsl:call-template name="BorderStyle"/>
        <xsl:call-template name="PaddingStyle"/>
    </xsl:template>

    <xsl:template name="BorderStyle">
        <!--- adds the border styles to a style attribute -->
        <xsl:if test="Style/Cell/@BorderColor">border-color: <xsl:value-of select="Style/Cell/@BorderColor"/>;</xsl:if>
        <xsl:if test="Style/Cell/@BorderStyle">border-style: <xsl:value-of select="Style/Cell/@BorderStyle"/>;</xsl:if>
        <xsl:if test="Style/Cell/@BorderWidth">border-width: <xsl:value-of select="Style/Cell/@BorderWidth"/>px;</xsl:if>
        <!--- left -->
        <xsl:if test="Style/Cell/@BorderLeftColor">border-left-color: <xsl:value-of select="Style/Cell/@BorderLeftColor"/>;</xsl:if>
        <xsl:if test="Style/Cell/@BorderLeftStyle">border-left-style: <xsl:value-of select="Style/Cell/@BorderLeftStyle"/>;</xsl:if>
        <xsl:if test="Style/Cell/@BorderLeftWidth">border-left-width: <xsl:value-of select="Style/Cell/@BorderLeftWidth"/>px;</xsl:if>
        <!--- right -->
        <xsl:if test="Style/Cell/@BorderRightColor">border-right-color: <xsl:value-of select="Style/Cell/@BorderRightColor"/>;</xsl:if>
        <xsl:if test="Style/Cell/@BorderRightStyle">border-right-style: <xsl:value-of select="Style/Cell/@BorderRightStyle"/>;</xsl:if>
        <xsl:if test="Style/Cell/@BorderRightWidth">border-right-width: <xsl:value-of select="Style/Cell/@BorderRightWidth"/>px;</xsl:if>
        <!--- top -->
        <xsl:if test="Style/Cell/@BorderTopColor">border-top-color: <xsl:value-of select="Style/Cell/@BorderTopColor"/>;</xsl:if>
        <xsl:if test="Style/Cell/@BorderTopStyle">border-top-style: <xsl:value-of select="Style/Cell/@BorderTopStyle"/>;</xsl:if>
        <xsl:if test="Style/Cell/@BorderTopWidth">border-top-width: <xsl:value-of select="Style/Cell/@BorderTopWidth"/>px;</xsl:if>
        <!--- bottom -->
        <xsl:if test="Style/Cell/@BorderBottomColor">border-bottom-color: <xsl:value-of select="Style/Cell/@BorderBottomColor"/>;</xsl:if>
        <xsl:if test="Style/Cell/@BorderBottomStyle">border-bottom-style: <xsl:value-of select="Style/Cell/@BorderBottomStyle"/>;</xsl:if>
        <xsl:if test="Style/Cell/@BorderBottomWidth">border-bottom-width: <xsl:value-of select="Style/Cell/@BorderBottomWidth"/>px;</xsl:if>
    </xsl:template>

    <xsl:template name="PaddingStyle">
        <!--- adds the padding styles to a style attribute -->
        <xsl:if test="Style/Cell/@Padding">padding: <xsl:value-of select="Style/Cell/@Padding"/>px;</xsl:if>
        <xsl:if test="Style/Cell/@PaddingLeft">padding-left: <xsl:value-of select="Style/Cell/@PaddingLeft"/>px;</xsl:if>
        <xsl:if test="Style/Cell/@PaddingRight">padding-right: <xsl:value-of select="Style/Cell/@PaddingRight"/>px;</xsl:if>
        <xsl:if test="Style/Cell/@PaddingTop">padding-top: <xsl:value-of select="Style/Cell/@PaddingTop"/>px;</xsl:if>
        <xsl:if test="Style/Cell/@PaddingBottom">padding-bottom: <xsl:value-of select="Style/Cell/@PaddingBottom"/>px;</xsl:if>
    </xsl:template>
</xsl:stylesheet>