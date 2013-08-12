query-sam
=========

A wrapper around Microsoft Log Parser allowing to run SQL queries over SAM files storing genetic sequence alignment data

SAM format specification: http://samtools.sourceforge.net/SAMv1.pdf

Requires Microsoft Log Parser to be installed: http://www.microsoft.com/en-gb/download/details.aspx?id=24659 (quick explanation: http://www.stevebunting.org/udpd4n6/forensics/logparser.htm)

Usage: query_sam.cmd [filename] [query]

	[filename]	Path to SAM file
	
	[query]		SQL query supported by Microsoft Log Parser, quoted
				Use %SAMFILE% in FROM clause to query the file specified in the first parameter
				In LIKE masks use double percent character e.g. WHERE QNAME LIKE 'EAS%%' 
				Column names available listed in sam_headers.txt
				
Example:
query_sam.cmd ex1.sam "SELECT QNAME, SEQ FROM %SAMFILE% WHERE SEQ LIKE '%%GAGGGGTGCAG%%'"