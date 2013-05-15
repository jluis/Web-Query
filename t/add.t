#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use Test::More;
use Web::Query;

my $html = <<HTML;
<div class="container">
  <div class="foo">Foo</div>
  <div class="bar">Bar</div>
</div>
HTML


# add($object)
is join('|', wq($html)->find('.foo')->add(wq($html)->find('.bar'))->as_html)
    => '<div class="foo">Foo</div>|<div class="bar">Bar</div>', 'add($object)';


# add($html)
is join('|', wq($html)->find('.foo')->add('<div class="bar">Bar</div>')->as_html)
    => '<div class="foo">Foo</div>|<div class="bar">Bar</div>', 'add($html)';

# add(@elements)
is join('|', wq($html)->find('.foo')->add(@{ wq($html)->find('div')->{trees}})->as_html)
    => '<div class="foo">Foo</div>|<div class="foo">Foo</div>|<div class="bar">Bar</div>', 'add(@elements)';

# add($selector, $xpath_context)
is join('|', wq($html)->find('.foo')->add('.bar', wq($html)->{trees}->[0] )->as_html)
    => '<div class="foo">Foo</div>|<div class="bar">Bar</div>', 'add($selector, $xpath_context)';



done_testing;