package WWW::NewsIsFree;

use 5.006;
use strict;
use warnings;

use RPC::XML::Client;
use Digest::MD5 qw/md5_hex/;

our $VERSION = '0.01';

my $RPCURL = 'http://www.newsisfree.com:80/RPC';

sub new($$) {
    bless {
	_user => $_[1]->{user},
	_pass => $_[1]->{password},
	_proxy => $_[1]->{proxy},
    }, $_[0];
}


sub getSource($$) {
    my $pkg = shift;
    my $newsid = shift;

    my $cli = RPC::XML::Client->new($RPCURL);
    $cli->{__useragent}->{proxy} = { 'http', $pkg->{_proxy} };

    my @arg = (
	     RPC::XML::string->new($pkg->{_user}),
	     RPC::XML::string->new(md5_hex $pkg->{_pass}),
	     RPC::XML::int->new($newsid)
	       );

    my $req = RPC::XML::request->new('hpe.getSource', @arg);
    my $resp = $cli->send_request($req);

    return undef unless ref $resp;

    my @retarr;
    for my $entry ( sort { $b->{date}->value <=> $a->{date}->value } @{$resp->{items}}){
	push @retarr, {
	    newsid => $newsid,
	    title => $entry->{title}->value,
	    link => $entry->{link}->value,
	    date => $entry->{date}->value,
	},
    }
    wantarray ? @retarr : \@retarr;
}


sub getSources($@) {
    my $pkg = shift;
    wantarray ? map { $pkg->getSource($_) } @_ : [ map { $pkg->getSource($_) } @_ ];
}

sub searchSources($$) {
    my $pkg = shift;
    my $query = shift;

    my $cli = RPC::XML::Client->new($RPCURL);
    $cli->{__useragent}->{proxy} = { 'http', $pkg->{_proxy} };

    my @arg = (
	     RPC::XML::string->new($pkg->{_user}),
	     RPC::XML::string->new(md5_hex $pkg->{_pass}),
	     RPC::XML::string->new($query)
	       );

    my $req = RPC::XML::request->new('hpe.searchSources', @arg);
    my $resp = $cli->send_request($req);

    return undef unless ref $resp;

    my @retarr;
    for my $entry ( @{$resp}){
	push @retarr, {
	    link   => $entry->{info}->value,
	    title  => $entry->{name}->value,
	    newsid => $entry->{id}->value,
	};
    }
    wantarray ? @retarr : \@retarr;
}


1;
__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

WWW::NewsIsFree - NewsIsFree Agent

=head1 SYNOPSIS

  use WWW::NewsIsFree;

  $n = WWW::NewsIsFree->new({
      user     => q^_____^,
      password => q^_____^,
      proxy    => 'http://proxy.here/'
      });

  $n->searchSources('newsisfree');

  $n->getSource($newsid);


=head1 DESCRIPTION

B<NewsIsFree>(http://www.newsisfree.com/) is a great news aggregator which collects over 3000 news sources and provides XML-RPC to access news sources. This module is a perl interface to B<NewsIsFree>.

=head1 METHODS

=head2 new

Registration at B<NewsIsFree> is required. User's name and password are need at instantiation.

Password is encoded with L<Digest::MD5> before it is sent out to the server.

=head2 getSource

Gets the news with some source identifier. You need to check the website for what the identifier is for some specific source.

=head2 getSources

Gets multiple sources with an array of identifiers.

=head2 searchSources

Searches the whole collection for some query.

=head1 AUTHOR

xern <xern@cpan.org>

=head1 SEE ALSO

http://www.newsisfree.com/

=head1 LICENSE

Released under The Artistic License

=cut
