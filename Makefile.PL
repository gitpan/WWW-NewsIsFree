use ExtUtils::MakeMaker;
WriteMakefile(
	      'NAME'		=> 'WWW::NewsIsFree',
	      'VERSION_FROM'	=> 'NewsIsFree.pm',
	      'PREREQ_PM'		=> {
		  'RPC::XML::Client' => 0,
		  'Digest::MD5'      => 0,
	      },
	      ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
	       (ABSTRACT_FROM => 'NewsIsFree.pm', # retrieve abstract from module
		AUTHOR     => 'xern <xern@cpan.org>') : ()),
	      );
