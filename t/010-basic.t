#!/usr/bin/env raku

use Test;
use XML::Fast;

my $xml = q:to/END_XML/;
<root>
  <person>
    <name>John</name>
    <age>
    30
    </age>
  </person>
  <person>
    <name>Jane</name>
    <age>25</age>
  </person>
</root>
END_XML

my %expect = ( person => [ { name => "John", age => 30 }, { name => "Jane", age => 25 } ]);

my %data = from-xml($xml);
is-deeply %data, %expect, "got back the structure that was expected";

done-testing;
# vim: ft=raku
