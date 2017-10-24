<?xml version="1.0" encoding="UTF-8"?>
<!--
 IBM Confidential
 
 OCO Source Materials
 
 IBM SPSS Products: Data Collection
 
 (C) Copyright IBM Corp. 2001, 2011
 
 The source code for this program is not published or otherwise divested of its trade secrets, irrespective of what has been deposited with the U.S. Copyright Office.
 -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="bIncludeCSSStyles" select="true()"/>
    <xsl:param name="bIncludeElementIds" select="true()"/>
    <xsl:param name="sImageLocation"/>
    <xsl:param name="bShowOnly" select="false()"/>
    <xsl:param name="bAutoComplete" select="false()"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="Questions">
        <Question>
            <xsl:apply-templates select="Question"/>
        </Question>
    </xsl:template>
    
    <xsl:template match="Question">
        <xsl:param name="bWithinTable" select="false()"/>
        
        <xsl:if test="Style/@ElementAlign = 'NewLine'">
            <xsl:choose>
                <xsl:when test="position() != 1 and not($bWithinTable)">
                    <div><br /></div>
                </xsl:when>
                <xsl:otherwise>
                    <div></div>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:element name="span">
            <!--- Set style -->
            <xsl:attribute name="style">
                <xsl:if test="not($bWithinTable)">
                    <xsl:if test="Style/Cell/@Width or Style/Cell/@Height or Style/Cell/@BorderStyle or Style/Cell/@BorderTopStyle or Style/Cell/@BorderBottomStyle or Style/Cell/@BorderLeftStyle or Style/Cell/@BorderRightStyle">
                        <xsl:call-template name="SpanStyle"/>
                    </xsl:if>
                    <xsl:call-template name="BlockStyle"/>
                </xsl:if>
            </xsl:attribute>
            <!--- For each used to ensure order -->
            <xsl:for-each select="*">
                <xsl:choose>
                    <xsl:when test="name() = 'Control'">
                        <xsl:apply-templates select="."/>
                    </xsl:when>
                    <xsl:when test="name() = 'Label'">
                        <xsl:apply-templates select=".">
                            <xsl:with-param name="sLabelClass" select="'mrQuestionText'"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:when test="name() = 'Error'">
                        <xsl:apply-templates select=".">
                            <xsl:with-param name="sLabelClass" select="'mrErrorText'"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:when test="name() = 'Table'">
                        <xsl:apply-templates select=".">
                            <xsl:with-param name="Orientation" select="../Style/@Orientation" />
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:when test="name() = 'Questions'">
                        <xsl:apply-templates/>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="Label | Error">
        <xsl:param name="sLabelClass" select="'UNKNOWN'"/>
        <xsl:param name="bWithinTable" select="false()"/>
        
        <xsl:choose>
            <xsl:when test="$bIncludeElementIds and @ElementId != ''">
                <xsl:element name="label">
                    <xsl:attribute name="for">
                        <xsl:value-of select="@ElementId"/>
                    </xsl:attribute>
                    <xsl:call-template name="LabelBase">
                        <xsl:with-param name="sLabelClass" select="$sLabelClass"/>
                        <xsl:with-param name="bWithinTable" select="$bWithinTable"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="LabelBase">
                    <xsl:with-param name="sLabelClass" select="$sLabelClass"/>
                    <xsl:with-param name="bWithinTable" select="$bWithinTable"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="LabelBase">
        <xsl:param name="sLabelClass" select="'UNKNOWN'"/>
        <xsl:param name="bWithinTable" select="false()"/>
        
        <xsl:if test="Style/@ElementAlign = 'NewLine'">
            <div></div>
        </xsl:if>
        <xsl:element name="span">
            <xsl:if test="$bIncludeCSSStyles">
                <xsl:attribute name="class"><xsl:value-of select="$sLabelClass"/></xsl:attribute>
            </xsl:if>
            <xsl:attribute name="style">
                <xsl:call-template name="LabelStyle"/>
                <xsl:if test="Style/@Width or Style/@Height">
                    <xsl:call-template name="SpanStyle"/>
                </xsl:if>
                <xsl:if test="not($bWithinTable)">
                    <xsl:call-template name="BlockStyle"/>
                </xsl:if>
            </xsl:attribute>
            <xsl:call-template name="Label"/>
        </xsl:element>
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
    
    <!--- TABLE -->
    
    <xsl:template match="Table">
        <xsl:param name="Orientation" select="Column" />
        <xsl:choose>
            <xsl:when test="@UseTablesLayout = '0'">
                <xsl:element name="span">
                    <xsl:if test="$bIncludeCSSStyles">
                        <xsl:attribute name="class">mrQuestionTable</xsl:attribute>
                    </xsl:if>
                    <xsl:for-each select="parent::node()">
                        <xsl:attribute name="style">
                            <!-- Ensure the list vertical-align -->
                            <xsl:text>display:block;</xsl:text>
                            <xsl:call-template name="TableStyle"/>
                        </xsl:attribute>
                    </xsl:for-each>
                    <xsl:call-template name="SpanRow">
                        <xsl:with-param name="Orientation" select="$Orientation" />
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <!--- div tag needed for horizontal alignment of tables-->
                <xsl:element name="table">
                    <xsl:if test="@Summary">
                        <xsl:attribute name="summary">
                            <xsl:value-of select="@Summary"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$bIncludeCSSStyles">
                        <xsl:attribute name="class">mrQuestionTable</xsl:attribute>
                    </xsl:if>
                    <xsl:for-each select="parent::node()">
                        <xsl:attribute name="style">
                            <xsl:if test="not (Style/@Width or Style/@Height)">
                                <xsl:call-template name="SpanStyle"/>
                            </xsl:if>
                            <xsl:call-template name="TableStyle"/>
                        </xsl:attribute>
                    </xsl:for-each>
                    <xsl:apply-templates select="Row">
                        <xsl:sort select="@Y" order="ascending" data-type="number" />
                    </xsl:apply-templates>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="Row">
        <xsl:element name="tr">
            <xsl:apply-templates select="Cell">
                <xsl:sort select="@X" order="ascending" data-type="number" />
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="Cell">
        <xsl:choose>
            <xsl:when test="@IsHeading">
                <xsl:element name="th">
                    <xsl:call-template name="CellImpl"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="td">
                    <xsl:call-template name="CellImpl"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="CellImpl">
        <!--- Apply cell style -->
        <xsl:call-template name="CellSpanStyle"/>
        <!--- Element ID -->
        <xsl:if test="$bIncludeElementIds">
            <xsl:attribute name="id">
                <xsl:text>Cell.</xsl:text>
                <xsl:value-of select="@X"/>
                <xsl:text>.</xsl:text>
                <xsl:value-of select="@Y"/>
            </xsl:attribute>
        </xsl:if>
        <!--- CSS Class -->
        <xsl:if test="$bIncludeCSSStyles and @Class">
            <xsl:attribute name="class"><xsl:value-of select="@Class"/></xsl:attribute>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="Control[1]/Style">
                <xsl:for-each select="Control[1]">
                    <xsl:attribute name="style"><xsl:call-template name="CellStyle"/></xsl:attribute>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="Label[1]/Style">
                <xsl:for-each select="Label[1]">
                    <xsl:attribute name="style"><xsl:call-template name="CellStyle"/></xsl:attribute>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="Error[1]/Style">
                <xsl:for-each select="Error[1]">
                    <xsl:attribute name="style"><xsl:call-template name="CellStyle"/></xsl:attribute>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="Question[1]/Style">
                <xsl:for-each select="Question[1]">
                    <xsl:attribute name="style"><xsl:call-template name="CellStyle"/></xsl:attribute>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
        <xsl:for-each select="*">
            <xsl:choose>
                <xsl:when test="name() = 'Control'">
                    <xsl:apply-templates select="."/>
                </xsl:when>
                <xsl:when test="name() = 'Label'">
                    <xsl:apply-templates select=".">
                        <xsl:with-param name="sLabelClass" select="'mrQuestionText'"/>
                        <xsl:with-param name="bWithinTable" select="true()"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="name() = 'Error'">
                    <xsl:apply-templates select=".">
                        <xsl:with-param name="sLabelClass" select="'mrErrorText'"/>
                        <xsl:with-param name="bWithinTable" select="true()"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="name() = 'Table'">
                    <xsl:apply-templates select="."/>
                </xsl:when>
                <xsl:when test="name() = 'Question'">
                    <xsl:apply-templates select=".">
                        <xsl:with-param name="bWithinTable" select="true()"/>
                    </xsl:apply-templates>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="CellSpanStyle">
        <xsl:choose>
            <xsl:when test="Control[1]/Style/Cell/@ColSpan">
                <xsl:attribute name="colspan"><xsl:value-of select="Control[1]/Style/Cell/@ColSpan"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="Label[1]/Style/Cell/@ColSpan">
                <xsl:attribute name="colspan"><xsl:value-of select="Label[1]/Style/Cell/@ColSpan"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="Error[1]/Style/Cell/@ColSpan">
                <xsl:attribute name="colspan"><xsl:value-of select="Error[1]/Style/Cell/@ColSpan"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="Question[1]/Style/Cell/@ColSpan">
                <xsl:attribute name="colspan"><xsl:value-of select="Question[1]/Style/Cell/@ColSpan"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="@WeightX > 1">
                <xsl:attribute name="colspan"><xsl:value-of select="@WeightX"/></xsl:attribute>
            </xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="Control[1]/Style/Cell/@RowSpan">
                <xsl:attribute name="rowspan"><xsl:value-of select="Control[1]/Style/Cell/@RowSpan"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="Label[1]/Style/Cell/@RowSpan">
                <xsl:attribute name="rowspan"><xsl:value-of select="Label[1]/Style/Cell/@RowSpan"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="Error[1]/Style/Cell/@RowSpan">
                <xsl:attribute name="rowspan"><xsl:value-of select="Error[1]/Style/Cell/@RowSpan"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="Question[1]/Style/Cell/@RowSpan">
                <xsl:attribute name="rowspan"><xsl:value-of select="Question[1]/Style/Cell/@RowSpan"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="@WeightY > 1">
                <xsl:attribute name="rowspan"><xsl:value-of select="@WeightY"/></xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!-- SPAN LAYOUT -->
    
    <xsl:template name="SpanRow">
        <xsl:param name="Orientation" select="Column" />
        <xsl:for-each select="Row">
            <xsl:sort select="@Y" order="ascending" data-type="number"/>
            <xsl:call-template name="SpanCell">
                <xsl:with-param name="Orientation" select="$Orientation" />
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="SpanCell">
        <xsl:param name="Orientation" select="Column" />
        <xsl:for-each select="Cell">
            <xsl:sort select="@X" order="ascending" data-type="number" />
            <xsl:element name="span">
                <!--- Apply cell style -->
                <xsl:call-template name="CellSpanStyle"/>
                <!--- Element ID -->
                <xsl:if test="$bIncludeElementIds">
                    <xsl:attribute name="id">
                        <xsl:text>Cell.</xsl:text>
                        <xsl:value-of select="@X"/>
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="@Y"/>
                    </xsl:attribute>
                </xsl:if>
                <!--- CSS Class -->
                <xsl:if test="$bIncludeCSSStyles and @Class">
                    <xsl:attribute name="class">
                        <xsl:value-of select="@Class"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="Control[1]/Style">
                        <xsl:for-each select="Control[1]">
                            <xsl:attribute name="style">
                                <xsl:call-template name="CellStyle">
                                    <xsl:with-param name="bUseTablesLayout" select="false()" />
                                    <xsl:with-param name="Orientation" select="$Orientation" />
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="Label[1]/Style">
                        <xsl:for-each select="Label[1]">
                            <xsl:attribute name="style">
                                <xsl:call-template name="CellStyle"/>
                            </xsl:attribute>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="Error[1]/Style">
                        <xsl:for-each select="Error[1]">
                            <xsl:attribute name="style">
                                <xsl:call-template name="CellStyle"/>
                            </xsl:attribute>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="Question[1]/Style">
                        <xsl:for-each select="Question[1]">
                            <xsl:attribute name="style">
                                <xsl:call-template name="CellStyle"/>
                            </xsl:attribute>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
                <xsl:for-each select="*">
                    <xsl:choose>
                        <xsl:when test="name() = 'Control'">
                            <xsl:apply-templates select="."/>
                        </xsl:when>
                        <xsl:when test="name() = 'Label'">
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="sLabelClass" select="'mrQuestionText'"/>
                                <xsl:with-param name="bWithinTable" select="true()"/>
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:when test="name() = 'Error'">
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="sLabelClass" select="'mrErrorText'"/>
                                <xsl:with-param name="bWithinTable" select="true()"/>
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:when test="name() = 'Table'">
                            <xsl:apply-templates select="."/>
                        </xsl:when>
                        <xsl:when test="name() = 'Question'">
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="bWithinTable" select="true()"/>
                            </xsl:apply-templates>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <!--- CONTROL -->
    
    <xsl:template match="Control">
        <xsl:if test="Style/@ElementAlign = 'NewLine'">
            <div></div>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="@Type = 'Static'">
                <xsl:call-template name="StaticControl"/>
            </xsl:when>
            <xsl:when test="@Type = 'Edit'">
                <xsl:call-template name="EditControl"/>
            </xsl:when>
            <xsl:when test="@Type = 'SingleLineEdit'">
                <xsl:call-template name="SingleLineEditControl"/>
            </xsl:when>
            <xsl:when test="@Type = 'MultiLineEdit'">
                <xsl:call-template name="MultiLineEditControl"/>
            </xsl:when>
            <xsl:when test="@Type = 'DropList'">
                <xsl:call-template name="DropListControl"/>
            </xsl:when>
            <xsl:when test="@Type = 'ComboList'">
                <xsl:call-template name="ComboListControl"/>
            </xsl:when>
            <xsl:when test="@Type = 'RadioButton'">
                <xsl:call-template name="RadioButtonControl"/>
            </xsl:when>
            <xsl:when test="@Type = 'CheckButton'">
                <xsl:call-template name="CheckButtonControl"/>
            </xsl:when>
            <xsl:when test="@Type = 'ListBox'">
                <xsl:call-template name="ListBoxControl"/>
            </xsl:when>
            <xsl:when test="@Type = 'ListControl'">
                <xsl:call-template name="ListControlControl"/>
            </xsl:when>
            <xsl:when test="@Type = 'Button'">
                <xsl:call-template name="ButtonControl"/>
            </xsl:when>
            <xsl:when test="@Type = 'Date'">
                <xsl:call-template name="DateControl"/>
            </xsl:when>
            <xsl:when test="@Type = 'Time'">
                <xsl:call-template name="TimeControl"/>
            </xsl:when>
            <xsl:when test="@Type = 'DateTime'">
                <xsl:call-template name="DateTimeControl"/>
            </xsl:when>
            <xsl:when test="@Type = 'Password'">
                <xsl:call-template name="PasswordControl"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="StaticControl"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="StaticControl">
        <xsl:element name="span">
            <xsl:attribute name="style">
                <xsl:if test="Style/@Width or Style/@Height">
                    <xsl:call-template name="SpanStyle"/>
                </xsl:if>
                <xsl:call-template name="ControlStyle"/>
            </xsl:attribute>
            <xsl:for-each select="Category">
                <xsl:apply-templates select="Label">
                    <xsl:with-param name="sLabelClass" select="'mrShowText'"/>
                </xsl:apply-templates>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="EditControl">
        <!--- Need to decide whether to use a text area of a edit control -->
        <xsl:choose>
            <xsl:when test="number(@Length) > 40">
                <xsl:call-template name="MultiLineEditControl"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="SingleLineEditControl"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="SingleLineEditControl">
        <!--- Control Label -->
        <xsl:if test="Category[1]/Label">
            <xsl:choose>
                <xsl:when test="$bIncludeElementIds">
                    <xsl:element name="label">
                        <xsl:attribute name="for">
                            <xsl:value-of select="@ElementID"/>
                            <xsl:if test="Category[1]/@CategoryID">
                                <xsl:value-of select="Category[1]/@CategoryID"/>
                            </xsl:if>
                        </xsl:attribute>
                        <xsl:apply-templates select="Category[1]/Label">
                            <xsl:with-param name="sLabelClass" select="'mrSingleText'"/>
                        </xsl:apply-templates>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="Category[1]/Label">
                        <xsl:with-param name="sLabelClass" select="'mrSingleText'"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <!--- Edit box -->
        <xsl:element name="input">
            <!--- Set Control Type -->
            <xsl:attribute name="type">text</xsl:attribute>
            <!--- Input name -->
            <xsl:attribute name="name">
                <xsl:value-of select="@QuestionName"/>
                <xsl:if test="Category[1]/@Name">
                    <xsl:value-of select="Category[1]/@Name"/>
                </xsl:if>
            </xsl:attribute>
            <!--- ID -->
            <xsl:if test="$bIncludeElementIds">
                <xsl:attribute name="id">
                    <xsl:value-of select="@ElementID"/>
                    <xsl:if test="Category[1]/@CategoryID">
                        <xsl:value-of select="Category[1]/@CategoryID"/>
                    </xsl:if>
                </xsl:attribute>
            </xsl:if>
            <!--- Alt -->
            <xsl:if test="@Alt != ''">
                <xsl:attribute name="Alt">
                    <xsl:value-of select="@Alt"/>
                </xsl:attribute>
            </xsl:if>
            <!--- CSS Class -->
            <xsl:if test="$bIncludeCSSStyles">
                <xsl:attribute name="class">mrEdit</xsl:attribute>
            </xsl:if>
            <!--- Show Only -->
            <xsl:if test="$bShowOnly != false()">
                <xsl:attribute name="disabled"/>
            </xsl:if>
            <!--- Accelerator access key -->
            <xsl:if test="Style/Control/@Accelerator != ''">
                <xsl:attribute name="accesskey">
                    <xsl:value-of select="Style/Control/@Accelerator"/>
                </xsl:attribute>
            </xsl:if>
            <!--- AutoComplete -->
            <xsl:choose>
                <xsl:when test="$bAutoComplete = true()">
                    <xsl:attribute name="autocomplete">on</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="autocomplete">off</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <!--- Read Only -->
            <xsl:if test="Style/Control/@ReadOnly = 'true'">
                <xsl:attribute name="readonly"/>
            </xsl:if>
            <!--- Set Control Style -->
            <xsl:attribute name="style"><xsl:call-template name="ControlStyle"/></xsl:attribute>
            <!--- Max length -->
            <xsl:if test="@Length">
                <xsl:attribute name="maxlength"><xsl:value-of select="@Length"/></xsl:attribute>
            </xsl:if>
            <!--- Default text -->
            <xsl:attribute name="value">
                <xsl:choose>
                    <xsl:when test="Category[1]/@Checked = 'true'">
                        <xsl:value-of select="'*'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@Value"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="MultiLineEditControl">
        <!--- Control Label -->
        <xsl:if test="Category[1]/Label">
            <xsl:choose>
                <xsl:when test="$bIncludeElementIds">
                    <xsl:element name="label">
                        <xsl:attribute name="for">
                            <xsl:value-of select="@ElementID"/>
                            <xsl:if test="Category[1]/@CategoryID">
                                <xsl:value-of select="Category[1]/@CategoryID"/>
                            </xsl:if>
                        </xsl:attribute>
                        <xsl:apply-templates select="Category[1]/Label">
                            <xsl:with-param name="sLabelClass" select="'mrSingleText'"/>
                        </xsl:apply-templates>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="Category[1]/Label">
                        <xsl:with-param name="sLabelClass" select="'mrSingleText'"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <!--- Text Area -->
        <xsl:element name="textarea">
            <!--- Input name -->
            <xsl:attribute name="name">
                <xsl:value-of select="@QuestionName"/>
                <xsl:if test="Category[1]/@Name">
                    <xsl:value-of select="Category[1]/@Name"/>
                </xsl:if>
            </xsl:attribute>
            <!--- ID -->
            <xsl:if test="$bIncludeElementIds">
                <xsl:attribute name="id">
                    <xsl:value-of select="@ElementID"/>
                    <xsl:if test="Category[1]/@CategoryID">
                        <xsl:value-of select="Category[1]/@CategoryID"/>
                    </xsl:if>
                </xsl:attribute>
            </xsl:if>
            <!--- Alt -->
            <xsl:if test="@Alt != ''">
                <xsl:attribute name="Alt">
                    <xsl:value-of select="@Alt"/>
                </xsl:attribute>
            </xsl:if>
            <!--- CSS Class -->
            <xsl:if test="$bIncludeCSSStyles">
                <xsl:attribute name="class">mrEdit</xsl:attribute>
            </xsl:if>
            <!--- Show Only -->
            <xsl:if test="$bShowOnly != false()">
                <xsl:attribute name="disabled"/>
            </xsl:if>
            <!--- Accelerator access key -->
            <xsl:if test="Style/Control/@Accelerator != ''">
                <xsl:attribute name="accesskey">
                    <xsl:value-of select="Style/Control/@Accelerator"/>
                </xsl:attribute>
            </xsl:if>
            <!--- AutoComplete -->
            <xsl:choose>
                <xsl:when test="$bAutoComplete = true()">
                    <xsl:attribute name="autocomplete">on</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="autocomplete">off</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <!--- Read Only -->
            <xsl:if test="Style/Control/@ReadOnly = 'true'">
                <xsl:attribute name="readonly"/>
            </xsl:if>
            <!--- Set Control Style -->
            <xsl:attribute name="style"><xsl:call-template name="ControlStyle"/></xsl:attribute>
            <!--- Rows -->
            <xsl:choose >
                <xsl:when test="Style/@Rows != ''">
                    <xsl:attribute name="rows"><xsl:value-of select="Style/@Rows"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="rows"><xsl:value-of select="6"/></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <!--- Columns -->
            <xsl:choose >
                <xsl:when test="Style/@Columns != ''">
                    <xsl:attribute name="cols"><xsl:value-of select="Style/@Columns"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="cols"><xsl:value-of select="40"/></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <!--- Default text -->
            <xsl:choose>
                <xsl:when test="Category[1]/@Checked = 'true'">
                    <xsl:value-of select="'*'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@Value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="DropListControl">
        <xsl:choose>
            <xsl:when test="Style/Control/@ReadOnly = 'true'">
                <!--- Read Only Drop list is displayed as an edit box -->
                <xsl:element name="input">
                    <!--- Set Control Type -->
                    <xsl:attribute name="type">text</xsl:attribute>
                    <!--- Input name -->
                    <xsl:attribute name="name">
                        <xsl:value-of select="@QuestionName"/>
                        <xsl:if test="Category[@Checked = 'true'][1]/@Name">
                            <xsl:value-of select="Category[@Checked = 'true'][1]/@Name"/>
                        </xsl:if>
                    </xsl:attribute>
                    <!--- ID -->
                    <xsl:if test="$bIncludeElementIds">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@ElementID"/>
                            <xsl:if test="Category[@Checked = 'true'][1]/@Name">
                                <xsl:value-of select="Category[@Checked = 'true'][1]/@CategoryID"/>
                            </xsl:if>
                        </xsl:attribute>
                    </xsl:if>
                    <!--- Alt -->
                    <xsl:if test="@Alt != ''">
                        <xsl:attribute name="Alt">
                            <xsl:value-of select="@Alt"/>
                        </xsl:attribute>
                    </xsl:if>
                    <!--- CSS Class -->
                    <xsl:if test="$bIncludeCSSStyles">
                        <xsl:attribute name="class">mrDropdown</xsl:attribute>
                    </xsl:if>
                    <!--- Show Only -->
                    <xsl:if test="$bShowOnly != false()">
                        <xsl:attribute name="disabled"/>
                    </xsl:if>
                    <!--- Read Only -->
                    <xsl:attribute name="readonly"/>
                    <!--- Set Control Style -->
                    <xsl:attribute name="style"><xsl:call-template name="ControlStyle"/></xsl:attribute>
                    <!--- Default text -->
                    <xsl:attribute name="value">
                        <xsl:value-of select="Category[@Checked = 'true'][1]/Label"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="select">
                    <!--- Input name -->
                    <xsl:attribute name="name">
                        <xsl:value-of select="@QuestionName"/>
                    </xsl:attribute>
                    <!--- ID -->
                    <xsl:if test="$bIncludeElementIds">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@ElementID"/>
                        </xsl:attribute>
                    </xsl:if>
                    <!--- CSS Class -->
                    <xsl:if test="$bIncludeCSSStyles">
                        <xsl:attribute name="class">mrDropdown</xsl:attribute>
                    </xsl:if>
                    <!--- Show Only -->
                    <xsl:if test="$bShowOnly != false()">
                        <xsl:attribute name="disabled"/>
                    </xsl:if>
                    <!--- Accelerator access key -->
                    <xsl:if test="Style/Control/@Accelerator != ''">
                        <xsl:attribute name="accesskey">
                            <xsl:value-of select="Style/Control/@Accelerator"/>
                        </xsl:attribute>
                    </xsl:if>
                    <!--- Set Control Style -->
                    <xsl:attribute name="style"><xsl:call-template name="ControlStyle"/></xsl:attribute>
                    <!--- Drop list categories -->
                    <xsl:for-each select="Category">
                        <xsl:choose>
                            <xsl:when test="@CategoryList">
                                <xsl:element name="optgroup">
                                    <!--- Set Option Style -->
                                    <xsl:for-each select="Label">
                                        <xsl:attribute name="style"><xsl:call-template name="LabelStyle"/></xsl:attribute>
                                    </xsl:for-each>
                                    <!--- Set Option Class -->
                                    <xsl:attribute name="class">mrMultiple</xsl:attribute>
                                    <!--- Label -->
                                    <xsl:attribute name="label"><xsl:value-of select="Label/Text"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="option">
                                    <!--- Set Option Style -->
                                    <xsl:for-each select="Label">
                                        <xsl:attribute name="style"><xsl:call-template name="LabelStyle"/></xsl:attribute>
                                    </xsl:for-each>
                                    <!--- Set Option Class -->
                                    <xsl:attribute name="class">mrMultiple</xsl:attribute>
                                    <!--- Check if selected -->
                                    <xsl:if test="@Checked = 'true'">
                                        <xsl:attribute name="selected"/>
                                    </xsl:if>
                                    <xsl:choose>
                                        <xsl:when test="@IsHeading">
                                            <!--- Option value -->
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="''"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="@Name"/>
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:for-each select="Label"><xsl:call-template name="LabelText"/></xsl:for-each>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="ComboListControl">
        <br /><B>ComboList NOT IMPLEMENTED</B>
    </xsl:template>
    
    <xsl:template name="RadioButtonControl">
        <!--- Control Label -->
        <xsl:element name="input">
            <!--- Set Control Type -->
            <xsl:attribute name="type">radio</xsl:attribute>
            <!--- Input name -->
            <xsl:attribute name="name">
                <xsl:value-of select="@QuestionName"/>
            </xsl:attribute>
            <!--- ID -->
            <xsl:if test="$bIncludeElementIds">
                <xsl:attribute name="id">
                    <xsl:value-of select="@ElementID"/>
                    <xsl:if test="Category[1]/@CategoryID">
                        <xsl:value-of select="Category[1]/@CategoryID"/>
                    </xsl:if>
                </xsl:attribute>
            </xsl:if>
            <!--- Alt -->
            <xsl:if test="@Alt != ''">
                <xsl:attribute name="Alt">
                    <xsl:value-of select="@Alt"/>
                </xsl:attribute>
            </xsl:if>
            <!--- CSS Class -->
            <xsl:if test="$bIncludeCSSStyles">
                <xsl:attribute name="class">mrSingle</xsl:attribute>
            </xsl:if>
            <!--- Show Only -->
            <xsl:if test="$bShowOnly != false()">
                <xsl:attribute name="disabled"/>
            </xsl:if>
            <!--- Read Only -->
            <xsl:if test="Style/Control/@ReadOnly = 'true'">
                <xsl:attribute name="disabled"/>
            </xsl:if>
            <!--- Accelerator access key -->
            <xsl:if test="Style/Control/@Accelerator != ''">
                <xsl:attribute name="accesskey">
                    <xsl:value-of select="Style/Control/@Accelerator"/>
                </xsl:attribute>
            </xsl:if>
            <!--- Set Control Style -->
            <xsl:attribute name="style"><xsl:call-template name="ControlStyle"/></xsl:attribute>
            <!--- Button Category -->
            <xsl:attribute name="value">
                <xsl:if test="Category[1]/@Name"><xsl:value-of select="Category[1]/@Name"/></xsl:if>
            </xsl:attribute>
            <!--- Is Button Checked -->
            <xsl:if test="Category[1]/@Checked = 'true'">
                <xsl:attribute name="checked"/>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$bIncludeElementIds and Category[1]/Label">
                    <xsl:element name="label">
                        <xsl:attribute name="for">
                            <xsl:value-of select="@ElementID"/>
                            <xsl:if test="Category[1]/@CategoryID">
                                <xsl:value-of select="Category[1]/@CategoryID"/>
                            </xsl:if>
                        </xsl:attribute>
                        <xsl:apply-templates select="Category[1]/Label">
                            <xsl:with-param name="sLabelClass" select="'mrSingleText'"/>
                        </xsl:apply-templates>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="Category[1]/Label">
                        <xsl:with-param name="sLabelClass" select="'mrSingleText'"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="CheckButtonControl">
        <!--- Control Label -->
        <xsl:element name="input">
            <!--- Set Control Type -->
            <xsl:attribute name="type">checkbox</xsl:attribute>
            <!--- Input name -->
            <xsl:attribute name="name">
                <xsl:value-of select="@QuestionName"/>
                <xsl:if test="Category[1]/@Name">
                    <xsl:value-of select="Category[1]/@Name"/>
                </xsl:if>
            </xsl:attribute>
            <!--- ID -->
            <xsl:if test="$bIncludeElementIds">
                <xsl:attribute name="id">
                    <xsl:value-of select="@ElementID"/>
                    <xsl:if test="Category[1]/@CategoryID">
                        <xsl:value-of select="Category[1]/@CategoryID"/>
                    </xsl:if>
                </xsl:attribute>
            </xsl:if>
            <!--- Alt -->
            <xsl:if test="@Alt != ''">
                <xsl:attribute name="Alt">
                    <xsl:value-of select="@Alt"/>
                </xsl:attribute>
            </xsl:if>
            <!--- CSS Class -->
            <xsl:if test="$bIncludeCSSStyles">
                <xsl:attribute name="class">mrMultiple</xsl:attribute>
            </xsl:if>
            <!--- Show Only -->
            <xsl:if test="$bShowOnly != false()">
                <xsl:attribute name="disabled"/>
            </xsl:if>
            <!--- Read Only -->
            <xsl:if test="Style/Control/@ReadOnly = 'true'">
                <xsl:attribute name="disabled"/>
            </xsl:if>
            <!--- Accelerator access key -->
            <xsl:if test="Style/Control/@Accelerator != ''">
                <xsl:attribute name="accesskey">
                    <xsl:value-of select="Style/Control/@Accelerator"/>
                </xsl:attribute>
            </xsl:if>
            <!--- Set Control Style -->
            <xsl:attribute name="style"><xsl:call-template name="ControlStyle"/></xsl:attribute>
            <!--- Button Category -->
            <xsl:attribute name="value">
                <xsl:if test="Category[1]/@Name"><xsl:value-of select="Category[1]/@Name"/></xsl:if>
            </xsl:attribute>
            <!--- Is Button Checked -->
            <xsl:if test="Category[1]/@Checked = 'true'">
                <xsl:attribute name="checked"/>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$bIncludeElementIds and Category[1]/Label">
                    <xsl:element name="label">
                        <xsl:attribute name="for">
                            <xsl:value-of select="@ElementID"/>
                            <xsl:if test="Category[1]/@CategoryID">
                                <xsl:value-of select="Category[1]/@CategoryID"/>
                            </xsl:if>
                        </xsl:attribute>
                        <xsl:apply-templates select="Category[1]/Label">
                            <xsl:with-param name="sLabelClass" select="'mrMultipleText'"/>
                        </xsl:apply-templates>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="Category[1]/Label">
                        <xsl:with-param name="sLabelClass" select="'mrMultipleText'"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="ListBoxControl">
        <xsl:element name="select">
            <xsl:attribute name="size">4</xsl:attribute>
            <xsl:attribute name="multiple"/>
            <!--- Input name -->
            <xsl:attribute name="name">
                <xsl:value-of select="@QuestionName"/>
            </xsl:attribute>
            <!--- ID -->
            <xsl:if test="$bIncludeElementIds">
                <xsl:attribute name="id">
                    <xsl:value-of select="@ElementID"/>
                </xsl:attribute>
            </xsl:if>
            <!--- Alt -->
            <xsl:if test="@Alt != ''">
                <xsl:attribute name="Alt">
                    <xsl:value-of select="@Alt"/>
                </xsl:attribute>
            </xsl:if>
            <!--- CSS Class -->
            <xsl:if test="$bIncludeCSSStyles">
                <xsl:attribute name="class">mrListBox</xsl:attribute>
            </xsl:if>
            <!--- Show Only -->
            <xsl:if test="$bShowOnly != false()">
                <xsl:attribute name="disabled"/>
            </xsl:if>
            <!--- Accelerator access key -->
            <xsl:if test="Style/Control/@Accelerator != ''">
                <xsl:attribute name="accesskey">
                    <xsl:value-of select="Style/Control/@Accelerator"/>
                </xsl:attribute>
            </xsl:if>
            <!--- Set Control Style -->
            <xsl:attribute name="style"><xsl:call-template name="ControlStyle"/></xsl:attribute>
            <!--- List box categories -->
            <xsl:for-each select="Category">
                <xsl:choose>
                    <xsl:when test="@CategoryList">
                        <xsl:element name="optgroup">
                            <!--- Set Option Style -->
                            <xsl:for-each select="Label">
                                <xsl:attribute name="style"><xsl:call-template name="LabelStyle"/></xsl:attribute>
                            </xsl:for-each>
                            <!--- Set Option Class -->
                            <xsl:attribute name="class">mrMultiple</xsl:attribute>
                            <!--- Label -->
                            <xsl:attribute name="label"><xsl:value-of select="Label/Text"/></xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="option">
                            <!--- Set Option Style -->
                            <xsl:for-each select="Label">
                                <xsl:attribute name="style"><xsl:call-template name="LabelStyle"/></xsl:attribute>
                            </xsl:for-each>
                            <!--- Set Option Class -->
                            <xsl:attribute name="class">mrMultiple</xsl:attribute>
                            <!--- Check if selected -->
                            <xsl:if test="@Checked = 'true'">
                                <xsl:attribute name="selected"/>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="@IsHeading">
                                    <!--- Option value -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="''"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="@Name"/>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:for-each select="Label"><xsl:call-template name="LabelText"/></xsl:for-each>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="ListControlControl">
        <br /><B>ListControl NOT IMPLEMENTED</B>
    </xsl:template>
    
    <xsl:template name="ButtonControl">
        <xsl:choose>
            <xsl:when test="Style/@Image != ''">
                <!--- Image control buttons -->
                <xsl:element name="input">
                    <xsl:attribute name="type">image</xsl:attribute>
                    <!--- Input name -->
                    <xsl:attribute name="name">
                        <xsl:value-of select="@QuestionName"/>
                        <xsl:if test="Category[1]/@Name">
                            <xsl:value-of select="Category[1]/@Name"/>
                        </xsl:if>
                    </xsl:attribute>
                    <!--- ID -->
                    <xsl:if test="$bIncludeElementIds">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@ElementID"/>
                            <xsl:if test="Category[1]/@CategoryID">
                                <xsl:value-of select="Category[1]/@CategoryID"/>
                            </xsl:if>
                        </xsl:attribute>
                    </xsl:if>
                    <!--- Alt -->
                    <xsl:if test="@Alt != ''">
                        <xsl:attribute name="Alt">
                            <xsl:value-of select="@Alt"/>
                        </xsl:attribute>
                    </xsl:if>
                    <!--- CSS Class -->
                    <xsl:if test="$bIncludeCSSStyles">
                        <xsl:attribute name="sLabelClass">mrSingleText</xsl:attribute>
                    </xsl:if>
                    <!--- Show Only -->
                    <xsl:if test="$bShowOnly != false()">
                        <xsl:attribute name="disabled"/>
                    </xsl:if>
                    <!--- Accelerator access key -->
                    <xsl:if test="Style/Control/@Accelerator != ''">
                        <xsl:attribute name="accesskey">
                            <xsl:value-of select="Style/Control/@Accelerator"/>
                        </xsl:attribute>
                    </xsl:if>
                    <!--- Image control style -->
                    <xsl:attribute name="style">
                        <xsl:call-template name="ControlStyle"/>
                        <xsl:for-each select="Category[1]/Label">
                            <xsl:call-template name="BlockStyle"/>
                        </xsl:for-each>
                    </xsl:attribute>
                    <!--- Src text -->
                    <xsl:attribute name="src">
                        <xsl:if test="not((starts-with(Style/@Image, 'http:'))or(starts-with(Style/@Image, 'https:')))">
                            <xsl:value-of select="$sImageLocation"/>
                        </xsl:if>
                        <xsl:value-of select="Style/@Image"/>
                    </xsl:attribute>
                    <!--- Input value -->
                    <xsl:if test="Category[1]/@Name">
                        <xsl:attribute name="value"><xsl:value-of select="Category[1]/@Name"/></xsl:attribute>
                    </xsl:if>
                    <!--- Alt text -->
                    <xsl:attribute name="alt"><xsl:value-of select="Category/Label/Text"/></xsl:attribute>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="input">
                    <xsl:attribute name="type">submit</xsl:attribute>
                    <!--- Input name -->
                    <xsl:attribute name="name">
                        <xsl:value-of select="@QuestionName"/>
                        <xsl:if test="Category[1]/@Name">
                            <xsl:value-of select="Category[1]/@Name"/>
                        </xsl:if>
                    </xsl:attribute>
                    <!--- ID -->
                    <xsl:if test="$bIncludeElementIds">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@ElementID"/>
                            <xsl:if test="Category[1]/@CategoryID">
                                <xsl:value-of select="Category[1]/@CategoryID"/>
                            </xsl:if>
                        </xsl:attribute>
                    </xsl:if>
                    <!--- CSS Class -->
                    <xsl:if test="$bIncludeCSSStyles">
                        <xsl:attribute name="sLabelClass">mrSingleText</xsl:attribute>
                    </xsl:if>
                    <!--- Show Only -->
                    <xsl:if test="$bShowOnly != false()">
                        <xsl:attribute name="disabled"/>
                    </xsl:if>
                    <!--- Accelerator access key -->
                    <xsl:if test="Style/Control/@Accelerator != ''">
                        <xsl:attribute name="accesskey">
                            <xsl:value-of select="Style/Control/@Accelerator"/>
                        </xsl:attribute>
                    </xsl:if>
                    <!--- Button style -->
                    <xsl:attribute name="style">
                        <xsl:call-template name="ControlStyle"/>
                        <xsl:for-each select="Category[1]/Label">
                            <xsl:call-template name="LabelStyle"/>
                            <xsl:call-template name="BlockStyle"/>
                        </xsl:for-each>
                    </xsl:attribute>
                    <!--- Button Label -->
                    <xsl:attribute name="value"><xsl:value-of select="Category/Label/Text"/></xsl:attribute>
                    <!--- Alt text -->
                    <xsl:attribute name="alt"><xsl:value-of select="Category/Label/Text"/></xsl:attribute>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="DateControl">
        <br /><B>Date NOT IMPLEMENTED</B>
    </xsl:template>
    
    <xsl:template name="TimeControl">
        <br /><B>Time NOT IMPLEMENTED</B>
    </xsl:template>
    
    <xsl:template name="DateTimeControl">
        <br /><B>DateTime NOT IMPLEMENTED</B>
    </xsl:template>
    
    <xsl:template name="PasswordControl">
        <!--- Control Label -->
        <xsl:choose>
            <xsl:when test="$bIncludeElementIds and Category[1]/Label">
                <xsl:element name="label">
                    <xsl:attribute name="for">
                        <xsl:value-of select="@ElementID"/>
                        <xsl:if test="Category[1]/@CategoryID">
                            <xsl:value-of select="Category[1]/@CategoryID"/>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:apply-templates select="Category[1]/Label"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="Category[1]/Label"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:element name="input">
            <!--- Set Control Type -->
            <xsl:attribute name="type">password</xsl:attribute>
            <!--- Input name -->
            <xsl:attribute name="name">
                <xsl:value-of select="@QuestionName"/>
                <xsl:if test="Category[1]/@Name">
                    <xsl:value-of select="Category[1]/@Name"/>
                </xsl:if>
            </xsl:attribute>
            <!--- ID -->
            <xsl:if test="$bIncludeElementIds">
                <xsl:attribute name="id">
                    <xsl:value-of select="@ElementID"/>
                    <xsl:if test="Category[1]/@CategoryID">
                        <xsl:value-of select="Category[1]/@CategoryID"/>
                    </xsl:if>
                </xsl:attribute>
            </xsl:if>
            <!--- CSS Class -->
            <xsl:if test="$bIncludeCSSStyles">
                <xsl:attribute name="class">mrEdit</xsl:attribute>
            </xsl:if>
            <!--- Show Only -->
            <xsl:if test="$bShowOnly != false()">
                <xsl:attribute name="disabled"/>
            </xsl:if>
            <!--- Accelerator access key -->
            <xsl:if test="Style/Control/@Accelerator != ''">
                <xsl:attribute name="accesskey">
                    <xsl:value-of select="Style/Control/@Accelerator"/>
                </xsl:attribute>
            </xsl:if>
            <!--- AutoComplete -->
            <xsl:choose>
                <xsl:when test="$bAutoComplete = true()">
                    <xsl:attribute name="autocomplete">on</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="autocomplete">off</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <!--- Read Only -->
            <xsl:if test="Style/Control/@ReadOnly = 'true'"><xsl:attribute name="readonly"></xsl:attribute></xsl:if>
            <!--- Set Control Style -->
            <xsl:attribute name="style"><xsl:call-template name="ControlStyle"/></xsl:attribute>
            <!--- Max number of characters -->
            <xsl:if test="@Length">
                <xsl:attribute name="maxlength"><xsl:value-of select="@Length"/></xsl:attribute>
            </xsl:if>
            <!--- Default text -->
            <xsl:attribute name="value"><xsl:choose>
                <xsl:when test="Category[1]/@Checked = 'true'">
                    <xsl:value-of select="'*'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@Value"/>
                </xsl:otherwise>
            </xsl:choose>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <!--- Style Templates -->
    
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
    
    <xsl:template name="ControlStyle">
        <!--- adds the control styles to a style attribute -->
        <xsl:call-template name="LabelStyle"/>
    </xsl:template>
    
    <xsl:template name="TableStyle">
        <!--- adds the table styles to a style attribute -->
        <xsl:call-template name="LabelStyle"/>
    </xsl:template>
    
    <xsl:template name="CellStyle">
        <!--- adds the cell styles to a style attribute -->
        <xsl:param name="bUseTablesLayout" select="true()"/>
        <xsl:param name="Orientation" select="Column" />
        <xsl:choose>
            <xsl:when test="not($bUseTablesLayout)">
                <xsl:if test="$Orientation = 'Row'">
                    <!-- spans in single row -->
                    <xsl:text>display:inline-block;</xsl:text>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
        <xsl:call-template name="BlockStyle"/>
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