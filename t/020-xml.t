#!/usr/bin/env raku

use Test;
use XML::Fast;

my @tests = (
    {
        name    => 'complex with Attributes',
        xml     => '<root><person id="1"><name>John</name></person></root>',
        expect  => { person => { name => "John", id => "1" } }
    },
    {
        name    => 'simple multi-elements to list of scalar',
        xml     => '<root><person>Rod</person><person>Jane</person><person>Freddie</person></root>',
        expect  => { person => [ 'Rod', 'Jane', 'Freddie' ] }
    },
    {
        name    => 'complex with attributes with simple content',
        xml     => '<root><person id="1">Rod</person><person id="2">Jane</person><person id="3">Freddie</person></root>',
        expect  => { person => [ { id => "1", text => 'Rod' } , { id => "2", text => 'Jane' }, { id => "3", text => 'Freddie' } ] }
    },

);

for @tests -> $test {
    my %data = from-xml($test<xml>);
    is-deeply %data, $test<expect>, $test<name>;
}

done-testing;
# vim: ft=raku
