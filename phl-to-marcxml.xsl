<?xml version="1.0" encoding="UTF-8"?>
 
<!-- ===============================================================================================================|

	Folha de estilo para a conversão de registros bibliográficos PHL(XML) em registros no Formato MARC 21 (MARCXML)
    
	Versão 1.2 - de 1 de agosto de 2015.
	Disponível em: http://docs.fabricioassumpcao.com/phl2marc21-1-2.xsl 
	Especificações em: http://fabricioassumpcao.com/conversao-de-phl-para-marc-21
	
	Criada por Fabrício Silva Assumpção 
	como parte da dissertação "Conversão de registros em XML para MARC 21: um modelo baseado em folhas de estilo XSLT", 
	(http://hdl.handle.net/11449/93658) desenvolvida no mestrado do Programa de Pós-Graduação em Ciência da Informação
	da UNESP, Campus de Marília, 	sob a orientação da Prof.ª Dr.ª Plácida Leopoldina Ventura Amorim da Costa Santos
	e com o financiamento da Coordenação de Aperfeiçoamento de Pessoal de Nível Superior (CAPES).
	
	Contato: 
	Fabrício Silva Assumpção
	E-mail: assumpcao.f (at) gmail.com
	http://fabricioassumpcao.com
		
    =========================================================================

	Licença: Esta folha de estilo está sob uma licença livre; você pode redistribui-la 
	e/ou modificá-la sob os termos da GNU General Public License version 3 publicada 
	pela Free Software Foundation (http://www.gnu.org/licenses/gpl.html).
	
	This program is free software: you can redistribute it and/or modify 
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.    
	
|=============================================================================================================== -->	

<xsl:stylesheet version="2.0"
	xmlns:marc="http://www.loc.gov/MARC21/slim"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes" version="1.0" encoding="UTF-8"/>
	
	<xsl:template match="/">
		<marc:collection
			xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd"
			xmlns:marc="http://www.loc.gov/MARC21/slim" 
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
			<xsl:for-each select="db/rec[v005]">
				<marc:record>
					<xsl:call-template name="bibliographicRecord"/>
				</marc:record>
			</xsl:for-each>
		</marc:collection>
	</xsl:template>
	
	<!-- Início do template bibliographicRecord -->

	<xsl:template name="bibliographicRecord">

		<!-- Com base no Nível bibliográfico (PHL 006), define a variável Nível bibliográfico (MARC LDR/07) que será utilizada na folha de estilo -->

		<xsl:variable name="bibliographicLevel">
			<xsl:choose>	
				<xsl:when test="v006='m'">m</xsl:when>
				<xsl:when test="v006='am'">a</xsl:when>
				<xsl:when test="v006='s'">m</xsl:when>
				<xsl:when test="v006='as'">a</xsl:when>
				<xsl:when test="v006='c' and v035">s</xsl:when>
				<xsl:otherwise>m</xsl:otherwise>				
			</xsl:choose>
		</xsl:variable>
				
		<!-- Líder (MARC LDR) --> 

		<xsl:element name="marc:leader">
			
			<!-- Líder - Tipo de registro (MARC LDR/06) - Tipo de documento (PHL 005) -->			
			
			<xsl:variable name="leader06">
				<xsl:choose>
					<xsl:when test="v005='1'">j</xsl:when>
					<xsl:when test="v005='2'">a</xsl:when>
					<xsl:when test="v005='3'">a</xsl:when>
					<xsl:when test="v005='4'">a</xsl:when>
					<xsl:when test="v005='5'">k</xsl:when>
					<xsl:when test="v005='6'">o</xsl:when>
					<xsl:when test="v005='7'">a</xsl:when>
					<xsl:when test="v005='8'">t</xsl:when>
					<xsl:when test="v005='9'">e</xsl:when>
					<xsl:when test="v005='10'">a</xsl:when>
					<xsl:when test="v005='11'">a</xsl:when>
					<xsl:when test="v005='12'">p</xsl:when>
					<xsl:when test="v005='13'">c</xsl:when>
					<xsl:when test="v005='14'">a</xsl:when>
					<xsl:when test="v005='15'">r</xsl:when>
					<xsl:when test="v005='16'">a</xsl:when>
					<xsl:when test="v005='17'">a</xsl:when>
					<xsl:when test="v005='18'">a</xsl:when>
					<xsl:when test="v005='19'">a</xsl:when>
					<xsl:when test="v005='20'">m</xsl:when>
					<xsl:when test="v005='21'">a</xsl:when>
					<xsl:when test="v005='22'">g</xsl:when>
					<xsl:when test="v005='23'">a</xsl:when>
					<xsl:when test="v005='24'">a</xsl:when>
					<xsl:otherwise>p</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:value-of select="concat('     n',$leader06,$bibliographicLevel,' a22     uu 4500')"/>
		</xsl:element>
		
		<!-- Campos de controle (MARC 00X) -->
		
		<!-- Número de controle (MARC 001) - Identificação do título (PHL 002) --> 

		<xsl:variable name="controlNumber">
			<xsl:value-of select="v002" />
		</xsl:variable>

		<xsl:if test="v002">
			<marc:controlfield tag="001">
				<xsl:value-of select="$controlNumber"/>
			</marc:controlfield>
		</xsl:if>
		
		<!-- Identificador do número de controle (MARC 003) --> 
		
		<!-- Inserir o Identificador do número de controle (código/sigla da biblioteca) e remover as marcações de comentário.

		<marc:controlfield tag="003">INSERIR_O_CÓDIGO_AQUI</marc:controlfield> -->
		
		<!-- Data e hora da última transação (MARC 005) - Datas de controle (PHL 999) -->

		<marc:controlfield tag="005">
			
			<xsl:variable name="yyyymmdd" select="substring(v999[last()],3,8)" />
				
			<xsl:variable name="hhmmss" select="substring(v999[last()],13,6)" />
			
			<xsl:value-of select="concat($yyyymmdd,$hhmmss,'.0')" />
						
		</marc:controlfield>
		
		<!-- Elementos de dados de tamanho fixo (MARC 008) -->

		<!-- Data de criação do registro (MARC 008/00-05) - Datas de controle (PHL 999) -->		

		<xsl:variable name="controlField008-00-05" select="substring(v999[position() = 1],5,6)" />

		<!-- Data 1 (MARC 008/07-10) - Data de publicação padronizada (PHL 065) e Data de publicação (PHL 064) -->
		
		<xsl:variable name="controlField008-07-10">
			<xsl:choose>
				<xsl:when test="string-length(v065) &#62; 3">
					<xsl:value-of select="substring(v065, 1, 4)" />
				</xsl:when>
				<xsl:when test="starts-with(v064, '1') and string-length(v064) &#62; 3">			
					<xsl:value-of select="substring(v064, 1, 4)" />
				</xsl:when>
				<xsl:when test="starts-with(v064, '2') and string-length(v064) &#62; 3">
					<xsl:value-of select="substring(v064, 1, 4)" />
				</xsl:when>
				<xsl:when test="starts-with(v064, 'c') and string-length(v064) &#62; 3">
					<xsl:value-of select="substring(v064, 2, 4)" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>||||</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Local de publicação, produção ou execução (MARC 008/15-17) - País de publicação (PHL 067) e Cidade de publicação (PHL 066) -->

		<xsl:variable name="controlField008-15-17">
			<xsl:choose>
				<xsl:when test="contains(v067,'Brasil') or contains(v066,'São Paulo') or contains(v066,'Rio de Janeiro')">
					<xsl:text xml:space="preserve">bl </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text xml:space="preserve">xx </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Forma do item (MARC 008/23) - Suporte (PHL 022) -->
		
		<xsl:variable name="controlField008-23">
			<xsl:choose>
				<xsl:when test="v005='23'">f</xsl:when> <!-- Refere-se ao código para material em braille -->
				<xsl:when test="v022='1'"><xsl:text xml:space="preserve"> </xsl:text></xsl:when>
				<xsl:when test="v022='2'">r</xsl:when>
				<xsl:when test="v022='3'">q</xsl:when>
				<xsl:when test="v022='4'">q</xsl:when>
				<xsl:when test="v022='5'">s</xsl:when>
				<xsl:when test="v022='6'">q</xsl:when>
				<xsl:when test="v022='7'">s</xsl:when>
				<xsl:when test="v022='8'">q</xsl:when>
				<xsl:when test="v022='9'">r</xsl:when>
				<xsl:when test="v022='10'">o</xsl:when>
				<xsl:when test="v022='11'">b</xsl:when>
				<xsl:when test="v022='12'">q</xsl:when>
				<xsl:when test="v022='13'">q</xsl:when>
				<xsl:when test="v022='14'"><xsl:text xml:space="preserve"> </xsl:text></xsl:when>
				<xsl:when test="v022='15'"><xsl:text xml:space="preserve"> </xsl:text></xsl:when>
				<xsl:when test="v022='16'"><xsl:text xml:space="preserve"> </xsl:text></xsl:when>
				<xsl:when test="v022='17'"><xsl:text xml:space="preserve"> </xsl:text></xsl:when>
				<xsl:when test="v022='18'"><xsl:text xml:space="preserve"> </xsl:text></xsl:when>
				<xsl:when test="v022='19'"><xsl:text xml:space="preserve"> </xsl:text></xsl:when>
				<xsl:when test="v022='20'"><xsl:text xml:space="preserve"> </xsl:text></xsl:when>
				<xsl:when test="v022='21'"><xsl:text xml:space="preserve"> </xsl:text></xsl:when>
				<xsl:when test="v022='22'"><xsl:text xml:space="preserve"> </xsl:text></xsl:when>
				<xsl:otherwise>
					<xsl:text xml:space="preserve"> </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Natureza do conteúdo (MARC 008/24-27) - Tipo de conteúdo (PHL 071) -->  
	
		<xsl:variable name="natureOfContents" select="v071"/>
		<xsl:variable name="controlField008-24-27">
			<xsl:choose>
				<xsl:when test="$natureOfContents='1'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='2'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='3'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='4'"><xsl:text xml:space="preserve">b   </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='5'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='6'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='7'"><xsl:text xml:space="preserve">c   </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='8'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='9'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='10'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='11'"><xsl:text xml:space="preserve">d   </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='12'"><xsl:text xml:space="preserve">f   </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='13'"><xsl:text xml:space="preserve">m   </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='14'"><xsl:text xml:space="preserve">l   </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='15'"><xsl:text xml:space="preserve">e   </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='16'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='17'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='18'"><xsl:text xml:space="preserve">l   </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='19'"><xsl:text xml:space="preserve">l   </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='20'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='21'"><xsl:text xml:space="preserve">f   </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='22'"><xsl:text xml:space="preserve">u   </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='23'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='24'"><xsl:text xml:space="preserve">j   </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='25'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='26'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='27'"><xsl:text xml:space="preserve">t   </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='28'"><xsl:text xml:space="preserve">w   </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='29'"><xsl:text xml:space="preserve">m   </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='30'"><xsl:text xml:space="preserve">m   </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='31'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='32'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='33'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='34'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='35'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='36'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='37'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:when test="$natureOfContents='38'"><xsl:text xml:space="preserve">    </xsl:text></xsl:when>
				<xsl:otherwise><xsl:text xml:space="preserve">    </xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Publicação de conferência (MARC 008/29) - Tipo de conteúdo - Evento, congresso, conferência, etc. (PHL 071=17) -->  
	
		<xsl:variable name="controlField008-29">
			<xsl:choose>
				<xsl:when test="$natureOfContents='17'">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Forma literária (MARC 008/33) - Tipo de conteúdo - Literatura (PHL 071=20) -->  

		<xsl:variable name="controlField008-33">
			<xsl:choose>
				<xsl:when test="$natureOfContents='20'">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>		

		<!-- Biografia (MARC 008/34) - Tipo de conteúdo - Literatura (PHL 071=20) -->  

		<xsl:variable name="controlField008-34">
			<xsl:choose>
				<xsl:when test="$natureOfContents='5'">b</xsl:when>
				<xsl:otherwise><xsl:text xml:space="preserve"> </xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>		
		
		<!-- Idioma (MARC 008/35-37) - Idiomas do texto (PHL 040) e Idioma do resumo (PHL 041) -->
		
		<!-- Verificar se os códigos dos idiomas correspondem aos respectivos idiomas na versão do PHL.
		Adicionar outros idiomas se necessário.
		Utilizar os códigos disponíveis em: http://www.loc.gov/marc/languages/langhome.html -->

		<xsl:variable name="controlField008-35-37">
			<xsl:choose>
				<xsl:when test="v040[1]='1'">por</xsl:when>
				<xsl:when test="v040[1]='2'">spa</xsl:when>
				<xsl:when test="v040[1]='3'">eng</xsl:when>
				<xsl:when test="v040[1]='4'">ita</xsl:when>
				<xsl:when test="v040[1]='5'">fre</xsl:when>
				<xsl:when test="v040[1]='6'">ger</xsl:when>
				<xsl:when test="v040[1]='7'">jpn</xsl:when>
				<xsl:when test="v040[1]='8'">lat</xsl:when>
				<xsl:when test="v041[1]='1'">por</xsl:when>
				<xsl:when test="v041[1]='2'">spa</xsl:when>
				<xsl:when test="v041[1]='3'">eng</xsl:when>
				<xsl:when test="v041[1]='4'">ita</xsl:when>
				<xsl:when test="v041[1]='5'">fre</xsl:when>
				<xsl:when test="v041[1]='6'">ger</xsl:when>
				<xsl:when test="v041[1]='7'">jpn</xsl:when>
				<xsl:when test="v041[1]='8'">lat</xsl:when>
				<xsl:otherwise>
					<xsl:text xml:space="preserve">   </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Elementos de dados de tamanho fixo (MARC 008) -->
		
		<marc:controlfield tag="008">
			<xsl:value-of select="concat($controlField008-00-05,'s',$controlField008-07-10,'    ',$controlField008-15-17,'||||g',$controlField008-23,$controlField008-24-27,'|',$controlField008-29,'|| ',$controlField008-33,$controlField008-34,$controlField008-35-37,' d')"/>
		</marc:controlfield>

		<!-- International Standard Book Number (ISBN) (MARC 020) - ISBN (PHL 069) -->

		<xsl:if test="$bibliographicLevel = 'm'">
			<xsl:for-each select="v069">
				<marc:datafield tag="020" ind1=" " ind2=" ">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</marc:datafield>
			</xsl:for-each>
		</xsl:if>
		
		<!-- International Standard Serial Number (ISSN) (MARC 022) - ISSN (PHL 035) -->
		
		<xsl:if test="$bibliographicLevel = 'm'">
			<xsl:for-each select="v035">
				<marc:datafield tag="022" ind1=" " ind2=" ">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</marc:datafield>
			</xsl:for-each>
		</xsl:if>

		<!-- Código do idioma (MARC 041) - Idiomas do texto (PHL 040) e Idioma do resumo (PHL 041) -->

		<xsl:if test="count(v040) &#62; 1">
			<marc:datafield tag="041" ind1=" " ind2=" ">
				<xsl:for-each select="v040">
					<marc:subfield code="a">
						<xsl:choose>
							<xsl:when test=".='1'">por</xsl:when>
							<xsl:when test=".='2'">spa</xsl:when>
							<xsl:when test=".='3'">eng</xsl:when>
							<xsl:when test=".='4'">ita</xsl:when>
							<xsl:when test=".='5'">fre</xsl:when>
							<xsl:when test=".='6'">ger</xsl:when>
							<xsl:when test=".='7'">jpn</xsl:when>
							<xsl:when test=".='8'">lat</xsl:when>
						</xsl:choose>
					</marc:subfield>
				</xsl:for-each>	
				<xsl:if test="v041">
					<marc:subfield code="b">
						<xsl:choose>
							<xsl:when test="v041='1'">por</xsl:when>
							<xsl:when test="v041='2'">spa</xsl:when>
							<xsl:when test="v041='3'">eng</xsl:when>
							<xsl:when test="v041='4'">ita</xsl:when>
							<xsl:when test="v041='5'">fre</xsl:when>
							<xsl:when test="v041='6'">ger</xsl:when>
							<xsl:when test="v041='7'">jpn</xsl:when>
							<xsl:when test="v041='8'">lat</xsl:when>
						</xsl:choose>
					</marc:subfield>
				</xsl:if>		
			</marc:datafield>
		</xsl:if>

		<!-- Classificação Decimal Universal (CDU) (MARC 080) - Classificação (PHL 003) -->
		
		<!-- Escolher entre CDU ou CDD

		<xsl:for-each select="v003">
			<marc:datafield tag="080" ind1=" " ind2=" ">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</marc:datafield>
		</xsl:for-each> -->

		<!-- Classificação Decimal de Dewey (CDD) (MARC 082) - Classificação (PHL 003) -->

		<xsl:for-each select="v003">
			<marc:datafield tag="082" ind1="0" ind2="4">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</marc:datafield>
		</xsl:for-each>

		<!-- Notação de autor (Campo local 090) - Cutter/PHA (PHL 103) -->

		<xsl:if test="v103">
			<marc:datafield tag="090" ind1=" " ind2=" ">
				<marc:subfield code="a">
					<xsl:value-of select="v103"/>
				</marc:subfield>
			</marc:datafield>
		</xsl:if>

		<!-- Pontos de acesso principais (MARC 1xx) -->
		
		<xsl:choose>
			<xsl:when test="$bibliographicLevel = 'm'">
				<xsl:choose>
					
					<!-- Ponto de acesso principal - Nome pessoal (MARC 100) - Autor (PHL 016) -->
					
					<xsl:when test="v016">
						<marc:datafield tag="100" ind1="1" ind2=" ">
							<marc:subfield code="a">
								<xsl:value-of select="v016[1]"/>
							</marc:subfield>
						</marc:datafield>		
					</xsl:when>
					
					<!-- Ponto de acesso principal - Nome corporativo (MARC 110) - Autores coletivos (PHL 017) -->			
					
					<xsl:when test="v017">
						<marc:datafield tag="110" ind1="2" ind2=" ">
							<marc:subfield code="a">
								<xsl:value-of select="v017[1]"/>
							</marc:subfield>
						</marc:datafield>		
					</xsl:when>
					
					<!-- Ponto de acesso principal - Nome de evento (MARC 111) - Nome do evento (PHL 053), Data do evento (PHL 054), Data padronizada do Evento (PHL 055) e Local do evento (PHL 056) -->
					
					<xsl:when test="v053">
						<marc:datafield tag="111" ind1="2" ind2=" ">
							<xsl:for-each select="v053[1]">
								<marc:subfield code="a">
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:for-each>
							<xsl:if test="v056 or v055">
								<marc:subfield code="c">
									<xsl:choose>
										<xsl:when test="v056">
											<xsl:value-of select="v056[1]"/>		
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="substring(v055[1],1,4)"/>											
										</xsl:otherwise>
									</xsl:choose>
								</marc:subfield>			
							</xsl:if>
							<xsl:if test="v054[1]">				
								<marc:subfield code="d">
									<xsl:value-of select="v054[1]"/>
								</marc:subfield>
							</xsl:if>				
						</marc:datafield>			
					</xsl:when>
				</xsl:choose>				
			</xsl:when>

			<xsl:when test="$bibliographicLevel = 'a'">				
				<xsl:choose>
					
					<!-- Ponto de acesso principal - Nome pessoal (MARC 100) - Autor da parte (PHL 010) -->
					
					<xsl:when test="v010">
						<marc:datafield tag="100" ind1="1" ind2=" ">
							<marc:subfield code="a">
								<xsl:value-of select="v010[1]"/>
							</marc:subfield>
						</marc:datafield>		
					</xsl:when>
					
					<!-- Ponto de acesso principal - Nome corporativo (MARC 110) - Autor coletivo da parte (PHL 011) -->			
					
					<xsl:when test="v011">
						<marc:datafield tag="110" ind1="2" ind2=" ">
							<marc:subfield code="a">
								<xsl:value-of select="v011[1]"/>
							</marc:subfield>
						</marc:datafield>		
					</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>

		<!-- Título traduzido pela agência catalogadora (MARC 242) - Título traduzido (PHL 019) e Título traduzido da parte (PHL 013) -->	

		<xsl:choose>
			<xsl:when test="$bibliographicLevel = 'm'">
				<xsl:for-each select="v019">
					<marc:datafield tag="242" ind1="1" ind2="0">
						<marc:subfield code="a">
							<xsl:value-of select="."/>
						</marc:subfield>
					</marc:datafield>
				</xsl:for-each>		
			</xsl:when>
			<xsl:when test="$bibliographicLevel = 'a'">
				<xsl:for-each select="v013">
					<marc:datafield tag="242" ind1="1" ind2="0">
						<marc:subfield code="a">
							<xsl:value-of select="."/>
						</marc:subfield>
					</marc:datafield>
				</xsl:for-each>				
			</xsl:when>
		</xsl:choose>

		<!-- Indicação de título (MARC 245) - Título (PHL 018), Subtítulo (PHL 181),
			Título e subtítulo da parte (PHL 012), 
			Título da série (PHL 030) e Subtítulo da série (PHL 182) -->	
	
		<xsl:choose>

			<!-- Título para recursos monográficos -->
			
			<xsl:when test="$bibliographicLevel = 'm' and v006 = 'm'">	
				<marc:datafield tag="245" ind1="1" ind2="0">
					<xsl:choose>
						<xsl:when test="v018 and v181">
							<marc:subfield code="a">
								<xsl:value-of select="concat(v018[1],' :')"/>
							</marc:subfield>
							<marc:subfield code="b">
								<xsl:value-of select="v181[1]"/>
							</marc:subfield>
						</xsl:when>
						<xsl:when test="v018">
							<marc:subfield code="a">
								<xsl:value-of select="v018[1]"/>
							</marc:subfield>
						</xsl:when>
						<xsl:when test="v006 = 's'">
							<marc:subfield code="a">
								<xsl:value-of select="v030"/>
							</marc:subfield>
						</xsl:when>
					</xsl:choose>
					
					<!-- SEM PONTUAÇÃO
					
					<xsl:choose>
						<xsl:if test="v018">
							<marc:subfield code="a">
								<xsl:value-of select="v018[1]"/>
							</marc:subfield>
						</xsl:if>
						<xsl:if test="v181">
							<marc:subfield code="b">
								<xsl:value-of select="v181[1]"/>
							</marc:subfield>
						</xsl:if>
					</xsl:choose> -->
					
				</marc:datafield>
			</xsl:when>
			
			<!-- Título de periódicos: toda a coleção ou cada fascículo -->
			
			<xsl:when test="$bibliographicLevel = 'm' and v006 = 's'">
				<marc:datafield tag="245" ind1="1" ind2="0">
					<marc:subfield code="a">
						<xsl:choose>
							<xsl:when test="v182">
								<xsl:value-of select="concat(v030,' :')" />		
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="v030" />
							</xsl:otherwise>
						</xsl:choose>
					</marc:subfield>
					<xsl:if test="v182">
						<marc:subfield code="b">
							<xsl:value-of select="v182" />
						</marc:subfield>
					</xsl:if>

					<!-- SEM PONTUAÇÃO 
			
					<marc:subfield code="a">
						<xsl:value-of select="v030" />
					</marc:subfield>
					<xsl:if test="v182">
						<marc:subfield code="b">
							<xsl:value-of select="v182" />
						</marc:subfield>
					</xsl:if> -->
					
				</marc:datafield>
			</xsl:when>

			<!-- Título da parte de um recurso monográfico ou periódico (analítica) -->
			
			<xsl:when test="$bibliographicLevel = 'a'">
				<marc:datafield tag="245" ind1="1" ind2="0">
					<xsl:choose>
						<xsl:when test="contains(v012,':')">
							<marc:subfield code="a">
								<xsl:value-of select="concat(substring-before(v012,':'),' :')"/>
							</marc:subfield>
							<marc:subfield code="b">
								<xsl:value-of select="substring-after(v012,': ')"/>
							</marc:subfield>
						</xsl:when>
						<xsl:otherwise>
							<marc:subfield code="a">
								<xsl:value-of select="v012"/>
							</marc:subfield>		
						</xsl:otherwise>
					</xsl:choose>
					
					<!-- SEM PONTUAÇÃO
					
					<xsl:choose>
						<xsl:when test="contains(v012,':')">
							<marc:subfield code="a">
								<xsl:value-of select="substring-before(v012,':')"/>
							</marc:subfield>
							<marc:subfield code="b">
								<xsl:value-of select="substring-after(v012,': ')"/>
							</marc:subfield>
						</xsl:when>
						<xsl:otherwise>
							<marc:subfield code="a">
								<xsl:value-of select="v012"/>
							</marc:subfield>
						</xsl:otherwise>
					</xsl:choose> -->
					
				</marc:datafield>
			</xsl:when>
		</xsl:choose>
		
		<!-- Indicação de edição (MARC 250) - Edição (PHL 063) -->	
		
		<xsl:if test="$bibliographicLevel = 'm' and v063">
			<marc:datafield tag="250" ind1=" " ind2=" ">
				<marc:subfield code="a">
					<xsl:value-of select="v063"/>
				</marc:subfield>
			</marc:datafield>
		</xsl:if>
		
		<!-- Publicação, distribuição, etc. (MARC 260) - Cidade de publicação (PHL 066), País de publicação (PHL 067), Editora (PHL 062), Data de publicação (PHL 064) e Data de publicação padronizada (PHL 065) -->

		<xsl:if test="v066 or v062 or v064">
			<marc:datafield tag="260" ind1=" " ind2=" ">
				<xsl:for-each select="v066">
					<marc:subfield code="a">
						<xsl:value-of select="concat(.,' :')"/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="v067">
					<marc:subfield code="a">
						<xsl:value-of select="concat(.,' :')"/>
					</marc:subfield>
				</xsl:for-each>	
				<xsl:for-each select="v062">
					<marc:subfield code="b">
						<xsl:value-of select="concat(.,',')"/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:choose>
					<xsl:when test="v064">
						<marc:subfield code="c">
							<xsl:value-of select="v064"/>
						</marc:subfield>
					</xsl:when>
					<xsl:when test="v065">
						<marc:subfield code="c">
							<xsl:value-of select="substring(v065,1,4)"/>
						</marc:subfield>		
					</xsl:when>
				</xsl:choose>

				<!-- SEM PONTUAÇÃO
		
				<xsl:for-each select="v066">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>				
				<xsl:for-each select="v067">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>	
				<xsl:for-each select="v062">
					<marc:subfield code="b">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:choose>
					<xsl:when test="v064">
						<marc:subfield code="c">
							<xsl:value-of select="v064"/>
						</marc:subfield>
					</xsl:when>
					<xsl:when test="v065">
						<marc:subfield code="c">
							<xsl:value-of select="substring(v065,1,4)"/>
						</marc:subfield>		
					</xsl:when>
				</xsl:choose> -->

			</marc:datafield>
		</xsl:if>
		
		<!-- Descrição física (MARC 300) - Total de páginas (PHL 020), Informação descritiva do suporte (PHL 038) e Informação descritiva da parte (PHL 141) -->

		<xsl:choose>		
			<xsl:when test="$bibliographicLevel = 'a' and v141">
				<marc:datafield tag="300" ind1=" " ind2=" ">
					<marc:subfield code="a">
						<xsl:value-of select="v141"/>
					</marc:subfield>
				</marc:datafield>
			</xsl:when>
			<xsl:when test="$bibliographicLevel = 'm' and (v020 or v038)">
				<marc:datafield tag="300" ind1=" " ind2=" ">
					<marc:subfield code="a">
						<xsl:choose>
							<xsl:when test="v020 and v038">
								<xsl:value-of select="concat(v020,' p. :',v038)"/>	
							</xsl:when>
							<xsl:when test="v020">
								<xsl:value-of select="concat(v020,' p.')"/>	
							</xsl:when>
							<xsl:when test="v038">
								<xsl:value-of select="v038"/>
							</xsl:when>
						</xsl:choose>
					</marc:subfield>
				</marc:datafield>
			</xsl:when>
		</xsl:choose>
		
		<!-- Datas de publicação e/ou designação sequencial (MARC 362) - Ano e/ou volume (PHL 031) e Fascículo (PHL 032) -->
		
		<xsl:if test="$bibliographicLevel = 'm' and v006 = 's' and (v031 or v032 or v021)">
			<marc:datafield tag="362" ind1="0" ind2=" ">
				<marc:subfield code="a">
					<xsl:choose>
						<xsl:when test="v031 and v032">
							<xsl:value-of select="concat(v031,', ',v032)" />
						</xsl:when>
						<xsl:when test="v031">
							<xsl:value-of select="v031" />
						</xsl:when>
						<xsl:when test="v032">
							<xsl:value-of select="v032" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="v021" />
						</xsl:otherwise>
					</xsl:choose>
				</marc:subfield>
			</marc:datafield>
		</xsl:if>
		
		<!-- Indicação de série (MARC 490) - Título da série (PHL 030) -->
		
		<xsl:if test="$bibliographicLevel = 'm' and v006 = 'm' and v030">
			<marc:datafield tag="490" ind1="0" ind2=" ">
				<marc:subfield code="a">
					<xsl:choose>
						<xsl:when test="contains(v030,', ') and v182">
							<xsl:value-of select="concat(substring-before(v030,', '),': ',v182,' ;')" />
						</xsl:when>
						<xsl:when test="contains(v030,', ')">
							<xsl:value-of select="concat(substring-before(v030,', '),' ;')" />
						</xsl:when>
						<xsl:when test="v182">
							<xsl:value-of select="concat(v030,': ',v182)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="v030" />
						</xsl:otherwise>
					</xsl:choose>
				</marc:subfield>
				<xsl:if test="string-length(substring-after(v030,', ')) &#62; 0">
					<marc:subfield code="v">
						<xsl:value-of select="substring-after(v030,', ')" />
					</marc:subfield>
				</xsl:if>
			</marc:datafield>
		</xsl:if>
		
		<!-- Notas 5xx -->
		
		<!-- Nota geral (MARC 500) - Notas gerais (PHL 061) -->

		<xsl:if test="$bibliographicLevel = 'm'">
			<xsl:for-each select="v061">
				<marc:datafield tag="500" ind1=" " ind2=" ">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</marc:datafield>
			</xsl:for-each>
		</xsl:if>

		<!-- Nota geral (MARC 500) - Instituição patrocinadora do evento (PHL 052) -->
		
		<xsl:if test="$bibliographicLevel = 'm'">
			<xsl:for-each select="v052">
				<marc:datafield tag="500" ind1=" " ind2=" ">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</marc:datafield>
			</xsl:for-each>
		</xsl:if>
		
		<!-- Nota geral (MARC 500) - Tipo de conteúdo (PHL 071) -->
	
		<xsl:if test="v006 = 'm' and (v071=1 or v071=2 or v071=3 or v071=5 or v071=6 or v071=8 or v071=9 or 
			v071=10 or v071=16 or v071=23 or v071=25 or v071=26 or v071=35 or v071=36 or v071=37)">
			<marc:datafield tag="500" ind1=" " ind2=" ">
				<marc:subfield code="a">
					<xsl:choose>
						<xsl:when test="$natureOfContents='1'">Almanaque</xsl:when>
						<xsl:when test="$natureOfContents='2'">Atlas</xsl:when>
						<xsl:when test="$natureOfContents='3'">Base de dados</xsl:when>
						<xsl:when test="$natureOfContents='5'">Biografia</xsl:when>
						<xsl:when test="$natureOfContents='6'">Boletim</xsl:when>
						<xsl:when test="$natureOfContents='8'">Correspondência enviada</xsl:when>
						<xsl:when test="$natureOfContents='9'">Correspondência recebida</xsl:when>
						<xsl:when test="$natureOfContents='10'">Desenho técnico</xsl:when>
						<xsl:when test="$natureOfContents='16'">Entrevista</xsl:when>
						<xsl:when test="$natureOfContents='23'">Notícia</xsl:when>
						<xsl:when test="$natureOfContents='25'">Projeto arquitetônico</xsl:when>
						<xsl:when test="$natureOfContents='26'">Projeto de pesquisa</xsl:when>
						<xsl:when test="$natureOfContents='35'">Guia</xsl:when>
						<xsl:when test="$natureOfContents='36'">Fotografia</xsl:when>
						<xsl:when test="$natureOfContents='37'">Software</xsl:when>
					</xsl:choose>
				</marc:subfield>
			</marc:datafield>			
		</xsl:if>
	
		<!-- Nota geral (MARC 500) - Área do conhecimento (PHL 085) -->

		<xsl:if test="$bibliographicLevel = 'm'">
			<xsl:variable name="fieldOfKnowledge">
				<xsl:choose>
					<xsl:when test="v085='1'">Ciências Exatas e da Terra</xsl:when>
					<xsl:when test="v085='2'">Ciências Biológicas</xsl:when>
					<xsl:when test="v085='3'">Engenharias</xsl:when>
					<xsl:when test="v085='4'">Ciências da Saúde</xsl:when>
					<xsl:when test="v085='5'">Ciências Agrárias</xsl:when>
					<xsl:when test="v085='6'">Ciências Sociais Aplicadas</xsl:when>
					<xsl:when test="v085='7'">Ciências Humanas</xsl:when>
					<xsl:when test="v085='8'">Lingüística, Letras e Artes</xsl:when>					
				</xsl:choose>
			</xsl:variable>
			
			<xsl:if test="v085 &#60; 9">
				<marc:datafield tag="500" ind1=" " ind2=" ">
					<marc:subfield code="a">
						<xsl:value-of select="concat('Área do conhecimento: ',$fieldOfKnowledge)"/>
					</marc:subfield>
				</marc:datafield>
			</xsl:if>
		</xsl:if>
	
		<!-- Nota geral (MARC 500) - Símbolo (PHL 068) -->

		<xsl:if test="$bibliographicLevel = 'm'">
			<xsl:for-each select="v068">
				<marc:datafield tag="500" ind1=" " ind2=" ">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</marc:datafield>
			</xsl:for-each>
		</xsl:if>
		
		<!-- Nota geral (MARC 500) - Patrocinadores do projeto (PHL 058) -->
		
		<xsl:if test="$bibliographicLevel = 'm'">
			<xsl:for-each select="v058">
				<xsl:variable name="v058" select="."/>
				<marc:datafield tag="500" ind1=" " ind2=" ">
					<marc:subfield code="a">
						<xsl:value-of select="concat('Patrocinadores do projeto: ',$v058)"/>
					</marc:subfield>
				</marc:datafield>
			</xsl:for-each>
		</xsl:if>
	
		<!-- Nota geral (MARC 500) - Nome do projeto de pesquisa (PHL 059) -->
			
		<xsl:if test="$bibliographicLevel = 'm'">
			<xsl:for-each select="v059">
				<xsl:variable name="v059" select="."/>
				<marc:datafield tag="500" ind1=" " ind2=" ">
					<marc:subfield code="a">
						<xsl:value-of select="concat('Nome do projeto de pesquisa: ',$v059)"/>
					</marc:subfield>
				</marc:datafield>
			</xsl:for-each>
		</xsl:if>
	
		<!-- Nota geral (MARC 500) - Número do projeto de pesquisa (PHL 060) -->
	
		<xsl:if test="$bibliographicLevel = 'm'">
			<xsl:for-each select="v060">
				<xsl:variable name="v060" select="."/>
				<marc:datafield tag="500" ind1=" " ind2=" ">
					<marc:subfield code="a">
						<xsl:value-of select="concat('Número do projeto de pesquisa: ',$v060)"/>
					</marc:subfield>
				</marc:datafield>
			</xsl:for-each>
		</xsl:if>
		
		<!-- Nota de dissertação (MARC 502) - Notas de tese / dissertação (PHL 051) e Instituição da tese (PHL 050) -->
	
		<xsl:if test="$bibliographicLevel = 'm' and (v050 or v051)">
			<marc:datafield tag="502" ind1=" " ind2=" ">
				<xsl:for-each select="v051">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="v050">
					<marc:subfield code="c">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</marc:datafield>
		</xsl:if>

		<!-- Nota de bibliografia, etc. (MARC 504) - Total de referências (PHL 072) -->
		
		<xsl:if test="v072">
			<marc:datafield tag="505" ind1=" " ind2=" ">
				<marc:subfield code="b">
					<xsl:value-of select="."/>
				</marc:subfield>
			</marc:datafield>
		</xsl:if>
		
		<!-- Nota de conteúdo formatado (MARC 505) - Notas de conteúdo (PHL 086) -->
	
		<xsl:if test="$bibliographicLevel = 'm' and v086">
			<marc:datafield tag="505" ind1="8" ind2="0">
				<xsl:for-each select="v086">
					<marc:subfield code="t">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</marc:datafield>
		</xsl:if>
		
		<!-- Nota de créditos de criação/produção (MARC 508) - Créditos ou ementa (PHL 015) e Créditos ou ementa (nível analítico) (PHL 121) -->
		
		<xsl:choose>
			<xsl:when test="$bibliographicLevel = 'm'">
				<xsl:for-each select="v015">
					<marc:datafield tag="508" ind1=" " ind2=" ">
						<marc:subfield code="a">
							<xsl:value-of select="."/>
						</marc:subfield>
					</marc:datafield>
				</xsl:for-each>				
			</xsl:when>
			<xsl:when test="$bibliographicLevel = 'a'">
				<xsl:for-each select="v121">
					<marc:datafield tag="508" ind1=" " ind2=" ">
						<marc:subfield code="a">
							<xsl:value-of select="."/>
						</marc:subfield>
					</marc:datafield>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
		
		<!-- Resumo (MARC 520) - Resumo (PHL 083) -->

		<xsl:for-each select="v083">
			<marc:datafield tag="520" ind1="3" ind2=" ">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</marc:datafield>
		</xsl:for-each>

		<!-- Nota sobre programa de estudo (MARC 526) - Bibliografia de cursos (PHL 079) -->
		
		<xsl:if test="v079">
			<marc:datafield tag="526" ind1="8" ind2=" ">
				<marc:subfield code="a">
					<xsl:value-of select="079"/>
				</marc:subfield>
			</marc:datafield>
		</xsl:if>

		<!-- Nota geral (MARC 590) - Observações do bibliotecário (PHL 089) -->
		
		<xsl:for-each select="v089">
			<marc:datafield tag="590" ind1=" " ind2=" ">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</marc:datafield>
		</xsl:for-each>
		
		<!-- Nota local (MARC 590) - Comentários Wiki Folksonomia (PHL 186) -->

		<xsl:for-each select="v186">
			<marc:datafield tag="590" ind1=" " ind2=" ">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</marc:datafield>
		</xsl:for-each>
		
		<!-- Pontos de acesso de assunto (MARC 6XX) -->
		
		<!-- Pontos de acesso de assunto - Nome pessoal (MARC 600) - Indivíduo como tema (PHL 078) -->

		<xsl:for-each select="v078">
			<marc:datafield tag="600" ind1="1" ind2="4">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>		
			</marc:datafield>
		</xsl:for-each>

		<!-- Pontos de acesso de assunto - Termo cronológico (MARC 648) - Alcance temporal Desde (PHL 074) e Alcance temporal Até (PHL 075) -->
		
		<xsl:if test="v074 or v075">
			<marc:datafield tag="650" ind1=" " ind2="4">
				<marc:subfield code="a">
					<xsl:choose>
						<xsl:when test="v074 and v075">
							<xsl:value-of select="concat(v074,'-',v075)"/>							
						</xsl:when>
						<xsl:when test="v074">
							<xsl:value-of select="v074"/>							
						</xsl:when>
						<xsl:when test="v075">
							<xsl:value-of select="v075"/>							
						</xsl:when>
					</xsl:choose>
				</marc:subfield>		
			</marc:datafield>
		</xsl:if>

		<!-- Pontos de acesso de assunto - Termo tópico (MARC 650) - Descritor pré-codificado (PHL 076) -->

		<xsl:for-each select="v076">
			<marc:datafield tag="650" ind1=" " ind2="4">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>		
			</marc:datafield>
		</xsl:for-each>

		<!-- Pontos de acesso de assunto - Termo tópico (MARC 650) - Descritores de conteúdo (PHL 087) -->

		<xsl:for-each select="v087">
			<marc:datafield tag="650" ind1=" " ind2="4">
				<xsl:choose>
					<xsl:when test="contains(.,'^s')">
						<marc:subfield code="a">
							<xsl:value-of select="substring-before(.,'^s')" />
						</marc:subfield>						
						<marc:subfield code="x">
							<xsl:value-of select="substring-after(.,'^s')" />
						</marc:subfield>						
					</xsl:when>
					<xsl:otherwise>
						<marc:subfield code="a">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:otherwise>
				</xsl:choose>					
			</marc:datafield>
		</xsl:for-each>
		
		<!-- Pontos de acesso de assunto - Termo tópico (MARC 650) - Descritores secundários (PHL 088) -->

		<xsl:for-each select="v088">
			<marc:datafield tag="650" ind1=" " ind2="4">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>								
			</marc:datafield>
		</xsl:for-each>	
		
		<!-- Pontos de acesso de assunto - Nome geográfico (MARC 651) - Outras localidades (PHL 082) -->

		<xsl:for-each select="v082">
			<marc:datafield tag="651" ind1=" " ind2="4">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>		
			</marc:datafield>
		</xsl:for-each>

		<!-- Pontos de acesso secundários (MARC 7XX) -->
		
		<!-- Pontos de acesso secundários - Nome pessoal (MARC 700) - Autor (PHL 016) e Autor da parte (PHL 010) -->

		<xsl:choose>
			<xsl:when test="$bibliographicLevel = 'm'">
				<xsl:for-each select="v016[position()>1]">
					<marc:datafield tag="700" ind1="1" ind2=" ">
						<marc:subfield code="a">
							<xsl:value-of select="."/>
						</marc:subfield>
					</marc:datafield>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$bibliographicLevel = 'a'">
				<xsl:for-each select="v010[position()>1]">
					<marc:datafield tag="700" ind1="1" ind2=" ">
						<marc:subfield code="a">
							<xsl:value-of select="."/>
						</marc:subfield>
					</marc:datafield>
				</xsl:for-each>			
			</xsl:when>
		</xsl:choose>
	
		<!-- Pontos de acesso secundários - Nome corporativo (MARC 710) - Autores coletivos (PHL 017) e Autor coletivo da parte (PHL 011);
		Pontos de acesso secundários - Nome de evento (MARC 711) - Nome do evento (PHL 053), Data do evento (PHL 054) e Local do evento (PHL 056) -->
		
		<xsl:choose>
			<xsl:when test="$bibliographicLevel = 'm'">
				<xsl:choose>
					<xsl:when test="v016">
						<xsl:for-each select="v017">
							<marc:datafield tag="710" ind1="2" ind2=" ">
								<marc:subfield code="a">
									<xsl:value-of select="."/>
								</marc:subfield>
							</marc:datafield>
						</xsl:for-each>
						<xsl:if test="v053">
							<marc:datafield tag="711" ind1="2" ind2=" ">
								<xsl:if test="v053">
									<marc:subfield code="a">
										<xsl:value-of select="v053[1]"/>
									</marc:subfield>
								</xsl:if>
								<xsl:if test="v056">
									<marc:subfield code="c">
										<xsl:value-of select="v056"/>
									</marc:subfield>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="v054">
										<marc:subfield code="d">
											<xsl:value-of select="v054"/>
										</marc:subfield>	
									</xsl:when>
									<xsl:when test="v055">
										<marc:subfield code="d">
											<xsl:value-of select="substring(v055,1,4)"/>
										</marc:subfield>
									</xsl:when>
								</xsl:choose>	
							</marc:datafield>
						</xsl:if>
					</xsl:when>
					<xsl:when test="v017">
						<xsl:for-each select="v017[position()>1]">
							<marc:datafield tag="710" ind1="2" ind2=" ">
								<marc:subfield code="a">
									<xsl:value-of select="."/>
								</marc:subfield>
							</marc:datafield>
						</xsl:for-each>
						<xsl:if test="v053">
							<marc:datafield tag="711" ind1="2" ind2=" ">
								<xsl:if test="v053">
									<marc:subfield code="a">
										<xsl:value-of select="v053[1]"/>
									</marc:subfield>
								</xsl:if>
								<xsl:if test="v056">
									<marc:subfield code="c">
										<xsl:value-of select="v056"/>
									</marc:subfield>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="v054">
										<marc:subfield code="d">
											<xsl:value-of select="v054"/>
										</marc:subfield>	
									</xsl:when>
									<xsl:when test="v055">
										<marc:subfield code="d">
											<xsl:value-of select="substring(v055,1,4)"/>
										</marc:subfield>
									</xsl:when>
								</xsl:choose>	
							</marc:datafield>
						</xsl:if>
					</xsl:when>
					<xsl:when test="v053[position()>1]">
						<marc:datafield tag="711" ind1="2" ind2=" ">
							<marc:subfield code="a">
								<xsl:value-of select="v053[position()>1]"/>
							</marc:subfield>
							<marc:subfield code="c">
								<xsl:value-of select="v056[position()>1]"/>
							</marc:subfield>						
							<marc:subfield code="d">
								<xsl:value-of select="v054[position()>1]"/>
							</marc:subfield>
						</marc:datafield>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			
			<xsl:when test="$bibliographicLevel = 'a'">
				<xsl:choose>
					<xsl:when test="v010">
						<xsl:for-each select="v011">
							<marc:datafield tag="710" ind1="2" ind2=" ">
								<marc:subfield code="a">
									<xsl:value-of select="."/>
								</marc:subfield>
							</marc:datafield>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="v011">
						<xsl:for-each select="v011[position()>1]">
							<marc:datafield tag="710" ind1="2" ind2=" ">
								<marc:subfield code="a">
									<xsl:value-of select="."/>
								</marc:subfield>
							</marc:datafield>
						</xsl:for-each>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
				
		<!-- Descrição do todo (MARC 773) -->
		
		<xsl:if test="$bibliographicLevel = 'a'">
			<marc:datafield tag="773" ind1="0" ind2="8">
				
				<!-- Ponto de acesso principal ($a) - Autor (PHL 016), Autores coletivos (PHL 017) e Nome do evento (PHL 053) -->
				
				<xsl:if test="v016 or v017 or v053">
					<marc:subfield code="a">
						<xsl:choose>
							<xsl:when test="v016">
								<xsl:value-of select="v016[1]"/>
							</xsl:when>
							<xsl:when test="v017">	
								<xsl:value-of select="v017[1]"/>
							</xsl:when>
							<xsl:when test="v053">
								<xsl:value-of select="v053[1]"/>
							</xsl:when>
						</xsl:choose>				
					</marc:subfield>
				</xsl:if>
				
				<!-- Título ($t) - Titulo (PHL 018), Subtítulo (PHL 181), Título da série (PHL 030) e Subtítulo da série (PHL 182) -->
				
				<xsl:choose>
					<xsl:when test="v018 and v181">
						<marc:subfield code="t">
							<xsl:value-of select="concat(v018,' : ',v181)"/>
						</marc:subfield>
					</xsl:when>
					
					<xsl:when test="v018">
						<marc:subfield code="t">
							<xsl:value-of select="v018"/>
						</marc:subfield>
					</xsl:when>
					
					<xsl:when test="v030 and v182">
						<marc:subfield code="t">
							<xsl:value-of select="concat(v030,' : ',v182)"/>
						</marc:subfield>
					</xsl:when>
					
					<xsl:when test="v030">
						<marc:subfield code="t">
							<xsl:value-of select="v030"/>
						</marc:subfield>
					</xsl:when>
				</xsl:choose>

				<!-- Edição ($b) - Edição (PHL 063) -->
				
				<xsl:if test="v063">
					<marc:subfield code="b">
						<xsl:value-of select="v063"/>
					</marc:subfield>
				</xsl:if>
				
				<!-- Partes relacionadas ($g) - Intervalo de páginas (PHL 014), Volume (PHL 021), Anoe /ou volume (PHL 031), Fascículo (PHL 032) -->
				
				<xsl:if test="v014 or v031 or v032 or v021">					
					<marc:subfield code="g">		
						<xsl:choose>
							<xsl:when test="v014 and v031 and v032">
								<xsl:value-of select="concat(v031,', ',v032,', p. ',v014)" />
							</xsl:when>
							<xsl:when test="v014 and v031">
								<xsl:value-of select="concat(v031,', p. ',v014)" />
							</xsl:when>
							<xsl:when test="v031 and v032">
								<xsl:value-of select="concat(v031,', ',v032)" />
							</xsl:when>
							<xsl:when test="v014 and v032">
								<xsl:value-of select="concat(v032,', p. ',v014)" />
							</xsl:when>
							<xsl:when test="v031">
								<xsl:value-of select="v031" />
							</xsl:when>
							<xsl:when test="v014">
								<xsl:value-of select="concat('p. ',v014)" />
							</xsl:when>
							<xsl:when test="v032">
								<xsl:value-of select="v032" />
							</xsl:when>
							<xsl:when test="v021">
								<xsl:value-of select="v021" />
							</xsl:when>
						</xsl:choose>				
					</marc:subfield>
				</xsl:if>
				
				<!-- Local de publicação, publicador e data de publicação ($d) - Cidade de publicação (PHL 066), Editora (PHL 062), 
					Data de publicação (PHL 064) e Data de publicação padronizada (PHL 065) -->
				
				<xsl:if test="v066 or v062 or v064">
					<marc:subfield code="d">
						<xsl:if test="v066">
							<xsl:value-of select="v066"/>							
						</xsl:if>
						<xsl:choose>
							<xsl:when test="v066 and v062">
								<xsl:value-of select="concat(' : ',v062)"/>	
							</xsl:when>
							<xsl:when test="v062">
								<xsl:value-of select="v062" />
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="v064">
								<xsl:value-of select="concat(', ',v064)"/>
							</xsl:when>
							<xsl:when test="v065">
								<xsl:value-of select="concat(', ',substring(v065,1,4))"/>
							</xsl:when>
						</xsl:choose>
					</marc:subfield>
				</xsl:if>

				<!-- International Standard Serial Number (ISSN) ($x) - International Standard Serial Number (ISSN) (PHL 035) -->
				
				<xsl:if test="v035">
					<marc:subfield code="x">
						<xsl:value-of select="concat('ISSN ',v035[1])"/>
					</marc:subfield>
				</xsl:if>
				
				<!-- International Standard Book Number (ISBN) ($z) - International Standard Book Number (ISBN) (PHL 068) -->
				
				<xsl:if test="v069">
					<marc:subfield code="z">
						<xsl:value-of select="concat('ISBN ',v069[1])"/>
					</marc:subfield>
				</xsl:if>
					
				<!-- Número de controle do registro ($w) - Identificação do todo (PHL 996) -->
				
				<marc:subfield code="w">
					<xsl:value-of select="v996"/>
				</marc:subfield>
				
			</marc:datafield>
		</xsl:if>

		<!-- Localização e acesso eletrônico (MARC 856) - Meio eletrônico (PHL 008) e Imagem do objeto (PHL 070) -->

		<xsl:for-each select="v008">
			<marc:datafield tag="856" ind1="4" ind2="0">
				<marc:subfield code="u">
					<xsl:choose>
						<xsl:when test="contains(.,'^u')">
							<xsl:value-of select="substring-after(substring-before(.,'^u'),'^i')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-after(.,'^i')"/>
						</xsl:otherwise>
					</xsl:choose>
				</marc:subfield>
			</marc:datafield>
		</xsl:for-each>
		
		<xsl:for-each select="v070">
			<marc:datafield tag="856" ind1="4" ind2="2">
				<marc:subfield code="u">
					<xsl:value-of select="."/>
				</marc:subfield>
				<marc:subfield code="y">
					<xsl:text>Capa</xsl:text>
				</marc:subfield>
			</marc:datafield>
		</xsl:for-each>

		<!-- Campo de informação não MARC (MARC 887) - Código HTML (PHL 084) -->
		
		<xsl:for-each select="v084">
			<marc:datafield tag="887" ind1=" " ind2=" ">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</marc:datafield>
		</xsl:for-each>

		<!-- Campo de informação não MARC (MARC 887) - Código HTML restrito (PHL 096) -->
		
		<xsl:for-each select="v096">
			<marc:datafield tag="887" ind1=" " ind2=" ">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</marc:datafield>
		</xsl:for-each>
		
		<!-- Item (Campo local 900) -  Dados sobre os itens a partir dos registros de tombo adicionados ao final do documento XML, ou do campo Tombo (PHL 007)-->

		<xsl:choose>
			<xsl:when test="/db/rec[v800=$controlNumber]">
				<xsl:for-each select="/db/rec[v800=$controlNumber]">
					<marc:datafield tag="900" ind1=" " ind2=" ">
						
						<!-- Número de tombo ($a) -->
						
						<xsl:if test="v801">
							<marc:subfield code="a">
								<xsl:value-of select="v801"/>
							</marc:subfield> 
						</xsl:if>
						
						<!-- Complemento ($b) -->
						
						<xsl:if test="v802">
							<marc:subfield code="b">
								<xsl:value-of select="v802"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Exemplar ($c) -->
						
						<xsl:if test="v803">
							<marc:subfield code="c">
								<xsl:value-of select="v803"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Campo livre ($d) -->
						
						<xsl:if test="v804">
							<marc:subfield code="d">
								<xsl:value-of select="v804"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Campo livre ($e) -->
						
						<xsl:if test="v805">
							<marc:subfield code="e">
								<xsl:value-of select="v805"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Curso ($f) -->
						
						<xsl:if test="v806">
							<marc:subfield code="f">
								<xsl:value-of select="v806"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Status ($g) -->
						
						<xsl:if test="v807">
							<marc:subfield code="g"> 
								<xsl:choose>
									<xsl:when test="v807 = '0'">Indisponível</xsl:when>
									<xsl:when test="v807 = '1'">Circulante</xsl:when>
									<xsl:when test="v807 = '2'">Consulta local</xsl:when>
									<xsl:otherwise>Desconhecido</xsl:otherwise>
								</xsl:choose>
							</marc:subfield>
						</xsl:if>
						
						<!-- Os campos livres de 808 a 818 não foram incluído aqui -->
						
						<!-- Tipo de aquisição ($h) -->
						
						<xsl:if test="v819">
							<marc:subfield code="h">
								<xsl:choose>
									<xsl:when test="v819 = '1'">Compra</xsl:when>
									<xsl:when test="v819 = '2'">Permuta</xsl:when>
									<xsl:when test="v819 = '3'">Doação</xsl:when>
									<xsl:when test="v819 = '4'">Outro</xsl:when>
									<xsl:otherwise>Desconhecido</xsl:otherwise>
								</xsl:choose>
							</marc:subfield>
						</xsl:if>
						
						<!-- Data da aquisição ($i) -->
						
						<xsl:if test="v820">
							<marc:subfield code="i">
								<xsl:value-of select="v820"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Fornecedor/Doador ($j) -->
						
						<xsl:if test="v821">
							<marc:subfield code="j">
								<xsl:value-of select="v821"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Nota fiscal ($k) -->
						
						<xsl:if test="v822">
							<marc:subfield code="k">
								<xsl:value-of select="v822"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Valor em moeda corrente  ($l) -->
						
						<xsl:if test="v823">
							<marc:subfield code="l">
								<xsl:value-of select="v823"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Valor em dólar  ($m) -->
						
						<xsl:if test="v824">
							<marc:subfield code="m">
								<xsl:value-of select="v824"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Prazo excepcional ($n) -->
						
						<xsl:if test="v825">
							<marc:subfield code="n">
								<xsl:value-of select="v825"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Restauração ($o) -->
						
						<xsl:if test="v826">
							<marc:subfield code="o">
								<xsl:value-of select="v826"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Prevenção ($p) -->
						
						<xsl:if test="v827">
							<marc:subfield code="p">
								<xsl:value-of select="v827"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Campo livre ($q) -->
						
						<xsl:if test="v828">
							<marc:subfield code="q">
								<xsl:value-of select="v828"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Campo livre ($r) -->
						
						<xsl:if test="v829">
							<marc:subfield code="r">
								<xsl:value-of select="v829"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Antigos proprietários ($s) -->
						
						<xsl:if test="v830">
							<marc:subfield code="s">
								<xsl:value-of select="v830"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Cedência ($t) -->
						
						<xsl:if test="v831">
							<marc:subfield code="t">
								<xsl:value-of select="v831"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Campo livre ($u) -->
						
						<xsl:if test="v832">
							<marc:subfield code="u">
								<xsl:value-of select="v832"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Valor do seguro ($v) -->
						
						<xsl:if test="v833">
							<marc:subfield code="v">
								<xsl:value-of select="v833"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Campo livre ($w) -->
						
						<xsl:if test="v834">
							<marc:subfield code="w">
								<xsl:value-of select="v834"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Campo livre ($x) -->
						
						<xsl:if test="v835">
							<marc:subfield code="x">
								<xsl:value-of select="v835"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Campo livre ($y) -->
						
						<xsl:if test="v836">
							<marc:subfield code="y">
								<xsl:value-of select="v836"/>
							</marc:subfield>
						</xsl:if>
						
						<!-- Observações gerais ($z) -->
						
						<xsl:if test="v837">
							<marc:subfield code="z">
								<xsl:value-of select="v837"/>
							</marc:subfield>
						</xsl:if>
					</marc:datafield>
				</xsl:for-each>
			</xsl:when>
			
			<!-- Caso os registros de tombo não tenham sido acrescentados ao final do arquivo XML, os dados sobre os itens serão extraídos dos campos 007 do PHL -->
			
			<xsl:otherwise>
				<xsl:for-each select="v007">
					<marc:datafield tag="900" ind1=" " ind2=" ">
						
						<!-- Número de tombo ($a) -->
						
						<marc:subfield code="a">
							<xsl:value-of select="substring-before(substring-after(.,'^a'),'^')"/>
						</marc:subfield>
						
						<!-- Exemplar ($c) -->
						
						<marc:subfield code="c">
							<xsl:value-of select="substring-before(substring-after(.,'^b'),'^')"/>
						</marc:subfield>
						
						<!-- Mode de aquisição ($h) -->
						
						<marc:subfield code="h">
							<xsl:variable name="codigoTipoDeAquisicao" select="substring-before(substring-after(.,'^c'),'^')" />
							<xsl:variable name="tipoDeAquisicao">
								<xsl:choose>
									<xsl:when test="$codigoTipoDeAquisicao = '1'">Compra</xsl:when>
									<xsl:when test="$codigoTipoDeAquisicao = '2'">Permuta</xsl:when>
									<xsl:when test="$codigoTipoDeAquisicao = '3'">Doação</xsl:when>
									<xsl:when test="$codigoTipoDeAquisicao = '4'">Outra</xsl:when>
									<xsl:otherwise>Desconhecida</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="$tipoDeAquisicao"/>
						</marc:subfield>
						
						<!-- Data de aquisição ($i) -->
						
						<marc:subfield code="i">
							<xsl:value-of select="substring-before(substring-after(.,'^d'),'^')"/>
						</marc:subfield>
						
						<!-- Status da circulação ($g)-->
						
						<marc:subfield code="g">
							<xsl:variable name="codigoStatusDaCirculacao" select="substring-before(substring-after(.,'^e'),'^')" />
							<xsl:variable name="statusDaCirculacao">
								<xsl:choose>
									<xsl:when test="$codigoStatusDaCirculacao = '0'">Indisponível</xsl:when>
									<xsl:when test="$codigoStatusDaCirculacao = '1'">Circulante</xsl:when>
									<xsl:when test="$codigoStatusDaCirculacao = '2'">Consulta local</xsl:when>
									<xsl:otherwise>Desconhecido</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="$statusDaCirculacao"/>	
						</marc:subfield>
						
						<!-- Prazo excepcional ($n) -->
						
						<xsl:if test="string-length(substring-before(substring-after(.,'^f'),'^')) &#62; 0">
							<marc:subfield code="n">
								<xsl:value-of select="substring-before(substring-after(.,'^f'),'^')"/>
							</marc:subfield>
						</xsl:if>
						
					</marc:datafield>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>

		<!-- Histórico de modificações do registro (Campo local 998) - Datas de controle (PHL 999) -->
			
		<xsl:for-each select="v999">
			<marc:datafield tag="998" ind1=" " ind2=" ">
				<marc:subfield code="a">
					<xsl:value-of select="substring(.,3,8)" />
				</marc:subfield>
				<marc:subfield code="b">
					<xsl:value-of select="substring(.,13,6)" />
				</marc:subfield>
				<marc:subfield code="c">
					<xsl:value-of select="substring-after(.,'^b')"></xsl:value-of>
				</marc:subfield>
			</marc:datafield>
		</xsl:for-each>
		
		
	</xsl:template>
	
	<!-- Fim do template bibliographicRecord -->
	
</xsl:stylesheet>

<!-- Folha de estilo criada por Fabrício Silva Assumpção - assumpcao.f (at) gmail.com | http://fabricioassumpcao.com -->
