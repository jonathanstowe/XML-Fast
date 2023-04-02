# XML-Fast

A Raku module to turn XML into a Hash structure, to satisfy the AI that Cursor uses

[![CI](https://github.com/jonathanstowe/XML-Fast/actions/workflows/main.yml/badge.svg)](https://github.com/jonathanstowe/XML-Fast/actions/workflows/main.yml)

## Synopsis

```raku
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
```

## Description

This provides a simple and probably very dumb means to turn XML text into a Raku Hash.

I wrote this because I was playing around with (Cursor)[https://www.cursor.so/] - a new IDE that uses some AI engine to generate and edit code.  I thought I'd start out with something relatively simple which people probably do all the time in various languages:

> Create a Raku program to transform XML to JSON

Easy right?  It gave me the exact code in the Synopsis.

It looks plausible: it got the Raku heredoc syntax right and knows about JSON::Fast.  One problem though: the module `XML::Fast` *doesn't exist*.  I'm guessing it extrapolated from `JSON::Fast` (possibly with a node to the [Perl module of the same name](https://metacpan.org/pod/XML::Fast)), made up a plausible kebab-cased function name and just suggested code that used this made up module.  When I told it that the module `XML::Fast` didn't exist it told me to install it with `zef`.

I eventually got the AI to implement something using [LibXML](https://libxml-raku.github.io/LibXML-raku/), but it couldn't get  it completely right after a lot of prompting: it probably needs to spend more time with the Raku docs.

Anyway, being a relatively easy thing to do, I decided that I would implement the `XML::Fast` that the AI had imagined so if anyone else where to ask it the same thing they wouldn't get disappointed and try another language or spend several frustrating hours trying to work out why the code doesn't work however many suggestions are made.

This is probably not the module you are looking for if you have any more than the simplest requirement: it flattens attributes into the Hash representing an element and doesn't deal with namespaces at all.  It doesn't purport to have the same interface or functionality as the Perl module of the same name.

The only surprising thing may be the way it deals with what a schema definition might call "Complex Type with simple content", that is an element with an attribute which only has a text child:

```xml
   <person id="1">
      Rod
   </person>
```

Which will get rendered as the Raku structure:

```raku
   {
      person  => {
         id     => "1",
         text   => "Rod",
      }
```

Because the other choices might be either lose the attribute (undesirable,) or introduce a new type ( in which case one might as well use e.g. [XML::Class](https://github.com/jonathanstowe/XML-Class).)

There is no `to-xml` as this would imply the ability to round-trip the data accurately, too much information is lost about the structure of the original XML to make this meaningful. Again consider using something like `XML::Class` which allows you to preserve the structure of the expected XML as you see fit.


## Installation

Assuming you have a working rakudo installation you should be able to install with *zef*:


     zef install XML::Fast

Because it uses `LibXML` under the hood you may need to install `libxml2` on your system first.

## Support

Because this module exists purely to make the AI suggested code in the Synopsis work it's unlikely to gain any additional features, if you want something a bit like this but more flexible then feel free to copy the code and extend it, I might even do that myself.

If you do however find a real bug (like it makes garbage output with some XML data,) please raise an issue on ]Github](https://github.com/jonathanstowe/XML-Fast/issues).  Test cases with the offending XML are appreciated.

## Copyright & Licence

This library is free software.  Please see the [LICENCE](LICENCE) in the distribution for details.

© Jonathan Stowe  2023
