<?xml version="1.0" encoding="UTF-8"?>
<xsd:schema elementFormDefault="qualified" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <xsd:element name="Questions">
        <xsd:annotation>
            <xsd:documentation>Questions element contains the questions for the current page</xsd:documentation>
        </xsd:annotation>
        <xsd:complexType>
            <xsd:choice minOccurs="0" maxOccurs="unbounded">
                <xsd:element ref="Question" />
            </xsd:choice>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="Question">
        <xsd:annotation>
            <xsd:documentation>The Question element is used to represent a question in the interview</xsd:documentation>
        </xsd:annotation>
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element ref="Style" minOccurs="0" />
                <xsd:element name="Label" type="Label" minOccurs="0" />
                <xsd:element name="Error" type="Label" minOccurs="0" maxOccurs="unbounded" />
                <xsd:element ref="Table" minOccurs="0" />
                <xsd:element ref="Questions" minOccurs="0" />
                <xsd:element ref="Control" minOccurs="0" maxOccurs="unbounded" />
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="Table">
        <xsd:annotation>
            <xsd:documentation>The definition of a question table</xsd:documentation>
        </xsd:annotation>
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element ref="Row" maxOccurs="unbounded" />
            </xsd:sequence>
            <xsd:attribute name="Summary" type="xsd:string" use="optional" />
            <xsd:attribute name="UseTablesLayout" type="xsd:boolean" use="optional" />
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="Row">
        <xsd:annotation>
            <xsd:documentation>The defintion of a table row</xsd:documentation>
        </xsd:annotation>
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element ref="Cell" maxOccurs="unbounded" />
            </xsd:sequence>
            <xsd:attribute name="Y" type="xsd:long" use="optional" />
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="Cell">
        <xsd:annotation>
            <xsd:documentation>The definition of a table cell</xsd:documentation>
        </xsd:annotation>
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element name="Label" type="Label" minOccurs="0" />
                <xsd:element name="Error" type="Label" minOccurs="0" maxOccurs="unbounded" />
                <xsd:element ref="Control" minOccurs="0" maxOccurs="unbounded" />
                <xsd:element ref="Table" minOccurs="0" maxOccurs="unbounded" />
            </xsd:sequence>
            <xsd:attribute name="X" type="xsd:long" use="required" />
            <xsd:attribute name="Y" type="xsd:long" use="required" />
            <xsd:attribute name="Class" type="xsd:string" use="optional" />
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="Control">
        <xsd:annotation>
            <xsd:documentation>The definition of a question control</xsd:documentation>
        </xsd:annotation>
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element ref="Style" minOccurs="0" />
                <xsd:element ref="Category" minOccurs="0" maxOccurs="unbounded" />
            </xsd:sequence>
            <xsd:attribute name="Type" type="ControlTypes" use="required" />
            <xsd:attribute name="QuestionName" type="xsd:string" use="required" />
            <xsd:attribute name="ElementID" type="xsd:string" use="optional" />
            <xsd:attribute name="Value" type="xsd:string" use="optional" />
            <xsd:attribute name="Length" type="xsd:long" use="optional" />
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="Category">
        <xsd:annotation>
            <xsd:documentation>The defintion of a control category</xsd:documentation>
        </xsd:annotation>
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element name="Label" type="Label" minOccurs="0" />
            </xsd:sequence>
            <xsd:attribute name="Name" type="xsd:string" use="required" />
            <xsd:attribute name="CategoryID" type="xsd:string" use="required" />
            <xsd:attribute name="Checked" type="xsd:string" use="optional" />
        </xsd:complexType>
    </xsd:element>
    <xsd:complexType name="Label">
        <xsd:annotation>
            <xsd:documentation>A element type which is used to set a label for questions, banners, errors, and navigation controls</xsd:documentation>
        </xsd:annotation>
        <xsd:sequence>
            <xsd:element ref="Style" />
            <xsd:element name="Text" />
        </xsd:sequence>
    </xsd:complexType>
    <xsd:element name="Style">
        <xsd:annotation>
            <xsd:documentation>The Style element is used to set presentation styles for Question element</xsd:documentation>
        </xsd:annotation>
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element name="Control" minOccurs="0">
                    <xsd:complexType>
                        <xsd:attribute name="Type" type="ControlTypes" use="optional" />
                        <xsd:attribute name="ReadOnly" type="xsd:boolean" use="optional" />
                        <xsd:attribute name="Accelerator" type="xsd:long" use="optional" />
                    </xsd:complexType>
                </xsd:element>
                <xsd:element name="Cell" minOccurs="0">
                    <xsd:complexType>
                        <xsd:attribute name="Width" type="xsd:string" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="Height" type="xsd:string" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="BgColor" type="xsd:string" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="BorderColor" type="xsd:string" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="BorderLeftColor" type="xsd:string" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="BorderRightColor" type="xsd:string" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="BorderTopColor" type="xsd:string" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="BorderBottomColor" type="xsd:string" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="BorderStyle" type="BorderStyles" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="BorderLeftStyle" type="BorderStyles" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="BorderRightStyle" type="BorderStyles" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="BorderTopStyle" type="BorderStyles" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="BorderBottomStyle" type="BorderStyles" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="BorderWidth" type="xsd:long" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="BorderLeftWidth" type="xsd:long" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="BorderRightWidth" type="xsd:long" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="BorderTopWidth" type="xsd:long" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="BorderBottomWidth" type="xsd:long" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="Padding" type="xsd:long" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="PaddingLeft" type="xsd:long" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="PaddingRight" type="xsd:long" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="PaddingTop" type="xsd:long" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="PaddingBottom" type="xsd:long" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="Wrap" type="xsd:boolean" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="ColSpan" type="xsd:long" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="RowSpan" type="xsd:long" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="RepeatHeader" type="xsd:long" use="optional">
                        </xsd:attribute>
                        <xsd:attribute name="RepeatSideHeader">
                        </xsd:attribute>
                    </xsd:complexType>
                </xsd:element>
                <xsd:element name="Font" minOccurs="0">
                    <xsd:complexType>
                        <xsd:attribute name="Family" type="xsd:string" use="optional" />
                        <xsd:attribute name="Size" type="xsd:long" use="optional" />
                        <xsd:attribute name="IsUnderline" type="xsd:boolean" use="optional" />
                        <xsd:attribute name="IsItalic" type="xsd:boolean" use="optional" />
                        <xsd:attribute name="IsBold" type="xsd:boolean" use="optional" />
                        <xsd:attribute name="IsStrikethrough" type="xsd:boolean" use="optional" />
                        <xsd:attribute name="IsOverline" type="xsd:boolean" use="optional" />
                        <xsd:attribute name="IsBlink" type="xsd:boolean" use="optional" />
                        <xsd:attribute name="IsSuperScript" type="xsd:boolean" use="optional" />
                        <xsd:attribute name="IsSubscript" type="xsd:boolean" use="optional" />
                    </xsd:complexType>
                </xsd:element>
                <xsd:element name="Audio" minOccurs="0">
                    <xsd:complexType>
                        <xsd:attribute name="Name" type="xsd:string">
                        </xsd:attribute>
                        <xsd:attribute name="PlayControlPosition" type="AudioControlPositions">
                        </xsd:attribute>
                        <xsd:attribute name="RecordControlPosition" type="AudioControlPositions">
                        </xsd:attribute>
                        <xsd:attribute name="Record" type="RecordModes">
                        </xsd:attribute>
                    </xsd:complexType>
                </xsd:element>
            </xsd:sequence>
            <xsd:attribute name="Color" type="xsd:string" use="optional" />
            <xsd:attribute name="BgColor" type="xsd:string" use="optional" />
            <xsd:attribute name="Hidden" type="xsd:boolean" use="optional" />
            <xsd:attribute name="Align" type="Alignments" use="optional" />
            <xsd:attribute name="VerticalAlign" type="VerticalAlignments" use="optional" />
            <xsd:attribute name="ElementAlign" type="ElementAlignments" use="optional" />
            <xsd:attribute name="Orientation" type="Orientations" use="optional" />
            <xsd:attribute name="Indent" type="xsd:long" use="optional" />
            <xsd:attribute name="ZIndex" type="xsd:long" use="optional" />
            <xsd:attribute name="Cursor" type="CursorStyles" use="optional" />
            <xsd:attribute name="Image" type="xsd:string" use="optional" />
            <xsd:attribute name="ImagePosition" type="ImagePositions" use="optional" />
            <xsd:attribute name="Rows" type="xsd:long" use="optional" />
            <xsd:attribute name="Columns" type="xsd:long" use="optional" />
            <xsd:attribute name="Width" type="xsd:string" use="optional" />
            <xsd:attribute name="Height" type="xsd:string" use="optional" />
        </xsd:complexType>
    </xsd:element>
    <xsd:simpleType name="Alignments">
        <xsd:annotation>
            <xsd:documentation>Constant values for alignment in styles</xsd:documentation>
        </xsd:annotation>
        <xsd:restriction base="xsd:string">
            <xsd:enumeration value="AlignLeft" />
            <xsd:enumeration value="AlignCenter" />
            <xsd:enumeration value="AlignRight" />
            <xsd:enumeration value="AlignJustify" />
        </xsd:restriction>
    </xsd:simpleType>
    <xsd:simpleType name="CursorStyles">
        <xsd:annotation>
            <xsd:documentation>Constant values for different cursor types</xsd:documentation>
        </xsd:annotation>
        <xsd:restriction base="xsd:string">
            <xsd:enumeration value="Auto" />
            <xsd:enumeration value="CrossHair" />
            <xsd:enumeration value="Default" />
            <xsd:enumeration value="Hand" />
            <xsd:enumeration value="Move" />
            <xsd:enumeration value="EResize" />
            <xsd:enumeration value="NEResize" />
            <xsd:enumeration value="NResize" />
            <xsd:enumeration value="NWResize" />
            <xsd:enumeration value="WResize" />
            <xsd:enumeration value="SWResize" />
            <xsd:enumeration value="SResize" />
            <xsd:enumeration value="SEResize" />
            <xsd:enumeration value="Text" />
            <xsd:enumeration value="Wait" />
            <xsd:enumeration value="Help" />
        </xsd:restriction>
    </xsd:simpleType>
    <xsd:simpleType name="BorderStyles">
        <xsd:annotation>
            <xsd:documentation>Constant values for different types of borders</xsd:documentation>
        </xsd:annotation>
        <xsd:restriction base="xsd:string">
            <xsd:enumeration value="None" />
            <xsd:enumeration value="Solid" />
            <xsd:enumeration value="Double" />
            <xsd:enumeration value="Groove" />
            <xsd:enumeration value="Ridge" />
            <xsd:enumeration value="Inset" />
            <xsd:enumeration value="Outset" />
        </xsd:restriction>
    </xsd:simpleType>
    <xsd:simpleType name="ControlTypes">
        <xsd:annotation>
            <xsd:documentation>Constant values for different types of borders</xsd:documentation>
        </xsd:annotation>
        <xsd:restriction base="xsd:string">
            <xsd:enumeration value="Static" />
            <xsd:enumeration value="Edit" />
            <xsd:enumeration value="SingleLineEdit"/>
            <xsd:enumeration value="MultiLineEdit"/>
            <xsd:enumeration value="DropList" />
            <xsd:enumeration value="ComboList" />
            <xsd:enumeration value="RadioButton" />
            <xsd:enumeration value="CheckButton" />
            <xsd:enumeration value="ListBox" />
            <xsd:enumeration value="ListControl" />
            <xsd:enumeration value="Button" />
            <xsd:enumeration value="Date" />
            <xsd:enumeration value="Time" />
            <xsd:enumeration value="DateTime" />
            <xsd:enumeration value="Password" />
        </xsd:restriction>
    </xsd:simpleType>
    <xsd:simpleType name="CategoryTypes">
        <xsd:annotation>
            <xsd:documentation>Constant values for alignment in styles</xsd:documentation>
        </xsd:annotation>
        <xsd:restriction base="xsd:string">
            <xsd:enumeration value="Category" />
            <xsd:enumeration value="CategoryList" />
        </xsd:restriction>
    </xsd:simpleType>
    <xsd:simpleType name="QuestionTypes">
        <xsd:annotation>
            <xsd:documentation>Constant values for alignment in styles</xsd:documentation>
        </xsd:annotation>
        <xsd:restriction base="xsd:string">
            <xsd:enumeration value="Simple" />
            <xsd:enumeration value="LoopCategorical" />
            <xsd:enumeration value="LoopNumeric" />
            <xsd:enumeration value="Compound" />
            <xsd:enumeration value="Block" />
            <xsd:enumeration value="Page" />
        </xsd:restriction>
    </xsd:simpleType>
    <xsd:simpleType name="Orientations">
        <xsd:annotation>
            <xsd:documentation>Constant values for orientation in styles</xsd:documentation>
        </xsd:annotation>
        <xsd:restriction base="xsd:string">
            <xsd:enumeration value="Column" />
            <xsd:enumeration value="Row" />
        </xsd:restriction>
    </xsd:simpleType>
    <xsd:simpleType name="VerticalAlignments">
        <xsd:annotation>
            <xsd:documentation>Constant values for vertical alignment in styles</xsd:documentation>
        </xsd:annotation>
        <xsd:restriction base="xsd:string">
            <xsd:enumeration value="Baseline" />
            <xsd:enumeration value="Middle" />
            <xsd:enumeration value="Sub" />
            <xsd:enumeration value="Super" />
            <xsd:enumeration value="TextTop" />
            <xsd:enumeration value="TextBottom" />
            <xsd:enumeration value="Top" />
            <xsd:enumeration value="Bottom" />
        </xsd:restriction>
    </xsd:simpleType>
    <xsd:simpleType name="ElementAlignments">
        <xsd:annotation>
            <xsd:documentation>Constant values for element alignment in styles</xsd:documentation>
        </xsd:annotation>
        <xsd:restriction base="xsd:string">
            <xsd:enumeration value="Default" />
            <xsd:enumeration value="Left" />
            <xsd:enumeration value="NewLine" />
        </xsd:restriction>
    </xsd:simpleType>
    <xsd:simpleType name="ImagePositions">
        <xsd:annotation>
            <xsd:documentation>Constant values for an image position</xsd:documentation>
        </xsd:annotation>
        <xsd:restriction base="xsd:string">
            <xsd:enumeration value="Only" />
            <xsd:enumeration value="Left" />
            <xsd:enumeration value="Right" />
            <xsd:enumeration value="Top" />
            <xsd:enumeration value="Bottom" />
            <xsd:enumeration value="None" />
        </xsd:restriction>
    </xsd:simpleType>
    <xsd:simpleType name="AudioControlPositions">
        <xsd:annotation>
            <xsd:documentation>Constant values for audio control position</xsd:documentation>
        </xsd:annotation>
        <xsd:restriction base="xsd:string">
            <xsd:enumeration value="Left" />
            <xsd:enumeration value="Right" />
            <xsd:enumeration value="Top" />
            <xsd:enumeration value="Bottom" />
        </xsd:restriction>
    </xsd:simpleType>
    <xsd:simpleType name="RecordModes">
        <xsd:annotation>
            <xsd:documentation>Constant values for audio record mode</xsd:documentation>
        </xsd:annotation>
        <xsd:restriction base="xsd:string">
            <xsd:enumeration value="None" />
            <xsd:enumeration value="Manual" />
            <xsd:enumeration value="Auto" />
            <xsd:enumeration value="Prohibited" />
        </xsd:restriction>
    </xsd:simpleType>
</xsd:schema>