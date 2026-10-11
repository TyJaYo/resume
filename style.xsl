<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8" indent="yes" />

    <xsl:template match="/resume">
        <html lang="en">
            <head>
                <meta charset="UTF-8" />
                <title><xsl:value-of select="contact/name" /> - Resume</title>
                <style>
                body { 
                    font-family: sans-serif; 
                    max-width: 615px; 
                    margin: 40px auto; 
                    padding: 0 20px; 
                    color: #333; 
                    line-height: 1.5; 
                }
                
                .controls { 
                    display: flex; 
                    align-items: center; 
                    gap: 10px; 
                    float: right;
                }
                button { 
                    cursor: pointer; 
                    padding: 0 4px; 
                    font-size: 1.5rem; 
                    border: 1px solid white; 
                    border-radius: 50%; 
                    background: white; 
                    transition: background 0.15s ease;
                }
                button:hover {
                    background: lightgray;
                }
                button.active { 
                    border-color: #004499; 
                }
                
                body.lang-us en-gb { display: none; }
                body.lang-us en-us { display: inline; }
                body.lang-uk en-us { display: none; }
                body.lang-uk en-gb { display: inline; }
                
                .main-header { margin-bottom: 0; }
                .main-name { margin: 0 0 5px 0; font-size: 2.2rem; font-weight: 800; letter-spacing: -0.02em; }
                .main-desc { margin: 0; color: #555; font-size: 1.15rem; font-weight: 500; }
                
                .section-title { font-size: 1.5rem; font-weight: 700; border-bottom: 2px solid #333; padding-bottom: 5px; margin-bottom: 20px; }
                .company-block { margin-bottom: 30px; }
                .company-header { display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 0; }
                .company-name { font-size: 1.25rem; font-weight: bold; margin: 0; color: #111; }
                .company-summary { font-style: italic; color: #666; margin-top: 0; margin-bottom: 15px; font-size: 0.95rem; }
                
                .job { margin-left: 5px; border-left: 3px solid #0066cc; padding-left: 15px; margin-bottom: 20px; }
                .job-header { display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 8px; }
                .role-title { font-weight: 600; font-size: 1.05rem; margin: 0; color: #222; }
                .duration { font-size: 0.85rem; color: #666; font-variant-numeric: tabular-nums; white-space: nowrap; font-weight: 500; }
                ul, li { margin: 0 }
                li { margin-bottom: 4px; max-width: 520px }
                .duty, .brag { color: #444; }
            </style>
            </head>
            <body class="lang-us">

                <div class="controls">
                    <button id="btn-us" class="active" onclick="setRegion('us')">🇺🇸</button>
                    <button id="btn-uk" onclick="setRegion('uk')">🇬🇧</button>
                </div>

                <header class="main-header">
                    <h1 class="main-name">
                        <xsl:value-of select="contact/name" />
                    </h1>
                    <p class="main-desc">
                        <xsl:value-of select="contact/desc" />
                    </p>
                </header>

                <section>
                    <h2 class="section-title">Experience</h2>
                    <xsl:for-each select="experience/company">
                        <div class="company-block">
                            <div class="company-header">
                                <h3 class="company-name">
                                    <xsl:value-of select="name" />
                                </h3>
                                <span class="duration" data-start="{duration/@start}"
                                    data-end="{duration/@end}">
                                    <xsl:value-of select="duration" />
                                </span>
                            </div>
                            <p class="company-summary">
                                <xsl:copy-of select="desc/node() | desc/text()" />
                            </p>

                            <xsl:for-each select="role">
                                <div class="job">
                                    <div class="job-header">
                                        <h4 class="role-title">
                                            <xsl:value-of select="title" />
                                        </h4>
                                        <span class="duration" data-start="{duration/@start}"
                                            data-end="{duration/@end}">
                                            <xsl:value-of select="duration" />
                                        </span>
                                    </div>
                                    <ul>
                                        <li class="duty"><xsl:copy-of
                                            select="duty/node() | duty/text()" /></li>
                                        <li class="brag"><xsl:copy-of
                                            select="brag/node() | brag/text()" /></li>
                                    </ul>
                                </div>
                            </xsl:for-each>
                        </div>
                    </xsl:for-each>
                </section>

                <script>
                <![CDATA[
                function parseAndFormatDate(isoString, region) {
                    if (!isoString) return "Present";
                    
                    var parts = isoString.split('-');
                    var year = parts[0];
                    var month = parts[1];
                    var day = parts[2] || "01";
                    
                    if (region === 'us') {
                        return month + "/" + day + "/" + year;
                    } else {
                        return day + "/" + month + "/" + year;
                    }
                }

                function setRegion(region) {
                    var candidateName = document.querySelector('.main-name').textContent;

                    if (region === 'us') {
                        document.body.className = 'lang-us';
                        document.getElementById('btn-us').className = 'active';
                        document.getElementById('btn-uk').className = '';
                        document.title = candidateName + " - Resume"; 
                    } else {
                        document.body.className = 'lang-uk';
                        document.getElementById('btn-uk').className = 'active';
                        document.getElementById('btn-us').className = '';
                        document.title = candidateName + " - CV"; 
                    }

                    var elements = document.querySelectorAll('.duration');
                    for (var i = 0; i < elements.length; i++) {
                        var el = elements[i];
                        var startRaw = el.getAttribute('data-start');
                        var endRaw = el.getAttribute('data-end');
                        
                        var formattedStart = parseAndFormatDate(startRaw, region);
                        var formattedEnd = parseAndFormatDate(endRaw, region);
                        
                        el.textContent = formattedStart + " — " + formattedEnd;
                    }
                }

                window.onload = function() { 
                    setRegion('us'); 
                };
                ]]>
            </script>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>