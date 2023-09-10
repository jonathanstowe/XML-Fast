#!/usr/bin/env raku

use Test;
use XML::Fast;

my $xml = q:to/END_XML/;
<root>
<person>
    <note><![CDATA[Jane's husband]]></note>
    <name>John</name>
    <age>
    30
    </age>
  </person>
  <person>
    <note><![CDATA[John's wife]]></note>
    <name>Jane</name>
    <age>25</age>
  </person>
</root>
END_XML

my %expect = ( person => [ { name => "John", age => 30, note => "Jane's husband" }, { name => "Jane", age => 25, note => "John's wife" } ]);

my %data = from-xml($xml);
is-deeply %data, %expect, "got back the structure that was expected";

done-testing;
# vim: ft=raku
