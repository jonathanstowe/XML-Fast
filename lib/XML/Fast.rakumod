=begin pod

=head1 NAME

XML::Fast - turn XML into a Raku hash in a cheap and cheerful fashion

=head1 SYNOPSIS

=begin code

use JSON::Fast;
use XML::Fast;
￼
my $xml = q:to/END_XML/;
<root>
  <person>
    <name>John</name>
    <age>30</age>
  </person>
  <person>
    <name>Jane</name>
    <age>25</age>
  </person>
</root>
END_XML
￼
my $json = to-json(from-xml($xml));
say $json;

=end code

=head1 DESCRIPTION

This is a very simple way of turning XML data into a Raku data structure, it doesn't offer any control over how this is done. Please see the README for an explanation as to why it exists.

There is a single exported function C<from-xml> which takes either an XML string or a single C<LibXML::Element>.

There is no C<to-xml> as this would imply the ability to round-trip the data accurately, too much information is lost about the structure of the original XML to make this meaningful.

=end pod

module XML::Fast {
    use JSON::Fast;
    use LibXML;
    use LibXML::Document;
    use LibXML::Enums;

    multi sub from-xml(Str $xml_string) is export {
        my $doc = LibXML::Document.parse($xml_string);
        my $root = $doc.root;
        from-xml($root);
    }
    multi sub from-xml(LibXML::Element $node where -> $n { ($n.firstChild !~~ LibXML::Text && $n.firstChild !~~ LibXML::CDATA) || $n.firstChild.isBlank || $n.attributes.elems }) is export {
        my %new_hash;
        my $attrs = $node.attributes;
        for $attrs.kv -> $attr-name, $attr-value {
            %new_hash{$attr-name} = $attr-value.value;
        }
        my @nodes = $node.children(:!blank);
        for @nodes -> $child {
            my $hash = from-xml($child);
            %new_hash.push: { $child.localname => $hash };
        }
        return %new_hash;
    }

    multi sub from-xml(LibXML::Element $node where -> $n {$n.firstChild.nodeType == XML_TEXT_NODE && !$n.firstChild.isBlank && !$n.attributes.elems}) is export {
        from-xml($node.firstChild);
    }

    multi sub from-xml(LibXML::Element $node where -> $n {$n.firstChild ~~ LibXML::CDATA }) is export {
        from-xml($node.firstChild);
    }

    multi sub from-xml(LibXML::Text $node ) is export {
        my $value = $node.nodeValue;
        Numeric($value) || $value;
    }

    multi sub from-xml(LibXML::CDATA $node) is export {
        $node.nodeValue;
    }

}
# vim: filetype=raku
