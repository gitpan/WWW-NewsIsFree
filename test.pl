use Test;
BEGIN { plan tests => 3 };
ok(1);

use WWW::NewsIsFree;

use Data::Dumper;

print <<TEST;

WWW::NewsIsFree is going to do some content retrieval tests.
Please skip it if network is not available or you do not have an account at http://www.newsisfree.com/ yet.

TEST

print "Start the tests [y/N]?";


$ans = <STDIN>;
if($ans =~ /y/i){
    print "User's name: ";
    chomp($user = <STDIN>);
    die unless $user;
    print "User's password (What you type will show on screen): ";
    chomp($pass = <STDIN>);
    die unless $pass;
    print "User's proxy server (skip it if none): ";
    chomp($proxy = <STDIN>);
    
    $n = WWW::NewsIsFree->new({
	user=> $user,
	password=> $pass,
	proxy=> $proxy
	});
    ok( ($n->searchSources('newsisfree') ? 1 : 0), 1 );
    ok( ($n->getSource(2315) ? 1 : 0) , 1);
}
else{
    ok(1);
    ok(1);
}

