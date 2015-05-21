<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="iso-8859-1" indent="yes"/>
	<xsl:template match="/" xmlns:b="http://knx.org/xml/project/11">
		<xsl:for-each select="b:KNX/b:Project/b:Installations/b:Installation/b:Topology">
			<datapoints>
				<xsl:for-each
					select="b:Area/b:Line/b:DeviceInstance/b:ComObjectInstanceRefs/b:ComObjectInstanceRef/b:Connectors">
					<xsl:variable name="verz"
						select="document(concat(substring(../@RefId,0,7),'/',substring-before(../@RefId, '_O'), '.xml'))/b:KNX/b:ManufacturerData/b:Manufacturer/b:ApplicationPrograms/b:ApplicationProgram/b:Static/b:ComObjectTable/b:ComObject[@Id = ../../b:ComObjectRefs/b:ComObjectRef[@Id = current()/../@RefId]/@RefId]"/>
					<xsl:variable name="grosse">
						<xsl:choose>
							<xsl:when test="substring-after($verz/@ObjectSize,' ') = 'Bytes'">
								<xsl:value-of select="substring-before($verz/@ObjectSize,' ')*8"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-before($verz/@ObjectSize,' ')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="master"
						select="document('knx_master.xml')/b:KNX/b:MasterData/b:DatapointTypes/b:DatapointType[@SizeInBit = $grosse]"/>
					<xsl:variable name="master2"
						select="document('knx_master.xml')/b:KNX/b:MasterData/b:DatapointTypes/b:DatapointType/b:DatapointSubtypes/b:DatapointSubtype[@Id = current()/../@DatapointType]"/>
					<xsl:variable name="master3"
						select="document('knx_master.xml')/b:KNX/b:MasterData/b:DatapointTypes/b:DatapointType[@Id = current()/../@DatapointType]"/>
					<xsl:variable name="graddress"
						select="/b:KNX/b:Project/b:Installations/b:Installation/b:GroupAddresses/b:GroupRanges/b:GroupRange/b:GroupRange"/>
					<xsl:variable name="buildingpart"
						select="/b:KNX/b:Project/b:Installations/b:Installation/b:Buildings//b:DeviceInstanceRef[@RefId = current()/../../../@Id]"/>
					<datapoint>
						<xsl:attribute name="stateBased">
							<xsl:value-of select="'true'"/>
						</xsl:attribute>
						<xsl:attribute name="name">
							<xsl:for-each select="b:Send">
								<xsl:value-of
									select="translate($graddress/b:GroupAddress[@Id = current()/@GroupAddressRefId]/@Name, ' /()', '')"
								/>
							</xsl:for-each>
						</xsl:attribute>
						<xsl:attribute name="desc">
							<xsl:value-of select="$verz/@Name"/>
						</xsl:attribute>
						<xsl:attribute name="mainNumber">
							<xsl:choose>
								<xsl:when test="../@DatapointType != ''">
									<xsl:choose>
										<xsl:when test="string-length(../@DatapointType) > 5">
											<xsl:value-of select="$master2/../../@Number"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$master3/@Number"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$master/@Number"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="dptID">
							<xsl:choose>
								<xsl:when test="../@DatapointType != ''">
									<xsl:choose>
										<xsl:when test="string-length(../@DatapointType) > 5">
											<xsl:value-of
												select="concat($master2/../../@Number, '.',format-number($master2/@Number, '000') )"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat($master3/@Number, '.001')"
											/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="concat($master/@Number,'.',format-number($master/b:DatapointSubtypes/b:DatapointSubtype/@Number, '000'))"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="priority">
							<xsl:choose>
								<xsl:when test="../@Priority">
									<xsl:value-of select="../@Priority"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$verz/@Priority"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="actionName">
							<xsl:choose>
								<xsl:when test="../@DatapointType != ''">
									<xsl:choose>
										<xsl:when test="string-length(../@DatapointType) > 5">
											<xsl:value-of select="$master2/@Name"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$master3/@Name"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="$master/b:DatapointSubtypes/b:DatapointSubtype/@Name"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="actionDesc">
							<xsl:choose>
								<xsl:when test="../@DatapointType != ''">
									<xsl:choose>
										<xsl:when test="string-length(../@DatapointType) > 5">
											<xsl:value-of select="$master2/@Text"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$master3/@Text"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="$master/b:DatapointSubtypes/b:DatapointSubtype/@Text"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="dptDesc">
							<xsl:choose>
								<xsl:when test="../@DatapointType != ''">
									<xsl:choose>
										<xsl:when test="string-length(../@DatapointType) > 5">
											<xsl:value-of select="$master2/../../@Text"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$master3/@Text"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$master/@Text"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="dptBitsSize">
							<xsl:choose>
								<xsl:when test="../@DatapointType != ''">
									<xsl:choose>
										<xsl:when test="string-length(../@DatapointType) > 5">
											<xsl:value-of select="$master2/../../@SizeInBit"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$master3/@SizeInBit"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$master/@SizeInBit"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="location">
							<xsl:call-template name="location">
								<xsl:with-param name="loc" select="$buildingpart/.."/>
							</xsl:call-template>
						</xsl:attribute>
						<xsl:for-each select="b:Send">
							<knxAddress type="group">
								<xsl:value-of
									select="$graddress/b:GroupAddress[@Id = current()/@GroupAddressRefId]/@Address"
								/>
							</knxAddress>
						</xsl:for-each>
						<expiration timeout="0"/>
						<xsl:choose>
							<xsl:when test="b:Receive">
								<xsl:for-each select="b:Receive">
									<updatingAddresses>
										<xsl:value-of
											select="$graddress/b:GroupAddress[@Id = current()/@GroupAddressRefId]/@Address"
										/>
									</updatingAddresses>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<updatingAddresses>
									<xsl:text> </xsl:text>
								</updatingAddresses>
							</xsl:otherwise>
						</xsl:choose>
						<invalidatingAddresses>
							<xsl:text> </xsl:text>
						</invalidatingAddresses>
					</datapoint>
				</xsl:for-each>
			</datapoints>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="location">
		<xsl:param name="loc"/>		
		<xsl:choose>
			<xsl:when test="name($loc/..) = 'BuildingPart'">
				<xsl:value-of select="translate(concat($loc/@Name, '.'), ' /()', '')"/>
				<xsl:call-template name="location">
					<xsl:with-param name="loc" select="$loc/.."/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="translate($loc/@Name, ' /()', '')"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
