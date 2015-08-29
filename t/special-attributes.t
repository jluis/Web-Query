use strict;
use warnings;

use Test::More;

use lib 't/lib';

use WQTest;

WQTest::test {
    my $class = shift;

    subtest 'id()' => sub { test_id($class) };

};


sub test_id { 
    my $class = shift;

    my $wq = $class->new_from_html(q{
    <div>
        <a></a>
        <b id="foo"></b>
        <c id="bar">1</c>
        <c>2</c>
        <c id="baz">3</c>
    </div>
});

    is_deeply [ $wq->find('a')->id ] => [ undef ], "no id, list context";
    is scalar $wq->find('a')->id  => undef, "no id, scalar context";

    is $wq->find('#foo')->id => 'foo', 'single element';
    is scalar($wq->find('#foo')->id) => 'foo', 'single element, scalar context';

    is_deeply [ $wq->find('c')->id ], [ 'bar', undef, 'baz' ], 'many elements, list context';
    is_deeply scalar $wq->find('c')->id, 'bar', 'many elements, scalar context';

    $wq->find('b')->id('fool');
    is $wq->find('#fool')->tagname => 'b', 'change id, scalar';

    isa_ok $wq->find('c')->id('buz'), 'Web::Query';

    is $wq->find('c')->id('buz')->size => 1, 'only the first element';
    is $wq->find('#buz')->text => 1, "change first element";

    my $i = 0;
    $wq->find('c')->id(sub{ 'new_'.$i++ });

    is $wq->find('#new_'.$_)->size => 1 for 0..2;
}
