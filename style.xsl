<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://w3.org">
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/resume">
        <html lang="en">
        <head>
            <meta charset="UTF-8"/>
            <title><xsl:value-of select="contact/name"/> - Resume</title>
            <style>
                body { font-family: system-ui, sans-serif; max-width: 600px; margin: 40px auto; padding: 0 20px; color: #333; line-height: 1.5; }
                .controls { margin-bottom: 25px; background: #f5f5f5; padding: 12px; border-radius: 6px; display: flex; align-items: center; gap: 10px; }
                button { cursor: pointer; padding: 6px 12px; font-size: 0.95rem; border: 1px solid #ccc; border-radius: 4px; background: white; font-weight: 500; }
                button.active { background: #0066cc; color: white; border-color: #004499; }
                
                /* Inline Word Switcher Styles */
                body.lang-us en-gb { display: none; }
                body.lang-us en-us { display: inline; }
                body.lang-uk en-us { display: none; }
                body.lang-uk en-gb { display: inline; }
                
                .company-block { margin-bottom: 30px; }
                .company-header { display: flex; justify-content: space-between; align-items: baseline; border-bottom: 1px solid #eee; padding-bottom: 4px; margin-bottom: 10px; }
                .company-name { font-size: 1.25rem; font-weight: bold; margin: 0; }
                
                .job { margin-left: 5px; border-left: 3px solid #0066cc; padding-left: 15px; margin-bottom: 20px; }
                .job-header { display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 5px; }
                .role-title { font-weight: 600; font-size: 1.05rem; margin: 0; }
                .duration { font-size: 0.85rem; color: #666; font-variant-numeric: tabular-nums; white-space: nowrap; }
                
                p { margin: 4px 0; }
                .brag { font-size: 0.9rem; color: #0055aa; font-weight: 500; }
            </style>
        </head>
        <body class="lang-us">
            
            <div class="controls">
                <span>Region Config:</span>
                <button id="btn-us" class="active" onclick="setRegion('us')">🇺🇸 US (MM/YYYY)</button>
                <button id="btn-uk" onclick="setRegion('uk')">🇬🇧 UK (DD/MM/YYYY)</button>
            </div>

            <header style="margin-bottom: 25px;">
                <h1 style="margin: 0 0 5px 0;"><xsl:value-of select="contact/name"/></h1>
                <p style="margin: 0; color: #555; font-size: 1.1rem; font-weight: 500;"><xsl:value-of select="contact/desc"/></p>
            </header>

            <section>
                <h2>Experience</h2>
                <xsl:for-each select="experience/company">
                    <div class="company-block">
                        <div class="company-header">
                            <h3 class="company-name"><xsl:value-of select="name"/></h3>
                            <span class="duration" data-start="{duration/@start}" data-end="{duration/@end}">
                                <xsl:value-of select="duration"/>
                            </span>
                        </div>
                        <p style="font-style: italic; color: #666; margin-top: 0; margin-bottom: 15px; font-size: 0.95rem;">
                            <xsl:copy-of select="desc/node() | desc/text()"/>
                        </p>
                        
                        <xsl:for-each select="role">
                            <div class="job">
                                <div class="job-header">
                                    <h4 class="role-title"><xsl:value-of select="title"/></h4>
                                    <span class="duration" data-start="{duration/@start}" data-end="{duration/@end}">
                                        <xsl:value-of select="duration"/>
                                    </span>
                                </div>
                                <p>💡 <xsl:copy-of select="duty/node() | duty/text()"/></p>
                                <p class="brag">🏆 <xsl:copy-of select="brag/node() | brag/text()"/></p>
                            </div>
                        </xsl:for-each>
                    </div>
                </xsl:for-each>
            </section>

            <script>
                function parseAndFormatDate(isoString, region) {
                    if (!isoString) return "Present";
                    const parts = isoString.split('-');
                    const year = parts[0];
                    const month = parts[1];
                    const day = parts[2] || "01";
                    
                    if (region === 'us') {
                        return month + "/" + year;
                    } else {
                        return day + "/" + month + "/" + year;
                    }
                }

                function setRegion(region) {
                    if (region === 'us') {
                        document.body.className = 'lang-us';
                        document.getElementById('btn-us').className = 'active';
                        document.getElementById('btn-uk').className = '';
                    } else {
                        document.body.className = 'lang-uk';
                        document.getElementById('btn-uk').className = 'active';
                        document.getElementById('btn-us').className = '';
                    }

                    document.querySelectorAll('.duration').forEach(function(el) {
                        const startRaw = el.getAttribute('data-start');
                        const endRaw = el.getAttribute('data-end');
                        
                        const formattedStart = parseAndFormatDate(startRaw, region);
                        const formattedEnd = parseAndFormatDate(endRaw, region);
                        
                        el.textContent = formattedStart + " — " + formattedEnd;
                    });
                }

                window.onload = function() { setRegion('us'); };
            </script>
        </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
