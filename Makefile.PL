use ExtUtils::MakeMaker;

require 5.008;

eval "use Test::Manifest 1.21";

WriteMakefile(
	'NAME'	       => 'Surveyor::App',
	'ABSTRACT'     => 'Run benchmarks from a package',
	'VERSION_FROM' => 'lib/Surveyor/App.pm',
	'LICENSE'      => 'perl',
	'AUTHOR'       => 'brian d foy <bdfoy@cpan.org>',
	
	'PREREQ_PM'    => { 
		'Test::More' => '0',
		},

	META_MERGE => {
		resources => {
			Repository => 'http://github.com/briandfoy/'
			}
		},

	clean  => { FILES    => q|Surveyor-App-*| },
	);
